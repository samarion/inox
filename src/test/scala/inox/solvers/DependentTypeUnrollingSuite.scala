/* Copyright 2009-2018 EPFL, Lausanne */

package inox
package solvers

import org.scalatest.funsuite.AnyFunSuite

/** Regression tests for the encoding of dependent types (Pi, refinements) and of
  * first-class functions in the unrolling solver, following the unfolding
  * procedure of the reducibility-based soundness proof (Voirol, EPFL thesis 9479).
  */
class DependentTypeUnrollingSuite extends AnyFunSuite {
  import inox.trees.{given, _}
  import inox.trees.dsl.{given, _}
  import SolverResponses.{given, _}

  private val posFun = refinement("r" :: IntegerType())(_ > IntegerLiteral(0))

  // FList = FNil | FCons(head: Pi(x: BigInt). {r: BigInt | r > 0}, tail: FList)
  private val fListID = FreshIdentifier("FList")
  private val fNilID = FreshIdentifier("FNil")
  private val fConsID = FreshIdentifier("FCons")
  private val fList = mkSort(fListID)() { _ => Seq(
    (fNilID, Seq()),
    (fConsID, Seq("head" :: pi("x" :: IntegerType())(_ => posFun), "tail" :: T(fListID)()))
  )}

  given symbols: Symbols = NoSymbols.withSorts(Seq(fList))
  val program = InoxProgram(symbols)

  val solverNames: Seq[String] = {
    (if (SolverFactory.hasNativeZ3) Seq("nativez3", "unrollz3") else Nil) ++
    (if (SolverFactory.hasZ3) Seq("smt-z3") else Nil) ++
    (if (SolverFactory.hasCVC4) Seq("smt-cvc4") else Nil) ++
    (if (SolverFactory.hasCVC5) Seq("smt-cvc5") else Nil) ++
    Seq("princess")
  }

  def solver(ctx: Context): SimpleSolverAPI { val program: InoxProgram } = {
    SimpleSolverAPI(program.getSolver(ctx))
  }

  protected def test(name: String)(body: Context => Unit): Unit = {
    // Workaround for a compiler crash caused by calling super.test
    def superTest(self: AnyFunSuite, name: String)(body: => Unit): Unit =
      self.test(name)(body)

    for {
      sname <- solverNames
      // Models are not checked: the default value of a function model is not constrained by
      // the codomain of its Pi type, so such models may fail validation (and yield Unknown).
      ctx = TestContext(Options(Seq(optSelectedSolvers(Set(sname)))))
    } superTest(this, s"$name solver=$sname")(body(ctx))
  }

  // Note: `===` and `!==` have the precedence of assignment operators in Scala, so
  // comparisons are parenthesized below.
  private def assertSAT(ctx: Context, e: Expr): Unit = {
    val res = solver(ctx).solveSAT(e)
    assert(res.isSAT, s"expected SAT for ${e.asString(using PrinterOptions())}, got $res")
  }

  private def assertUNSAT(ctx: Context, e: Expr): Unit = {
    val res = solver(ctx).solveSAT(e)
    assert(res.isUNSAT, s"expected UNSAT for ${e.asString(using PrinterOptions())}, got $res")
  }

  private val pos = refinement("y" :: IntegerType())(_ > IntegerLiteral(0))

  // f: Pi(x: {y: BigInt | y > 0}). {r: BigInt | r > 0}
  private val posToPos = PiType(Seq("x" :: pos), refinement("r" :: IntegerType())(_ > IntegerLiteral(0)))

  test("Pi codomain is not assumed outside of the domain") { ctx =>
    // f(0) lies outside of f's domain, so nothing is known about its result.
    val f = ("f" :: posToPos).toVariable
    assertSAT(ctx, f(IntegerLiteral(0)) <= IntegerLiteral(0))
  }

  test("Pi codomain is assumed inside of the domain") { ctx =>
    val f = ("f" :: posToPos).toVariable
    assertUNSAT(ctx, f(IntegerLiteral(1)) <= IntegerLiteral(0))
  }

  test("Pi codomain is assumed for symbolic arguments in the domain") { ctx =>
    val f = ("f" :: posToPos).toVariable
    val x = ("x" :: IntegerType()).toVariable
    assertUNSAT(ctx, x > IntegerLiteral(5) && f(x) <= IntegerLiteral(0))
    assertSAT(ctx, x < IntegerLiteral(5) && f(x) <= IntegerLiteral(0))
  }

  test("Pi codomain does not constrain equal functions outside of the domain") { ctx =>
    // Through f == g, the codomain of f must not leak into g(0).
    val f = ("f" :: posToPos).toVariable
    val g = ("g" :: (IntegerType() =>: IntegerType())).toVariable
    assertSAT(ctx, (f === g) && g(IntegerLiteral(0)) <= IntegerLiteral(0))
    assertUNSAT(ctx, (f === g) && g(IntegerLiteral(1)) <= IntegerLiteral(0))
  }

  test("dependent Pi codomain") { ctx =>
    // f: Pi(x: BigInt). {r: BigInt | r > x}
    val f = ("f" :: pi("x" :: IntegerType())(x => refinement("r" :: IntegerType())(_ > x))).toVariable
    assertUNSAT(ctx, f(IntegerLiteral(3)) <= IntegerLiteral(3))
  }

  test("dependent Pi domain") { ctx =>
    // h: Pi(x: BigInt, y: {z: BigInt | z > x}). {r: BigInt | r > 0}
    val dep = {
      val xv = "x" :: IntegerType()
      val yv = "y" :: refinement("z" :: IntegerType())(_ > xv.toVariable)
      ("h" :: PiType(Seq(xv, yv), refinement("r" :: IntegerType())(_ > IntegerLiteral(0)))).toVariable
    }
    assertUNSAT(ctx, dep(IntegerLiteral(1), IntegerLiteral(2)) <= IntegerLiteral(0))
    assertSAT(ctx, dep(IntegerLiteral(2), IntegerLiteral(1)) <= IntegerLiteral(0))
  }

  // F: Pi(g: {h: BigInt => BigInt | h(0) > 0}). {r: BigInt | r > 0}
  private val refinedFunDomain = PiType(
    Seq("g" :: refinement("h" :: (IntegerType() =>: IntegerType()))(h => h(IntegerLiteral(0)) > IntegerLiteral(0))),
    posFun)

  // F: Pi(g: Pi(x: BigInt). {r: BigInt | r > 0}). {r: BigInt | r > 0}
  private val piFunDomain = PiType(Seq("g" :: pi("x" :: IntegerType())(_ => posFun)), posFun)

  test("Pi codomain is not assumed for function arguments outside of a refined domain") { ctx =>
    val f = ("F" :: refinedFunDomain).toVariable
    val g = ("g" :: (IntegerType() =>: IntegerType())).toVariable
    assertSAT(ctx, f(\("x" :: IntegerType())(_ => IntegerLiteral(-1))) <= IntegerLiteral(0))
    assertSAT(ctx, (g(IntegerLiteral(0)) <= IntegerLiteral(0)) && (f(g) <= IntegerLiteral(0)))
  }

  test("Pi codomain is assumed for function arguments inside of a refined domain") { ctx =>
    val f = ("F" :: refinedFunDomain).toVariable
    val g = ("g" :: (IntegerType() =>: IntegerType())).toVariable
    assertUNSAT(ctx, f(\("x" :: IntegerType())(_ => IntegerLiteral(1))) <= IntegerLiteral(0))
    assertUNSAT(ctx, (g(IntegerLiteral(0)) > IntegerLiteral(0)) && (f(g) <= IntegerLiteral(0)))
  }

  test("Pi codomain is not assumed for function arguments outside of a Pi domain") { ctx =>
    val f = ("F" :: piFunDomain).toVariable
    val g = ("g" :: (IntegerType() =>: IntegerType())).toVariable
    assertSAT(ctx, f(\("x" :: IntegerType())(_ => IntegerLiteral(-1))) <= IntegerLiteral(0))
    assertSAT(ctx, f(g) <= IntegerLiteral(0))
  }

  test("Pi codomain is assumed for function arguments inside of a Pi domain") { ctx =>
    val f = ("F" :: piFunDomain).toVariable
    val g = ("g" :: pi("x" :: IntegerType())(_ => posFun)).toVariable
    assertUNSAT(ctx, f(\("x" :: IntegerType())(_ => IntegerLiteral(1))) <= IntegerLiteral(0))
    assertUNSAT(ctx, f(g) <= IntegerLiteral(0))
  }

  test("counterexamples are found for function arguments inside of a Pi domain") { ctx =>
    // The domain check must not introduce quantifiers that prevent model construction.
    val f = ("F" :: piFunDomain).toVariable
    val g = ("g" :: pi("x" :: IntegerType())(_ => posFun)).toVariable
    assertSAT(ctx, f(\("x" :: IntegerType())(_ => IntegerLiteral(1))) > IntegerLiteral(5))
    assertSAT(ctx, f(g) > IntegerLiteral(5))
  }

  test("Pi codomain with a higher-order function domain") { ctx =>
    // H: Pi(h: Pi(k: Pi(x: BigInt). {r | r > 0}). {r | r > 0}). {r | r > 0}
    val k = "k" :: pi("x" :: IntegerType())(_ => posFun)
    val h = ("H" :: PiType(Seq("h" :: PiType(Seq(k), posFun)), posFun)).toVariable
    // k => k(0) lies in the domain as k(0) > 0 for every k in Pi(x: BigInt). {r | r > 0}
    assertUNSAT(ctx, h(\(k)(k => k(IntegerLiteral(0)))) <= IntegerLiteral(0))
    // k => k(0) - 1 does not, as k may be x => 1
    assertSAT(ctx, h(\(k)(k => k(IntegerLiteral(0)) - IntegerLiteral(1))) <= IntegerLiteral(0))
  }

  test("Pi codomain with an empty domain for a function argument") { ctx =>
    // Every function lies in Pi(x: {y | false}). {r | r > 0}
    val dom = pi("x" :: refinement("y" :: IntegerType())(_ => BooleanLiteral(false)))(_ => posFun)
    val f = ("F" :: PiType(Seq("g" :: dom), posFun)).toVariable
    val g = ("g" :: (IntegerType() =>: IntegerType())).toVariable
    assertUNSAT(ctx, f(g) <= IntegerLiteral(0))
    assertSAT(ctx, f(g) > IntegerLiteral(0))
  }

  test("Pi codomain with functions in an ADT domain") { ctx =>
    // F: Pi(l: FList). {r | r > 0}
    val f = ("F" :: PiType(Seq("l" :: T(fListID)()), posFun)).toVariable
    def cons(h: Expr, t: Expr): Expr = ADT(fConsID, Seq(), Seq(h, t))
    val nil = ADT(fNilID, Seq(), Seq())
    def const(i: Int): Expr = \("x" :: IntegerType())(_ => IntegerLiteral(i))
    assertUNSAT(ctx, f(nil) <= IntegerLiteral(0))
    assertUNSAT(ctx, f(cons(const(1), nil)) <= IntegerLiteral(0))
    assertUNSAT(ctx, f(cons(const(1), cons(const(2), nil))) <= IntegerLiteral(0))
    assertSAT(ctx, f(cons(const(1), cons(const(-1), nil))) <= IntegerLiteral(0))
  }

  test("negated universal quantifier") { ctx =>
    // Regression test for the negative-polarity quantifier clause (thesis Ch. 4).
    val p = forall("x" :: IntegerType())(_ => BooleanLiteral(false))
    assertSAT(ctx, !p)
    assertUNSAT(ctx, p)
  }

  test("lambda equality is syntactic") { ctx =>
    // Lambdas with different captured values are distinct even when they are
    // extensionally equal (thesis Section 2.6.1).
    val a = ("a" :: IntegerType()).toVariable
    val b = ("b" :: IntegerType()).toVariable
    def l(c: Expr) = \("x" :: IntegerType())(x => if_ (x > x + IntegerLiteral(1)) { c } else_ { IntegerLiteral(0) })
    assertUNSAT(ctx, (a !== b) && (l(a) === l(b)))
    assertUNSAT(ctx, (a === b) && (l(a) !== l(b)))
  }

  test("lambda equality is up to simplification") { ctx =>
    // Lambda bodies are simplified before being compared, so a capture that the
    // simplifier removes no longer distinguishes lambdas.
    val a = ("a" :: IntegerType()).toVariable
    val b = ("b" :: IntegerType()).toVariable
    def l(c: Expr) = \("x" :: IntegerType())(x => c * IntegerLiteral(0))
    assertSAT(ctx, (a !== b) && (l(a) === l(b)))
  }

  test("free function equal to a lambda applies the lambda") { ctx =>
    val f = ("f" :: (IntegerType() =>: IntegerType())).toVariable
    val a = ("a" :: IntegerType()).toVariable
    val l = \("x" :: IntegerType())(x => x + a)
    assertUNSAT(ctx, (f === l) && (f(IntegerLiteral(1)) !== a + IntegerLiteral(1)))
    assertSAT(ctx, (f === l) && (f(IntegerLiteral(1)) === IntegerLiteral(5)))
  }
}
