/* Copyright 2009-2018 EPFL, Lausanne */

package inox
package solvers

import org.scalatest.funsuite.AnyFunSuite

/** Models must distinguish nullary functions that the solver considers distinct, even when
  * they return the same value (Voirol, EPFL thesis 9479, Chapter 2).
  */
class NullaryFunctionModelSuite extends AnyFunSuite {
  import inox.trees.{given, _}
  import inox.trees.dsl.{given, _}
  import SolverResponses.{given, _}

  given symbols: Symbols = NoSymbols
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

  private val fun = FunctionType(Seq(), IntegerType())
  private val zero = Lambda(Seq(), E(BigInt(0)))

  test("nullary function distinct from a lambda with the same result") { s =>
    val f = Variable.fresh("f", fun)
    val res = s.solveSAT(Application(f, Seq()) === E(BigInt(0)) && Not(f === zero))
    assert(res.isSAT, s"expected SAT with a valid model, got $res")
  }

  test("distinct nullary functions with the same result") { s =>
    val f = Variable.fresh("f", fun)
    val g = Variable.fresh("g", fun)
    val res = s.solveSAT(
      Application(f, Seq()) === E(BigInt(0)) && Application(g, Seq()) === E(BigInt(0)) && Not(f === g))
    assert(res.isSAT, s"expected SAT with a valid model, got $res")
  }

  test("distinct nullary functions with distinct results") { s =>
    val f = Variable.fresh("f", fun)
    val g = Variable.fresh("g", fun)
    val h = Variable.fresh("h", fun)
    val res = s.solveSAT(
      Application(f, Seq()) === E(BigInt(0)) && Application(g, Seq()) === E(BigInt(1)) &&
      Application(h, Seq()) === E(BigInt(1)) && Not(f === zero) && Not(g === h))
    assert(res.isSAT, s"expected SAT with a valid model, got $res")
  }

  test("equal nullary functions") { s =>
    val f = Variable.fresh("f", fun)
    val res = s.solveSAT(Application(f, Seq()) === E(BigInt(0)) && (f === zero))
    assert(res.isSAT, s"expected SAT with a valid model, got $res")
  }
}
