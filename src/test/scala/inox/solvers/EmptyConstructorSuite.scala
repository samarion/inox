/* Copyright 2009-2026 EPFL, Lausanne */

package inox
package solvers

import Feature._

/** Constructors flagged with [[ast.Definitions.AllowEmpty]] may have no values, as type parameters
  * may (@see [[EmptyTypeParameterSuite]]), so the solver must not prove that they have any.
  */
class EmptyConstructorSuite extends SolverTestSuite {
  import inox.trees.{given, _}
  import inox.trees.dsl.{given, _}
  import SolverResponses.{given, _}

  // An open class without known implementations: `Absurdity`, with the values of `AbsurdityExt`
  val absID = FreshIdentifier("Absurdity")
  val extID = FreshIdentifier("AbsurdityExt")
  val absSort = mkSort(absID, AllowEmpty(extID))() { _ => Seq((extID, Seq("x" :: IntegerType()))) }
  val absT = T(absID)()

  // An open class with a known implementation `Known`
  val openID = FreshIdentifier("Open")
  val knownID = FreshIdentifier("Known")
  val openExtID = FreshIdentifier("OpenExt")
  val openSort = mkSort(openID, AllowEmpty(openExtID))() { _ => Seq(
    (knownID, Seq()),
    (openExtID, Seq("x" :: IntegerType()))
  )}

  // A generic open class `Countable[T]`
  val countableID = FreshIdentifier("Countable")
  val countableExtID = FreshIdentifier("CountableExt")
  val countableSort = mkSort(countableID, AllowEmpty(countableExtID))("T") { _ =>
    Seq((countableExtID, Seq("x" :: IntegerType())))
  }

  val listID = FreshIdentifier("List")
  val consID = FreshIdentifier("Cons")
  val nilID = FreshIdentifier("Nil")
  val head = FreshIdentifier("head")
  val tail = FreshIdentifier("tail")
  val listSort = mkSort(listID)("A") { case Seq(a) => Seq(
    (consID, Seq(ValDef(head, a), ValDef(tail, T(listID)(a)))),
    (nilID, Seq())
  )}

  override protected def symbols: Symbols =
    NoSymbols.withSorts(Seq(absSort, openSort, countableSort, listSort))
  given Symbols = symbols

  private val fID = FreshIdentifier("f")
  // an uninterpreted method of the open class
  private def f(a: Expr) = UninterpretedCall(fID, Seq(), Seq(a), FunctionType(Seq(absT), IntegerType()))
  // the contract of `f`, which no implementation can meet
  private val contract = forall("a" :: absT)(a => f(a) > E(BigInt(0)) && f(a) < E(BigInt(0)))

  private def empty(tpe: Type) = forall("x" :: tpe)(_ => E(false))

  private def notUnsat(e: Expr)(using ctx: Context): Unit = {
    val res = solver(ctx).solveSAT(e)
    assert(!res.isUNSAT, s"expected SAT or unknown, got $res")
  }

  private def unsat(e: Expr)(using ctx: Context): Unit = {
    val res = solver(ctx).solveSAT(e)
    assert(res.isUNSAT, s"expected UNSAT, got $res")
  }

  test("constructors that may be empty are not proven inhabited", ADTs, Quantifiers) { ctx => given Context = ctx
    notUnsat(empty(absT))
  }

  test("an unsatisfiable contract empties the constructor", ADTs, Quantifiers) { ctx => given Context = ctx
    notUnsat(contract)
  }

  test("an unsatisfiable contract refutes the values of the constructor", ADTs, Quantifiers) { ctx => given Context = ctx
    unsat(contract && Not(empty(absT)))
  }

  test("a free value of the constructor makes it inhabited", ADTs, Quantifiers) { ctx => given Context = ctx
    val y = Variable.fresh("y", absT)
    unsat(Equals(y, y) && empty(absT))
  }

  test("free values hold no value of an empty constructor", ADTs, Quantifiers) { ctx => given Context = ctx
    val xs = Variable.fresh("xs", T(listID)(absT))
    unsat(xs.is(consID) && xs.getField(tail).is(consID) && empty(absT))
  }

  test("free values without values of an empty constructor remain", ADTs, Quantifiers) { ctx => given Context = ctx
    val xs = Variable.fresh("xs", T(listID)(absT))
    notUnsat(xs.is(nilID) && empty(absT))
  }

  test("other constructors still inhabit the sort", ADTs, Quantifiers) { ctx => given Context = ctx
    unsat(empty(T(openID)()))
  }

  test("values of other constructors don't inhabit an empty constructor", ADTs, Quantifiers) { ctx => given Context = ctx
    val y = Variable.fresh("y", T(openID)())
    notUnsat(y.is(knownID) && forall("x" :: T(openID)())(x => x.is(knownID)))
  }

  test("constructors have values at each instantiation of their type parameters", ADTs, Quantifiers, Functions) { ctx => given Context = ctx
    val y = Variable.fresh("y", T(countableID)(IntegerType()))
    notUnsat(Equals(y, y) && empty(T(countableID)(IntegerType() =>: IntegerType())))
  }

  test("values at an instantiation inhabit the constructor at that instantiation", ADTs, Quantifiers) { ctx => given Context = ctx
    val y = Variable.fresh("y", T(countableID)(IntegerType()))
    unsat(Equals(y, y) && empty(T(countableID)(IntegerType())))
  }

  test("free values are checked once the constructor may be empty", ADTs, Quantifiers) { ctx => given Context = ctx
    val factory = program.getSolver(ctx)
    val s = factory.getNewSolver()
    try {
      val xs = Variable.fresh("xs", T(listID)(absT))
      // nothing lets the constructor be empty yet, so `xs` isn't unrolled down to its values of it
      s.assertCnstr(xs.is(consID) && xs.getField(tail).is(consID))
      assert(s.check(Simple).isSAT)
      s.push()
      s.assertCnstr(empty(absT))
      assert(s.check(Simple).isUNSAT)
      s.pop()
      assert(s.check(Simple).isSAT)
    } finally factory.reclaim(s)
  }

  test("sorts with only constructors that may be empty have no known instance") { ctx => given Context = ctx
    assert(program.symbols.hasInstance(absT).isEmpty)
    assert(program.symbols.hasInstance(T(openID)()) == Some(true))
  }

  test("simplest values avoid constructors that may be empty") { ctx => given Context = ctx
    given program.Semantics = program.getSemantics
    assert(program.symbols.simplestValue(T(openID)()) == ADT(knownID, Seq(), Seq()))
    assert(program.symbols.simplestValue(absT) == ADT(extID, Seq(), Seq(IntegerLiteral(0))))
  }

  test("only constructors of the sort may be empty") { ctx => given Context = ctx
    val badSort = mkSort(FreshIdentifier("Bad"), AllowEmpty(extID))() { _ => Seq((FreshIdentifier("Bad"), Seq())) }
    assertThrows[NotWellFormedException](NoSymbols.withSorts(Seq(absSort, badSort)).ensureWellFormed)
  }
}
