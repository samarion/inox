/* Copyright 2009-2018 EPFL, Lausanne */

package inox
package solvers

import org.scalatest.funsuite.AnyFunSuite

/** Type parameters may be instantiated with empty types (Voirol, EPFL thesis 9479, Chapter 3),
  * so the unrolling solver must not prove that a type parameter is inhabited.
  */
class EmptyTypeParameterSuite extends AnyFunSuite {
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
      val ctx = TestContext(Options(Seq(optSelectedSolvers(Set(sname)))))
      superTest(this, s"$name solver=$sname")(body(SimpleSolverAPI(program.getSolver(ctx))))
    }
  }

  private val tp = TypeParameter.fresh("T")

  test("type parameters are not proven inhabited") { s =>
    // Satisfiable when T is empty
    val res = s.solveSAT(forall("x" :: tp)(_ => E(false)))
    assert(!res.isUNSAT, s"expected SAT or unknown, got $res")
  }

  test("inhabited type parameters are still refuted") { s =>
    val y = Variable.fresh("y", tp)
    val res = s.solveSAT(Equals(y, y) && forall("x" :: tp)(_ => E(false)))
    assert(res.isUNSAT, s"expected UNSAT, got $res")
  }

  test("generic properties are still proven") { s =>
    val res = s.solveSAT(Not(forall("x" :: tp, "z" :: tp)((x, z) => (x === z) ==> (z === x))))
    assert(res.isUNSAT, s"expected UNSAT, got $res")
  }
}
