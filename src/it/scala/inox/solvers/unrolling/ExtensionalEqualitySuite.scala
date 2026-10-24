/* Copyright 2009-2018 EPFL, Lausanne */

package inox
package solvers
package unrolling

import SolverResponses._
import evaluators.EvaluationResults

/** Checks extensional equality between functions, and that functions that aren't extensionally
  * equal have a distinguishing input in models.
  *
  * @see [[ast.Expressions.ExtEquals]]
  */
class ExtensionalEqualitySuite extends SolvingTestSuite {
  import inox.trees._
  import dsl._

  override def configurations =
    for {
      solverName   <- Seq("nativez3", "unrollz3", "smt-z3", "smt-cvc5")
      modelFinding <- Seq(0, 1)
    } yield Seq(
      optSelectedSolvers(Set(solverName)),
      optCheckModels(true),
      optModelFinding(modelFinding),
      optTimeout(300),
    )

  override def optionsString(options: Options): String =
    "solvr=" + options.findOptionOrDefault(optSelectedSolvers).head + " " +
    "model=" + options.findOptionOrDefault(optModelFinding)

  val listID = FreshIdentifier("List")
  val consID = FreshIdentifier("Cons")
  val nilID  = FreshIdentifier("Nil")
  val head = FreshIdentifier("head")
  val tail = FreshIdentifier("tail")

  val List = mkSort(listID)("A") {
    case Seq(aT) => Seq(
      (nilID, Seq()),
      (consID, Seq(ValDef(head, aT), ValDef(tail, T(listID)(aT))))
    )
  }

  val sizeID = FreshIdentifier("size")
  val sizeFd = mkFunDef(sizeID)("A") { case Seq(aT) => (
    Seq("l" :: T(listID)(aT)), IntegerType(), { case Seq(l) =>
      if_ (l `is` consID) {
        E(BigInt(1)) + E(sizeID)(aT)(l.getField(tail))
      } else_ {
        E(BigInt(0))
      }
    })
  }

  val boxID = FreshIdentifier("Box")
  val boxConsID = FreshIdentifier("MkBox")
  val fn = FreshIdentifier("fn")

  val Box = mkSort(boxID)() {
    case Seq() => Seq((boxConsID, Seq(ValDef(fn, IntegerType() =>: IntegerType()))))
  }

  // a recursive type with function fields, like Stainless's encoding of `Object`
  val objID = FreshIdentifier("Obj")
  val funID = FreshIdentifier("Fun")
  val numID = FreshIdentifier("Num")
  val objFn = FreshIdentifier("objFn")
  val objNum = FreshIdentifier("objNum")

  val Obj = mkSort(objID)() {
    case Seq() => Seq(
      (funID, Seq(ValDef(objFn, T(objID)() =>: T(objID)()))),
      (numID, Seq(ValDef(objNum, IntegerType())))
    )
  }

  val program = InoxProgram(new Symbols(Map(sizeID -> sizeFd), Map(listID -> List, boxID -> Box, objID -> Obj)))

  val intList = T(listID)(IntegerType())

  private def solve(clause: Expr)(using Context): Map[ValDef, Expr] = {
    SimpleSolverAPI(program.getSolver).solveSAT(clause) match {
      case SatWithModel(model) => model.vars
      case res => fail(s"Expected a model, got $res")
    }
  }

  private def result(clause: Expr)(using Context) = SimpleSolverAPI(program.getSolver).solveSAT(clause)

  private def neq(e1: Expr, e2: Expr): Expr = Not(ExtEquals(e1, e2))

  /** cvc5 models don't give values to functions applied to functions, and cvc5 gives up on maps
    * with function values, even without extensional equality (e.g. for `f(h) != g(h)`). */
  private val modelsOfFunctionValues: Context => FilterStatus = ctx =>
    if (ctx.options.findOptionOrDefault(optSelectedSolvers) == Set("smt-cvc5")) Ignore else Test

  /** Closed sub-expressions of the extracted models that have type `tpe`. */
  private def candidates(tpe: Type, es: Iterable[Expr]): Set[Expr] = es.toSet.flatMap { (e: Expr) =>
    exprOps.collect[Expr] {
      case e if e.getType(using program.symbols) == tpe && exprOps.variablesOf(e).isEmpty => Set(e)
      case _ => Set.empty
    } (e)
  }

  /** Whether `f1` and `f2` give different results on some inputs taken from `pool` (by default,
    * the two functions themselves). Results of function type are compared the same way, so curried
    * functions are distinguished by a sequence of inputs. */
  private def distinguishable(f1: Expr, f2: Expr, pool: Expr*)(using ctx: Context): Boolean = {
    val FunctionType(from, _) = f1.getType(using program.symbols): @unchecked
    val exprs = pool ++ Seq(f1, f2)
    val evaluator = program.getEvaluator
    val argss = from.foldRight(Seq(Seq.empty[Expr])) { (tpe, rest) =>
      for (arg <- candidates(tpe, exprs).toSeq; args <- rest) yield arg +: args
    }
    argss.exists { args =>
      val r1 = evaluator.eval(Application(f1, args))
      val r2 = evaluator.eval(Application(f2, args))
      (r1, r2) match {
        case (EvaluationResults.Successful(v1), EvaluationResults.Successful(v2)) =>
          v1.getType(using program.symbols) match {
            case _: FunctionType => distinguishable(v1, v2, (exprs :+ v1 :+ v2)*)
            case _ => v1 != v2
          }
        case _ => false
      }
    }
  }

  // Models: functions that aren't extensionally equal are told apart by an input

  test("distinct first-order functions") {
    val f = ("f" :: (IntegerType() =>: IntegerType())).toVariable
    val g = ("g" :: (IntegerType() =>: IntegerType())).toVariable
    val model = solve(neq(f, g))
    assert(distinguishable(model(f.toVal), model(g.toVal)))
  }

  test("distinct function and lambda") {
    val f = ("f" :: (IntegerType() =>: IntegerType())).toVariable
    val lambda = \("x" :: IntegerType())(x => x + E(BigInt(1)))
    val model = solve(neq(f, lambda))
    assert(distinguishable(model(f.toVal), lambda))
  }

  test("distinct higher-order functions", modelsOfFunctionValues) {
    val tpe = (IntegerType() =>: IntegerType()) =>: IntegerType()
    val f = ("f" :: tpe).toVariable
    val g = ("g" :: tpe).toVariable
    val model = solve(neq(f, g))
    assert(distinguishable(model(f.toVal), model(g.toVal)))
  }

  test("distinct functions agreeing on an input") {
    val f = ("f" :: (IntegerType() =>: IntegerType())).toVariable
    val g = ("g" :: (IntegerType() =>: IntegerType())).toVariable
    val model = solve(neq(f, g) && f(E(BigInt(0))) === g(E(BigInt(0))))
    assert(distinguishable(model(f.toVal), model(g.toVal)))
  }

  test("many pairwise distinct functions") {
    // All functions agree on `true`, so each of them needs a different result on `false`
    val fs = (1 to 16).map(i => (s"f$i" :: (BooleanType() =>: IntegerType())).toVariable)
    val pairs = for (f1 <- fs; f2 <- fs if f1.id.globalId < f2.id.globalId) yield (f1, f2)
    val clause = andJoin(fs.map(f => f(E(true)) === E(BigInt(0))) ++ pairs.map((f1, f2) => neq(f1, f2)))
    val model = solve(clause)
    val evaluator = program.getEvaluator
    def resultOnFalse(f: Variable): Option[Expr] = evaluator.eval(Application(model(f.toVal), Seq(E(false)))) match {
      case EvaluationResults.Successful(v) => Some(v)
      case _ => None
    }
    val results = fs.map(f => f -> resultOnFalse(f)).toMap
    for ((f1, f2) <- pairs) {
      assert(results(f1).isDefined && results(f1) != results(f2), s"$f1 and $f2 aren't distinguished")
    }
  }

  test("distinct functions of several arguments") {
    val tpe = (IntegerType(), IntegerType()) =>: IntegerType()
    val f = ("f" :: tpe).toVariable
    val g = ("g" :: tpe).toVariable
    val zero = E(BigInt(0))
    val model = solve(neq(f, g) && f(zero, zero) === g(zero, zero))
    assert(distinguishable(model(f.toVal), model(g.toVal)))
  }

  test("distinct curried functions") {
    val tpe = IntegerType() =>: (IntegerType() =>: IntegerType())
    val f = ("f" :: tpe).toVariable
    val g = ("g" :: tpe).toVariable
    val model = solve(neq(f, g))
    assert(distinguishable(model(f.toVal), model(g.toVal)))
  }

  test("distinct function and closure") {
    // the lambda captures `y`, so it is only known up to the value of `y`
    val f = ("f" :: (IntegerType() =>: IntegerType())).toVariable
    val y = ("y" :: IntegerType()).toVariable
    val lambda = \("x" :: IntegerType())(x => x + y)
    val model = solve(neq(f, lambda) && f(E(BigInt(0))) === y)
    val closed = \("x" :: IntegerType())(x => x + model(y.toVal))
    assert(distinguishable(model(f.toVal), closed))
  }

  test("distinct functions in datatypes") {
    val b1 = ("b1" :: T(boxID)()).toVariable
    val b2 = ("b2" :: T(boxID)()).toVariable
    val zero = E(BigInt(0))
    val model = solve(neq(b1, b2) && b1.getField(fn)(zero) === b2.getField(fn)(zero))
    (model(b1.toVal), model(b2.toVal)) match {
      case (ADT(_, _, Seq(f1)), ADT(_, _, Seq(f2))) => assert(distinguishable(f1, f2))
      case res => fail(s"Unexpected model: $res")
    }
  }

  test("distinct functions on a type parameter") {
    val tp = TypeParameter.fresh("A")
    val f = ("f" :: (tp =>: tp)).toVariable
    val g = ("g" :: (tp =>: tp)).toVariable
    val model = solve(neq(f, g))
    assert(distinguishable(model(f.toVal), model(g.toVal)))
  }

  test("all Boolean functions") {
    // There are exactly four functions from Boolean to Boolean, so the model must contain each
    // of them, with a distinguishing input for every pair.
    val fs = (1 to 4).map(i => (s"f$i" :: (BooleanType() =>: BooleanType())).toVariable)
    val pairs = for (f1 <- fs; f2 <- fs if f1.id.globalId < f2.id.globalId) yield (f1, f2)
    val model = solve(andJoin(pairs.map((f1, f2) => neq(f1, f2))))
    for ((f1, f2) <- pairs) {
      assert(distinguishable(model(f1.toVal), model(f2.toVal), E(true), E(false)), s"$f1 and $f2 aren't distinguished")
    }
  }

  test("distinguishing input that needs unfolding") {
    // `f` and `g` agree on every list of size 0 or 1, so the distinguishing input must be a
    // longer list, which requires unfolding `size` on it
    val tpe = intList =>: IntegerType()
    val h = ("h" :: tpe).toVariable
    val k = ("k" :: tpe).toVariable
    def agreeOnShortLists(h: Expr) =
      \("l" :: intList)(l => if_ (sizeFd(IntegerType())(l) <= E(BigInt(1))) { E(BigInt(0)) } else_ { h(l) })
    val (f, g) = (agreeOnShortLists(h), agreeOnShortLists(k))
    val model = solve(neq(f, g))
    val (fm, gm) = (exprOps.replaceFromSymbols(model, f), exprOps.replaceFromSymbols(model, g))
    assert(distinguishable(fm, gm))
  }

  test("distinct functions next to a recursive function") {
    val f = ("f" :: (IntegerType() =>: IntegerType())).toVariable
    val g = ("g" :: (IntegerType() =>: IntegerType())).toVariable
    val l = ("l" :: intList).toVariable
    val size = sizeFd(IntegerType())(l)
    val model = solve(neq(f, g) && f(size) === g(E(BigInt(2))) && size > E(BigInt(2)))
    assert(distinguishable(model(f.toVal), model(g.toVal)))
  }

  test("distinct functions over a recursive type with function fields") {
    val tpe = T(objID)() =>: T(objID)()
    val f = ("f" :: tpe).toVariable
    val g = ("g" :: tpe).toVariable
    val model = solve(neq(f, g))
    assert(distinguishable(model(f.toVal), model(g.toVal)))
  }

  test("distinct maps with function values", modelsOfFunctionValues) {
    val tpe = MapType(IntegerType(), IntegerType() =>: IntegerType())
    val m1 = ("m1" :: tpe).toVariable
    val m2 = ("m2" :: tpe).toVariable
    assert(result(neq(m1, m2)).isSAT)
  }

  // Equal functions: extensional equality holds regardless of how functions are written

  test("eta-expanded function") {
    val f = ("f" :: (IntegerType() =>: IntegerType())).toVariable
    val g = ("g" :: (IntegerType() =>: IntegerType())).toVariable
    assert(result(f =~= \("x" :: IntegerType())(x => g(x))).isSAT)
    assert(result(neq(f, \("x" :: IntegerType())(x => f(x)))).isUNSAT)
  }

  test("structurally distinct, extensionally equal lambdas") {
    val id = \("x" :: IntegerType())(x => x)
    val alsoId = \("x" :: IntegerType())(x => if_ (x === E(BigInt(0))) { E(BigInt(0)) } else_ { x })
    assert(result(neq(id, alsoId)).isUNSAT)
    assert(result(neq(\("x" :: IntegerType())(x => x + E(BigInt(1))), \("x" :: IntegerType())(x => E(BigInt(1)) + x))).isUNSAT)
  }

  test("functions equal on every input") {
    val f = ("f" :: (IntegerType() =>: IntegerType())).toVariable
    val g = ("g" :: (IntegerType() =>: IntegerType())).toVariable
    assert(result(neq(f, g) && forall("x" :: IntegerType())(x => f(x) === g(x))).isUNSAT)
  }

  test("more distinct Boolean functions than there are") {
    val fs = (1 to 5).map(i => (s"f$i" :: (BooleanType() =>: BooleanType())).toVariable)
    val pairs = for (f1 <- fs; f2 <- fs if f1.id.globalId < f2.id.globalId) yield (f1, f2)
    assert(result(andJoin(pairs.map((f1, f2) => neq(f1, f2)))).isUNSAT)
  }

  test("functions on Unit agreeing on ()") {
    val f = ("f" :: (UnitType() =>: IntegerType())).toVariable
    val g = ("g" :: (UnitType() =>: IntegerType())).toVariable
    val clause = neq(f, g) && f(UnitLiteral()) === E(BigInt(0)) && g(UnitLiteral()) === E(BigInt(0))
    assert(result(clause).isUNSAT)
  }

  test("equal functions agree") {
    val f = ("f" :: (IntegerType() =>: IntegerType())).toVariable
    val g = ("g" :: (IntegerType() =>: IntegerType())).toVariable
    val x = ("x" :: IntegerType()).toVariable
    assert(result((f =~= g) && (f(x) !== g(x))).isUNSAT)
  }

  test("equal datatypes have equal function fields") {
    val b1 = ("b1" :: T(boxID)()).toVariable
    val b2 = ("b2" :: T(boxID)()).toVariable
    val zero = E(BigInt(0))
    assert(result((b1 =~= b2) && (b1.getField(fn)(zero) !== b2.getField(fn)(zero))).isUNSAT)
    assert(result((b1 =~= b2) && (b1.getField(fn)(zero) === b2.getField(fn)(zero))).isSAT)
  }

  test("equal lists of functions") {
    val tpe = T(listID)(IntegerType() =>: IntegerType())
    val l1 = ("l1" :: tpe).toVariable
    val l2 = ("l2" :: tpe).toVariable
    val one = E(BigInt(1))
    val clause = (l1 =~= l2) && (l1 `is` consID) &&
      (l1.getField(tail) `is` consID) &&
      (l1.getField(tail).getField(head)(one) !== l2.getField(tail).getField(head)(one))
    assert(result(clause).isUNSAT)
  }

  test("equal maps with function values", modelsOfFunctionValues) {
    val tpe = MapType(IntegerType(), IntegerType() =>: IntegerType())
    val m1 = ("m1" :: tpe).toVariable
    val m2 = ("m2" :: tpe).toVariable
    val zero = E(BigInt(0))
    assert(result((m1 =~= m2) && (MapApply(m1, zero)(zero) !== MapApply(m2, zero)(zero))).isUNSAT)
  }

  test("specification by a quantifier") {
    val f = ("f" :: (IntegerType() =>: IntegerType())).toVariable
    val id = \("x" :: IntegerType())(x => x)
    assert(result(forall("x" :: IntegerType())(x => f(x) === x) && neq(f, id)).isUNSAT)
    assert(result((f =~= id) && (f(E(BigInt(3))) !== E(BigInt(3)))).isUNSAT)
  }

  test("extensional equality on a recursive type with function fields") {
    val tpe = T(objID)() =>: T(objID)()
    val f = ("f" :: tpe).toVariable
    val g = ("g" :: tpe).toVariable
    assert(!result(f =~= \("x" :: T(objID)())(x => g(x))).isUNSAT)
  }

  test("extensional equality on types that admit equality") {
    val x = ("x" :: IntegerType()).toVariable
    val l = ("l" :: intList).toVariable
    assert(result(neq(x, x)).isUNSAT)
    assert(result((l =~= C(nilID)(IntegerType())()) && (l `is` consID)).isUNSAT)
  }

  test("unsatisfiable query with distinct functions") {
    // the distinguishing input must not keep the solver from refuting the query by unfolding `size`
    val tpe = intList =>: IntegerType()
    val f = ("f" :: tpe).toVariable
    val g = ("g" :: tpe).toVariable
    val l = ("l" :: intList).toVariable
    val one = C(consID)(IntegerType())(E(BigInt(1)), C(nilID)(IntegerType())())
    val clause = neq(f, g) && (f(l) === g(l)) && (l === one) && (sizeFd(IntegerType())(l) !== E(BigInt(1)))
    assert(result(clause).isUNSAT)
  }

  test("incremental solving") {
    val f = ("f" :: (IntegerType() =>: IntegerType())).toVariable
    val g = ("g" :: (IntegerType() =>: IntegerType())).toVariable
    val solver = program.getSolver.getNewSolver()
    try {
      solver.assertCnstr(neq(f, g))
      solver.push()
      solver.assertCnstr(f =~= g)
      assert(solver.check(Simple).isUNSAT)
      solver.pop()
      solver.check(Model) match {
        case SatWithModel(model) => assert(distinguishable(model.vars(f.toVal), model.vars(g.toVal)))
        case res => fail(s"Expected a model, got $res")
      }
      solver.push()
      solver.assertCnstr(f(E(BigInt(1))) === g(E(BigInt(1))))
      solver.check(Model) match {
        case SatWithModel(model) => assert(distinguishable(model.vars(f.toVal), model.vars(g.toVal)))
        case res => fail(s"Expected a model, got $res")
      }
      solver.pop()
    } finally {
      solver.free()
    }
  }
}
