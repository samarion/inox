/* Copyright 2009-2026 EPFL, Lausanne */

package inox
package solvers
package unrolling

/** Uninterpreted functions return arbitrary values of their return types, which models define. */
class UninterpretedFunctionSuite extends UnrollingTestSuite {
  import trees._
  import dsl._
  import SolverResponses._

  // An uninterpreted function whose body would contradict the queries below
  val id = mkFunDef(FreshIdentifier("id"), Uninterpreted)()(_ => (
    Seq("x" :: IntegerType()), IntegerType(), { case Seq(x) => x }))

  // An uninterpreted function with a dependent return type
  val greater = {
    val x = ValDef.fresh("x", IntegerType())
    val v = ValDef.fresh("v", IntegerType())
    mkFunDef(FreshIdentifier("greater"), Uninterpreted)()(_ => (
      Seq(x), RefinementType(v, v.toVariable > x.toVariable), { case Seq(x) => x + E(BigInt(1)) }))
  }

  // A generic uninterpreted function
  val pick = mkFunDef(FreshIdentifier("pick"), Uninterpreted)("T")(tps => (
    Seq("x" :: tps.head), tps.head, { case Seq(x) => x }))

  // A function that calls an uninterpreted one
  val incId = mkFunDef(FreshIdentifier("incId"))()(_ => (
    Seq("x" :: IntegerType()), IntegerType(), { case Seq(x) => id(x) + E(BigInt(1)) }))

  val symbols = NoSymbols.withFunctions(Seq(id, greater, pick, incId))
  val program = InoxProgram(symbols)

  /** The model of `clause`, after checking that it satisfies the clause. */
  def modelOf(clause: Expr)(using Context): program.Model = {
    val res = SimpleSolverAPI(program.getSolver).solveSAT(clause)
    val SatWithModel(model) = res: @unchecked
    val evaluator = program.getSemantics.withFunctions(model.functions).getEvaluator
    val evRes = evaluator.eval(clause, model)
    assert(evRes.result == Some(BooleanLiteral(true)), s"$evRes in $model")
    model
  }

  test("bodies of uninterpreted functions are ignored") {
    val model = modelOf(id(IntegerLiteral(0)) === IntegerLiteral(1))
    assert(model.interpretations contains (id.id -> Seq.empty), model)
  }

  test("uninterpreted functions are functions") {
    val x = Variable.fresh("x", IntegerType())
    val y = Variable.fresh("y", IntegerType())
    val clause = x === y && Not(id(x) === id(y))
    assert(SimpleSolverAPI(program.getSolver).solveSAT(clause).isUNSAT)
  }

  test("results of uninterpreted functions lie in their return types") {
    val x = Variable.fresh("x", IntegerType())
    assert(SimpleSolverAPI(program.getSolver).solveSAT(greater(x) <= x).isUNSAT)
    modelOf(greater(IntegerLiteral(0)) === IntegerLiteral(5))
  }

  test("calls to uninterpreted functions through other functions") {
    val x = Variable.fresh("x", IntegerType())
    modelOf(incId(IntegerLiteral(0)) === IntegerLiteral(5))
    modelOf(incId(x) === IntegerLiteral(5) && id(IntegerLiteral(3)) === IntegerLiteral(2))
  }

  test("generic uninterpreted functions are defined at each instantiation") {
    val tp = TypeParameter.fresh("A")
    val a = Variable.fresh("a", tp)
    val model = modelOf(Not(pick(tp)(a) === a) && pick(IntegerType())(IntegerLiteral(0)) === IntegerLiteral(1))
    assert(model.interpretations contains (pick.id -> Seq(tp)), model)
    assert(model.interpretations contains (pick.id -> Seq(IntegerType())), model)
  }

  test("evaluating an uninterpreted function needs a model") { ctx ?=>
    val res = program.getEvaluator.eval(incId(IntegerLiteral(0)))
    assert(res.isInstanceOf[evaluators.EvaluationResults.EvaluatorError], res)
  }
}
