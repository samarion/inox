/* Copyright 2009-2026 EPFL, Lausanne */

package inox
package solvers
package smtlib

class ResourceLimitSuite extends TestSuite {
  import inox.trees._
  import dsl._
  import SolverResponses._

  override def configurations = Seq(
    Seq(optSelectedSolvers(Set("smt-z3")), optZ3Rlimit(1L)),
    Seq(optSelectedSolvers(Set("smt-cvc5")), optCVC5Rlimit(1L))
  )

  override def optionsString(options: Options): String =
    "solver=" + options.findOptionOrDefault(optSelectedSolvers).head

  given symbols: Symbols = NoSymbols
  val program = InoxProgram(symbols)

  // Factoring a product of two primes takes the solvers far more than one unit of resources
  val x = Variable.fresh("x", IntegerType())
  val y = Variable.fresh("y", IntegerType())
  val hard = And(Seq(
    Equals(Times(x, y), E(BigInt(1000003) * BigInt(999983))),
    GreaterThan(x, E(BigInt(1))),
    GreaterThan(y, E(BigInt(1)))))

  test("A query that exhausts the resource limit is unknown, and says so") { ctx ?=>
    val solver = program.getSolver(ctx).getNewSolver()
    try {
      solver.assertCnstr(hard)
      assert(solver.check(Simple) == Unknown)
      assert(solver.resourceLimitReached)
    } finally {
      solver.free()
    }
  }

  test("Without a resource limit, the solver doesn't report one") { ctx ?=>
    val noLimit = ctx.withOpts(optZ3Rlimit(0L), optCVC5Rlimit(0L))
    val solver = program.getSolver(noLimit).getNewSolver()
    try {
      solver.assertCnstr(GreaterThan(x, E(BigInt(1))))
      assert(solver.check(Simple) == Sat)
      assert(!solver.resourceLimitReached)
    } finally {
      solver.free()
    }
  }
}
