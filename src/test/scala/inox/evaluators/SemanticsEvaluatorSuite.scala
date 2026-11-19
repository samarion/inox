/* Copyright 2009-2026 EPFL, Lausanne */

package inox
package evaluators

/** The evaluator suites, run on the evaluator generated from Inox's semantics. */
class SemanticsEvaluatorSuite extends EvaluatorSuite {
  override def mkEvaluator(p: InoxProgram, c: Context): RecursiveEvaluator { val program: p.type } =
    SemanticsEvaluator(p, c)
}

class SemanticsRecursiveEvaluatorSuite extends RecursiveEvaluatorSuite {
  override def mkEvaluator(p: InoxProgram, c: Context): RecursiveEvaluator { val program: p.type } =
    SemanticsEvaluator(p, c)
}

class SemanticsSolvingEvaluatorSuite extends SolvingEvaluatorSuite {
  override def mkEvaluator(p: InoxProgram, c: Context): RecursiveEvaluator { val program: p.type } =
    SemanticsEvaluator(p, c)
}

/** The hooks of [[SemanticsEvaluator]] for the languages that extend Inox's: lowering, and native
  * functions for the trees that aren't lowered. */
class SemanticsEvaluatorLoweringSuite extends org.scalatest.funsuite.AnyFunSuite {
  import inox.trees._

  val ctx = TestContext.empty

  // a function on dependent pairs is outside the semantics
  val x = ValDef.fresh("x", IntegerType())
  val y = ValDef.fresh("y", IntegerType())
  val pair = ValDef.fresh("p", SigmaType(Seq(x), RefinementType(y, GreaterEquals(y.toVariable, x.toVariable))))
  def second(a: Expr) = Application(Lambda(Seq(pair), TupleSelect(pair.toVariable, 2)), Seq(Tuple(Seq(a, a))))

  // a native function, which doubles its argument
  val double = FreshIdentifier("double")
  val n = ValDef.fresh("n", IntegerType())
  def twice(a: Expr) = UninterpretedCall(double, Seq(), Seq(a), IntegerType())

  val fId = FreshIdentifier("f")
  val f = new FunDef(fId, Seq(), Seq(n), IntegerType(), Plus(twice(n.toVariable), IntegerLiteral(1)), Seq())
  val gId = FreshIdentifier("g")
  val g = new FunDef(gId, Seq(), Seq(n), IntegerType(), Plus(second(n.toVariable), IntegerLiteral(1)), Seq())
  val program = InoxProgram(NoSymbols.withFunctions(Seq(f, g)))

  /** The native calls, and the trees that `e` evaluates first, which the fallback evaluates. */
  var natives = Seq.empty[Seq[Expr]]
  var fallbacks = 0

  def evaluator(lowering: Boolean) = {
    natives = Seq()
    fallbacks = 0
    class Impl(override val program: InoxProgram)(using override val semantics: program.Semantics)
      extends SemanticsEvaluator(program, ctx) with HasDefaultGlobalContext with HasDefaultRecContext {
      override protected def lower(e: Expr) = e match {
        case Lambda(Seq(vd), b) if lowering && vd.tpe.isInstanceOf[SigmaType] =>
          Some(Lambda(Seq(vd.copy(tpe = TupleType(Seq(IntegerType(), IntegerType())))), b))
        case _ => None
      }
      override protected def isNative(id: Identifier) = id == double
      override protected def native(id: Identifier, tps: Seq[Type], args: Seq[Expr]) = {
        natives :+= args
        val Seq(IntegerLiteral(i)) = args: @unchecked
        IntegerLiteral(2 * i)
      }
      override def eval(expr: Expr, model: program.Model) = super.eval(expr, model)
      override def e(expr: Expr)(using rctx: RC, gctx: GC): Expr = {
        expr match {
          case _: FunctionInvocation => fallbacks += 1
          case _ =>
        }
        super.e(expr)
      }
    }
    new Impl(program)(using program.getSemantics)
  }

  test("A native function is called on the values of its arguments") {
    val ev = evaluator(lowering = true)
    assert(ev.eval(FunctionInvocation(fId, Seq(), Seq(IntegerLiteral(20)))) == EvaluationResults.Successful(IntegerLiteral(41)))
    // in a lambda, with the value of its parameter
    val l = Application(Lambda(Seq(n), twice(n.toVariable)), Seq(IntegerLiteral(3)))
    assert(ev.eval(l).result == Some(IntegerLiteral(6)))
    assert(natives == Seq(Seq(IntegerLiteral(20)), Seq(IntegerLiteral(3))))
    assert(fallbacks == 0)
  }

  test("A lowered tree stays in the semantics") {
    val ev = evaluator(lowering = true)
    assert(ev.eval(FunctionInvocation(gId, Seq(), Seq(IntegerLiteral(41)))).result == Some(IntegerLiteral(42)))
    assert(fallbacks == 0)
  }

  test("A program that isn't lowered is left to the recursive evaluator") {
    val ev = evaluator(lowering = false)
    assert(ev.eval(FunctionInvocation(gId, Seq(), Seq(IntegerLiteral(41)))).result == Some(IntegerLiteral(42)))
    assert(fallbacks == 1)
    // which calls the native functions too
    assert(ev.eval(FunctionInvocation(fId, Seq(), Seq(IntegerLiteral(20)))).result == Some(IntegerLiteral(41)))
    assert(natives == Seq(Seq(IntegerLiteral(20))))
  }
}
