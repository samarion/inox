/* Copyright 2009-2026 EPFL, Lausanne */

package inox
package certificates

import org.scalatest.funsuite.AnyFunSuite

/** The lowering of sources to the syntax of the session, on tables written by hand: a generic
  * list of the sources, of which the session has the instances at `Int` and `Bool`. */
class LoweringSuite extends AnyFunSuite {
  import Checker._

  def sexprs(text: String): List[SExpr] = parse(text)
  def sexpr(text: String): SExpr = parse(text).head

  val tables = new Lowering.Tables(
    script = sexprs("""
      (declare-fun p!0 (Int) Bool)
      (declare-fun dynLambda!0 (Int Int) Int)
    """),
    solverSymbols = sexprs("""
      (List!0 sort "List$0[BigInt]" (List!9 Int))
      (List!1 sort "List$0[Boolean]" (List!9 Bool))
      (Cons!0 constructor "Cons$0" "List$0[BigInt]" (List!9 Int))
      (Cons!1 constructor "Cons$0" "List$0[Boolean]" (List!9 Bool))
      (Nil!0 constructor "Nil$0" "List$0[BigInt]" (List!9 Int))
      (Nil!1 constructor "Nil$0" "List$0[Boolean]" (List!9 Bool))
      (head!0 selector "Cons$0" "List$0[BigInt]" "0" (List!9 Int))
      (head!1 selector "Cons$0" "List$0[Boolean]" "0" (List!9 Bool))
      (is-Cons!0 tester "Cons$0" "List$0[BigInt]" (List!9 Int))
      (size!0 function "size$0" "BigInt" (Int))
      (size!1 function "size$0" "Boolean" (Bool))
      (dynLambda!0 application "(BigInt) => BigInt" (-> Int Int))
      (Int sort "(BigInt) => BigInt" (-> Int Int))
      (x!0 variable "x$1" "BigInt")
    """),
    declarations = sexprs("""
      (declare-datatypes ((List!9 1)) ((par (T!9) ((Cons!9 (head!9 T!9) (tail!9 (List!9 T!9))) (Nil!9)))))
      (declare-fun (par (T!8) (size!9 ((List!9 T!8)) Int)))
    """),
    sourceSymbols = sexprs("""
      (List!9 sort "List$0")
      (Cons!9 constructor "Cons$0" "List$0")
      (Nil!9 constructor "Nil$0" "List$0")
      (head!9 selector "Cons$0" "List$0" "0")
      (tail!9 selector "Cons$0" "List$0" "1")
      (size!9 function "size$0")
      (typing!0 uninterpreted "typing$0")
      (x!0 variable "x$1" "BigInt" (! Int :var v :restrict (> v 0)))
      (l!0 variable "l$1" "List$0[Boolean]" (List!9 Bool))
      (f!0 variable "f$1" "(BigInt) => BigInt" (-> (! Int :var a) Int))
      (p!0 variable "p$1" "(BigInt) => Boolean" (-> Int Bool))
    """))

  def lowered(text: String): String = tables.lower(sexpr(text)).toString
  def refused(text: String): String = intercept[Lowering.Refused](tables.lower(sexpr(text))).why

  test("Constructors, selectors, testers and instances are those of the inferred sort") {
    assert(lowered("(Cons!9 x!0 (as Nil!9 (List!9 Int)))") == "(Cons!0 x!0 Nil!0)")
    assert(lowered("(head!9 l!0)") == "(head!1 l!0)")
    assert(lowered("((_ is Cons!9) (Cons!9 x!0 (as Nil!9 (List!9 Int))))") == "(is-Cons!0 (Cons!0 x!0 Nil!0))")
    assert(lowered("(size!9 l!0)") == "(size!1 l!0)")
    assert(lowered("((as Cons!9 (List!9 Bool)) true l!0)") == "(Cons!1 true l!0)")
  }

  test("Refinements don't change sorts") {
    assert(lowered("(Cons!9 x!0 (as Nil!9 (List!9 (! Int :var w :restrict (> w 1)))))") == "(Cons!0 x!0 Nil!0)")
  }

  test("Applications are of predicates, or of the dynamic application of their sort") {
    assert(lowered("(@ p!0 x!0)") == "(p!0 x!0)")
    assert(lowered("(@ f!0 x!0)") == "(dynLambda!0 f!0 x!0)")
  }

  test("Markers keep their head, and their arguments are lowered") {
    assert(lowered("((as typing!0 (List!9 Bool)) \"free\" l!0 (head!9 l!0))") ==
      "((as typing!0 (List!9 Bool)) \"free\" l!0 (head!1 l!0))")
  }

  test("Existential quantifiers are negated universal ones, and sets are those of the session") {
    assert(lowered("(exists ((y Int)) (not (= y x!0)))") == "(not (forall ((y Int)) (= y x!0)))")
    assert(lowered("(member x!0 (insert (as emptyset Int) 1 x!0))") ==
      "(set.member x!0 (set.insert x!0 (set.singleton 1)))")
    assert(lowered("(insert (as emptyset Int) x!0 1)") == "(set.insert x!0 1 (as set.empty (Set Int)))")
  }

  test("A source that can't be typed, or whose symbol the session lacks, is refused") {
    assert(refused("(as Nil!9 (List!9 Real))").contains("the session has no constructor \"Nil$0\" of sort (List!9 Real)"))
    assert(refused("Nil!9").contains("don't determine its type parameter T!9"))
    assert(refused("(lambda ((y Int)) y)").contains("can't be lowered"))
  }
}
