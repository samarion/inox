/* Copyright 2009-2026 EPFL, Lausanne */

package inox
package ast

import org.scalatest.funsuite.AnyFunSuite

/** Unit tests of [[TypeOps.erasePositiveRefinements]] and [[TypeOps.dropParamRefinements]]. */
class ParamRefinementsSuite extends AnyFunSuite {
  import inox.trees._
  import dsl._

  val symbols = NoSymbols
  import symbols.{erasePositiveRefinements, dropParamRefinements}

  def positive(name: String, tpe: Type = IntegerType()): RefinementType = {
    val v = ValDef.fresh(name, tpe)
    RefinementType(v, v.toVariable > E(BigInt(0)))
  }

  test("refinements are erased") {
    assert(erasePositiveRefinements(positive("x")) == IntegerType())
    assert(erasePositiveRefinements(positive("x", positive("y"))) == IntegerType())
    assert(erasePositiveRefinements(TupleType(Seq(positive("x"), BooleanType()))) ==
      TupleType(Seq(IntegerType(), BooleanType())))
  }

  test("function domains are kept") {
    val dom = positive("x")
    assert(erasePositiveRefinements(FunctionType(Seq(dom), positive("y"))) ==
      FunctionType(Seq(dom), IntegerType()))

    val a = ValDef.fresh("a", dom)
    assert(erasePositiveRefinements(PiType(Seq(a), positive("y"))) == PiType(Seq(a), IntegerType()))
  }

  test("sigma binders are erased in the types that refer to them") {
    // (a: { a | a > 0 }, { x | x < a } => BigInt)
    val a = ValDef.fresh("a", positive("a"))
    val x = ValDef.fresh("x", IntegerType())
    val dom = RefinementType(x, x.toVariable < a.toVariable)
    val SigmaType(Seq(na), FunctionType(Seq(RefinementType(nx, pred)), IntegerType())) =
      erasePositiveRefinements(SigmaType(Seq(a), FunctionType(Seq(dom), IntegerType()))): @unchecked

    assert(na.id == a.id && na.tpe == IntegerType())
    assert(nx == x)
    assert(pred == (x.toVariable < na.toVariable))
  }

  test("parameter refinements become an assumption on the body") {
    // def f(x: { x | x > 0 }, y: { y | y > x }): { r | r > x } = x + y
    val x = ValDef.fresh("x", positive("x"))
    val yv = ValDef.fresh("y", IntegerType())
    val y = ValDef.fresh("y", RefinementType(yv, yv.toVariable > x.toVariable))
    val r = ValDef.fresh("r", IntegerType())
    val fd = new FunDef(FreshIdentifier("f"), Seq(), Seq(x, y),
      RefinementType(r, r.toVariable > x.toVariable), x.toVariable + y.toVariable, Seq())

    val nfd = dropParamRefinements(fd)
    val Seq(nx, ny) = nfd.params: @unchecked
    assert(nx.id == x.id && nx.tpe == IntegerType())
    assert(ny.id == y.id && ny.tpe == IntegerType())
    assert(nfd.returnType == RefinementType(r, r.toVariable > nx.toVariable))
    assert(nfd.fullBody == Assume(
      and(nx.toVariable > E(BigInt(0)), ny.toVariable > nx.toVariable),
      nx.toVariable + ny.toVariable))
  }

  test("functions without parameter refinements are unchanged") {
    val x = ValDef.fresh("x", FunctionType(Seq(positive("y")), IntegerType()))
    val fd = new FunDef(FreshIdentifier("f"), Seq(), Seq(x), IntegerType(), E(BigInt(0)), Seq())
    assert(dropParamRefinements(fd) eq fd)
  }
}
