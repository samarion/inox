/* Copyright 2009-2026 EPFL, Lausanne */

package inox
package solvers
package smtlib

import org.scalatest.funsuite.AnyFunSuite

import scala.concurrent.duration._

/** cvc5 translates bit-vectors to integers in the programs that convert between them, see
  * [[CVC5Solver.convertsBVsAndInts]]: in its default mode, it doesn't relate a bit-vector to its
  * integer value within minutes, even on two variables, and in the translated mode, it doesn't prove
  * simple bit tricks.
  */
class CVC5BVAsIntSuite extends AnyFunSuite {
  import inox.trees.{given, _}
  import inox.trees.dsl.{given, _}
  import SolverResponses._

  // compare(a, b) = (a < b) == (BigInt(a) < BigInt(b))
  private val compareID = FreshIdentifier("compare")
  private val compare = mkFunDef(compareID)() { _ => (
    Seq("a" :: Int32Type(), "b" :: Int32Type()), BooleanType(), { case Seq(a, b) =>
      (a < b) === (BVToInt(a) < BVToInt(b))
    })
  }

  // sum(a, b) = BigInt(a) + BigInt(b)
  private val sumID = FreshIdentifier("sum")
  private val sum = mkFunDef(sumID)() { _ => (
    Seq("a" :: Int32Type(), "b" :: Int32Type()), IntegerType(), { case Seq(a, b) =>
      BVToInt(a) + BVToInt(b)
    })
  }

  // toInt(i) = i.toInt
  private val toIntID = FreshIdentifier("toInt")
  private val toInt = mkFunDef(toIntID)() { _ => (
    Seq("i" :: IntegerType()), Int32Type(), { case Seq(i) => IntToBV(32, true, i) })
  }

  // plus(a, b) = a + b, without conversions
  private val plusID = FreshIdentifier("plus")
  private val plus = mkFunDef(plusID)() { _ => (
    Seq("a" :: Int32Type(), "b" :: Int32Type()), Int32Type(), { case Seq(a, b) => a + b })
  }

  private val conversions = NoSymbols.withFunctions(Seq(compare, sum, toInt))
  private val noConversions = NoSymbols.withFunctions(Seq(plus))

  private val Seq(a, b) = Seq("a", "b").map(Variable.fresh(_, Int32Type()))
  private val i = Variable.fresh("i", IntegerType())

  private def requireCVC5(): Unit =
    if (SolverTestSuite.requiredSolvers("smt-cvc5")) assert(SolverFactory.hasCVC5, "Solver smt-cvc5 is required but isn't available")
    else assume(SolverFactory.hasCVC5, "smt-cvc5 is not available")

  /** Checks `expr` on cvc5 in `symbols`, checking the models it finds. */
  private def check(symbols: Symbols, expr: Expr, options: Seq[OptionValue[?]] = Seq.empty)
    : SolverResponse[Map[ValDef, Expr], Set[Expr]] = {
    val program = InoxProgram(symbols)
    val ctx = TestContext(Options(Seq(optSelectedSolvers(Set("smt-cvc5")), optCheckModels(true)) ++ options))
    // without the translation, the queries below don't finish in minutes
    val factory = program.getSolver(ctx).withTimeout(30.seconds)
    val s = factory.getNewSolver()
    try {
      s.assertCnstr(expr)
      s.check(Model) match {
        case SatWithModel(model) => SatWithModel(model.vars)
        case Unsat => Unsat
        case _ => Unknown
      }
    } finally factory.reclaim(s)
  }

  test("Programs are translated exactly when they convert") {
    assert(CVC5Solver.convertsBVsAndInts(InoxProgram(conversions)))
    assert(!CVC5Solver.convertsBVsAndInts(InoxProgram(noConversions)))
  }

  test("cvc5 keeps proving bit tricks in programs without conversions") {
    requireCVC5()
    given Symbols = noConversions
    // (a & (a - 1)) == a - (a & -a) clears the lowest set bit both ways: proved at once by
    // bit-blasting, and not within minutes once translated to integers
    val trick = BVAnd(a, a - Int32Literal(1)) === (a - BVAnd(a, UMinus(a)))
    assert(check(noConversions, Not(trick)) == Unsat)
  }

  test("cvc5 relates bit-vector comparisons to integer ones") {
    requireCVC5()
    given Symbols = conversions
    assert(check(conversions, Not(FunctionInvocation(compareID, Seq(), Seq(a, b)))) == Unsat)
  }

  test("cvc5 finds models through BigInt(a)") {
    requireCVC5()
    given Symbols = conversions
    val total = E(BigInt(4000000000L))
    check(conversions, FunctionInvocation(sumID, Seq(), Seq(a, b)) === total) match {
      case SatWithModel(vars) =>
        val Int32Literal(va) = vars(a.toVal): @unchecked
        val Int32Literal(vb) = vars(b.toVal): @unchecked
        assert(BigInt(va) + BigInt(vb) == BigInt(4000000000L))
      case res => fail(s"Expected a model, got $res")
    }
  }

  test("cvc5 finds models through i.toInt") {
    requireCVC5()
    given Symbols = conversions
    val constraint = andJoin(Seq(
      FunctionInvocation(toIntID, Seq(), Seq(i)) === Int32Literal(-1),
      i > E(BigInt(0)),
      i < E(BigInt(5000000000L))
    ))
    check(conversions, constraint) match {
      case SatWithModel(vars) => assert(vars(i.toVal) == IntegerLiteral(BigInt(4294967295L)))
      case res => fail(s"Expected a model, got $res")
    }
  }

  test("An explicit --solve-bv-as-int takes precedence") {
    requireCVC5()
    given Symbols = conversions
    val off = Seq(optCVC5Options(Set("--solve-bv-as-int=off")))
    val factory = InoxProgram(conversions).getSolver(TestContext(Options(Seq(optSelectedSolvers(Set("smt-cvc5"))) ++ off)))
      .withTimeout(2.seconds)
    val s = factory.getNewSolver()
    try {
      s.assertCnstr(Not(FunctionInvocation(compareID, Seq(), Seq(a, b))))
      assert(s.check(Simple) == Unknown)
    } finally factory.reclaim(s)
  }
}
