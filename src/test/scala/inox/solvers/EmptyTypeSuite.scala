/* Copyright 2009-2026 EPFL, Lausanne */

package inox
package solvers

import Feature._

/** Types other than type parameters may be empty too: refinements, ADTs with invariants, and the
  * types built from them. The solver must not prove that such a type is inhabited. */
class EmptyTypeSuite extends SolverTestSuite {
  import inox.trees.{given, _}
  import inox.trees.dsl.{given, _}
  import SolverResponses.{given, _}

  // case class Foo(n: BigInt) { require(false) }
  val fooID = FreshIdentifier("Foo")
  val fooConsID = FreshIdentifier("Foo")
  val fooInvID = FreshIdentifier("fooInv")
  val fooInv = mkFunDef(fooInvID)() { _ => (Seq("f" :: T(fooID)()), BooleanType(), { case Seq(_) => E(false) }) }
  val fooSort = mkSort(fooID, HasADTInvariant(fooInvID))() { _ => Seq((fooConsID, Seq("n" :: IntegerType()))) }

  // case class Box(foo: Foo)
  val boxID = FreshIdentifier("Box")
  val boxConsID = FreshIdentifier("Box")
  val boxSort = mkSort(boxID)() { _ => Seq((boxConsID, Seq("foo" :: T(fooID)()))) }

  // case class C(n: BigInt) { require(forall(t: BigInt => BigInt) => g(this, f(this, t)) == t) }
  // with f, g uninterpreted (the dummy implementation of a Countable[BigInt => BigInt])
  val cID = FreshIdentifier("C")
  val cConsID = FreshIdentifier("C")
  val cInvID = FreshIdentifier("cInv")
  val fID = FreshIdentifier("f")
  val gID = FreshIdentifier("g")
  val ffTpe = IntegerType() =>: IntegerType()
  def fCall(c: Expr, t: Expr) = UninterpretedCall(fID, Seq(), Seq(c, t), FunctionType(Seq(T(cID)(), ffTpe), IntegerType()))
  def gCall(c: Expr, n: Expr) = UninterpretedCall(gID, Seq(), Seq(c, n), FunctionType(Seq(T(cID)(), IntegerType()), ffTpe))
  val cInv = mkFunDef(cInvID)() { _ => (Seq("c" :: T(cID)()), BooleanType(), { case Seq(c) =>
    forall("t" :: ffTpe)(t => gCall(c, fCall(c, t)) === t)
  }) }
  val cSort = mkSort(cID, HasADTInvariant(cInvID))() { _ => Seq((cConsID, Seq("n" :: IntegerType()))) }

  override protected def symbols: Symbols =
    NoSymbols.withFunctions(Seq(fooInv, cInv)).withSorts(Seq(fooSort, boxSort, cSort))
  given Symbols = symbols

  val fooT = T(fooID)()
  val emptyRefinement = RefinementType("v" :: IntegerType(), E(false))

  private def notUnsat(e: Expr)(using ctx: Context): Unit = {
    val res = solver(ctx).solveSAT(e)
    assert(!res.isUNSAT, s"expected SAT or unknown, got $res")
  }
  private def unsat(e: Expr)(using ctx: Context): Unit = {
    val res = solver(ctx).solveSAT(e)
    assert(res.isUNSAT, s"expected UNSAT, got $res")
  }

  test("empty refinement", Quantifiers) { ctx => notUnsat(forall("x" :: emptyRefinement)(_ => E(false)))(using ctx) }
  test("refinement whose values are not all empty", Quantifiers) { ctx =>
    unsat(forall("x" :: RefinementType("v" :: IntegerType(), E(true)))(_ => E(false)))(using ctx)
  }
  test("ADT with false invariant", ADTs, Quantifiers) { ctx => notUnsat(forall("x" :: fooT)(_ => E(false)))(using ctx) }
  test("ADT with empty field", ADTs, Quantifiers) { ctx => notUnsat(forall("x" :: T(boxID)())(_ => E(false)))(using ctx) }
  test("function into an empty ADT", ADTs, Functions, Quantifiers) { ctx =>
    notUnsat(forall("x" :: (IntegerType() =>: fooT))(_ => E(false)))(using ctx)
  }
  test("function from an empty ADT", ADTs, Functions, Quantifiers) { ctx =>
    unsat(forall("x" :: (fooT =>: IntegerType()))(_ => E(false)))(using ctx)
  }
  test("tuple with an empty component", ADTs, Quantifiers) { ctx =>
    notUnsat(forall("x" :: TupleType(Seq(IntegerType(), fooT)))(_ => E(false)))(using ctx)
  }
  test("free function from an empty ADT", ADTs, Functions, Quantifiers) { ctx =>
    val h = Variable.fresh("h", fooT =>: IntegerType())
    notUnsat(h === h && forall("x" :: fooT)(_ => E(false)))(using ctx)
  }
  test("set of an empty ADT", ADTs, Sets, Quantifiers) { ctx =>
    val s = Variable.fresh("s", SetType(fooT))
    notUnsat(s === s && forall("x" :: fooT)(_ => E(false)))(using ctx)
  }
  test("Countable dummy: values refute the law", ADTs, Functions, Quantifiers) { ctx =>
    // with c a value, the diagonal d(x) = g(c, x)(x) + 1 refutes the invariant
    val c = Variable.fresh("c", T(cID)())
    val d = \("x" :: IntegerType())(x => Application(gCall(c, x), Seq(x)) + E(BigInt(1)))
    unsat(Application(gCall(c, fCall(c, d)), Seq(fCall(c, d))) === Application(d, Seq(fCall(c, d))))(using ctx)
  }
  test("not forall gives a value of an empty ADT", ADTs, Quantifiers) { ctx =>
    // exists x: Foo. true is false
    unsat(Not(forall("x" :: fooT)(_ => E(false))))(using ctx)
  }

  private val tp = TypeParameter.fresh("T")
  test("function into a type parameter", Functions, Quantifiers, TypeParameters) { ctx =>
    notUnsat(forall("x" :: (IntegerType() =>: tp))(_ => E(false)))(using ctx)
  }
  test("function into a type parameter, with a value", Functions, Quantifiers, TypeParameters) { ctx =>
    val y = Variable.fresh("y", tp)
    unsat(y === y && forall("x" :: (IntegerType() =>: tp))(_ => E(false)))(using ctx)
  }
  test("function into an empty ADT, used in the body", ADTs, Functions, Quantifiers) { ctx =>
    notUnsat(forall("x" :: (IntegerType() =>: fooT))(x => Application(x, Seq(E(BigInt(0)))) === Application(x, Seq(E(BigInt(1))))  && E(false)))(using ctx)
  }
  test("ADT with a field into an empty ADT", ADTs, Functions, Quantifiers) { ctx =>
    notUnsat(forall("x" :: TupleType(Seq(IntegerType() =>: fooT, IntegerType())))(_ => E(false)))(using ctx)
  }
  test("map into an empty ADT", ADTs, Maps, Quantifiers) { ctx =>
    notUnsat(forall("x" :: MapType(IntegerType(), fooT))(_ => E(false)))(using ctx)
  }
}
