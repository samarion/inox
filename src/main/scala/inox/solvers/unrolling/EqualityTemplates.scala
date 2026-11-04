/* Copyright 2009-2018 EPFL, Lausanne */

package inox
package solvers
package unrolling

import utils._

import scala.collection.mutable.{Set => MutableSet, Map => MutableMap}

/** Incrementally unfolds equality relations between types for which the
  * SMT notion of equality is not relevant.
  *
  * This covers custom equalities on sorts (see [[ast.Definitions.ADTSort.equality]]), and
  * extensional equality (see [[ast.Expressions.ExtEquals]]) on types that don't admit equality.
  * Extensional equality on functions and maps quantifies over their inputs.
  */
trait EqualityTemplates { self: Templates =>
  import context.{given, _}
  import program._
  import program.trees._
  import program.symbols.{given, _}

  import equalityManager._

  private val checking: MutableSet[TypedADTSort] = MutableSet.empty
  private val unrollCache: MutableMap[Type, Boolean] = MutableMap.empty

  def unrollEquality(tpe: Type): Boolean = unrollCache.getOrElse(tpe, {
    val res = tpe match {
      case adt: ADTType =>
        val sort = adt.getSort
        sort.hasEquality || (!checking(sort) && {
          checking += sort
          sort.constructors.exists(c => c.fields.exists(vd => unrollEquality(vd.getType)))
        })

      case BooleanType() | UnitType() | CharType() | IntegerType() |
           RealType() | StringType() | (_: BVType) | (_: TypeParameter) => false

      case NAryType(tpes, _) => tpes.exists(unrollEquality)
    }

    unrollCache(tpe) = res
    res
  })

  def equalitySymbol(tpe: Type, extensional: Boolean = false): (Variable, Encoded) = {
    typeSymbols.cached(tpe -> extensional) {
      val v = Variable.fresh((if (extensional) "exteq" else "eq") + tpe, FunctionType(Seq(tpe, tpe), BooleanType()))
      v -> encodeSymbol(v)
    }
  }

  /** Whether `v` is the symbol of an equality (extensional or not) on type `tpe`. */
  def isEqualitySymbol(v: Variable, tpe: Type): Boolean =
    v == equalitySymbol(tpe)._1 || typeSymbols.get(tpe -> true).exists(_._1 == v)

  /** The extensional equality of `e1` and `e2` of type `tpe`, unfolded one level. */
  private[unrolling] def extensionalEquality(tpe: Type, e1: Expr, e2: Expr): Expr = {
    // Sorts are unfolded lazily since they can be recursive, and other types right away, so that
    // quantifiers over the inputs of curried functions or maps of functions form a single Forall
    def ext(e1: Expr, e2: Expr): Expr = e1.getType match {
      case tpe if admitsEquality(tpe) => Equals(e1, e2)
      case _: ADTType => ExtEquals(e1, e2)
      case tpe => extensionalEquality(tpe, e1, e2)
    }

    def forall(params: Seq[ValDef], body: Expr): Expr = body match {
      case Forall(inner, body) => Forall(params ++ inner, body)
      case _ => Forall(params, body)
    }

    tpe match {
      case adt: ADTType =>
        val sort = adt.getSort
        if (sort.hasEquality) {
          sort.equality.get.applied(Seq(e1, e2))
        } else {
          orJoin(sort.constructors.map { tcons =>
            val instCond = and(isCons(e1, tcons.id), isCons(e2, tcons.id))
            val fieldConds = tcons.fields.map(vd => ext(ADTSelector(e1, vd.id), ADTSelector(e2, vd.id)))
            andJoin(instCond +: fieldConds)
          })
        }

      case TupleType(tps) =>
        andJoin(tps.indices.map(i => ext(TupleSelect(e1, i + 1), TupleSelect(e2, i + 1))))

      case SigmaType(params, _) =>
        andJoin((1 to params.size + 1).map(i => ext(TupleSelect(e1, i), TupleSelect(e2, i))))

      case FunctionType(from, _) =>
        val xs = from.map(tp => Variable.fresh("x", tp, true))
        forall(xs.map(_.toVal), ext(Application(e1, xs), Application(e2, xs)))

      case PiType(params, _) =>
        val xs = params.map(_.freshen)
        val subst = (params zip xs.map(_.toVariable)).toMap
        val vds = xs.map(vd => vd.copy(tpe = typeOps.replaceFromSymbols(subst, vd.tpe)))
        val args = vds.map(_.toVariable)
        forall(vds, ext(Application(e1, args), Application(e2, args)))

      case MapType(from, _) =>
        val k = Variable.fresh("k", from, true)
        forall(Seq(k.toVal), ext(MapApply(e1, k), MapApply(e2, k)))

      case _ => throw new InternalSolverError(s"Why does $tpe require extensional equality unrolling!?")
    }
  }

  private[unrolling] def mkEqualities(
    blocker: Encoded,
    tpe: Type,
    e1: Encoded,
    e2: Encoded,
    register: Boolean = true
  ): (Encoded, Clauses) = {
    if (!unrollEquality(tpe)) (mkEquals(e1, e2), Seq())
    else if (register) (registerEquality(blocker, tpe, e1, e2), Seq())
    else {
      val app = mkApp(equalitySymbol(tpe)._2, FunctionType(Seq(tpe, tpe), BooleanType()), Seq(e1, e2))
      (app, Seq(mkImplies(mkAnd(blocker, mkEquals(e1, e2)), app)))
    }
  }

  class EqualityTemplate private(val key: EqualityKey, val contents: TemplateContents) extends Template {
    def instantiate(aVar: Encoded, e1: Encoded, e2: Encoded): Clauses = {
      instantiate(aVar, Seq(Left(e1), Left(e2)))
    }

    override protected def instantiate(substMap: Map[Encoded, Arg]): Clauses = {
      val clauses = Template.instantiate(
        contents.clauses, contents.blockers, contents.applications, contents.matchers,
        Map.empty, substMap)

      // register equalities (WILL NOT lead to any [[instantiate]] calls)
      val substituter = mkSubstituter(substMap.view.mapValues(_.encoded).toMap)
      for 
        eq <- contents.equalities
        bp = substituter(eq._1)
        equality <- eq._2
      yield
        registerEquality(bp, equality.substitute(substituter))

      clauses
    }
  }

  object EqualityTemplate {
    private val cache: MutableMap[EqualityKey, EqualityTemplate] = MutableMap.empty

    /** Extensional equalities are only unfolded in the polarity in which they occur, so that the
      * quantifiers they introduce keep it: the template for a positive (resp. negative) occurrence
      * only says that the equality implies (resp. is implied by) its unfolding. */
    def apply(key: EqualityKey): EqualityTemplate = cache.getOrElse(key, {
      val EqualityKey(tpe, extensional, polarity) = key
      val (f, fT) = equalitySymbol(tpe, extensional)
      val args @ Seq(e1, e2) = Seq("e1", "e2").map(s => Variable.fresh(s, tpe))
      val argsT = args.map(encodeSymbol)

      val pathVar = Variable.fresh("b", BooleanType(), true)
      val pathVarT = encodeSymbol(pathVar)

      val app = Application(f, args)
      val tmplClauses = if (extensional) {
        val body = extensionalEquality(tpe, e1, e2)
        val expr = polarity match {
          case Some(true) => Implies(app, body)
          case Some(false) => Implies(body, app)
          case None => Equals(app, body)
        }
        mkClauses0(pathVar, expr, (args zip argsT).toMap + (f -> fT) + (pathVar -> pathVarT), Some(true))
      } else mkClauses0(pathVar, Equals(app, tpe match {
        case adt: ADTType =>
          val sort = adt.getSort

          if (sort.hasEquality) {
            sort.equality.get.applied(args)
          } else {
            orJoin(sort.constructors.map { tcons =>
              val instCond = and(isCons(e1, tcons.id), isCons(e2, tcons.id))
              val fieldConds = tcons.fields.map(vd => Equals(ADTSelector(e1, vd.id), ADTSelector(e2, vd.id)))
              andJoin(instCond +: fieldConds)
            })
          }

        case TupleType(tps) =>
          andJoin(tps.indices.map(i => Equals(TupleSelect(e1, i + 1), TupleSelect(e2, i + 1))))

        case _ => throw new InternalSolverError(s"Why does $tpe require equality unrolling!?")
      }), (args zip argsT).toMap + (f -> fT) + (pathVar -> encodeSymbol(pathVar)))

      val (contents, _) = Template.contents(
        pathVar -> pathVarT, args zip argsT, tmplClauses,
        substMap = Map(f -> fT), optApp = Some(fT -> FunctionType(Seq(tpe, tpe), BooleanType()))
      )

      val res = new EqualityTemplate(key, contents)
      cache(key) = res
      res
    })
  }

  def instantiateEquality(blocker: Encoded, equality: Equality): Clauses = {
    val Equality(tpe, e1, e2, extensional, _) = equality
    val key = equality.key
    val clauses = new scala.collection.mutable.ListBuffer[Encoded]

    if (!instantiated(key)((blocker, e1, e2))) {
      val eqBlocker = eqBlockers.get(equality) match {
        case Some(eqBlocker) =>
          eqBlocker

        case None =>
          val eqBlocker = encodeSymbol(Variable.fresh("q", BooleanType(), true))
          eqBlockers += equality -> eqBlocker

          clauses ++= EqualityTemplate(key).instantiate(eqBlocker, e1, e2)

          val (_, f) = equalitySymbol(tpe, extensional)
          val ft = FunctionType(Seq(tpe, tpe), BooleanType())

          // congruence is transitive
          for ((tb, te1, te2) <- instantiated(key); cond = mkAnd(eqBlocker, tb)) {
            if (e2 == te1) {
              clauses += mkImplies(
                mkAnd(cond, mkApp(f, ft, Seq(e1, e2)), mkApp(f, ft, Seq(e2, te2))),
                mkApp(f, ft, Seq(e1, te2))
              )

              instantiated += key -> (instantiated(key) + ((cond, e1, te2)))
            }

            if (te2 == e1) {
              clauses += mkImplies(
                mkAnd(cond, mkApp(f, ft, Seq(te1, te2)), mkApp(f, ft, Seq(te2, e2))),
                mkApp(f, ft, Seq(te1, e2))
              )

              instantiated += key -> (instantiated(key) + ((cond, te1, e2)))
            }
          }

          // congruence is commutative
          clauses += mkImplies(eqBlocker, mkEquals(mkApp(f, ft, Seq(e1, e2)), mkApp(f, ft, Seq(e2, e1))))
          instantiated += key -> (instantiated(key) + ((eqBlocker, e1, e2)) + ((eqBlocker, e2, e1)))

          clauses += mkImplies(mkEquals(e1, e2), mkApp(f, ft, Seq(e1, e2)))
          eqBlocker
      }

      if (eqBlocker != blocker) {
        registerImplication(blocker, eqBlocker)
        clauses += mkImplies(blocker, eqBlocker)
      }

      reporter.debug("Unrolling equality behind " + equality + " (" + clauses.size + ")")
      for (cl <- clauses) {
        reporter.debug("  . " + cl)
      }
    }

    clauses.toSeq
  }

  def registerEquality(blocker: Encoded, tpe: Type, e1: Encoded, e2: Encoded): Encoded = {
    registerEquality(blocker, Equality(tpe, e1, e2))
  }

  def registerEquality(blocker: Encoded, equality: Equality): Encoded = {
    val tpe = equality.tpe
    val gen = nextGeneration(currentGeneration)
    val notBlocker = mkNot(blocker)

    equalityInfos.get(blocker) match {
      case Some((exGen, origGen, _, exEqs)) =>
        val minGen = gen min exGen
        equalityInfos += blocker -> (minGen, origGen, notBlocker, exEqs + equality)
      case None =>
        equalityInfos += blocker -> (gen, gen, notBlocker, Set(equality))
    }

    mkApp(equality.symbols._2, FunctionType(Seq(tpe, tpe), BooleanType()), Seq(equality.e1, equality.e2))
  }

  private[unrolling] object equalityManager extends Manager {
    private[EqualityTemplates] val eqBlockers = new IncrementalMap[Equality, Encoded]()
    private[EqualityTemplates] val typeSymbols = new IncrementalMap[(Type, Boolean), (Variable, Encoded)]
    private[EqualityTemplates] val equalityInfos = new IncrementalMap[Encoded, (Int, Int, Encoded, Set[Equality])]
    private[EqualityTemplates] val instantiated = new IncrementalMap[EqualityKey, Set[(Encoded, Encoded, Encoded)]].withDefaultValue(Set.empty)

    val incrementals: Seq[IncrementalState] = Seq(eqBlockers, typeSymbols, equalityInfos, instantiated)

    def unrollGeneration: Option[Int] =
      if (equalityInfos.isEmpty) None
      else Some(equalityInfos.values.map(_._1).min)

    def satisfactionAssumptions: Seq[Encoded] = equalityInfos.map(_._2._3).toSeq
    def refutationAssumptions: Seq[Encoded] = Seq.empty

    def promoteBlocker(b: Encoded): Boolean = {
      if (equalityInfos `contains` b) {
        val (_, origGen, notB, eqs) = equalityInfos(b)
        equalityInfos += b -> (currentGeneration, origGen, notB, eqs)
        true
      } else {
        false
      }
    }

    def unroll: Clauses = if (equalityInfos.isEmpty) Seq.empty else {
      val newClauses = new scala.collection.mutable.ListBuffer[Encoded]

      val eqBlockers = equalityInfos.filter(_._2._1 <= currentGeneration).toSeq.map(_._1)
      val newEqInfos = eqBlockers.flatMap(id => equalityInfos.get(id).map(id -> _))
      equalityInfos --= eqBlockers

      for ((blocker, (gen, _, _, eqs)) <- newEqInfos; e <- eqs) {
        newClauses ++= instantiateEquality(blocker, e)
      }

      reporter.debug("Unrolling equalities (" + newClauses.size + ")")
      for (cl <- newClauses) {
        reporter.debug("  . " + cl)
      }

      newClauses.toSeq
    }
  }
}
