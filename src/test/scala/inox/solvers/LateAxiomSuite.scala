/* Copyright 2009-2026 EPFL, Lausanne */

package inox
package solvers

import Feature._

/** Axioms are instantiated at the function applications that were seen before them, although the
  * clauses of their matchers are only emitted with the first axiom.
  */
class LateAxiomSuite extends SolverTestSuite {
  import inox.trees.{given, _}
  import inox.trees.dsl.{given, _}
  import SolverResponses._

  override protected def options = Seq(optCheckModels(true))

  private val I = IntegerType()

  private val idID = FreshIdentifier("id")
  private val id = mkFunDef(idID)() { _ => (
    Seq("x" :: I), I, { case Seq(x) => x + E(BigInt(0)) })
  }

  override protected def symbols: Symbols = NoSymbols.withFunctions(Seq(id))
  given Symbols = symbols

  private def withSolver(ctx: Context)(body: Solver { val program: InoxProgram } => Unit): Unit = {
    val factory = program.getSolver(ctx)
    val s = factory.getNewSolver()
    try body(s) finally factory.reclaim(s)
  }

  private val f = ("f" :: (I =>: I)).toVariable
  private val three = E(BigInt(3))

  test("An axiom is instantiated at earlier applications", Integers, Functions, Quantifiers) { ctx =>
    withSolver(ctx) { s =>
      s.assertCnstr(f(three) === E(BigInt(5)))
      assert(s.check(Simple).isSAT)
      s.assertCnstr(forall("x" :: I)(x => f(x) === E(BigInt(0))))
      assert(s.check(Simple).isUNSAT)
    }
  }

  test("An axiom is instantiated at earlier applications under unfolded calls", Integers, Functions, Quantifiers) { ctx =>
    withSolver(ctx) { s =>
      // the application only appears once the call is unfolded, under its blocker
      s.assertCnstr(f(id(three)) === E(BigInt(5)))
      assert(s.check(Simple).isSAT)
      s.assertCnstr(forall("x" :: I)(x => f(x) === E(BigInt(0))))
      assert(s.check(Simple).isUNSAT)
    }
  }

  test("A popped axiom leaves the earlier applications for the next one", Integers, Functions, Quantifiers) { ctx =>
    withSolver(ctx) { s =>
      s.assertCnstr(f(three) === E(BigInt(5)))
      s.push()
      s.assertCnstr(forall("x" :: I)(x => f(x) === E(BigInt(0))))
      assert(s.check(Simple).isUNSAT)
      s.pop()
      assert(s.check(Simple).isSAT)
      s.push()
      s.assertCnstr(forall("x" :: I)(x => f(x) === E(BigInt(5))))
      assert(s.check(Simple).isSAT)
      s.pop()
      s.assertCnstr(forall("x" :: I)(x => f(x) > E(BigInt(5))))
      assert(s.check(Simple).isUNSAT)
    }
  }
}
