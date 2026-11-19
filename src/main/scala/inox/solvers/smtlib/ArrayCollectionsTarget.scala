/* Copyright 2009-2026 EPFL, Lausanne */

package inox
package solvers
package smtlib

import _root_.smtlib.trees.Terms.{Identifier => SMTIdentifier, Let => SMTLet, _}
import _root_.smtlib.extensions.tip.Terms.{Lambda => SMTLambda, _}
import _root_.smtlib.trees.Commands.{FunDef => SMTFunDef, _}
import _root_.smtlib.theories.Core.{Equals => SMTEquals, _}
import _root_.smtlib.theories.Operations._
import _root_.smtlib.theories._

import utils._
import utils.CaseSplit.*

/** Maps, sets, bags and map merges as arrays: a set is an array to Booleans, a bag an array to
  * integers, and their operations are constant arrays and `(_ map f)` of an operator over arrays,
  * as Z3 reads them. Shared by the targets of the solvers with such arrays (Z3 and Vik).
  */
trait ArrayCollectionsTarget extends SMTLIBTarget {
  import context.{given, _}
  import program._
  import program.trees._
  import program.symbols.{given, _}

  /** The sort of the sets of `base`. */
  protected def setSort(base: Sort): Sort = Sort(SMTIdentifier(SSymbol("Array")), Seq(base, BoolSort()))

  /** Called before the first `(_ map f)`, for a solver that needs to know. */
  protected def usingArrayMaps(): Unit = ()

  override protected def computeSort(t: Type): Sort = t match {
    case SetType(base) =>
      declareSort(BooleanType())
      setSort(declareSort(base))
    case BagType(base) => declareSort(MapType(base, IntegerType()))
    case _ => super.computeSort(t)
  }

  protected def extractSet(e: Expr): Expr = e match {
    case FiniteMap(els, dflt, base, _) =>
      if (dflt != BooleanLiteral(false)) unsupported(dflt, "Solver returned a co-finite set which is not supported")
      if (els.forall(p => isValue(p._2))) FiniteSet(els.collect { case (e, BooleanLiteral(true)) => e }, base)
      else els.foldRight(FiniteSet(Seq.empty, base): Expr) { case ((k, v), s) => IfExpr(v, SetAdd(s, k), s) }
    case s: FiniteSet => s
    case _ => unsupported(e, "Expecting set expression in this position")
  }

  override protected def fromSMT(t: Term, otpe: Option[Type] = None)(using context: Context): Expr =
    fromSMTArrayCollections(t, otpe) otherwise super.fromSMT(t, otpe)

  /** The array terms that encode maps, sets and bags, among them Z3's `as-array` and lambdas. */
  protected def fromSMTArrayCollections(t: Term, otpe: Option[Type])(using context: Context): Expr = (t, otpe) match {
    case (QualifiedIdentifier(ExtendedIdentifier(SSymbol("as-array"), k: SSymbol), _), Some(tpe @ MapType(keyType, valueType))) =>
      val Some(Lambda(Seq(arg), body)) = context.getFunction(k, FunctionType(Seq(keyType), valueType)): @unchecked

      def extractCases(e: Expr): FiniteMap = e match {
        case Equals(argV, k) if valueType == BooleanType() && argV == arg.toVariable =>
          FiniteMap(Seq((k, BooleanLiteral(true))), BooleanLiteral(false), keyType, valueType)
        case IfExpr(Equals(argV, k), v, e) if argV == arg.toVariable =>
          val FiniteMap(elems, default, from, to) = extractCases(e)
          FiniteMap(elems :+ (k, v), default, from, to)
        case e => FiniteMap(Seq.empty, e, keyType, valueType)
      }
      extractCases(body)

    case (QualifiedIdentifier(ExtendedIdentifier(SSymbol("as-array"), k: SSymbol), _), Some(tpe @ SetType(base))) =>
      val fm @ FiniteMap(cases, dflt, _, _) = fromSMT(t, Some(MapType(base, BooleanType()))): @unchecked
      if (dflt != BooleanLiteral(false)) unsupported(fm, "Solver returned a co-finite set which is not supported")
      FiniteSet(cases.collect { case (k, BooleanLiteral(true)) => k }, base)

    case (QualifiedIdentifier(ExtendedIdentifier(SSymbol("as-array"), k: SSymbol), _), Some(tpe @ BagType(base))) =>
      val fm @ FiniteMap(cases, dflt, _, _) = fromSMT(t, Some(MapType(base, IntegerType()))): @unchecked
      if (dflt != IntegerLiteral(0)) unsupported(fm, "Solver returned a co-finite bag which is not supported")
      FiniteBag(cases.filter(_._2 != IntegerLiteral(BigInt(0))), base)

    case (SMTLambda(Seq(SortedVar(s, sort)), term), Some(tpe @ MapType(keyType, valueType))) =>
      val arg = ValDef.fresh(s.name, fromSMT(sort))
      val body = fromSMT(term, Some(valueType))(using context.withVariables(Seq(s -> arg.toVariable)))

      def extractCases(e: Expr): FiniteMap = e match {
        case Equals(argV, k) if valueType == BooleanType() && argV == arg.toVariable =>
          FiniteMap(Seq((k, BooleanLiteral(true))), BooleanLiteral(false), keyType, valueType)
        case IfExpr(Equals(argV, k), v, e) if argV == arg.toVariable =>
          val FiniteMap(elems, default, from, to) = extractCases(e)
          FiniteMap(elems :+ (k, v), default, from, to)
        case e => FiniteMap(Seq.empty, e, keyType, valueType)
      }
      extractCases(body)

    case (SMTLambda(Seq(arg), body), Some(tpe @ SetType(base))) =>
      val fm @ FiniteMap(cases, dflt, _, _) = fromSMT(t, Some(MapType(base, BooleanType()))): @unchecked
      if (dflt != BooleanLiteral(false)) unsupported(fm, "Solver returned a co-finite set which is not supported")
      FiniteSet(cases.collect { case (k, BooleanLiteral(true)) => k }, base)

    case (SMTLambda(Seq(arg), body), Some(tpe @ BagType(base))) =>
      val fm @ FiniteMap(cases, dflt, _, _) = fromSMT(t, Some(MapType(base, IntegerType()))): @unchecked
      if (dflt != IntegerLiteral(0)) unsupported(fm, "Solver returned a co-finite bag which is not supported")
      FiniteBag(cases.filter(_._2 != IntegerLiteral(BigInt(0))), base)

    case (FunctionApplication(
      QualifiedIdentifier(SMTIdentifier(SSymbol("const"), _), Some(ArraysEx.ArraySort(k, v))),
      Seq(defV)
    ), Some(MapType(from, to))) =>
      FiniteMap(Seq(), fromSMT(defV, Some(to)), from, to)

    case (FunctionApplication(
      QualifiedIdentifier(SMTIdentifier(SSymbol("store"), _), _),
      Seq(arr, key, elem)
    ), Some(mt @ MapType(from, to))) =>
      // a model's chain of stores over a constant array is a finite map, whose keys at the
      // default are left out (they may not even be values of the key type)
      val k = fromSMT(key, from)
      val v = fromSMT(elem, to)
      fromSMT(arr, mt) match {
        case FiniteMap(elems, dflt, _, _) if isValue(k) =>
          FiniteMap(elems.filter(_._1 != k) ++ (if (v == dflt) Seq() else Seq(k -> v)), dflt, from, to)
        case map => MapUpdated(map, k, v)
      }

    case (FunctionApplication(
      QualifiedIdentifier(SMTIdentifier(SSymbol("const"), _), Some(ArraysEx.ArraySort(k, v))),
      Seq(defV)
    ), Some(tpe @ SetType(base))) =>
      val dflt = fromSMT(defV, Some(BooleanType()))
      if (dflt != BooleanLiteral(false)) unsupported(dflt, "Solver returned a co-finite set which is not supported")
      FiniteSet(Seq.empty, base)

    case (FunctionApplication(
      QualifiedIdentifier(SMTIdentifier(SSymbol("store"), _), _),
      Seq(arr, key, elem)
    ), Some(st @ SetType(base))) =>
      // `store` overrides the previous membership of `key`, so storing `false` removes it
      val set = fromSMT(arr, st)
      val k = fromSMT(key, base)
      // and a model's chain of stores over a constant array is a finite set
      (set, fromSMT(elem, BooleanType())) match {
        case (FiniteSet(elems, _), BooleanLiteral(member)) if isValue(k) =>
          FiniteSet(elems.filter(_ != k) ++ (if (member) Seq(k) else Seq()), base)
        case (_, BooleanLiteral(true)) => SetAdd(set, k)
        case (_, BooleanLiteral(false)) => SetDifference(set, FiniteSet(Seq(k), base))
        case (_, cond) => IfExpr(cond, SetAdd(set, k), SetDifference(set, FiniteSet(Seq(k), base)))
      }

    // Matches (_ map or) in both long form (_ map (or (Bool Bool) Bool))
    // and short form (_ map or).
    case (FunctionApplication(
      QualifiedIdentifier(SMTIdentifier(SSymbol("map"),
        List(SList(List(SSymbol("or"), SList(List(SSymbol("Bool"), SSymbol("Bool"))), SSymbol("Bool")))
          | SSymbol("or"))), None),
      Seq(s1, s2)
    ), _) =>
      fromSMTUnifyType(s1, s2, otpe)((e1, e2) => SetUnion(extractSet(e1), extractSet(e2)))

    // Matches (_ map and) in both long form (_ map (and (Bool Bool) Bool))
    // and short form (_ map and).
    case (FunctionApplication(
      QualifiedIdentifier(SMTIdentifier(SSymbol("map"),
        List(SList(List(SSymbol("and"), SList(List(SSymbol("Bool"), SSymbol("Bool"))), SSymbol("Bool")))
          | SSymbol("and"))), None),
      Seq(s1, s2)
    ), _) =>
      fromSMTUnifyType(s1, s2, otpe)((e1, e2) => SetIntersection(extractSet(e1), extractSet(e2)))

    case (FunctionApplication(
      QualifiedIdentifier(SMTIdentifier(SSymbol("const"), _), Some(ArraysEx.ArraySort(k, v))),
      Seq(defV)
    ), Some(tpe @ BagType(base))) =>
      val dflt = fromSMT(defV, Some(IntegerType()))
      if (dflt != IntegerLiteral(BigInt(0))) unsupported(dflt, "Solver returned a co-finite bag which is not supported")
      FiniteBag(Seq.empty, base)

    case (FunctionApplication(
      QualifiedIdentifier(SMTIdentifier(SSymbol("store"), _), _),
      Seq(arr, key, elem)
    ), Some(bt @ BagType(base))) =>
      // `store` overrides the previous multiplicity of `key` (it does not add to it)
      val k = fromSMT(key, base)
      val v = fromSMT(elem, IntegerType())
      fromSMT(arr, bt) match {
        case FiniteBag(elems, _) =>
          FiniteBag(elems.filter(_._1 != k) ++ (if (v == IntegerLiteral(0)) Seq() else Seq(k -> v)), base)
        case bag => BagUnion(
          BagDifference(bag, FiniteBag(Seq(k -> MultiplicityInBag(k, bag)), base)),
          FiniteBag(Seq(k -> v), base))
      }

    case (FunctionApplication(
      QualifiedIdentifier(SMTIdentifier(SSymbol("const"), _), Some(ArraysEx.ArraySort(k, v))),
      Seq(defV)
    ), None) =>
      val keyType = fromSMT(k)
      val valType = fromSMT(v)
      FiniteMap(Seq(), fromSMT(defV, valType), keyType, valType)

    case (FunctionApplication(
      QualifiedIdentifier(SMTIdentifier(SSymbol("store"), _), _),
      Seq(arr, key, elem)
    ), None) =>
      MapUpdated(fromSMT(arr), fromSMT(key), fromSMT(elem))

    // Matches (_ map ite) in both long form (_ map (ite (Bool T T) T))
    // and short form (_ map ite).
    case (FunctionApplication(
      QualifiedIdentifier(SMTIdentifier(SSymbol("map"),
        List(SList(List(SSymbol("ite"), SList(List(SSymbol("Bool"), _, _, _)), _))
          | SSymbol("ite"))), None),
      Seq(mask, map1, map2)
    ), _) =>
      MapMerge(fromSMT(mask), fromSMT(map1), fromSMT(map2))

    case _ => unhandled
  }

  override protected def toSMT(e: Expr)(using bindings: Map[Identifier, Term]): Term = e match {
    /**
     * ===== Set operations =====
     */
    case fs @ FiniteSet(elems, base) =>
      declareSort(fs.getType)
      toSMT(FiniteMap(elems map ((_, BooleanLiteral(true))), BooleanLiteral(false), base, BooleanType()))

    case SubsetOf(ss, s) =>
      // a isSubset b   ==>   (a zip b).map(implies) == (* => true)
      val allTrue = ArrayConst(declareSort(s.getType), True())
      SMTEquals(ArrayMap(SSymbol("implies"), toSMT(ss), toSMT(s)), allTrue)

    case SetAdd(s, e) =>
      ArraysEx.Store(toSMT(s), toSMT(e), True())

    case ElementOfSet(e, s) =>
      ArraysEx.Select(toSMT(s), toSMT(e))

    case SetDifference(a, b) =>
      // a -- b
      // becomes:
      // a && not(b)

      ArrayMap(SSymbol("and"), toSMT(a), ArrayMap(SSymbol("not"), toSMT(b)))

    case SetUnion(l, r) =>
      ArrayMap(SSymbol("or"), toSMT(l), toSMT(r))

    case MapMerge(mask, map1, map2) =>
      val s = declareSort(map1.getType.asInstanceOf[MapType].to)
      ArrayMap(SortedSymbol("ite", List(BoolSort(), s, s), s), toSMT(mask), toSMT(map1), toSMT(map2))

    case SetIntersection(l, r) =>
      ArrayMap(SSymbol("and"), toSMT(l), toSMT(r))

    case fb @ FiniteBag(elems, base) =>
      // Elements with a multiplicity of zero or less are not in the bag.
      def positivePart(m: Expr): Expr = m match {
        case IntegerLiteral(i) => IntegerLiteral(i max 0)
        case _ => IfExpr(GreaterThan(m, IntegerLiteral(0)), m, IntegerLiteral(0))
      }
      val BagType(t) = fb.getType: @unchecked
      declareSort(BagType(t))
      toSMT(FiniteMap(elems.map { case (k, m) => k -> positivePart(m) }, IntegerLiteral(0), t, IntegerType()))

    case BagAdd(b, e) =>
      val bid = FreshIdentifier("b", true)
      val eid = FreshIdentifier("e", true)
      val (bSym, eSym) = (id2sym(bid), id2sym(eid))
      SMTLet(
        VarBinding(bSym, toSMT(b)), Seq(VarBinding(eSym, toSMT(e))),
        ArraysEx.Store(bSym, eSym, Ints.Add(ArraysEx.Select(bSym, eSym), Ints.NumeralLit(1)))
      )

    case MultiplicityInBag(e, b) =>
      ArraysEx.Select(toSMT(b), toSMT(e))

    case BagUnion(b1, b2) =>
      val plus = SortedSymbol("+", List(IntegerType(), IntegerType()).map(declareSort), declareSort(IntegerType()))
      ArrayMap(plus, toSMT(b1), toSMT(b2))

    case BagIntersection(b1, b2) =>
      toSMT(BagDifference(b1, BagDifference(b1, b2)))

    case BagDifference(b1, b2) =>
      val abs   = SortedSymbol("abs", List(IntegerType()).map(declareSort), declareSort(IntegerType()))
      val plus  = SortedSymbol("+", List(IntegerType(), IntegerType()).map(declareSort), declareSort(IntegerType()))
      val minus = SortedSymbol("-", List(IntegerType(), IntegerType()).map(declareSort), declareSort(IntegerType()))
      val div   = SortedSymbol("div", List(IntegerType(), IntegerType()).map(declareSort), declareSort(IntegerType()))

      val did = FreshIdentifier("d", true)
      val dSym = id2sym(did)

      val all2 = ArrayConst(declareSort(b1.getType), Ints.NumeralLit(2))

      SMTLet(
        VarBinding(dSym, ArrayMap(minus, toSMT(b1), toSMT(b2))), Seq(),
        ArrayMap(div, ArrayMap(plus, dSym, ArrayMap(abs, dSym)), all2)
      )

    case _ =>
      super.toSMT(e)
  }

  protected object SortedSymbol {
    // A sort as an S-expression, such as `Int`, `(_ BitVec 32)` or `(Array Int Bool)`
    private def sortExpr(s: Sort): SExpr = {
      val id = if (s.id.isIndexed) SList(SSymbol("_") :: s.id.symbol :: s.id.indices.toList) else s.id.symbol
      if (s.subSorts.isEmpty) id else SList(id :: s.subSorts.map(sortExpr).toList)
    }

    def apply(op: String, from: List[Sort], to: Sort) =
      SList(SSymbol(op), SList(from.map(sortExpr)*), sortExpr(to))
  }

  protected object ArrayMap {
    def apply(op: SExpr, arrs: Term*) = {
      usingArrayMaps()
      FunctionApplication(
        QualifiedIdentifier(SMTIdentifier(SSymbol("map"), List(op)), None),
        arrs
      )
    }
  }

  protected object ArrayConst {
    def apply(sort: Sort, default: Term) = {
      FunctionApplication(
        QualifiedIdentifier(SMTIdentifier(SSymbol("const")), Some(sort)),
        List(default))
    }
  }
}
