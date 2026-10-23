/* Copyright 2009-2018 EPFL, Lausanne */

package inox
package solvers

import Feature._

/** Models must distinguish nullary functions that the solver considers distinct, even when
  * they return the same value (Voirol, EPFL thesis 9479, Chapter 2).
  */
class NullaryFunctionModelSuite extends SolverTestSuite {
  import inox.trees.{given, _}
  import inox.trees.dsl.{given, _}
  import SolverResponses.{given, _}

  override protected def symbols: Symbols = NoSymbols
  given Symbols = symbols

  override protected def options = Seq(optCheckModels(true))

  private val fun = FunctionType(Seq(), IntegerType())
  private val zero = Lambda(Seq(), E(BigInt(0)))

  test("nullary function distinct from a lambda with the same result", Integers, Functions) { ctx =>
    val s = solver(ctx)
    val f = Variable.fresh("f", fun)
    val res = s.solveSAT(Application(f, Seq()) === E(BigInt(0)) && Not(f === zero))
    assert(res.isSAT, s"expected SAT with a valid model, got $res")
  }

  test("distinct nullary functions with the same result", Integers, Functions) { ctx =>
    val s = solver(ctx)
    val f = Variable.fresh("f", fun)
    val g = Variable.fresh("g", fun)
    val res = s.solveSAT(
      Application(f, Seq()) === E(BigInt(0)) && Application(g, Seq()) === E(BigInt(0)) && Not(f === g))
    assert(res.isSAT, s"expected SAT with a valid model, got $res")
  }

  test("distinct nullary functions with distinct results", Integers, Functions) { ctx =>
    val s = solver(ctx)
    val f = Variable.fresh("f", fun)
    val g = Variable.fresh("g", fun)
    val h = Variable.fresh("h", fun)
    val res = s.solveSAT(
      Application(f, Seq()) === E(BigInt(0)) && Application(g, Seq()) === E(BigInt(1)) &&
      Application(h, Seq()) === E(BigInt(1)) && Not(f === zero) && Not(g === h))
    assert(res.isSAT, s"expected SAT with a valid model, got $res")
  }

  test("equal nullary functions", Integers, Functions) { ctx =>
    val s = solver(ctx)
    val f = Variable.fresh("f", fun)
    val res = s.solveSAT(Application(f, Seq()) === E(BigInt(0)) && (f === zero))
    assert(res.isSAT, s"expected SAT with a valid model, got $res")
  }
}
