/* Copyright 2009-2018 EPFL, Lausanne */

package inox
package solvers
package unrolling

class FunctionEqualitySuite extends SolvingTestSuite with DatastructureUtils {
  import inox.trees._
  import dsl._

  val f = FreshIdentifier("f")
  val mmapID = FreshIdentifier("MMap")
  val mmapConsID = mmapID.freshen
  val mmap = mkSort(mmapID)("A","B") {
    case Seq(aT, bT) => Seq(
      (mmapConsID, Seq(ValDef(f, aT =>: T(optionID)(bT))))
    )
  }

  val containsID = FreshIdentifier("contains")
  val contains = mkFunDef(containsID)("A", "B") { case Seq(aT, bT) => (
    Seq("m" :: T(mmapID)(aT, bT), "k" :: aT), BooleanType(), { case Seq(m, k) =>
      m.getField(f)(k) `is` someID
    })
  }

  val symbols = baseSymbols
    .withFunctions(Seq(contains))
    .withSorts(Seq(mmap))

  val program = InoxProgram(symbols)

  test("simple theorem") {
    val clause = let(
      "states" :: T(mmapID)(IntegerType(), IntegerType() =>: IntegerType()),
      C(mmapConsID)(IntegerType(), IntegerType() =>: IntegerType())(\("i" :: IntegerType())(i => C(someID)(IntegerType() =>: IntegerType())(\("x" :: IntegerType())(x => IntegerLiteral(0)))))
    )(states => contains(IntegerType(), IntegerType() =>: IntegerType())(states, IntegerLiteral(0)) && E(false))

    assert(SimpleSolverAPI(program.getSolver).solveSAT(Not(clause)).isSAT)
  }

  test("equality between functions is rejected") {
    val f = ("f" :: (IntegerType() =>: IntegerType())).toVariable
    val g = ("g" :: (IntegerType() =>: IntegerType())).toVariable
    val clauses = Seq(
      f === (\("x" :: IntegerType())(x => g(x))),
      f === (\("x" :: IntegerType())(x => f(x))),
      f === (\("x" :: IntegerType())(x => g(x))) && g === (\("x" :: IntegerType())(x => f(x)))
    )

    for (clause <- clauses) {
      intercept[ast.TypeOps#TypeErrorException](SimpleSolverAPI(program.getSolver).solveSAT(clause))
    }
  }
}
