/* Copyright 2009-2018 EPFL, Lausanne */

package inox
package solvers
package unrolling

import utils._

import theories._
import evaluators._
import combinators._

import scala.collection.mutable.{Set => MutableSet, ListBuffer}

object optUnrollBound       extends IntOptionDef("unroll-bound", default = -1, "<Int> | -1 (unbounded)")
object optUnrollFactor      extends IntOptionDef("unroll-factor", default = 1, "<PosInt>")
object optFeelingLucky      extends FlagOptionDef("feeling-lucky", false)
object optUnrollAssumptions extends FlagOptionDef("unroll-assumptions", false)
/** How long, in milliseconds, the validation of a lucky model may take (see [[optFeelingLucky]]). */
object optLuckyTimeout      extends IntOptionDef("lucky-timeout", default = 5000, "<PosInt> (milliseconds)")

object optModelFinding      extends IntOptionDef("model-finding", 0, "<PosInt> | 0 (off)") {
  override val parser: OptionParsers.OptionParser[Int] = (s => s match {
    case "" => Some(1)
    case _ => OptionParsers.intParser(s)
  })
}

abstract class AbstractUnrollingSolver private
  (override val program: Program,
   override val context: Context)
  // Alias for `program`, as there are some places where `program` is shadowed.
  (val prog: program.type)
  (val enc: transformers.ProgramTransformer {val sourceProgram: program.type})
  (val programEncoder: transformers.ProgramTransformer {
    val sourceProgram: program.type
    val targetProgram: Program { val trees: enc.targetProgram.trees.type }
  })
  (using val semantics: program.Semantics,
   val targetSemantics: programEncoder.targetProgram.Semantics)
  extends Solver with ModelExtraction { self =>

  import context.{given, _}
  import program._
  import program.trees._
  import program.symbols.{given, _}
  import SolverResponses._

  protected type Encoded

  private def this(prog: Program,
                   context: Context,
                   enc: transformers.ProgramTransformer {val sourceProgram: prog.type},
                   programEncoder: transformers.ProgramTransformer {
                     val sourceProgram: prog.type
                     val targetProgram: Program {val trees: enc.targetProgram.trees.type}
                   })
                  (using semantics: prog.Semantics,
                   semanticsProvider: SemanticsProvider {val trees: enc.targetProgram.trees.type}) =
    this(prog, context)(prog)(enc)(programEncoder)(using semantics, programEncoder.targetProgram.getSemantics(using semanticsProvider))

  def this(prog: Program,
           context: Context,
           enc: transformers.ProgramTransformer {val sourceProgram: prog.type})
          // Given the encoder `enc`, produce a theory encoder of its target program
          (theoriesCtor: enc.type => transformers.ProgramTransformer {
            val sourceProgram: enc.targetProgram.type
            val targetProgram: Program {val trees: enc.targetProgram.trees.type}
          })
          (using semantics: prog.Semantics,
           semanticsProvider: SemanticsProvider {val trees: enc.targetProgram.trees.type}) =
    this(prog, context, enc, enc `andThen` theoriesCtor(enc))

  protected final val s: programEncoder.sourceProgram.trees.type = programEncoder.sourceProgram.trees
  protected final val t: programEncoder.targetProgram.trees.type = programEncoder.targetProgram.trees
  protected final val targetProgram: programEncoder.targetProgram.type = programEncoder.targetProgram

  protected val templates: Templates {
    val program: targetProgram.type
    type Encoded = self.Encoded
  }

  protected val underlying: AbstractSolver {
    val program: targetProgram.type
    type Trees = Encoded
  }

  protected final def encode(vd: ValDef): t.ValDef = programEncoder.encode(vd)
  protected final def decode(vd: t.ValDef): ValDef = programEncoder.decode(vd)

  protected final def encode(v: Variable): t.Variable = programEncoder.encode(v)
  protected final def decode(v: t.Variable): Variable = programEncoder.decode(v)

  protected final def encode(e: Expr): t.Expr = programEncoder.encode(e)
  protected final def decode(e: t.Expr): Expr = programEncoder.decode(e)

  protected final def encode(tpe: Type): t.Type = programEncoder.encode(tpe)
  protected final def decode(tpe: t.Type): Type = programEncoder.decode(tpe)

  lazy val checkModels = options.findOptionOrDefault(optCheckModels)
  lazy val ignoreModels = options.findOptionOrDefault(optIgnoreModels)
  lazy val silentErrors = options.findOptionOrDefault(optSilentErrors)
  lazy val unrollBound = options.findOptionOrDefault(optUnrollBound)
  lazy val unrollFactor = options.findOptionOrDefault(optUnrollFactor)
  lazy val feelingLucky = options.findOptionOrDefault(optFeelingLucky)
  lazy val luckyTimeout = options.findOptionOrDefault(optLuckyTimeout)
  lazy val unrollAssumptions = options.findOptionOrDefault(optUnrollAssumptions)
  lazy val modelFinding = options.findOptionOrDefault(optModelFinding) > 0

  def check(config: CheckConfiguration): config.Response[Model, Assumptions] =
    checkAssumptions(config)(Set.empty)

  private var unrollBoundHit: Boolean = false
  override def unrollBoundReached: Boolean = unrollBoundHit

  protected val freeVars  = new IncrementalMap[Variable, Encoded]()
  private val constraints = new IncrementalSeq[Expr]()

  protected var failures: ListBuffer[Throwable] = new ListBuffer
  protected var abort: Boolean = false
  protected var pause: Boolean = false

  def push(): Unit = {
    templates.push()
    constraints.push()
    freeVars.push()
  }

  def pop(): Unit = {
    templates.pop()
    constraints.pop()
    freeVars.pop()
  }

  def reset() = {
    failures.clear()
    abort = false
    pause = false
    if (evaluatorInterrupts.isInterrupted) evaluatorInterrupts.reset()

    templates.reset()
    constraints.reset()
    freeVars.reset()
    underlying.reset()
  }

  def interrupt(): Unit = {
    abort = true
    if (!evaluatorInterrupts.isInterrupted) evaluatorInterrupts.interrupt()
  }

  def free(): Unit = context.interruptManager.unregisterForInterrupts(this)

  protected def declareVariable(v: t.Variable): Encoded

  /** The model that the solver operates under, as when an evaluator solves for the foralls of an
    * expression that it evaluates in this model (see [[SolverFactory.getFromName]]).
    * The uninterpreted functions that the model interprets take their values in the model instead of
    * arbitrary ones. */
  protected def partialModel: program.Model = inox.Model.empty(program)

  /** The interpretation that the partial model gives to the uninterpreted function `id` at `tps`, if
    * it interprets it (see [[TemplateGenerator.interpretation]]). */
  protected final def interpretation(id: Identifier, tps: Seq[t.Type]): Option[t.Lambda] =
    partialModel.interpretations.get(id -> tps.map(decode(_))).collect {
      case l: Lambda => encode(l).asInstanceOf[t.Lambda]
    }

  def declare(vd: ValDef): Unit = context.timers.solvers.declare.run(try {
    context.timers.solvers.declare.sanity.run {
      assert(vd.getType.isTyped)
    }

    // Multiple calls to registerForInterrupts are (almost) idempotent and acceptable
    context.interruptManager.registerForInterrupts(this)

    val freeBindings: Map[Variable, Encoded] = (typeOps.variablesOf(vd.tpe) + vd.toVariable).map {
      v => v -> freeVars.cached(v)(declareVariable(encode(v)))
    }.toMap

    val newClauses = context.timers.solvers.declare.clauses.run {
      templates.instantiateVariable(encode(vd.toVariable), freeBindings.map(p => encode(p._1) -> p._2))
    }

    context.timers.solvers.declare.underlying.run {
      for (cl <- newClauses) {
        underlying.assertCnstr(cl)
      }
    }
  } catch {
    case e @ (_: InternalSolverError | _: Unsupported) => failures += e
  })

  lazy val functionEquality = options.findOptionOrDefault(optFunctionEquality)

  /** Rejects `expression` if it compares values that contain functions, either directly or through
    * the functions it calls (see [[optFunctionEquality]]). */
  private def checkNoFunctionComparisons(expression: Expr): Unit = {
    val violations = FunctionEquality.comparisons(program)(expression)
    if (violations.nonEmpty) {
      throw new TypeErrorException(
        "Functions can't be compared under --function-equality=none: " +
          violations.map(_.asString).mkString(", "), violations.head, violations.head.getPos)
    }

    val collections = FunctionEquality.functionKeyedCollections(program)(expression)
    if (collections.nonEmpty) {
      throw new TypeErrorException(
        "Sets and bags of functions and maps with function keys compare functions, which can't be " +
          "compared under --function-equality=none: " +
          collections.map(e => s"${e.asString}: ${e.getType.asString}").mkString(", "),
        collections.head, collections.head.getPos)
    }
  }

  def assertCnstr(expression: Expr): Unit = context.timers.solvers.assert.run(try {
    context.timers.solvers.assert.sanity.run {
      symbols.ensureWellFormed // make sure that the current program is well-formed
      typeCheck(expression, BooleanType(), PropType()) // make sure we've asserted a boolean or a proposition
      if (functionEquality == FunctionEquality.None) checkNoFunctionComparisons(expression)
    }

    // Multiple calls to registerForInterrupts are (almost) idempotent and acceptable
    context.interruptManager.registerForInterrupts(this)

    constraints += expression

    val freeBindings: Map[Variable, Encoded] = exprOps.variablesOf(expression).map {
      v => v -> freeVars.cached(v)(declareVariable(encode(v)))
    }.toMap

    val newClauses = context.timers.solvers.assert.clauses.run {
      templates.instantiateExpr(
        encode(expression),
        freeBindings.map(p => encode(p._1) -> p._2)
      )
    }

    context.timers.solvers.assert.underlying.run {
      for (cl <- newClauses) {
        underlying.assertCnstr(cl)
      }
    }
  } catch {
    case e @ (_: InternalSolverError | _: Unsupported) => failures += e
  })

  /** The interrupt manager of the solver's evaluators, which the solver's interrupts reach: the
    * extraction and the validation of a huge model then stop (see `RecursiveEvaluator.e`).
    */
  protected lazy val evaluatorInterrupts: InterruptManager = new InterruptManager(reporter)

  // Model values are compared as the solver sees them: functions are equal iff they are the same
  // function value, which the encoding makes structural (see [[optFunctionEquality]]).
  protected lazy val modelEvalContext: Context = context.copy(interruptManager = evaluatorInterrupts).withOpts(
    optIgnoreContracts(true), optFunctionEquality(FunctionEquality.Intensional))

  protected lazy val modelEvaluator: DeterministicEvaluator { val program: self.targetProgram.type } =
    targetSemantics.getEvaluator(using modelEvalContext)

  private def emit(silenceErrors: Boolean)(msg: String) =
    if (silenceErrors) reporter.debug(msg) else reporter.warning(msg)

  private def validateModel(model: program.Model, assumptions: Seq[Expr], silenceErrors: Boolean): Boolean = {
    // the values of the model have the types that it gives to the type parameters
    val formulas = (assumptions ++ constraints).map(typeOps.instantiateType(_, model.types))
    val expr = andJoin(formulas)

    // The uninterpreted functions whose models the typing conditions are being expanded through
    val expanding = MutableSet.empty[Identifier]
    def typing(value: Expr, tpe: Type): Expr = {
      def rec(e: Expr, tpe: Type): Expr = (e, tpe) match {
        // The models of functions are conditionals over their arguments, and their default values
        // are chosen in their codomains (see `defaultValue`)
        case (Let(vd, value, body), tpe) => Let(vd, value, rec(body, tpe)).copiedFrom(body)
        case (IfExpr(cond, thenn, elze), tpe) => IfExpr(cond, rec(thenn, tpe), rec(elze, tpe)).copiedFrom(e)
        // The default values of the models of functions are solved for in their refined codomains
        // (see `defaultValue`)
        case (uc: UninterpretedCall, _) if !model.interpretations.contains(uc.id -> uc.tps) &&
          uc.getTpe(stripRefinements = false) != uc.getType => BooleanLiteral(true)
        case (ADT(id, _, args), adt @ ADTType(_, tps)) =>
          // Field types may refer to the other fields of the constructor
          val fields = getConstructor(id, tps).fields
          andJoin((args zip fields).map(p => rec(p._1, p._2.tpe))) match {
            case BooleanLiteral(true) => BooleanLiteral(true)
            case p => (fields zip args).foldRight(p) { case ((vd, e), p) => Let(vd, e, p).copiedFrom(p) }
          }
        case (Tuple(es), TupleType(tps)) =>
          andJoin((es zip tps).map(p => rec(p._1, p._2)))
        case (FiniteSet(elems, _), SetType(base)) =>
          andJoin(elems.map(e => rec(e, base)))
        case (FiniteBag(elems, _), BagType(base)) =>
          andJoin(elems.map(p => and(rec(p._1, base), rec(p._2, IntegerType()))))
        case (FiniteMap(elems, dflt, _, _), MapType(from, to)) =>
          andJoin(elems.map(p => and(rec(p._1, from), rec(p._2, to))) :+ rec(dflt, to))
        // The models of functions may build the collections that they return by updates
        case (SetAdd(set, elem), SetType(base)) =>
          and(rec(set, tpe), rec(elem, base))
        case (BagAdd(bag, elem), BagType(base)) =>
          and(rec(bag, tpe), rec(elem, base))
        case (MapUpdated(map, key, value), MapType(from, to)) =>
          andJoin(Seq(rec(map, tpe), rec(key, from), rec(value, to)))
        case (Lambda(params, body), FunctionType(from, to)) =>
          val nparams = (params zip from).map { case (vd, tpe) => vd.copy(tpe = tpe) }
          forall(nparams, rec(
            exprOps.replaceFromSymbols((params zip nparams.map(_.toVariable)).toMap, body), to))
        // The calls of the functions that the model gives lie in a type when the bodies of their
        // models do, whose default values are chosen in their codomains (see `defaultValue`)
        case (UninterpretedCall(id, tps, args, _), tpe) if !expanding(id) && model.interpretations.contains(id -> tps) =>
          model.interpretations(id -> tps) match {
            case l: Lambda if l.params.size == args.size =>
              expanding += id
              val cond = rec(exprOps.replaceFromSymbols((l.params.map(_.toVariable) zip args).toMap, l.body), tpe)
              expanding -= id
              cond
            case _ => BooleanLiteral(false)
          }
        case (_, RefinementType(vd, pred)) =>
          and(rec(e, vd.tpe), Let(vd, e, pred).copiedFrom(e))
        case (Lambda(params, body), PiType(nparams, to)) =>
          forall(nparams, rec(
            exprOps.replaceFromSymbols((params zip nparams.map(_.toVariable)).toMap, body), to))
        case (Tuple(es), SigmaType(nparams, to)) =>
          andJoin(
            (es.init zip nparams).map(p => rec(p._1, p._2.tpe)) ++ (rec(es.last, to) match {
              case BooleanLiteral(true) => None
              case p => Some((nparams zip es.init).foldRight(p) {
                case ((vd, e), p) => Let(vd, e, p).copiedFrom(p)
              })
            })
          )
        // The closures of models call the functions that the model gives (see `uniquateClosure`)
        case (UninterpretedCall(id, Seq(), args, _), tpe) if !expanding(id) => model.interpretations.get(id -> Seq()) match {
          case Some(l: Lambda) if l.params.size == args.size =>
            expanding += id
            val cond = rec(exprOps.replaceFromSymbols((l.params.map(_.toVariable) zip args).toMap, l.body), tpe)
            expanding -= id
            cond
          case _ => BooleanLiteral(false)
        }
        case _ => BooleanLiteral(true)
      }

      rec(value, tpe)
    }

    // The results of the uninterpreted calls of the constraints lie in their types, where the
    // arguments of these calls are given by the model
    val modelVars = model.vars.keySet.map(_.toVariable)
    val callTypings = formulas.flatMap(exprOps.collect[UninterpretedCall] {
      // The calls that the model doesn't interpret can't be evaluated, so validation fails on them
      case uc: UninterpretedCall if exprOps.variablesOf(uc).subsetOf(modelVars) &&
        model.interpretations.contains(uc.id -> uc.tps) => Set(uc)
      case _ => Set.empty
    }).distinct.map(uc => typing(uc, uc.getTpe(stripRefinements = false)))

    val typingCond = andJoin(model.vars.toSeq.map { case (v, value) => typing(value, v.tpe) } ++ callTypings)

    // we have to check case class constructors in model for ADT invariants
    val newExpr = model.vars.toSeq.foldRight(and(typingCond, expr)) {
      case ((v, value), e) => Let(v, value, e)
    }

    val evaluator = semantics.getEvaluator(using context.copy(interruptManager = evaluatorInterrupts).withOpts(
      optSilentErrors(silenceErrors),
      optCheckModels(checkModels || feelingLucky)
    ))

    val evalModel = inox.Model(program)(Map.empty, partialModel.interpretations ++ model.interpretations, model.types)
    evaluator.eval(newExpr, evalModel) match {
      case EvaluationResults.Successful(BooleanLiteral(true)) =>
        reporter.debug("- Model validated.")
        true

      case EvaluationResults.Successful(_) =>
        reporter.debug("- Invalid model.")
        false

      case EvaluationResults.RuntimeError(msg) =>
        emit(silenceErrors)("- Model leads to runtime error: " + msg)
        false

      case EvaluationResults.EvaluatorError(msg) =>
        emit(silenceErrors)("- Model leads to evaluation error: " + msg)
        false
    }
  }

  /** Runs the validation of a lucky model, which fails once [[luckyTimeout]] has elapsed.
    *
    * A lucky model is only a shortcut to a counterexample that the search would find later, but
    * its validation evaluates the foralls of the program with nested solvers (see
    * [[evaluators.SolvingEvaluator]]), which can take much longer than the search itself.
    */
  private def withinLuckyTimeout(validation: => Boolean): Boolean = {
    var expired = false
    val expiry = new Interruptible {
      def interrupt(): Unit = evaluatorInterrupts.synchronized {
        if (!evaluatorInterrupts.isInterrupted) {
          expired = true
          evaluatorInterrupts.interrupt()
        }
      }
    }

    try new TimeoutFor(expiry).interruptAfter(luckyTimeout.toLong)(validation) finally {
      evaluatorInterrupts.synchronized {
        // The solver may have been interrupted in the meantime, in which case its evaluators stay so
        if (expired && !abort && evaluatorInterrupts.isInterrupted) {
          reporter.debug("- Lucky model validation timed out.")
          evaluatorInterrupts.reset()
        }
      }
    }
  }

  protected val emptyModel: Model =
    inox.Model(program)(Map.empty, Map.empty)

  def checkAssumptions(config: Configuration)(assumptions: Set[Expr]): config.Response[Model, Assumptions] =
      context.timers.solvers.unrolling.run(scala.util.Try({

    unrollBoundHit = false

    // throw error immediately if a previous call has already failed
    if (failures.nonEmpty) throw failures.head

    // Multiple calls to registerForInterrupts are (almost) idempotent and acceptable
    context.interruptManager.registerForInterrupts(this)

    new Check[config.type](config, assumptions).run()
  }).recover {
    case e @ (_: InternalSolverError | _: Unsupported) =>
      if (reporter.isDebugEnabled) reporter.debug(e)
      else if (!silentErrors && !abort) reporter.error(e.getMessage)
      config.cast(Unknown)
  }.get)

  /** A single call to [[checkAssumptions]]: a state machine that alternates between checking the
    * current unfolding, extracting and validating models, and unrolling further.
    *
    * Each state has its own method, which returns the next state, until a [[CheckResult]] is reached:
    *  - [[modelCheck]] looks for a model of the current unfolding, with the blockers assumed false,
    *  - [[finiteRangeCheck]] checks the models of queries over finite ranges,
    *  - [[validate]] extracts a model and checks it against the assumptions,
    *  - [[instantiateQuantifiers]] promotes the pending quantifier instantiations,
    *  - [[proofCheck]] checks the query without the blockers, to prove it unsatisfiable,
    *  - [[unroll]] unfolds the next generation of blockers.
    */
  private class Check[C <: Configuration & Singleton](val config: C, assumptions: Set[Expr]) {
    import SolverResponses._

    private type Response = SolverResponse[underlying.Model, Set[underlying.Trees]]

    private val assumptionsSeq       : Seq[Expr]          = assumptions.toSeq
    private val encodedAssumptions   : Seq[Encoded]       = assumptionsSeq.map { expr =>
      val vars = exprOps.variablesOf(expr)
      templates.mkEncoder(vars.map(v => encode(v) -> freeVars(v)).toMap)(encode(expr))
    }
    private val encodedToAssumptions : Map[Encoded, Expr] = (encodedAssumptions zip assumptionsSeq).toMap

    private def decodeAssumptions(core: Set[Encoded]): Set[Expr] = {
      core.flatMap(ast => encodedToAssumptions.get(ast) match {
        case Some(n @ Not(_: Variable)) => Some(n)
        case Some(v: Variable) => Some(v)
        case _ => None
      })
    }

    // the lambdas and the functions they capture that the model makes equal, and that the unrolling
    // hasn't related yet (see [[LambdaTemplates.equalCaptures]])
    private var modelCaptures: Option[(underlying.Model, Seq[(Encoded, Encoded)])] = None
    private def equalCaptures(umodel: underlying.Model): Seq[(Encoded, Encoded)] = modelCaptures match {
      case Some((m, captures)) if m.asInstanceOf[AnyRef] eq umodel.asInstanceOf[AnyRef] => captures
      case _ =>
        val candidates = templates.equalCaptures
        val captures = if (candidates.isEmpty) Seq.empty else {
          val wrapped = wrapModel(umodel)
          def holds(e: Encoded): Boolean = wrapped.modelEval(e, t.BooleanType()) == Some(t.BooleanLiteral(true))
          candidates.collect { case (start, lambda, f) if holds(start) && holds(templates.mkEquals(lambda, f)) => lambda -> f }
        }
        modelCaptures = Some(umodel -> captures)
        captures
    }

    sealed abstract class CheckState
    class CheckResult(val response: config.Response[Model, Assumptions]) extends CheckState
    case class Validate(model: underlying.Model) extends CheckState
    case object ModelCheck extends CheckState
    case object FiniteRangeCheck extends CheckState
    case object InstantiateQuantifiers extends CheckState
    case object ProofCheck extends CheckState
    case object Unroll extends CheckState

    object CheckResult {
      def cast(resp: Response): CheckResult = {
        // unsat assumptions may have been requested internally (eg. for witness assumptions)
        val res = resp match {
          case _: Unsatisfiable if !config.withUnsatAssumptions => Unsat
          case _ => resp
        }
        CheckResult(config.convert(config.cast(res), extractSimpleModel, decodeAssumptions))
      }

      def apply[M <: Model, A <: Assumptions](resp: config.Response[M, A]): CheckResult = resp match {
        case SatWithModel(_) if !checkModels && abort => new CheckResult(config `cast` Unknown)
        case _ => new CheckResult(resp)
      }

      def unapply(res: CheckResult): Option[config.Response[Model, Assumptions]] = Some(res.response)
    }

    object Abort {
      def unapply[A,B](resp: SolverResponse[A,B]): Boolean = {
        if (failures.nonEmpty || abort || pause) {
          true
        } else if (resp == Unknown) {
          if (!silentErrors) {
            reporter.error("Something went wrong. Underlying solver returned Unknown.")
          }
          true
        } else {
          false
        }
      }
    }

    private var unrollCount: Int = 0

    private def canUnroll: Boolean = unrollBound < 0 || unrollCount < unrollBound

    // The depth up to which distinguishing inputs are instantiated: 0 until the first model is found,
    // then one more level with each unrolling (see [[LambdaTemplates.witnessEqualities]])
    private var witnessLevel: Int = 0

    def run(): config.Response[Model, Assumptions] = {
      var currentState: CheckState = ModelCheck
      while (!currentState.isInstanceOf[CheckResult]) {
        currentState = currentState match {
          case ModelCheck => modelCheck()
          case FiniteRangeCheck => finiteRangeCheck()
          case Validate(umodel) => validate(umodel)
          case InstantiateQuantifiers => instantiateQuantifiers()
          case ProofCheck => proofCheck()
          case Unroll => unroll()
          case otherwise => sys.error(s"Unexpected case: $otherwise")
        }
      }

      val CheckResult(res) = currentState: @unchecked
      res
    }

    /** `model`, extracted from `umodel`, with the type parameters whose flags are off in `umodel`
      * instantiated with the empty type. The model checks only assume that type parameters have
      * values until a guard lets them be empty (see [[TypeTemplates.satisfactionAssumptions]]),
      * and from then on, the values of a type parameter that the model holds imply its flag. The
      * values of the model have the instantiated types, and the values of an empty type parameter
      * that the extracted model may still hold where nothing reaches them, such as the default
      * results of functions into it, become errors. */
    private def withEmptyTypes(model: program.Model, umodel: underlying.Model): program.Model = {
      val flags = templates.typesManager.typeParameterFlags
      val emptyTypes = if (flags.isEmpty) Set.empty else {
        val wrapped = wrapModel(umodel)
        flags.collect {
          case (tp, flag) if wrapped.modelEval(flag, t.BooleanType()) == Some(t.BooleanLiteral(false)) =>
            decode(tp.asInstanceOf[t.Type])
        }.collect { case tp: TypeParameter => tp }
      }
      if (emptyTypes.isEmpty) model else {
        val empty: Type = RefinementType(ValDef.fresh("empty", UnitType()), BooleanLiteral(false))
        val types: Map[TypeParameter, Type] = emptyTypes.map(_ -> empty).toMap
        def inst(tpe: Type): Type = typeOps.instantiateType(tpe, types)
        def instValue(e: Expr): Expr = typeOps.instantiateType(exprOps.postMap {
          case GenericValue(tp, _) if types.contains(tp) => Some(Error(tp, "Value of the empty type " + tp.id.name))
          case _ => None
        } (e), types)
        inox.Model(program)(
          model.vars.map { case (vd, e) => vd.copy(tpe = inst(vd.tpe)) -> instValue(e) },
          model.interpretations.map { case ((id, tps), e) => (id, tps.map(inst)) -> instValue(e) },
          types)
      }
    }

    private def witnessEqualities: Map[Encoded, Int] =
      if (witnessLevel > 0) templates.witnessEqualities else Map.empty

    /* The equalities between functions without distinguishing inputs that appear in the unsat core
     * of `res`, or all of them if the solver gave no core. Cores aren't necessarily reported as
     * literals, so they are compared modulo negation. */
    private def coreEqualities(res: Response, equalities: Map[Encoded, Int]): Map[Encoded, Int] = res match {
      case _: Unsatisfiable if equalities.nonEmpty =>
        def atom(e: Encoded): Encoded = templates.extractNot(e).getOrElse(e)
        res match {
          case UnsatWithAssumptions(core) =>
            val atoms = core.map(atom)
            equalities.filter(p => atoms(atom(p._1)))
          case _ => equalities
        }
      case _ => Map.empty
    }

    /* Instantiates the distinguishing inputs of the given equalities up to the current witness level.
     * If they are all deeper, we move on to the proof check: it either proves the query, or leads to
     * an unrolling, which raises the level. Going through the proof check ensures that witnesses can't
     * delay a proof that the unfolding already allows (see `function-witnesses.md`). */
    private def instantiateWitnesses(needed: Map[Encoded, Int]): CheckState = {
      val current = needed.filter(_._2 <= witnessLevel).keySet
      if (current.nonEmpty) {
        reporter.debug(" - Instantiating distinguishing function inputs")
        for (cl <- templates.instantiateWitnesses(current)) {
          underlying.assertCnstr(cl)
        }
        ModelCheck
      } else {
        ProofCheck
      }
    }

    /* Decides what to do with the pending equalities when a check that assumed them is UNSAT, given
     * the core equalities of the check and a way to run it again without the equalities. Returns
     * the next state, or the result of the check without equalities when they aren't to blame.
     *
     * Equalities in the core are instantiated first. Otherwise, the core may still be missing them
     * (solvers don't reliably report every assumption they used), so we check again without them:
     * if that is satisfiable, the equalities are needed, and we instantiate the whole current level,
     * which also keeps instantiation fair. */
    private def blamedEqualities(
      inCore: Map[Encoded, Int],
      equalities: Map[Encoded, Int],
      withoutEqualities: => Response
    ): Either[CheckState, Response] = {
      if (inCore.exists(_._2 <= witnessLevel)) {
        Left(instantiateWitnesses(inCore))
      } else {
        reporter.debug(" - Checking again without equalities between functions")
        val res = withoutEqualities
        res match {
          case _: Satisfiable => Left(instantiateWitnesses(equalities))
          case _ => Right(res)
        }
      }
    }

    /** Checks the current unfolding with the blockers assumed false (along with the other
      * satisfaction assumptions): a model of it is a candidate model of the query. */
    private def modelCheck(): CheckState = {
      reporter.debug(" - Running search...")

      val equalities = witnessEqualities
      val getModel = !templates.requiresFiniteRangeCheck || checkModels || templates.hasAxioms || config.withModel
      val getAssumptions = (unrollAssumptions && templates.canUnroll) || config.withUnsatAssumptions ||
        equalities.nonEmpty
      val checkConfig = Configuration(model = getModel && !ignoreModels, unsatAssumptions = getAssumptions)

      def check(equalities: Iterable[Encoded]): Response =
        context.timers.solvers.unrolling.check.run {
          underlying.checkAssumptions(checkConfig)(
            encodedAssumptions.toSet ++ templates.satisfactionAssumptions ++ equalities
          )
        }

      val resWithEqualities = check(equalities.keys)

      reporter.debug(" - Finished search with blocked literals")

      // the equalities are only assumed in `resWithEqualities`, so that every UNSAT answer below
      // comes from a check without them
      val next: Either[CheckState, Response] = resWithEqualities match {
        case Abort() => Right(resWithEqualities)
        case _: Unsatisfiable if equalities.nonEmpty =>
          blamedEqualities(coreEqualities(resWithEqualities, equalities), equalities, check(Seq.empty))
        case _ => Right(resWithEqualities)
      }

      next match {
        case Left(state) => state
        case Right(res) => res match {
          case Abort() =>
            CheckResult.cast(Unknown)

          // distinguishing inputs only matter once we have a model, in which distinct functions
          // may still agree on every input: check again with these assumed equal
          case _: Satisfiable if witnessLevel == 0 && templates.witnessEqualities.nonEmpty =>
            witnessLevel = 1
            ModelCheck

          case _: Satisfiable if templates.requiresFiniteRangeCheck =>
            FiniteRangeCheck

          case Sat =>
            if (config.withModel && ignoreModels) then
              // did we discard the model check manually?
              // if yes, recast to the right response, with an empty model
              CheckResult(config.cast(SatWithModel(emptyModel)))
            else
              CheckResult.cast(Sat)

          case SatWithModel(model) =>
            Validate(model)

          // Satisfaction assumptions that remain once nothing can be unrolled
          // (such as type parameters being inhabited) must still be dropped
          // before the query can be deemed unsatisfiable.
          case _: Unsatisfiable if !templates.canUnroll && templates.satisfactionAssumptions.isEmpty =>
            CheckResult.cast(res)

          case UnsatWithAssumptions(assumptions) if unrollAssumptions =>
            for (b <- assumptions) templates.promoteBlocker(b)
            ProofCheck

          case _ =>
            ProofCheck
        }
      }
    }

    /** Checks the current unfolding along with the clauses that bound the ranges of the
      * finite-range types, to get a model that respects them. */
    private def finiteRangeCheck(): CheckState = {
      reporter.debug(" - Verifying finite ranges")

      val clauses = templates.getFiniteRangeClauses

      // the model must have distinguishing inputs as well (see [[modelCheck]])
      val equalities = witnessEqualities

      val next: Either[CheckState, Response] =
        context.timers.solvers.unrolling.check.run {
          underlying.push()
          for (cl <- encodedAssumptions.toSeq ++ templates.satisfactionAssumptions ++ clauses) {
            underlying.assertCnstr(cl)
          }
          def check(equalities: Iterable[Encoded]) =
            underlying.checkAssumptions(Configuration(model = true, unsatAssumptions = equalities.nonEmpty))(
              equalities.toSet
            )
          val res = check(equalities.keys)
          val next = res match {
            case _: Unsatisfiable if equalities.nonEmpty && !abort && !pause =>
              val inCore = coreEqualities(res, equalities).filter(_._2 <= witnessLevel)
              if (inCore.nonEmpty) Left(inCore)
              else check(Seq.empty) match {
                case _: Satisfiable => Left(equalities.filter(_._2 <= witnessLevel))
                case _ => Right(res)
              }
            case _ => Right(res)
          }
          underlying.pop()
          next.left.map { needed =>
            if (needed.nonEmpty) instantiateWitnesses(needed) else InstantiateQuantifiers
          }
        }

      reporter.debug(" - Finished checking finite ranges")

      next match {
        case Left(state) => state
        case Right(res) => res match {
          case Abort() =>
            CheckResult.cast(Unknown)

          case SatWithModel(model) =>
            Validate(model)

          case _ =>
            InstantiateQuantifiers
        }
      }
    }

    /** Extracts a model from `umodel` and validates it, once the unfolding has related the lambdas
      * of `umodel` to the functions they capture. */
    private def validate(umodel: underlying.Model): CheckState = {
      if (abort || pause) {
        // Extracting and validating a large model takes time: skip them once interrupted
        CheckResult.cast(Unknown)
      } else if (equalCaptures(umodel).nonEmpty) {
        // the unrolling left out the clauses that relate these lambdas to the functions they capture
        // (see [[LambdaTemplates.equalCaptures]]), so the model needs them before it can be trusted
        reporter.debug(" - Relating lambdas to the captured functions that the model makes equal")
        for ((lambda, f) <- equalCaptures(umodel); cl <- templates.relateCapture(lambda, f)) {
          underlying.assertCnstr(cl)
        }
        // the applications of the functions are then related to the lambdas by unrolling them
        if (templates.canUnroll) Unroll else ModelCheck
      } else {
        requestedWitnesses = Map.empty
        exposedWitnesses = Set.empty
        (try { Some(withEmptyTypes(extractTotalModel(umodel), umodel)) } catch {
          case NoSimpleValue(tpe) =>
            if (!silentErrors) {
              reporter.error("No simple value found for type " + tpe.asString)
            }
            None
          case Canceled() => None
        }).map(validateExtracted(umodel, _)).getOrElse(CheckResult `cast` Unknown)
      }
    }

    /** Validates `model`, extracted from `umodel`: its functions may first need their
      * distinguishing inputs, and its quantifiers must fit in the supported fragment. */
    private def validateExtracted(umodel: underlying.Model, model: Model): CheckState = {
      lazy val sat = CheckResult(config `cast` (if (config.withModel) SatWithModel(model) else Sat))
      lazy val unknown = CheckResult `cast` Unknown

      lazy val valid = !checkModels || validateModel(model, assumptionsSeq, silenceErrors = silentErrors)

      // the extracted functions need these distinguishing inputs to tell their arguments apart,
      // and they are unfolded fairly, like the others (see [[LambdaTemplates.witnessEqualities]])
      val requested = requestedWitnesses.filter(_._2 <= (witnessLevel max 1)).keySet
      if (requested.nonEmpty && !abort && !pause) {
        reporter.debug(" - Instantiating requested distinguishing function inputs")
        for (cl <- templates.instantiateWitnesses(requested)) {
          underlying.assertCnstr(cl)
        }
        ModelCheck
      } else if (requestedWitnesses.nonEmpty && functionEquality == FunctionEquality.None && !abort && !pause) {
        // Without function equality, the model can't compare the functions instead, so we wait
        // for the unfolding to reach their distinguishing inputs (see [[instantiateWitnesses]]).
        reporter.debug(" - Requested distinguishing function inputs are deeper than the unfolding")
        witnessLevel = witnessLevel max 1
        ProofCheck
      } else if (exposedWitnesses.nonEmpty && !abort && !pause) {
        reporter.debug(" - Unfolding the distinguishing inputs of the functions in the model")
        for (cl <- templates.promoteWitnesses(exposedWitnesses)) {
          underlying.assertCnstr(cl)
        }
        ModelCheck
      } else if (checkModels && valid) {
        sat
      } else if (abort || pause) {
        unknown
      } else if (checkModels && !valid) {
        if (!silentErrors) {
          reporter.error("Something went wrong. The model should have been valid, yet we got this:")
          reporter.error("  " + model.asString.replaceAll("\n", "\n  "))
          reporter.error("for formula " + andJoin(assumptionsSeq ++ constraints).asString)
        }
        unknown
      } else if (templates.hasAxioms) {
        val wrapped = wrapModel(umodel)
        def modelEq(e1: Encoded, e2: Encoded): Boolean =
          wrapped.modelEval(templates.mkEquals(e1, e2), t.BooleanType()) == Some(t.BooleanLiteral(true))
        val axioms = templates.getAxioms.filter { q =>
          wrapped.modelEval(q.guard, t.BooleanType()) != Some(t.BooleanLiteral(false))
        }
        val optError = axioms.view.flatMap(q => q.checkForall(modelEq).map(err => q.body -> err)).headOption

        optError match {
          // The model of a quantifier outside of the supported fragment can't be trusted from
          // the instantiations alone, but evaluating the formula can still show it holds (e.g.
          // a quantifier over an empty type, which holds vacuously). Evaluating quantifiers over
          // function calls or lambdas unfolds them, which may not terminate, so these are left out.
          case Some(_) if !axioms.exists(_.hasComplexMatchers(modelEq)) &&
              validateModel(model, assumptionsSeq, silenceErrors = true) =>
            sat
          case Some((expr, err)) =>
            if (!silentErrors) {
              reporter.error("Quantification " + expr.asString(using templates.program.printerOpts) +
                " does not fit in supported fragment.\n  Reason: " + err)
              reporter.error("Model obtained was:")
              reporter.error("  " + model.asString.replaceAll("\n", "\n  "))
            }
            unknown
          case None =>
            sat
        }
      } else {
        sat
      }
    }

    private def instantiateQuantifiers(): CheckState = {
      if (templates.quantificationsManager.unrollGeneration.isEmpty) {
        if (!silentErrors) {
          reporter.error("Something went wrong. The model is not transitive yet we can't instantiate!?")
        }
        CheckResult.cast(Unknown)
      } else {
        templates.promoteQuantifications
        Unroll
      }
    }

    /** Checks the query without the blockers: UNSAT proves the query unsatisfiable. */
    private def proofCheck(): CheckState = {
      // The model of a proof check only serves to test whether we got lucky and to
      // prioritize blockers during unrolling, so we don't request it when neither applies.
      if (ignoreModels || !(feelingLucky || modelFinding || templates.hasInstantiationsWithBlockers)) {
        proofCheckWithoutModel()
      } else {
        proofCheckWithModel()
      }
    }

    private def proofCheckWithoutModel(): CheckState = {
      // check without additional model-guidance for unrolling
      reporter.debug(" - Running search without blocked literals (w/o lucky test)")

      val res = context.timers.solvers.unrolling.check.run {
          underlying.checkAssumptions(Configuration(model = false, unsatAssumptions = config.withUnsatAssumptions))(
            encodedAssumptions.toSet ++ templates.refutationAssumptions
          )
        }

      reporter.debug(" - Finished search without blocked literals")

      res match {
        case Abort() =>
          CheckResult.cast(Unknown)

        case _: Unsatisfiable =>
          CheckResult.cast(res)

        case _: Satisfiable =>
          Unroll

        case otherwise => sys.error(s"Unexpected case: $otherwise")
      }
    }

    /** The model of the proof check may be a model of the query (if we are feeling lucky), and it
      * gives priority to the blockers that keep the instantiations it falsifies from being considered. */
    private def proofCheckWithModel(): CheckState = {
      if (feelingLucky) {
        reporter.debug(" - Running search without blocked literals (w/ lucky test)")
      } else {
        reporter.debug(" - Running search without blocked literals (w/o lucky test)")
      }

      // we always ask for a model here in order to give priority to blockers that
      // are keeping quantified clause instantiations from being considered
      val res: Response =
        context.timers.solvers.unrolling.check.run {
          underlying.checkAssumptions(config `max` Configuration(model = true))(
            encodedAssumptions.toSet ++ templates.refutationAssumptions
          )
        }

      reporter.debug(" - Finished search without blocked literals")

      res match {
        case Abort() =>
          CheckResult.cast(Unknown)

        case _: Unsatisfiable =>
          CheckResult.cast(res)

        case SatWithModel(model) =>
          lazy val luckyModel = if (!feelingLucky) None else {
            (try { Some(withEmptyTypes(extractSimpleModel(model), model)) } catch { case _: NoSimpleValue => None })
              .filter(exModel => withinLuckyTimeout(validateModel(exModel, assumptionsSeq, silenceErrors = true)))
          }

          if (luckyModel.isDefined) {
            CheckResult(config `cast` (if (config.withModel) SatWithModel(luckyModel.get) else Sat))
          } else {
            val wrapped = wrapModel(model)

            if (modelFinding) {
              for {
                b <- templates.satisfactionAssumptions
                v = templates.extractNot(b).getOrElse(b)
                if wrapped.eval(v, BooleanType()) == Some(BooleanLiteral(true))
              } templates.promoteBlocker(v)
            }

            for {
              (inst, bs) <- templates.getInstantiationsWithBlockers
              if wrapped.eval(inst, BooleanType()) == Some(BooleanLiteral(false))
              b <- bs
            } templates.promoteBlocker(b, force = true)

            Unroll
          }
        case otherwise => sys.error(s"Unexpected case: $otherwise")
      }
    }

    private def unroll(): CheckState = {
      if (!canUnroll) {
        reporter.debug(s"- We need to keep going, but reached unroll bound ($unrollBound)")
        unrollBoundHit = true
        CheckResult.cast(Unknown)
      } else if (!templates.canUnroll) {
        // Only satisfaction assumptions that unrolling cannot discharge are left
        reporter.debug("- We need to keep going, but nothing is left to unroll")
        CheckResult.cast(Unknown)
      } else context.timers.solvers.unrolling.unroll.run {
        reporter.debug("- We need to keep going")

        // Unrolling `unrollFactor` times
        for (i <- 1 to unrollFactor.toInt if templates.canUnroll && !abort && !pause) {
          val newClauses = templates.unroll
          for (ncl <- newClauses) {
            underlying.assertCnstr(ncl)
          }
        }

        unrollCount += 1
        if (witnessLevel > 0) witnessLevel += 1

        reporter.debug(" - Finished unrolling")
        ModelCheck
      }
    }
  }
}

trait UnrollingSolver extends AbstractUnrollingSolver { self =>
  import context.{given, _}
  import program._
  import program.trees._
  import program.symbols.{given, _}

  type Encoded = t.Expr
  protected val underlying: AbstractSolver {
    val program: targetProgram.type
    type Trees = t.Expr
    type Model = targetProgram.Model
  }

  override lazy val name = "U:" + underlying.name

  override val templates = new TemplatesImpl(targetProgram, context)

  private class TemplatesImpl(override val program: targetProgram.type, override val context: Context)
                             (using override val semantics: targetProgram.Semantics)
    extends Templates {
    import program._
    import program.trees._
    import program.symbols.{given, _}

    type Encoded = Expr

    def asString(expr: Expr): String = expr.asString
    def abort: Boolean = self.abort
    def pause: Boolean = self.pause
    def interpretation(id: Identifier, tps: Seq[Type]): Option[Lambda] = self.interpretation(id, tps)

    def encodeSymbol(v: Variable): Expr = v.freshen
    def mkEncoder(bindings: Map[Variable, Expr])(e: Expr): Expr = exprOps.replaceFromSymbols(bindings, e)
    def mkSubstituter(substMap: Map[Expr, Expr]): Expr => Expr = (e: Expr) => exprOps.replace(substMap, e)

    def mkNot(e: Expr) = not(e)
    def mkOr(es: Expr*) = orJoin(es)
    def mkAnd(es: Expr*) = andJoin(es)
    def mkEquals(l: Expr, r: Expr) = Equals(l, r)
    def mkImplies(l: Expr, r: Expr) = implies(l, r)

    // declared by the SMT-LIB target (see [[smtlib.SMTLIBTarget.declareFirstOrder]])
    type Function = (Identifier, FunctionType)
    def mkFunction(name: String, from: Seq[Type], to: Type) = (FreshIdentifier(name, true), FunctionType(from, to))
    def mkFunApp(f: Function, args: Seq[Expr]) = UninterpretedCall(f._1, Seq.empty, args, f._2)

    def extractNot(e: Expr) = e match {
      case Not(e2) => Some(e2)
      case _ => None
    }

    def decodePartial(e: Expr, tpe: Type): Option[Expr] = Some(e)
  }

  protected def declareVariable(v: t.Variable): t.Variable = v
  protected def wrapModel(model: targetProgram.Model): ModelWrapper = ModelWrapperImpl(model)

  private case class ModelWrapperImpl(model: targetProgram.Model) extends ModelWrapper {
    // The functions of the program call the uninterpreted functions that free functions stand for,
    // whose values the model gives
    private lazy val evalModel: targetProgram.Model = {
      val functions = templates.uninterpretedFunctions.toSeq.flatMap {
        case (key, (_, fT: t.Variable)) => model.vars.get(fT.toVal).map { value =>
          key -> (if (templates.uninterpretedConstants(key)) t.Lambda(Seq.empty, value) else value)
        }
        case _ => None
      }
      if (functions.isEmpty) model
      else inox.Model(targetProgram)(model.vars, model.interpretations ++ functions)
    }

    private def e(expr: t.Expr): Option[t.Expr] = modelEvaluator.eval(expr, evalModel).result

    def extractConstructor(elem: t.Expr, tpe: t.ADTType): Option[Identifier] = e(elem) match {
      case Some(t.ADT(id, _, _)) => Some(id)
      case _ => None
    }

    def extractSet(elem: t.Expr, tpe: t.SetType): Option[Seq[t.Expr]] = e(elem) match {
      case Some(t.FiniteSet(elems, _)) => Some(elems)
      case _ => None
    }

    def extractBag(elem: t.Expr, tpe: t.BagType): Option[Seq[(t.Expr, t.Expr)]] = e(elem) match {
      case Some(t.FiniteBag(elems, _)) => Some(elems)
      case _ => None
    }

    def extractMap(elem: t.Expr, tpe: t.MapType): Option[(Seq[(t.Expr, t.Expr)], t.Expr)] = e(elem) match {
      case Some(t.FiniteMap(elems, default, _, _)) => Some((elems, default))
      case _ => None
    }

    def modelEval(elem: t.Expr, tpe: t.Type): Option[t.Expr] = e(elem)
    def getUninterpreted(id: Identifier): Option[t.Expr] = model.interpretations.collectFirst {
      case ((cid, tps), e) if cid == id && tps.isEmpty => e
    }

    override def toString = model.asString(using targetProgram.printerOpts)
  }

  override def dbg(msg: => Any) = underlying.dbg(msg)

  override def push(): Unit = {
    super.push()
    underlying.push()
  }

  override def pop(): Unit = {
    super.pop()
    underlying.pop()
  }

  override def reset(): Unit = {
    underlying.reset()
    super.reset()
  }

  override def interrupt(): Unit = {
    super.interrupt()
    underlying.interrupt()
  }

  override def free(): Unit = {
    super.free()
    underlying.free()
  }
}
