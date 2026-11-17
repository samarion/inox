/* Copyright 2009-2018 EPFL, Lausanne */

package inox
package evaluators

object optMaxCalls extends IntOptionDef("max-calls", 50000, "<PosInt> | -1 (unbounded)")

trait ContextualEvaluator extends Evaluator {
  import context.{given, _}
  import program._
  import program.trees._
  import program.symbols.{given, _}

  lazy val maxSteps: Int = options.findOptionOrDefault(optMaxCalls)
  lazy val globallyIgnoreContracts: Boolean = options.findOptionOrDefault(optIgnoreContracts)

  trait RecContext[RC <: RecContext[RC]] {
    def tps: Seq[Type]
    def mappings: Map[ValDef, Expr]
    def interpretations: Map[(Identifier, Seq[Type]), Expr]
    def locallyIgnoreContracts: Boolean

    def newTypes(tps: Seq[Type]): RC

    def newVars(news: Map[ValDef, Expr]): RC
    def withNewVar(vd: ValDef, expr: Expr): RC = newVars(mappings + (vd -> expr))
    def withNewVars(news: Map[ValDef, Expr]): RC = newVars(mappings ++ news)
    def withLocallyIgnoredContracts: RC

    def newInterpretations(news: Map[(Identifier, Seq[Type]), Expr]): RC
  }

  case class DefaultRecContext(
    tps: Seq[Type],
    mappings: Map[ValDef, Expr],
    interpretations: Map[(Identifier, Seq[Type]), Expr],
    locallyIgnoreContracts: Boolean
  ) extends RecContext[DefaultRecContext] {
    def newTypes(tps: Seq[Type]) = copy(tps = tps)
    def newVars(news: Map[ValDef, Expr]) = copy(mappings = news)
    def newInterpretations(news: Map[(Identifier, Seq[Type]), Expr]) = copy(interpretations = news)
    def withLocallyIgnoredContracts = copy(locallyIgnoreContracts = true)
  }

  class GlobalContext(val maxSteps: Int) {
    var stepsLeft = maxSteps

    /** The calls being evaluated, whose arguments are compared by reference (see [[ActiveCall]]). */
    val activeCalls = new java.util.HashSet[ActiveCall]
  }

  /** A call being evaluated. Evaluation is deterministic, so a call that reaches itself on the same
    * arguments never returns. Arguments are compared by reference, which is cheap and catches the
    * calls that pass their parameters on unchanged, e.g. `def f(x: Int): Int = f(x)`. */
  final class ActiveCall(val id: Identifier, val tps: Seq[Type], val args: Seq[Expr]) {
    override def hashCode: Int = (id, tps, args.map(System.identityHashCode)).hashCode
    override def equals(that: Any): Boolean = that match {
      case c: ActiveCall => c.id == id && c.tps == tps && c.args.size == args.size &&
        c.args.lazyZip(args).forall(_ eq _)
      case _ => false
    }
  }

  type RC <: RecContext[RC]
  type GC <: GlobalContext

  def initRC(model: program.Model): RC
  def initGC: GC

  case class EvalError(msg: String) extends Exception {
    override def getMessage = msg + Option(super.getMessage).map("\n" + _).getOrElse("")
  }
  case class RuntimeError(msg: String) extends Exception
  case class QuantificationError(msg: String) extends Exception

  def eval(expr: Expr, model: program.Model) = timers.evaluators.recursive.runtime.run {
    try {
      given gctx: GC = initGC
      // the type parameters that the model gives types to are evaluated as these types, which the
      // values of the model already have
      val ex = typeOps.instantiateType(expr, model.types)
      val rctx = initRC(model)
      val modelRctx = rctx.newVars(Map.empty)
      // Solvers evaluate many small expressions in large models, so the evaluation only gets the
      // values of the variables that `ex` reads, brought to the evaluator's form, rather than every
      // value of the model
      val values = exprOps.variablesOf(ex).iterator.map(_.toVal).flatMap { vd =>
        rctx.mappings.get(vd).map(v => vd -> modelValue(v)(using modelRctx))
      }.toMap
      EvaluationResults.Successful(e(ex)(using rctx.newVars(values)))
    } catch {
      case EvalError(msg) =>
        EvaluationResults.EvaluatorError(msg)
      case so: StackOverflowError =>
        EvaluationResults.RuntimeError("Stack overflow")
      case e @ RuntimeError(msg) =>
        EvaluationResults.RuntimeError(msg)
      case jre: java.lang.RuntimeException =>
        EvaluationResults.RuntimeError(jre.getMessage)
    }
  }

  protected def e(expr: Expr)(using rctx: RC, gctx: GC): Value

  /** The model value `v` in the form the evaluator gives to the values it builds. */
  protected def modelValue(v: Expr)(using rctx: RC, gctx: GC): Expr = v

  protected def ignoreContractsOn(expr: Expr)(using rctx: RC, gctx: GC): Boolean =
    globallyIgnoreContracts || rctx.locallyIgnoreContracts

  def typeErrorMsg(tree: Expr, expected: Type): String =
    s"""|Type error : expected ${expected.asString}, found ${tree.asString} of type ${tree.getType}.
        |
        |Type explanation:
        |${symbols.explainTyping(tree)(using new PrinterOptions())}
        """.stripMargin
}

trait HasDefaultRecContext extends ContextualEvaluator {
  import program.trees._
  type RC = DefaultRecContext
  def initRC(model: program.Model) = DefaultRecContext(Seq.empty, model.vars, model.interpretations, false)
}

trait HasDefaultGlobalContext extends ContextualEvaluator {
  type GC = GlobalContext
  def initGC = new GlobalContext(maxSteps)
}
