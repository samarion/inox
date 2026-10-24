/* Copyright 2009-2018 EPFL, Lausanne */

package inox
package ast

import org.scalatest.funsuite.AnyFunSuite

import inox.trees._
import inox.trees.dsl._

class EqualityTypesSuite extends AnyFunSuite {

  val listID = FreshIdentifier("List")
  val consID = FreshIdentifier("Cons")
  val nilID = FreshIdentifier("Nil")
  val head = FreshIdentifier("head")
  val tail = FreshIdentifier("tail")

  val list = mkSort(listID)("T") { case Seq(tp) => Seq(
    (consID, Seq(ValDef(head, tp), ValDef(tail, T(listID)(tp)))),
    (nilID, Seq())
  )}

  val boxID = FreshIdentifier("Box")
  val boxConsID = FreshIdentifier("Box")
  val fn = FreshIdentifier("fn")

  val box = mkSort(boxID)() { _ => Seq((boxConsID, Seq(ValDef(fn, IntegerType() =>: IntegerType())))) }

  // A recursive sort with a function field in only one of its constructors
  val treeID = FreshIdentifier("Tree")
  val leafID = FreshIdentifier("Leaf")
  val nodeID = FreshIdentifier("Node")
  val children = FreshIdentifier("children")
  val label = FreshIdentifier("label")

  val tree = mkSort(treeID)() { _ => Seq(
    (leafID, Seq(ValDef(label, IntegerType() =>: IntegerType()))),
    (nodeID, Seq(ValDef(children, T(listID)(T(treeID)()))))
  )}

  val bagID = FreshIdentifier("Bag")
  val bagConsID = FreshIdentifier("Bag")
  val elems = FreshIdentifier("elems")

  val bagSort = mkSort(bagID)("T") { case Seq(tp) => Seq((bagConsID, Seq(ValDef(elems, SetType(tp))))) }

  val containsID = FreshIdentifier("contains")
  val contains = mkFunDef(containsID)("T") { case Seq(tp) => (
    Seq("l" :: T(listID)(tp), "x" :: tp), BooleanType(), { case Seq(l, x) =>
      if_ (l `is` consID) {
        l.getField(head) === x || E(containsID)(tp)(l.getField(tail), x)
      } else_ {
        E(false)
      }
    })
  }

  val memberID = FreshIdentifier("member")
  val member = mkFunDef(memberID)("U") { case Seq(tp) => (
    Seq("l" :: T(listID)(tp), "x" :: tp), BooleanType(), { case Seq(l, x) => E(containsID)(tp)(l, x) })
  }

  val sizeID = FreshIdentifier("size")
  val size = mkFunDef(sizeID)("T") { case Seq(tp) => (
    Seq("l" :: T(listID)(tp)), IntegerType(), { case Seq(l) =>
      if_ (l `is` consID) {
        E(BigInt(1)) + E(sizeID)(tp)(l.getField(tail))
      } else_ {
        E(BigInt(0))
      }
    })
  }

  val symbols = NoSymbols
    .withSorts(Seq(list, box, tree, bagSort))
    .withFunctions(Seq(contains, member, size))

  given Symbols = symbols

  val intFun = IntegerType() =>: IntegerType()

  test("base types and tuples of them admit equality") {
    assert(symbols.admitsEquality(IntegerType()))
    assert(symbols.admitsEquality(TupleType(Seq(IntegerType(), BooleanType()))))
    assert(symbols.admitsEquality(SetType(IntegerType())))
    assert(symbols.admitsEquality(MapType(IntegerType(), StringType())))
  }

  test("function types and types containing them don't admit equality") {
    assert(!symbols.admitsEquality(intFun))
    assert(!symbols.admitsEquality(TupleType(Seq(IntegerType(), intFun))))
    assert(!symbols.admitsEquality(MapType(IntegerType(), intFun)))
    assert(!symbols.admitsEquality(T(boxID)()))
  }

  test("sorts admit equality depending on their type arguments") {
    assert(symbols.admitsEquality(T(listID)(IntegerType())))
    assert(symbols.admitsEquality(T(listID)(T(listID)(IntegerType()))))
    assert(!symbols.admitsEquality(T(listID)(intFun)))
    assert(!symbols.admitsEquality(T(listID)(T(boxID)())))
    assert(symbols.admitsEquality(T(listID)(TypeParameter.fresh("T"))))
  }

  test("recursive sorts don't admit equality when one of their constructors doesn't") {
    assert(!symbols.admitsEquality(T(treeID)()))
  }

  test("equality is rejected on types that don't admit it") {
    val f = Variable.fresh("f", intFun)
    val g = Variable.fresh("g", intFun)
    val b = Variable.fresh("b", T(boxID)())
    val l = Variable.fresh("l", T(listID)(IntegerType()))

    assert(symbols.equalityViolations(Equals(f, g)).size == 1)
    assert(symbols.equalityViolations(Equals(b, b)).size == 1)
    assert(symbols.equalityViolations(Equals(l, l)).isEmpty)
    assert(symbols.equalityViolations(Equals(f(E(BigInt(1))), g(E(BigInt(1))))).isEmpty)
    assert(symbols.equalityViolations(Equals(f, \("x" :: IntegerType())(x => x))).size == 1)
  }

  test("sets, bags and map keys need types that admit equality") {
    assert(symbols.equalityViolations(Variable.fresh("s", SetType(intFun))).size == 1)
    assert(symbols.equalityViolations(Variable.fresh("s", BagType(intFun))).size == 1)
    assert(symbols.equalityViolations(Variable.fresh("m", MapType(intFun, IntegerType()))).size == 1)
    assert(symbols.equalityViolations(Variable.fresh("m", MapType(IntegerType(), intFun))).isEmpty)
    assert(symbols.equalityViolations(FiniteSet(Seq.empty, intFun)).size == 1)
    assert(symbols.equalityViolations(
      FiniteMap(Seq.empty, \("x" :: IntegerType())(x => x), IntegerType(), intFun)).isEmpty)
  }

  test("sorts with sets of functions are rejected") {
    val badID = FreshIdentifier("Bad")
    val bad = mkSort(badID)() { _ => Seq((FreshIdentifier("Bad"), Seq(ValDef(FreshIdentifier("s"), SetType(intFun))))) }
    intercept[NotWellFormedException](symbols.withSorts(Seq(bad)).ensureWellFormed)
  }

  test("equality requirements are inferred for type parameters") {
    assert(symbols.equalityRequirements(containsID) == Set(0))
    assert(symbols.equalityRequirements(memberID) == Set(0))
    assert(symbols.equalityRequirements(sizeID) == Set.empty)
    assert(symbols.equalityRequirements(bagID) == Set(0))
    assert(symbols.equalityRequirements(listID) == Set.empty)
  }

  test("instantiating a type parameter that needs equality with a function type is rejected") {
    val l = Variable.fresh("l", T(listID)(intFun))
    val f = Variable.fresh("f", intFun)

    assert(symbols.equalityViolations(E(containsID)(intFun)(l, f)).size == 1)
    assert(symbols.equalityViolations(E(memberID)(intFun)(l, f)).size == 1)
    assert(symbols.equalityViolations(E(sizeID)(intFun)(l)).isEmpty)
    assert(symbols.equalityViolations(Variable.fresh("b", T(bagID)(intFun))).size == 1)

    val bad = mkFunDef(FreshIdentifier("bad"))() { _ => (
      Seq("l" :: T(listID)(intFun), "f" :: intFun), BooleanType(), { case Seq(l, f) =>
        E(containsID)(intFun)(l, f)
      })
    }

    assert(symbols.equalityViolations(bad).size == 1)
    intercept[NotWellFormedException](symbols.withFunctions(Seq(bad)).ensureWellFormed)
    symbols.ensureWellFormed
  }
}
