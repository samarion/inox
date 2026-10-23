/* Copyright 2009-2018 EPFL, Lausanne */

package inox
package solvers

import org.scalatest.funsuite.AnyFunSuite

/** The return type of a function only holds for arguments in its parameter types (Voirol,
  * EPFL thesis 9479, §3.6), so it must not be assumed at calls with ill-typed arguments.
  */
class CallArgumentTypeSuite extends AnyFunSuite {
  import inox.trees.{given, _}
  import inox.trees.dsl.{given, _}
  import SolverResponses.{given, _}

  private def zero = refinement("y" :: IntegerType())(_ === E(BigInt(0)))
  private def pos = refinement("y" :: IntegerType())(_ > E(BigInt(0)))

  // def id0(x: {y | y == 0}): {y | y == 0} = x
  private val id0ID = FreshIdentifier("id0")
  private val id0 = mkFunDef(id0ID)() { _ => (Seq("x" :: zero), zero, { case Seq(x) => x }) }

  // def count(n: {y | y > 0}): {y | y > 0} = if (n == 1) 1 else count(n - 1) + 1
  private val countID = FreshIdentifier("count")
  private val count = mkFunDef(countID)() { _ => (Seq("n" :: pos), pos, { case Seq(n) =>
    if_ (n === E(BigInt(1))) { E(BigInt(1)) } else_ { FunctionInvocation(countID, Seq(), Seq(n - E(BigInt(1)))) + E(BigInt(1)) }
  }) }

  given symbols: Symbols = NoSymbols.withFunctions(Seq(id0, count))
  val program = InoxProgram(symbols)

  val solverNames: Seq[String] = {
    (if (SolverFactory.hasNativeZ3) Seq("nativez3", "unrollz3") else Nil) ++
    (if (SolverFactory.hasZ3) Seq("smt-z3") else Nil) ++
    (if (SolverFactory.hasCVC4) Seq("smt-cvc4") else Nil) ++
    (if (SolverFactory.hasCVC5) Seq("smt-cvc5") else Nil) ++
    Seq("princess")
  }

  protected def test(name: String)(body: SimpleSolverAPI { val program: InoxProgram } => Unit): Unit = {
    // Workaround for a compiler crash caused by calling super.test
    def superTest(self: AnyFunSuite, name: String)(body: => Unit): Unit =
      self.test(name)(body)

    for (sname <- solverNames) {
      val ctx = TestContext(Options(Seq(optSelectedSolvers(Set(sname)), optCheckModels(true))))
      superTest(this, s"$name solver=$sname")(body(SimpleSolverAPI(program.getSolver(ctx))))
    }
  }

  test("return type is not assumed for ill-typed arguments") { s =>
    // id0(1) evaluates to 1
    val res = s.solveSAT(Not(FunctionInvocation(id0ID, Seq(), Seq(E(BigInt(1)))) === E(BigInt(0))))
    assert(res.isSAT, s"expected SAT, got $res")
  }

  test("return type is assumed for well-typed arguments") { s =>
    val res = s.solveSAT(Not(FunctionInvocation(id0ID, Seq(), Seq(E(BigInt(0)))) === E(BigInt(0))))
    assert(res.isUNSAT, s"expected UNSAT, got $res")
  }

  test("return type is assumed for arguments typed by their context") { s =>
    val x = Variable.fresh("x", pos)
    val res = s.solveSAT(Not(FunctionInvocation(countID, Seq(), Seq(x)) > E(BigInt(0))))
    assert(res.isUNSAT, s"expected UNSAT, got $res")
  }
}
