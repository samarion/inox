/* Copyright 2009-2018 EPFL, Lausanne */

package inox
package solvers
package unrolling

import theories.TheoryException

import scala.collection.mutable.{Map => MutableMap}

/** The extraction of models from the models of the underlying solver: [[ModelWrapper]] reads the
  * values of the underlying model, and [[extractTotalModel]] builds a model of the query from them,
  * in which functions are given by lambdas (see `function-witnesses.md` for distinguishing inputs). */
trait ModelExtraction { self: AbstractUnrollingSolver =>
  import context.{given, _}
  import program._
  import program.trees._
  import program.symbols.{given, _}

  /** The equality literals of the on-demand distinguishing inputs that the last model extraction
    * needed (see [[LambdaTemplates.onDemandWitnesses]]). */
  protected var requestedWitnesses: Map[Encoded, Int] = Map.empty

  /** The on-demand distinguishing inputs of the functions that show up in the last extracted model,
    * which then join the regular unfolding (see [[LambdaTemplates.promoteWitnesses]]). */
  protected var exposedWitnesses: Set[Encoded] = Set.empty

  protected def wrapModel(model: underlying.Model): ModelWrapper

  trait ModelWrapper {
    def modelEval(elem: Encoded, tpe: t.Type): Option[t.Expr]

    def extractConstructor(elem: Encoded, tpe: t.ADTType): Option[Identifier]
    def extractSet(elem: Encoded, tpe: t.SetType): Option[Seq[Encoded]]
    def extractMap(elem: Encoded, tpe: t.MapType): Option[(Seq[(Encoded, Encoded)], Encoded)]
    def extractBag(elem: Encoded, tpe: t.BagType): Option[Seq[(Encoded, Encoded)]]

    /** The value of the uninterpreted function `id` that the extracted values call, if any. */
    def getUninterpreted(id: Identifier): Option[t.Expr]

    def eval(elem: Encoded, tpe: Type): Option[Expr] = modelEval(elem, encode(tpe)).flatMap {
      expr => try {
        Some(decode(expr))
      } catch {
        case u: Unsupported => None
      }
    }

    def getModel(extract: (Encoded, Type) => Expr): program.Model = {
      // Functions that are equal in the model share their extraction, so variables with refined
      // types are extracted first for the shared value to lie in these types.
      val extracted = freeVars.toSeq.sortBy { case (v, _) => v.tpe == v.getType }
        .map { case (v, idT) => v -> extract(idT, v.tpe) }.toMap

      // The default values of function models may refer to the free variables of their types
      val allVs = extracted.map { case (v, e) => v.toVal -> exprOps.replaceFromSymbols(extracted, e) }

      // The free functions that stand for uninterpreted functions give their models, and their
      // applications in values are calls to these functions again
      val uninterpreted = templates.uninterpretedFunctions.toSeq.map { case ((id, tps), (f, fT)) =>
        (id, tps.map(decode(_))) -> (decode(f).asInstanceOf[Variable], fT)
      }
      val byFunction = uninterpreted.map { case (key, (f, _)) => f -> key }.toMap
      // Their models are extracted at their full types, so that they lie in their codomains
      val uninterpretedTypes = templates.uninterpretedTypes.toSeq.map { case ((id, tps), tpe) =>
        (id, tps.map(decode(_))) -> decode(tpe)
      }.toMap
      val constants = templates.uninterpretedConstants.map { case (id, tps) => (id, tps.map(decode(_))) }
      def restore(e: Expr): Expr = exprOps.postMap {
        case Application(f: Variable, args) if byFunction contains f =>
          val (id, tps) = byFunction(f)
          Some(UninterpretedCall(id, tps, args, f.getType))
        case f: Variable if byFunction.get(f).exists(constants) =>
          val (id, tps) = byFunction(f)
          Some(UninterpretedCall(id, tps, Seq.empty, FunctionType(Seq.empty, f.getType)))
        case _ => None
      } (e)
      // The model that the solver operates under gives the functions that it interprets
      val uninterpretedVs = uninterpreted.collect { case (key, (f, fT)) if !partialModel.interpretations.contains(key) =>
        val tpe = uninterpretedTypes.getOrElse(key, f.getType)
        key -> exprOps.replaceFromSymbols(extracted, (tpe, constants(key)) match {
          // The calls of constants are their values
          case (FunctionType(Seq(), to), true) => Lambda(Seq.empty, extract(fT, to))
          case _ => extract(fT, tpe)
        })
      }.toMap
      val vs = allVs.map { case (vd, e) => vd -> restore(e) }

      // The values may contain the calls of closures and extracted functions (see `uniquateClosure`),
      // whose uninterpreted functions the underlying model gives at no type arguments
      def interpretationsOf(e: Expr): Map[(Identifier, Seq[Type]), Expr] = {
        def rec(es: Seq[Expr], acc: Map[(Identifier, Seq[Type]), Expr]): Map[(Identifier, Seq[Type]), Expr] = {
          val cs = es.flatMap(exprOps.collect {
            case UninterpretedCall(id, Seq(), _, _) if !acc.contains(id -> Seq()) =>
              getUninterpreted(id).map(e => (id, Seq.empty[Type]) -> decode(e)).toSet
            case _ => Set.empty[((Identifier, Seq[Type]), Expr)]
          }).toMap
          if (cs.isEmpty) acc else rec(cs.values.toSeq, acc ++ cs)
        }
        rec(Seq(e), Map.empty)
      }

      val modelCs = (vs.values ++ uninterpretedVs.values).toSeq.flatMap(interpretationsOf)

      val modelInterpretations = (modelCs ++ uninterpretedVs).map { case (k, e) => k -> restore(e) }.toMap

      // The lambdas of the program that the model unblocks, with the values that they capture, or
      // only their types when these values can't be extracted
      val active: Seq[Either[FunctionType, Lambda]] = templates.getLambdaTemplates
        .filter(tmpl => modelEval(tmpl.start, t.BooleanType()) == Some(t.BooleanLiteral(true)))
        .map { tmpl =>
          val lambda = decode(tmpl.structure.body).asInstanceOf[Lambda]
          try {
            val locals = tmpl.structure.locals.map { case (v, ev) => decode(v) -> extract(ev, decode(v).getType) }
            Right(restore(exprOps.replaceFromSymbols(locals.toMap, lambda)).asInstanceOf[Lambda])
          } catch {
            case _: NoSimpleValue | _: Unsupported => Left(lambda.getType.asInstanceOf[FunctionType])
          }
        }

      val (inlinedVs, inlinedCs) = inlineUnambiguousClosures(vs, modelInterpretations, active)
      inox.Model(program)(inlinedVs, inlinedCs)
    }
  }

  /** Inlines the closures of a model (see `uniquateClosure`) whose functions no other function of the
    * model matches, as they need no uninterpreted function to stay distinct. The functions of the
    * model include the `active` lambdas of the program, which are those that evaluating the
    * constraints in the model can reach, or their types when their captured values are unknown.
    * The functions that the remaining closures call stay in the
    * model. */
  private def inlineUnambiguousClosures(
    vs: Map[ValDef, Expr],
    interpretations: Map[(Identifier, Seq[Type]), Expr],
    active: Seq[Either[FunctionType, Lambda]]
  ): (Map[ValDef, Expr], Map[(Identifier, Seq[Type]), Expr]) = {
    object Closure {
      def unapply(e: Expr): Option[(Identifier, Lambda)] = e match {
        case l @ Lambda(params, UninterpretedCall(id, Seq(), args, _))
            if args == params.map(_.toVariable) => interpretations.get(id -> Seq()) match {
          case Some(f: Lambda) if f.getType == l.getType => Some(id -> f)
          case _ => None
        }
        case _ => None
      }
    }

    def normal(l: Lambda): Expr = {
      val (nl, subst) = normalizeStructure(l, ast.SymbolOps.NormalizationLifting.Simple)
      exprOps.replaceFromSymbols(subst.map { case (v, e, _) => v -> e }.toMap, nl)
    }

    val values = vs.values.toSeq ++ interpretations.values
    val closures = values.flatMap(exprOps.collect[(Identifier, Lambda)] {
      case Closure(id, f) => Set(id -> f)
      case _ => Set.empty
    }).toMap
    // The functions that closures call are only counted through their closures
    val otherValues = vs.values.toSeq ++ interpretations.toSeq.map {
      case ((id, Seq()), l: Lambda) if closures.contains(id) => l.body
      case (_, e) => e
    }
    val others = otherValues.flatMap(exprOps.collect[Lambda] {
      case Closure(_, _) => Set.empty
      case l: Lambda => Set(l)
      case _ => Set.empty
    })

    // The functions of a closure are only inlined when no other function of the model has their
    // structure, including the functions of the other closures and the lambdas that the model
    // unblocks. The active lambdas whose captured values are unknown may have any structure.
    val counts = (closures.values.toSeq ++ others ++ active.flatMap(_.toOption))
      .groupBy(l => (l.getType, normal(l))).view.mapValues(_.size).toMap
    val opaque = active.flatMap(_.left.toOption).toSet[Type]
    val inlined = closures.filter { case (_, f) => counts((f.getType, normal(f))) == 1 && !opaque(f.getType) }

    if (inlined.isEmpty) (vs, interpretations) else {
      // The inlined functions may themselves contain closures, which are inlined in turn
      def inlineIn(e: Expr, seen: Set[Identifier]): Expr = exprOps.postMap {
        case Closure(id, _) if inlined.contains(id) && !seen(id) => Some(inlineIn(inlined(id), seen + id))
        case _ => None
      } (e)

      val newVs = vs.map { case (vd, e) => vd -> inlineIn(e, Set.empty) }
      val newCs = interpretations.map { case (k, e) => k -> inlineIn(e, Set.empty) }

      // The functions of inlined closures stay only where the remaining values still call them
      val called = (newVs.values ++ newCs.values).flatMap(exprOps.collect[Identifier] {
        case UninterpretedCall(id, Seq(), _, _) => Set(id)
        case _ => Set.empty
      }).toSet
      (newVs, newCs.filter { case ((id, tps), _) => !inlined.contains(id) || tps.nonEmpty || called(id) })
    }
  }

  protected def extractSimpleModel(model: underlying.Model): program.Model = {
    val wrapped = wrapModel(model)
    wrapped.getModel((e, tpe) => wrapped.eval(e, tpe.getType).getOrElse(simplestValue(tpe.getType)))
  }

  protected case class Canceled() extends Exception("Cancelation occurred while extracting model")

  /** Extracts a model from `umodel` in which equal functions get the same value, distinct functions
    * get distinct values, and every value lies in its (refined) type. The extraction also records the
    * distinguishing inputs that the model still needs, in [[requestedWitnesses]] and [[exposedWitnesses]]. */
  protected def extractTotalModel(umodel: underlying.Model): program.Model =
    new TotalModelExtraction(umodel).extract()

  /** A single extraction by [[extractTotalModel]]: the functions it extracts, and the ones it is extracting. */
  private class TotalModelExtraction(model: underlying.Model) {
    extension[T] (opt: Option[T]) {
      private def getOrThrow: T = opt match {
        case Some(t) => t
        case None =>
          if (abort) {
            // We got a None but were interrupted. Maybe this None is due to the cancellation,
            // so we throw a Canceled that will be caught by checkAssumptions
            throw Canceled()
          } else {
            // We got a None, but not due to interruption. This is likely a bug, this exception will not be caught.
            throw java.util.NoSuchElementException("None.get")
          }
      }
    }

    val wrapped = wrapModel(model)

    import targetProgram._
    import targetProgram.trees._
    import targetProgram.symbols.{given, _}

    // maintain extracted functions to make sure equality is well-defined
    var lambdaExtractions: Seq[(Encoded, Lambda)] = Seq.empty
    // the uninterpreted constants that stand for functions that are being extracted
    var functionExtractions: Seq[(Encoded, UninterpretedCall)] = Seq.empty
    // the uninterpreted functions that the closures which keep extracted functions distinct call
    var closureExtractions: Seq[(Identifier, Lambda)] = Seq.empty
    // the functions that are being extracted as the lambdas they are equal to, and those of them
    // whose lambda captures them, and which are then extracted from their applications instead
    var lambdasInProgress: Seq[Encoded] = Seq.empty
    var capturedByTheirLambda: Seq[Encoded] = Seq.empty

    // evaluating in the model can be costly, and extraction compares the same functions repeatedly
    val modelEqualities = MutableMap.empty[(Encoded, Encoded), Boolean]
    def modelEq(e1: Encoded, e2: Encoded): Boolean = e1 == e2 || modelEqualities.getOrElseUpdate(e1 -> e2,
      wrapped.modelEval(templates.mkEquals(e1, e2), BooleanType()) == Some(BooleanLiteral(true)))

    lazy val onDemandWitnesses = templates.onDemandWitnesses.groupMap(_._1)(_._2)
    // the functions that show up in the model, by type
    val extractedFunctions = MutableMap.empty[FunctionType, Set[Encoded]]

    def extractValue(v: Encoded, tpe: Type, seen: Map[FunctionType, Set[Encoded]]): Expr = {

      // Functions are returned with their full (possibly dependent) types, as the default values
      // of their models must lie in their codomains (@see [[extractFunction]]).
      def functionsOf(v: Encoded, tpe: Type): (Seq[(Encoded, Type)], Seq[Expr] => Expr) = {
        def reconstruct(subs: Seq[(Seq[(Encoded, Type)], Seq[Expr] => Expr)],
                        recons: Seq[Expr] => Expr): (Seq[(Encoded, Type)], Seq[Expr] => Expr) =
          (subs.flatMap(_._1), (exprs: Seq[Expr]) => {
            var curr = exprs
            recons(subs.map { case (es, recons) =>
              val (used, remaining) = curr.splitAt(es.size)
              curr = remaining
              recons(used)
            })
          })

        def rec(v: Encoded, tpe: Type): (Seq[(Encoded, Type)], Seq[Expr] => Expr) = tpe match {
          case (_: FunctionType | _: PiType) =>
            (Seq(v -> tpe), es => es.head)

          case RefinementType(vd, _) =>
            rec(v, vd.tpe)

          case SigmaType(params, to) =>
            // The type of the last element depends on the previous ones, which are substituted in its value
            val (functions, recons) = rec(v, TupleType(params.map(_.tpe) :+ to))
            (functions, es => recons(es) match {
              case Tuple(es) => Tuple(es.init :+ exprOps.replaceFromSymbols((params zip es.init).toMap, es.last))
              case e => e
            })

          case TupleType(tps) =>
            val id = Variable.fresh("tuple", tpe)
            val encoder = templates.mkEncoder(Map(id -> v))
            reconstruct(tps.zipWithIndex.map {
              case (tpe, index) => rec(encoder(TupleSelect(id, index + 1)), tpe)
            }, Tuple.apply)

          case tpe @ ADTType(sid, tps) =>
            val cons = wrapped.extractConstructor(v, tpe).getOrThrow
            val id = Variable.fresh("adt", tpe)
            val encoder = templates.mkEncoder(Map(id -> v))
            reconstruct(getConstructor(cons, tps).fields.map {
              vd => rec(encoder(ADTSelector(id, vd.id)), vd.tpe)
            }, ADT(cons, tps, _))

          case st @ SetType(base) =>
            val vs = wrapped.extractSet(v, st).getOrThrow
            reconstruct(vs.map(rec(_, base)), FiniteSet(_, base))

          case mt @ MapType(from, to) =>
            val (vs, dflt) = wrapped.extractMap(v, mt).getOrThrow
            reconstruct(vs.flatMap(p => Seq(rec(p._1, from), rec(p._2, to))) :+ rec(dflt, to), {
              case es :+ default => FiniteMap(es.grouped(2).map(s => s(0) -> s(1)).toSeq, default, from, to)
            })

          case bt @ BagType(base) =>
            val vs = wrapped.extractBag(v, bt).getOrThrow
            reconstruct(vs.map(p => rec(p._1, base)), es => FiniteBag((es zip vs).map {
              case (k, (_, v)) => k -> wrapped.modelEval(v, IntegerType()).getOrThrow
            }, base))

          case _ => (Seq.empty, (es: Seq[Expr]) => wrapped.modelEval(v, tpe).getOrThrow)
        }

        rec(v, tpe)
      }

      val ev = wrapped.modelEval(v, tpe.getType).filterNot(_.isInstanceOf[Variable])
      if (ev.isDefined) {
        val (functions, recons) = functionsOf(v, tpe)
        recons(functions.map { case (f, tpe) =>
          extractFunction(f, tpe, seen)
        })
      } else {
        unknownValue(tpe)
      }
    }

    /* A value of `tpe` for an element that the model doesn't give, such as a function that is never
     * applied. The simplest value of a function type may not lie in a refined codomain, so functions
     * get the default value of their models instead (see [[defaultValue]]). */
    def unknownValue(tpe: Type): Expr = tpe match {
      case RefinementType(vd, _) if !hasFunctions(vd.tpe) =>
        encode(program.symbols.simplestValue(decode(tpe.getType)))
      case RefinementType(vd, _) => unknownValue(vd.tpe)
      case _: FunctionType | _: PiType =>
        val (params, paramTypes, resultType) = signature(tpe)
        Lambda(params, defaultValue(params, paramTypes, resultType)
          .getOrElse(unknownValue(resultType)))
      case _ => encode(program.symbols.simplestValue(decode(tpe.getType)))
    }

    /** Fresh parameters for the function type `fullType`, with its parameter and result types in
      * terms of these parameters. */
    def signature(fullType: Type): (Seq[ValDef], Seq[Type], Type) = {
      val tpe = fullType.getType.asInstanceOf[FunctionType]
      val params: Seq[ValDef] = tpe.from.map(tpe => ValDef.fresh("x", tpe, true))
      fullType match {
        case PiType(ps, to) =>
          val subst: Map[ValDef, Expr] = (ps zip params.map(_.toVariable)).toMap
          (params, ps.map(vd => typeOps.replaceFromSymbols(subst, vd.tpe)), typeOps.replaceFromSymbols(subst, to))
        case FunctionType(from, to) => (params, from, to)
        case _ => (params, tpe.from, tpe.to)
      }
    }

    /** Whether values of type `tpe` can contain functions. */
    def hasFunctions(tpe: Type, seen: Set[Identifier] = Set.empty): Boolean = tpe match {
      case _: FunctionType | _: PiType => true
      case adt: ADTType =>
        !seen(adt.id) && adt.getSort.constructors.exists(_.fields.exists(vd => hasFunctions(vd.getType, seen + adt.id)))
      case NAryType(tps, _) => tps.exists(hasFunctions(_, seen))
    }

    // The membership of `e` in `tpe`, where only refinements are checked
    def refinementsOf(e: Expr, tpe: Type): Expr = tpe match {
      case RefinementType(vd, pred) => and(refinementsOf(e, vd.tpe), exprOps.replaceFromSymbols(Map(vd -> e), pred))
      case TupleType(tps) => andJoin(tps.zipWithIndex.map((tpe, i) => refinementsOf(TupleSelect(e, i + 1), tpe)))
      case _ => BooleanLiteral(true)
    }

    def isFirstOrder(tpe: Type): Boolean =
      !typeOps.exists { case _: FunctionType => true case _ => false } (tpe.getType)

    // The type `tpe` where every refinement only applies under `cond`, which is inhabited
    // whenever `tpe` is inhabited under `cond`
    def guardedType(cond: Expr, tpe: Type): Type = tpe match {
      case RefinementType(vd, pred) =>
        val nvd = vd.copy(tpe = guardedType(cond, vd.tpe))
        RefinementType(nvd, implies(cond, exprOps.replaceFromSymbols(Map(vd -> nvd.toVariable), pred)))
      case PiType(params, to) => PiType(params, guardedType(cond, to))
      case FunctionType(from, to) => FunctionType(from, guardedType(cond, to))
      case TupleType(tps) => TupleType(tps.map(guardedType(cond, _)))
      case _ => tpe
    }

    /* The default value of the model of a function, i.e. its value on the arguments the formula
     * doesn't apply it to. It must lie in the codomain `to` (in terms of `params`) for all arguments
     * in the domain, so a refined codomain is given by a call to a fresh uninterpreted function of
     * the parameters, whose result is in `{r: to | domain ==> r in to}`.
     * Function-typed parameters can't be checked by an expression, so they're assumed in the domain. */
    def defaultValue(params: Seq[ValDef], paramTypes: Seq[Type], to: Type): Option[Expr] =
      Option.when(to != to.getType) {
        val domain = andJoin((params zip paramTypes).collect {
          case (vd, tpe) if isFirstOrder(tpe) => refinementsOf(vd.toVariable, tpe)
        })
        exprOps.freshUninterpretedCall("default", params, guardedType(domain, to))
      }

    def extractFunction(f: Encoded, fullType: Type, seen: Map[FunctionType, Set[Encoded]]): Expr = {
      val tpe = fullType.getType.asInstanceOf[FunctionType]
      val nextSeen = seen + (tpe -> (seen(tpe) + f))
      extractedFunctions += tpe -> (extractedFunctions.getOrElse(tpe, Set.empty) + f)

      def extractLambda(f: Encoded, tpe: FunctionType): Option[Lambda] = {
        val optEqTemplate = templates.getLambdaTemplates(tpe).find { tmpl =>
          wrapped.modelEval(tmpl.start, BooleanType()) == Some(BooleanLiteral(true)) &&
          modelEq(tmpl.ids._2, f)
        }

        optEqTemplate.map(templateLambda)
      }

      // The lambda of `tmpl` in the model, with the model values of its closure
      def templateLambda(tmpl: templates.LambdaTemplate): Lambda = {
        val localsSubst = tmpl.structure.locals.map { case (v, ev) =>
          v -> extractValue(ev, v.getType, nextSeen)
        }.toMap

        val res = exprOps.replaceFromSymbols(localsSubst, tmpl.structure.body)
        val (nl, subst) = normalizeStructure(res.asInstanceOf[Lambda], ast.SymbolOps.NormalizationLifting.Simple)
        exprOps.replaceFromSymbols(subst.map { case (v, e, _) => v -> e }.toMap, nl).asInstanceOf[Lambda]
      }

      // `lambda`, made structurally distinct from the functions that differ from `f` in the model:
      // the other extracted functions and the lambdas of the query. Lambdas are compared
      // structurally, up to the names of their parameters and locals (and to the values of their
      // closures, as with the lambdas of the query).
      def distinctFromOthers(lambda: Lambda): Lambda = {
        def normal(l: Lambda): Expr = {
          val (nl, subst) = normalizeStructure(l, ast.SymbolOps.NormalizationLifting.Simple)
          exprOps.replaceFromSymbols(subst.map { case (v, e, _) => v -> e }.toMap, nl)
        }

        lazy val taken = lambdaExtractions.collect {
          case (_, img: Lambda) if img.getType == lambda.getType => normal(img)
        }.toSet ++ templates.getLambdaTemplates(tpe).filter { tmpl =>
          wrapped.modelEval(tmpl.start, BooleanType()) == Some(BooleanLiteral(true)) &&
          !modelEq(tmpl.ids._2, f)
        }.map(tmpl => normal(templateLambda(tmpl)))

        if (!taken(normal(lambda))) lambda else {
          val id = FreshIdentifier("f", true)
          closureExtractions :+= id -> lambda
          uniquateClosure(id, lambda)
        }
      }

      // The parameters of the model, and the parameter and result types of `fullType` in their terms
      val (params, paramTypes, resultType) = signature(fullType)

      // Whether the application of `caller` to `args` fails in the model (see [[Templates.appFailure]])
      def failsAt(caller: Encoded, ft: FunctionType, args: Seq[Encoded]): Boolean =
        templates.appFailureLiterals(ft).exists { case ((c, as), literal) =>
          modelEq(c, caller) && as.size == args.size && (as zip args).forall(modelEq(_, _)) &&
            wrapped.modelEval(literal, BooleanType()) == Some(BooleanLiteral(true))
        }
      def fails(args: Seq[Encoded]): Boolean = failsAt(f, tpe, args)

      // The model of the application of `f` to `args`, which fails where the application does
      def image(args: Seq[Encoded], resType: Type): Expr =
        if (fails(args)) Error(resType, "Application of a partial function")
        else extractValue(templates.mkApp(f, tpe, args), resType, nextSeen)

      // Results are extracted with their full types when these don't depend on the arguments
      val imageType = if ((typeOps.variablesOf(resultType) & params.map(_.toVariable).toSet).isEmpty) resultType
        else resultType.getType

      // Applications to distinguishing inputs come last, so that they don't determine the default
      // value of the extracted function (which must agree with quantifier instantiations).
      val arguments = templates.getGroundInstantiations(f, tpe).flatMap { case (b, eArgs) =>
        wrapped.modelEval(b, BooleanType()).filter(_ == BooleanLiteral(true)).map(_ => eArgs)
      }.distinct.sortBy(_.exists(templates.isWitnessArgument))

      // Unless equality is intensional, a lambda can be equal to a function that it captures, such
      // as `() => f()` and `f`. The model of `f` is then that of its applications, as its lambda's
      // depends on it. Applications that lead back to `f` again then refer to it as to the other
      // functions being extracted.
      val inLambda = lambdasInProgress.exists(modelEq(f, _))
      val inCycle = inLambda && !capturedByTheirLambda.exists(modelEq(f, _))
      if (inCycle) capturedByTheirLambda :+= f
      val asLambda = if (inLambda) None else {
        lambdasInProgress :+= f
        val lambda = try extractLambda(f, tpe) finally lambdasInProgress = lambdasInProgress.init
        // the lambda of `f` applies its model, which is simpler
        lambda.map { l =>
          if (!capturedByTheirLambda.exists(modelEq(f, _))) l
          else lambdaExtractions.collectFirst { case (e, img) if img.getType == l.getType && modelEq(e, f) => img }.getOrElse(l)
        }
      }

      asLambda.orElse {
        if (!inCycle && seen(tpe).exists(e => modelEq(f, e))) {
          Some(functionExtractions.collectFirst { case (e, c) if modelEq(f, e) => c }.getOrElse {
            val c = UninterpretedCall(FreshIdentifier("x", true), Seq.empty, Seq.empty, FunctionType(Seq.empty, tpe))
            functionExtractions :+= f -> c
            c
          })
        } else {
          None
        }
      }.getOrElse {
        val res = if (arguments.isEmpty) {
          defaultValue(params, paramTypes, resultType).map(Lambda(params, _))
            .getOrElse(wrapped.modelEval(f, tpe).getOrThrow.asInstanceOf[Lambda])
        } else if (tpe.from.isEmpty) {
          val lambda = Lambda(Seq.empty, image(Seq.empty, imageType))
          lambdaExtractions.collectFirst {
            case (e, img) if img.getType == lambda.getType && modelEq(e, f) => img
          }.getOrElse(distinctFromOthers(lambda))
        } else {
          val projections: Map[Type, Encoded] = (arguments.head zip params)
            .groupBy(p => p._2.getType)
            .view.mapValues(_.head._1).toMap

          val exArguments = for (args <- arguments) yield {
            (params zip args).map { case (vd, arg) => extractValue(arg, vd.getType, nextSeen) }
          }

          /* The condition under which the `i`-th parameter `v` takes the model value `arg`.
           * Values that contain functions are told apart from the other values at that position
           * through the distinguishing inputs of their functions, so that the extracted function only
           * compares the results of applications, and never functions themselves. */
          def argumentCondition(v: ValDef, i: Int, arg: Encoded, exArg: Expr): Expr =
            if (!hasFunctions(v.getType)) Equals(v.toVariable, exArg) else {
              val others = arguments.map(_(i)).foldLeft(Seq.empty[Encoded]) { (acc, other) =>
                if (modelEq(other, arg) || acc.exists(modelEq(_, other))) acc else acc :+ other
              }
              val conds = others.map(other => separate(v.toVariable, v.getType, arg, other))
              if (conds.forall(_.isDefined)) andJoin(conds.flatten) else Equals(v.toVariable, exArg)
            }

          /* A test that holds when `x` is the model value `a`, and fails when it is `b`, if the model
           * has one that doesn't need comparing functions. `a` and `b` differ in the model. Functions
           * are tested on their distinguishing inputs, and datatypes on their constructors and fields. */
          def separate(x: Expr, tpe: Type, a: Encoded, b: Encoded): Option[Expr] = {
            // the first test among `parts` (lazily), trying those without functions first
            def firstOf(parts: Seq[(Type, Expr, Encoded, Encoded)]): Option[Expr] =
              parts.filterNot(p => modelEq(p._3, p._4)).sortBy(p => hasFunctions(p._1))
                .iterator.flatMap((tpe, x, a, b) => separate(x, tpe, a, b)).nextOption()

            tpe match {
              case _ if !hasFunctions(tpe) => Some(Equals(x, extractValue(a, tpe, nextSeen)))

              case ft: FunctionType =>
                // a distinguishing input may be one where only one of `a` and `b` fails
                val inputs = templates.distinguishingInputs.collectFirst {
                  case ((f1, f2), (tpe, ws)) if tpe == ft &&
                    ((modelEq(f1, a) && modelEq(f2, b)) || (modelEq(f1, b) && modelEq(f2, a))) &&
                    (failsAt(a, ft, ws) || failsAt(b, ft, ws) ||
                      !modelEq(templates.mkApp(a, ft, ws), templates.mkApp(b, ft, ws))) => ws
                }

                // the pair may only have an on-demand distinguishing input, which we then request
                if (inputs.isEmpty) {
                  for ((tpe, ws) <- onDemandWitnesses if tpe == ft; (f1, f2, equality, depth) <- ws
                       if (modelEq(f1, a) && modelEq(f2, b)) || (modelEq(f1, b) && modelEq(f2, a))) {
                    requestedWitnesses += equality -> depth
                  }
                }

                // Applying `x` to an input where `a` or `b` fails would fail as well, so functions that
                // are told apart by where they fail are compared as such.
                inputs.filterNot(ws => failsAt(a, ft, ws) || failsAt(b, ft, ws)).flatMap { ws =>
                  val app = Application(x, (ws zip ft.from).map((w, tpe) => extractValue(w, tpe, nextSeen)))
                  separate(app, ft.to, templates.mkApp(a, ft, ws), templates.mkApp(b, ft, ws))
                }

              case TupleType(tps) =>
                val id = Variable.fresh("tuple", tpe)
                def select(v: Encoded, i: Int): Encoded = templates.mkEncoder(Map(id -> v))(TupleSelect(id, i))
                firstOf(tps.zipWithIndex.map((tpe, i) => (tpe, TupleSelect(x, i + 1), select(a, i + 1), select(b, i + 1))))

              case adt @ ADTType(_, tps) =>
                (wrapped.extractConstructor(a, adt), wrapped.extractConstructor(b, adt)) match {
                  case (Some(ca), Some(cb)) if ca != cb => Some(IsConstructor(x, ca))
                  case (Some(ca), Some(_)) =>
                    val id = Variable.fresh("adt", adt)
                    def select(v: Encoded, field: Identifier): Encoded =
                      templates.mkEncoder(Map(id -> v))(ADTSelector(id, field))
                    firstOf(getConstructor(ca, tps).fields.map { vd =>
                      (vd.getType, ADTSelector(x, vd.id), select(a, vd.id), select(b, vd.id))
                    }).map(cond => And(IsConstructor(x, ca), cond))
                  case _ => None
                }

              // sets, bags and maps of functions are compared as such
              case _ => None
            }
          }

          // Mappings on a subset of the arguments take the value at arbitrary other arguments, which
          // may lie outside of a refined codomain, so only exact mappings are kept for these.
          val optDefault = defaultValue(params, paramTypes, resultType)
          val subsets = if (optDefault.isDefined) Iterator(Set.empty[ValDef]) else params.toSet.subsets()

          // Exact mappings are extracted with the result type at their arguments
          val argumentsWithConds: Seq[(Seq[Encoded], Expr, Type)] =
            (for (subset <- subsets; (args, exArgs) <- arguments zip exArguments) yield {
              val (concreteArgs, condOpts) = params.zipWithIndex.map { case (v, i) =>
                if (!subset(v)) {
                  (args(i), Some(argumentCondition(v, i, args(i), exArgs(i))))
                } else {
                  (projections(v.getType), None)
                }
              }.unzip

              val resType = if (subset.isEmpty) typeOps.replaceFromSymbols((params zip exArgs).toMap, resultType)
                else imageType
              (concreteArgs, andJoin(condOpts.flatten), resType)
            }).toSeq

          val (withConds, default) = optDefault match {
            // all arguments agree in the model when one of them has a trivial condition
            // A trivial condition means that all arguments agree in the model, and that no
            // condition tells them apart without comparing functions. Outside of the domain, the
            // result needn't lie in the codomain, so it's only taken there.
            case Some(default) => argumentsWithConds.indexWhere(_._2 == BooleanLiteral(true)) match {
              case -1 => (argumentsWithConds, default)
              case i =>
                val (concreteArgs, _, resType) = argumentsWithConds(i)
                val domain = andJoin((params zip paramTypes).map((vd, tpe) => refinementsOf(vd.toVariable, tpe)))
                val inDomain = (params zip exArguments(i)).foldRight(domain) {
                  case ((vd, arg), body) => Let(vd, arg, body)
                }
                modelEvaluator.eval(inDomain, inox.Model.empty(targetProgram)).result match {
                  case Some(BooleanLiteral(false)) =>
                    (Seq((concreteArgs, Not(domain), resType)), default)
                  case _ =>
                    (Seq.empty, image(concreteArgs, resType))
                }
            }
            case None =>
              val withConds :+ ((concreteArgs, _, _)) = argumentsWithConds: @unchecked
              (withConds, image(concreteArgs, imageType))
          }

          // arguments whose conditions are trivial are covered by the default value
          val sortedArguments = withConds
            .filter(_._2 != BooleanLiteral(true))
            .groupBy(_._2)
            .view.mapValues(_.head)
            .toSeq
            .sortBy(p => -exprOps.formulaSize(p._1))

          val mappings = sortedArguments.map { case (cond, (arguments, _, resType)) =>
            (cond, image(arguments, resType))
          }

          val lambda = Lambda(params, mappings.foldRight(default) {
            case ((cond, img), elze) => IfExpr(cond, img, elze)
          })

          lambdaExtractions.collectFirst {
            case (e, img) if img.getType == lambda.getType && modelEq(e, f) => img
          }.getOrElse(distinctFromOthers(lambda))
        }

        lambdaExtractions :+= f -> res
        res
      }
    }

    /* The solver may return values that cannot be decoded by the theory encoder if they
     * weren't constrained by the generated clauses (eg. default values for functions).
     * We replace these by `simplestValue` instead of crashing as they won't have any influence
     * on model evaluation. */
    def decodeOrSimplest(e: t.Expr): s.Expr = try {
      decode(e)
    } catch {
      case t: TheoryException => program.symbols.simplestValue(decode(e.getType))
    }

    def extract(): program.Model = {
      val initSeen: Map[FunctionType, Set[Encoded]] = Map.empty.withDefaultValue(Set.empty)
      val exModel = wrapped.getModel((e, tpe) => decodeOrSimplest(extractValue(e, encode(tpe), initSeen)))
      // The constants that stand for functions are given by these functions
      val exFunctions = functionExtractions.map { case (e, c) =>
        c -> lambdaExtractions.collectFirst {
          case (f, lambda) if lambda.getType == c.getType && modelEq(f, e) => lambda
        }.get
      }
      val interpretations = exFunctions.map(p => (p._1.id, Seq.empty[s.Type]) -> decodeOrSimplest(Lambda(Seq.empty, p._2))) ++
        closureExtractions.map(p => (p._1, Seq.empty[s.Type]) -> decodeOrSimplest(p._2))

      // The distinct functions of the model need a distinguishing input, so on-demand pairs join the
      // regular unfolding once they show up in it (see [[LambdaTemplates.onDemandWitnesses]]): a free
      // function with the other free functions of the model, and with the lambdas that the model
      // instantiates. Pairs of lambdas are left to the extraction of the functions they are passed to
      // (see `argumentCondition`). We don't ask the model whether the functions are distinct, as solvers
      // may evaluate the equality of function values extensionally: their unfolding is guarded by it.
      for {
        (tpe, ws) <- onDemandWitnesses
        fs <- extractedFunctions.get(tpe).toSeq
        lambdas = templates.getLambdaTemplates(tpe).map(tmpl => tmpl.ids._2 -> tmpl.start).toMap
        (f1, f2, equality, _) <- ws
        if !lambdas.contains(f1) && fs.exists(modelEq(_, f1)) && (lambdas.get(f2) match {
          case Some(start) => wrapped.modelEval(start, BooleanType()) == Some(BooleanLiteral(true))
          case None => fs.exists(modelEq(_, f2))
        })
      } exposedWitnesses += equality

      inox.Model(program)(exModel.vars, exModel.interpretations ++ interpretations)
    }
  }
}
