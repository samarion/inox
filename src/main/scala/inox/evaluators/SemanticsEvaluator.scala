/* Copyright 2009-2026 EPFL, Lausanne */

package inox
package evaluators

import scala.collection.immutable.BitSet
import scala.collection.mutable

import inox.semantics.generated.{Semantics => S}

/** The evaluator generated from Inox's semantics (`proofs/semantics.md`), on Inox's trees.
  *
  * It converts the expression, the program and the model to the semantics' own trees, evaluates
  * them, and converts the value back, in the form that [[RecursiveEvaluator]] gives it. Calls count
  * against `--max-calls`, as in [[RecursiveEvaluator]], and fuel is unbounded otherwise.
  *
  * `Forall` is decided by the solver, as in [[SolvingEvaluator]]. What the semantics leaves out
  * falls back to [[RecursiveEvaluator]]: the dependent types, `--function-equality` other than
  * `none`, `--ignore-contracts`, and programs that use them. */
abstract class SemanticsEvaluator(override val program: Program, override val context: Context)
                                 (using override protected val semantics: program.Semantics)
  extends RecursiveEvaluator(program, context) {

  import context.{given, _}
  import program._
  import program.trees._
  import program.symbols.{given, _}

  override val name = "Semantics Evaluator"

  private def list[A](xs: Seq[A]): S.List[A] = xs.foldRight(S.Nil(): S.List[A])(S.Cons(_, _))

  private def seq[A](l: S.List[A]): Seq[A] = {
    val b = Seq.newBuilder[A]
    var cur = l
    while (cur.isInstanceOf[S.Cons[?]]) {
      val c = cur.asInstanceOf[S.Cons[A]]
      b += c.head
      cur = c.tail
    }
    b.result()
  }

  private final class Unsupported extends Exception

  private def unsupported: Nothing = throw Unsupported()

  /** The Inox trees of the semantics' expressions, for the closures and quantifiers that the
    * evaluator gives back or asks the solver about. */
  private val programOrigins = new java.util.IdentityHashMap[S.Expr, Expr]

  /** Those of the program, then those of the current evaluation, which are dropped after it. */
  private var origins = programOrigins

  private def origin(e: S.Expr): Expr =
    Option(origins.get(e)).orElse(Option(programOrigins.get(e))).getOrElse(throw RuntimeError(s"Unknown expression $e"))

  private def bitSet(bs: BitSet): BigInt = bs.foldLeft(BigInt(0))((acc, i) => acc.setBit(i - 1))

  private def toBitSet(x: BigInt, size: Int): BitSet = BitSet((1 to size).filter(i => x.testBit(i - 1))*)

  private def params(vds: Seq[ValDef]): S.List[S.Param] = list(vds.map(vd => S.Param(vd.id, tpe(vd.tpe))))

  private def tpe(t: Type): S.Type = t match {
    case IntegerType() => S.IntegerType()
    case BooleanType() => S.BooleanType()
    case UnitType() => S.UnitType()
    case CharType() => S.CharType()
    case RealType() => S.RealType()
    case StringType() => S.StringType()
    case BVType(s, w) => S.BVType(s, BigInt(w))
    case FPType(e, s) => S.FPType(BigInt(e), BigInt(s))
    case RoundingMode => S.RoundingModeType()
    case TypeParameter(id, _) => S.TypeParameter(id)
    case TupleType(ts) => S.TupleType(list(ts.map(tpe)))
    case SetType(b) => S.SetType(tpe(b))
    case BagType(b) => S.BagType(tpe(b))
    case MapType(f, t) => S.MapType(tpe(f), tpe(t))
    case FunctionType(f, t) => S.FunctionType(list(f.map(tpe)), tpe(t))
    case ADTType(id, tps) => S.ADTType(id, list(tps.map(tpe)))
    // the binders of refinements are renamed, so that equal types are equal in the semantics
    case RefinementType(vd, prop) =>
      val binder = ValDef(refinementBinder, vd.tpe)
      val renamed = exprOps.replaceFromSymbols(Map(vd -> binder.toVariable), prop)
      S.RefinementType(binder.id, tpe(vd.tpe), expr(renamed))
    case _ => unsupported
  }

  private val refinementBinder = FreshIdentifier("v")

  /** Whether `t` has functions, which [[RecursiveEvaluator]] doesn't put in collections without
    * function equality. */
  private def hasFunctions(t: Type): Boolean = typeOps.exists { case _: FunctionType => true; case _ => false }(t)

  /** Rewrites a tree that the semantics doesn't cover into trees that it does, before evaluation:
    * a subclass that extends the language lowers its own trees here. `None` leaves the tree as it
    * is. */
  protected def lower(e: Expr): Option[Expr] = None

  /** Whether the uninterpreted function `id` is native: the subclass implements it with
    * [[native]], instead of the model. A lowering can call native functions for the trees that it
    * doesn't lower to the semantics, as Stainless does for `choose`. */
  protected def isNative(id: Identifier): Boolean = false

  /** The value of the native function `id` at the type arguments `tps`, on the values `args`. */
  protected def native(id: Identifier, tps: Seq[Type], args: Seq[Expr]): Expr =
    throw EvalError(s"No native implementation of ${id.asString}")

  /** The recursive evaluator, which evaluates the programs that the semantics doesn't cover, calls
    * the native functions too. */
  override protected[evaluators] def e(expr: Expr)(using rctx: RC, gctx: GC): Expr = expr match {
    case UninterpretedCall(id, tps, args, _) if isNative(id) => native(id, tps, args.map(e))
    case _ => super.e(expr)
  }

  private def expr(e: Expr): S.Expr = lower(e) match {
    case Some(lowered) => expr(lowered)
    case None => convert(e)
  }

  private def convert(e: Expr): S.Expr = {
    def rec(e: Expr): S.Expr = expr(e)
    def all(es: Seq[Expr]) = list(es.map(rec))
    def pairs(ps: Seq[(Expr, Expr)]) = list(ps.map((k, v) => S.ExprPair(rec(k), rec(v))))
    val res: S.Expr = e match {
      case Assume(_, b) if globallyIgnoreContracts => rec(b)
      case Assume(p, b) => S.Assume(rec(p), rec(b))
      case v: Variable => S.Variable(v.id)
      case Let(vd, v, b) => S.Let(vd.id, rec(v), rec(b))
      case Application(c, as) => S.Application(rec(c), all(as))
      case Lambda(ps, b) => S.Lambda(params(ps), rec(b))
      case Forall(ps, b) => S.Forall(params(ps), rec(b))
      case UninterpretedCall(id, tps, as, _) => S.UninterpretedCall(id, list(tps.map(tpe)), all(as))
      case Error(_, _) => S.Error()
      case FunctionInvocation(id, tps, as) => S.FunctionInvocation(id, list(tps.map(tpe)), all(as))
      case IfExpr(c, t, f) => S.IfExpr(rec(c), rec(t), rec(f))
      case CharLiteral(c) => S.CharLiteral(BigInt(c.toInt))
      case bv: BVLiteral => S.BVLiteral(bv.signed, BigInt(bv.size), bitSet(bv.value))
      case IntegerLiteral(i) => S.IntegerLiteral(i)
      case FractionLiteral(n, d) => S.FractionLiteral(n, d)
      case FPLiteral(ex, sig, bs) => S.FPLiteral(BigInt(ex), BigInt(sig), bitSet(bs))
      case BooleanLiteral(b) => S.BooleanLiteral(b)
      case s: StringLiteral => S.StringLiteral(list(s.value.map(BigInt(_))))
      case UnitLiteral() => S.UnitLiteral()
      case RoundNearestTiesToEven => S.RoundNearestTiesToEven()
      case RoundNearestTiesToAway => S.RoundNearestTiesToAway()
      case RoundTowardPositive => S.RoundTowardPositive()
      case RoundTowardNegative => S.RoundTowardNegative()
      case RoundTowardZero => S.RoundTowardZero()
      // the values of type parameters are integers in the semantics
      case GenericValue(_, id) => S.IntegerLiteral(BigInt(id))
      case ADT(id, tps, as) => S.ADT(id, list(tps.map(tpe)), all(as))
      case IsConstructor(a, id) => S.IsConstructor(rec(a), id)
      case ADTSelector(a, id) => S.ADTSelector(rec(a), id)
      case Equals(l, r) => S.Equals(rec(l), rec(r))
      case And(es) => S.And(all(es))
      case Or(es) => S.Or(all(es))
      case Implies(l, r) => S.Implies(rec(l), rec(r))
      case Not(a) => S.Not(rec(a))
      case StringConcat(l, r) => S.StringConcat(rec(l), rec(r))
      case SubString(a, b, c) => S.SubString(rec(a), rec(b), rec(c))
      case StringLength(a) => S.StringLength(rec(a))
      case Plus(l, r) => S.Plus(rec(l), rec(r))
      case Minus(l, r) => S.Minus(rec(l), rec(r))
      case UMinus(a) => S.UMinus(rec(a))
      case Times(l, r) => S.Times(rec(l), rec(r))
      case Division(l, r) => S.Division(rec(l), rec(r))
      case Remainder(l, r) => S.Remainder(rec(l), rec(r))
      case Modulo(l, r) => S.Modulo(rec(l), rec(r))
      case LessThan(l, r) => S.LessThan(rec(l), rec(r))
      case GreaterThan(l, r) => S.GreaterThan(rec(l), rec(r))
      case LessEquals(l, r) => S.LessEquals(rec(l), rec(r))
      case GreaterEquals(l, r) => S.GreaterEquals(rec(l), rec(r))
      case BVNot(a) => S.BVNot(rec(a))
      case BVAnd(l, r) => S.BVAnd(rec(l), rec(r))
      case BVOr(l, r) => S.BVOr(rec(l), rec(r))
      case BVXor(l, r) => S.BVXor(rec(l), rec(r))
      case BVShiftLeft(l, r) => S.BVShiftLeft(rec(l), rec(r))
      case BVAShiftRight(l, r) => S.BVAShiftRight(rec(l), rec(r))
      case BVLShiftRight(l, r) => S.BVLShiftRight(rec(l), rec(r))
      case BVNarrowingCast(a, t) => S.BVNarrowingCast(rec(a), BigInt(t.size))
      case BVWideningCast(a, t) => S.BVWideningCast(rec(a), BigInt(t.size))
      case BVUnsignedToSigned(a) => S.BVUnsignedToSigned(rec(a))
      case BVSignedToUnsigned(a) => S.BVSignedToUnsigned(rec(a))
      case BVToInt(a) => S.BVToInt(rec(a))
      case IntToBV(size, signed, a) => S.IntToBV(BigInt(size), signed, rec(a))
      case FPEquals(l, r) => S.FPEquals(rec(l), rec(r))
      case FPAdd(rm, l, r) => S.FPAdd(rec(rm), rec(l), rec(r))
      case FPSub(rm, l, r) => S.FPSub(rec(rm), rec(l), rec(r))
      case FPUMinus(a) => S.FPUMinus(rec(a))
      case FPFMA(rm, a, b, c) => S.FPFMA(rec(rm), rec(a), rec(b), rec(c))
      case FPMul(rm, l, r) => S.FPMul(rec(rm), rec(l), rec(r))
      case FPDiv(rm, l, r) => S.FPDiv(rec(rm), rec(l), rec(r))
      case FPAbs(a) => S.FPAbs(rec(a))
      case FPMax(l, r) => S.FPMax(rec(l), rec(r))
      case FPMin(l, r) => S.FPMin(rec(l), rec(r))
      case FPRound(rm, a) => S.FPRound(rec(rm), rec(a))
      case Sqrt(rm, a) => S.Sqrt(rec(rm), rec(a))
      case FPCast(ex, sig, rm, a) => S.FPCast(BigInt(ex), BigInt(sig), rec(rm), rec(a))
      case FPFromBinary(ex, sig, a) => S.FPFromBinary(BigInt(ex), BigInt(sig), rec(a))
      case FPToBV(w, sg, rm, a) => S.FPToBV(BigInt(w), sg, rec(rm), rec(a))
      case FPToReal(a) => S.FPToReal(rec(a))
      case FPLessThan(l, r) => S.FPLessThan(rec(l), rec(r))
      case FPGreaterThan(l, r) => S.FPGreaterThan(rec(l), rec(r))
      case FPLessEquals(l, r) => S.FPLessEquals(rec(l), rec(r))
      case FPGreaterEquals(l, r) => S.FPGreaterEquals(rec(l), rec(r))
      case FPIsZero(a) => S.FPIsZero(rec(a))
      case FPIsInfinite(a) => S.FPIsInfinite(rec(a))
      case FPIsNaN(a) => S.FPIsNaN(rec(a))
      case FPIsNegative(a) => S.FPIsNegative(rec(a))
      case FPIsPositive(a) => S.FPIsPositive(rec(a))
      case FPIsNormal(a) => S.FPIsNormal(rec(a))
      case FPIsSubnormal(a) => S.FPIsSubnormal(rec(a))
      case Tuple(es) => S.Tuple(all(es))
      case TupleSelect(t, i) => S.TupleSelect(rec(t), BigInt(i))
      case FiniteSet(_, b) if !intensional && hasFunctions(b) => unsupported
      case FiniteBag(_, b) if !intensional && hasFunctions(b) => unsupported
      case FiniteMap(_, _, k, _) if !intensional && hasFunctions(k) => unsupported
      case FiniteSet(es, _) => S.FiniteSet(all(es))
      case SetAdd(a, b) => S.SetAdd(rec(a), rec(b))
      case ElementOfSet(a, b) => S.ElementOfSet(rec(a), rec(b))
      case SubsetOf(a, b) => S.SubsetOf(rec(a), rec(b))
      case SetIntersection(a, b) => S.SetIntersection(rec(a), rec(b))
      case SetUnion(a, b) => S.SetUnion(rec(a), rec(b))
      case SetDifference(a, b) => S.SetDifference(rec(a), rec(b))
      case FiniteBag(ps, _) => S.FiniteBag(pairs(ps))
      case BagAdd(a, b) => S.BagAdd(rec(a), rec(b))
      case MultiplicityInBag(a, b) => S.MultiplicityInBag(rec(a), rec(b))
      case BagIntersection(a, b) => S.BagIntersection(rec(a), rec(b))
      case BagUnion(a, b) => S.BagUnion(rec(a), rec(b))
      case BagDifference(a, b) => S.BagDifference(rec(a), rec(b))
      case FiniteMap(ps, d, _, _) => S.FiniteMap(pairs(ps), rec(d))
      case MapApply(a, b) => S.MapApply(rec(a), rec(b))
      case MapUpdated(a, b, c) => S.MapUpdated(rec(a), rec(b), rec(c))
      case MapMerge(a, b, c) => S.MapMerge(rec(a), rec(b), rec(c))
      case _ => unsupported
    }
    origins.put(res, e)
    res
  }

  /** The program in the semantics, or `None` if it uses something that the semantics leaves out. */
  private lazy val semanticsProgram: Option[S.Program] = try {
    Some(S.Program(
      list(symbols.functions.values.toSeq.map(fd =>
        S.FunDef(fd.id, list(fd.tparams.map(_.id)), list(fd.params.map(_.id)), expr(fd.fullBody)))),
      list(symbols.constructors.values.toSeq.map(c => S.Constructor(c.id, c.sort, params(c.fields)))),
      list(symbols.sorts.values.toSeq.map(s =>
        S.Sort(s.id, list(s.tparams.map(_.id)), s.invariant.filter(_ => !globallyIgnoreContracts).fold(S.None())(fd => S.Some(fd.id))))),
      S.Nil(),
      // intensional equality is outside the semantics: it is given as the oracle of extensional
      // equality, which compares the closures as `RecursiveEvaluator` does
      if (intensional) S.ExtensionalEquality() else S.NoFunctionEquality()))
  } catch {
    case _: Unsupported => None
  }

  private lazy val functionsById: Map[Identifier, S.FunDef] =
    semanticsProgram.toSeq.flatMap(p => seq(p.functions)).map(fd => fd.id -> fd).toMap
  private lazy val constructorsById: Map[Identifier, S.Constructor] =
    semanticsProgram.toSeq.flatMap(p => seq(p.constructors)).map(c => c.id -> c).toMap
  private lazy val sortsById: Map[Identifier, S.Sort] =
    semanticsProgram.toSeq.flatMap(p => seq(p.sorts)).map(s => s.id -> s).toMap

  private lazy val intensional: Boolean =
    options.findOptionOrDefault(solvers.unrolling.optFunctionEquality) == solvers.unrolling.FunctionEquality.Intensional

  /** Whether the semantics covers the options: extensional function equality is left to
    * [[RecursiveEvaluator]]. */
  private lazy val supportedOptions: Boolean =
    options.findOptionOrDefault(solvers.unrolling.optFunctionEquality) != solvers.unrolling.FunctionEquality.Extensional

  /** A value of the semantics as an Inox value of type `t`, in the form that [[RecursiveEvaluator]]
    * gives it. */
  private def back(v: S.Value, t: Type)(using ev: Impl): Expr = (v, t) match {
    case (_, RefinementType(vd, _)) => back(v, vd.tpe)
    case (S.IntV(i), tp: TypeParameter) => GenericValue(tp, i.toInt)
    case (S.IntV(i), _) => IntegerLiteral(i)
    case (S.BoolV(b), _) => BooleanLiteral(b)
    case (S.UnitV(), _) => UnitLiteral()
    case (S.CharV(c), _) => CharLiteral(c.toChar)
    case (S.RealV(n, d), _) => FractionLiteral(n, d)
    case (S.StringV(cs), _) => StringLiteral(seq(cs).map(_.toInt))
    case (S.BVV(s, w, x), _) => BVLiteral(s, toBitSet(x, w.toInt), w.toInt)
    case (S.FPV(e, s, x), _) => FPLiteral(e.toInt, s.toInt, toBitSet(x, (e + s).toInt))
    case (S.RoundingModeV(m), _) => m match {
      case S.RNE() => RoundNearestTiesToEven
      case S.RNA() => RoundNearestTiesToAway
      case S.RTP() => RoundTowardPositive
      case S.RTN() => RoundTowardNegative
      case S.RTZ() => RoundTowardZero
    }
    case (S.TupleV(vs), TupleType(ts)) => Tuple(seq(vs).zip(ts).map(back))
    case (S.ADTV(c, vs), ADTType(_, tps)) =>
      val tcons = getConstructor(c, tps)
      ADT(c, tps.map(_.getType), seq(vs).zip(tcons.fields).map((v, vd) => back(v, vd.tpe)))
    case (S.SetV(xs), SetType(b)) =>
      FiniteSet(seq(xs).map(back(_, b)).distinct.sortBy(_.toString), b.getType)
    case (S.BagV(xs), BagType(b)) =>
      FiniteBag(seq(xs).map { case S.BagEntry(x, n) => back(x, b) -> IntegerLiteral(n) }.sortBy(_._1.toString), b.getType)
    case (S.MapV(xs, d), MapType(f, to)) =>
      val default = back(d, to)
      FiniteMap(seq(xs).map { case S.MapEntry(k, x) => back(k, f) -> back(x, to) }
        .filter(_._2 != default).sortBy(_._1.toString), default, f.getType, to.getType)
    case (S.ClosureV(ps, body, env), FunctionType(from, _)) =>
      val vds = seq(ps).zip(from).map { case (S.Param(id, _), t) => ValDef(id, t) }
      ev.normalize(Lambda(vds, closed(body, env)))
    case _ => throw RuntimeError(s"Unexpected value $v of type ${t.asString}")
  }

  /** The types that `tys` gives to the type parameters of `orig`. */
  private def typeSubst(orig: Expr, tys: S.List[S.TypeBinding])(using ev: Impl): Map[TypeParameter, Type] =
    seq(tys).flatMap { case S.TypeBinding(id, _, _) =>
      typeOps.typeParamsOf(orig).find(_.id == id).map(tp => tp -> typeBack(ev.resolve(tys, S.TypeParameter(id))))
    }.toMap

  /** The Inox tree of `body`, with the values that `env` gives to its free variables. */
  private def closed(body: S.Expr, env: S.Env)(using ev: Impl): Expr = {
    val orig = origin(body)
    val S.Env(tys, vars) = env
    val tpSubst = typeSubst(orig, tys)
    val bindings = seq(vars).reverse.map { case S.Binding(id, v) => id -> v }.toMap
    val values = exprOps.variablesOf(orig).flatMap { v =>
      bindings.get(v.id).map(x => v -> back(x, typeOps.instantiateType(v.tpe, tpSubst)))
    }.toMap
    typeOps.instantiateType(exprOps.replaceFromSymbols(values, orig), tpSubst)
  }

  private def typeBack(t: S.Type): Type = t match {
    case S.IntegerType() => IntegerType()
    case S.BooleanType() => BooleanType()
    case S.UnitType() => UnitType()
    case S.CharType() => CharType()
    case S.RealType() => RealType()
    case S.StringType() => StringType()
    case S.BVType(s, w) => BVType(s, w.toInt)
    case S.FPType(e, s) => FPType(e.toInt, s.toInt)
    case S.RoundingModeType() => RoundingMode
    case S.TypeParameter(id) => TypeParameter(id, Seq())
    case S.TupleType(ts) => TupleType(seq(ts).map(typeBack))
    case S.SetType(b) => SetType(typeBack(b))
    case S.BagType(b) => BagType(typeBack(b))
    case S.MapType(f, to) => MapType(typeBack(f), typeBack(to))
    case S.FunctionType(f, to) => FunctionType(seq(f).map(typeBack), typeBack(to))
    case S.ADTType(id, tps) => ADTType(id, seq(tps).map(typeBack))
    case S.RefinementType(id, b, prop) =>
      RefinementType(ValDef(id, typeBack(b)), origin(prop))
  }

  /** The generated evaluator, for one evaluation: its calls count against `--max-calls`. */
  private final class Impl(maxSteps: Int, model: program.Model) extends S.Evaluator {
    private val interpretations = model.interpretations

    /** `l` as [[RecursiveEvaluator]] normalizes the lambdas it evaluates. */
    def normalize(l: Lambda): Expr = SemanticsEvaluator.this.e(l)(using initRC(model), initGC)

    private var stepsLeft = maxSteps

    override def eval(P: S.Program, fuel: BigInt, env: S.Env, e: S.Expr): S.Result[S.Value] = {
      if (interruptManager.isInterrupted) throw RuntimeError("Evaluation interrupted")
      e match {
        case S.UninterpretedCall(id, _, args) if isNative(id) => eval_list(P, fuel, env, args) match {
          case S.Ok(vs) => callNative(P, fuel, e, env, seq(vs))
          case S.Stuck() => S.Stuck()
          case S.OutOfFuel() => S.OutOfFuel()
        }
        case _ => super.eval(P, fuel, env, e)
      }
    }

    /** The value of the call `e` to a native function, on the values `vs` (see [[isNative]]). */
    private def callNative(P: S.Program, fuel: BigInt, e: S.Expr, env: S.Env, vs: Seq[S.Value]): S.Result[S.Value] = {
      val call = origin(e).asInstanceOf[UninterpretedCall]
      val tpSubst = typeSubst(call, env.types)(using this)
      val args = vs.zip(call.args).map((v, a) => back(v, typeOps.instantiateType(a.getType, tpSubst))(using this))
      val result = native(call.id, call.tps.map(typeOps.instantiateType(_, tpSubst)), args)
      super.eval(P, fuel, S.Env(S.Nil(), S.Nil()), expr(result))
    }

    override def call(P: S.Program, fuel: BigInt, f: Identifier, tps: S.List[S.Type],
                      tenv: S.List[S.TypeBinding], vs: S.List[S.Value]): S.Result[S.Value] = {
      if (stepsLeft < 0) throw RuntimeError("Exceeded number of allocated methods calls (" + maxSteps + ")")
      stepsLeft -= 1
      super.call(P, fuel, f, tps, tenv, vs)
    }

    override def lookup_fun(fs: S.List[S.FunDef], f: Identifier): S.Result[S.FunDef] =
      functionsById.get(f).fold(S.Stuck())(S.Ok(_))
    override def lookup_ctor(cs: S.List[S.Constructor], c: Identifier): S.Result[S.Constructor] =
      constructorsById.get(c).fold(S.Stuck())(S.Ok(_))
    override def lookup_sort(ss: S.List[S.Sort], s: Identifier): S.Result[S.Sort] =
      sortsById.get(s).fold(S.Stuck())(S.Ok(_))

    /** Decided by the solver, as [[SolvingEvaluator]] does. */
    def forall_result(P: S.Program, fuel: BigInt, env: S.Env, ps: S.List[S.Param], body: S.Expr): S.Result[S.Value] = {
      val forall = Forall(seq(ps).map(p => ValDef(p.id, typeBack(p.tpe))), origin(body))
      closed(S.Forall(ps, body).tap(origins.put(_, forall)), env)(using this) match {
        case f: Forall => onForallInvocation(f, interpretations) match {
          case BooleanLiteral(b) => S.Ok(S.BoolV(b))
          case _ => S.Stuck()
        }
        case _ => S.Stuck()
      }
    }

    def has_type(P: S.Program, tenv: S.List[S.TypeBinding], v: S.Value, t: S.Type): Boolean =
      throw EvalError("has-type is only used by quantifiers, which the solver decides")
    /** Intensional equality, which the semantics leaves out: the closures are equal if they are
      * the same normalized lambda. */
    def closures_equal(P: S.Program, f: S.Value, g: S.Value): Boolean = {
      def lambda(v: S.Value): Expr = v match {
        case S.ClosureV(ps, _, _) => back(v, FunctionType(seq(ps).map(p => typeBack(p.tpe)), Untyped))(using this)
        case _ => throw EvalError(s"Unexpected function $v")
      }
      lambda(f) == lambda(g)
    }
  }

  extension [A](a: A) private def tap(f: A => Any): A = { f(a); a }

  override def eval(e0: Expr, model: program.Model): EvaluationResult = {
    val sp = if (supportedOptions) semanticsProgram else None
    sp match {
      case None => super.eval(e0, model)
      case Some(sp) =>
        // the solver may evaluate with this evaluator while it decides a quantifier
        val saved = origins
        origins = new java.util.IdentityHashMap[S.Expr, Expr]
        try evalWith(sp, e0, model) finally origins = saved
    }
  }

  private def evalWith(sp: S.Program, e0: Expr, model: program.Model): EvaluationResult = {
    val ex = typeOps.instantiateType(e0, model.types)
    // the type of the result, to convert it back
    val resultType = ex.getType
    val converted = if (resultType == Untyped) None else try {
      val interps = model.interpretations.toSeq.map {
        case ((id, tps), Lambda(ps, body)) =>
          S.Interpretation(id, list(tps.map(tpe)), list(ps.map(_.id)), expr(body))
        case _ => unsupported
      }
      val vars = exprOps.variablesOf(ex).toSeq.flatMap(v => model.vars.get(v.toVal).map(v -> _))
      Some((expr(ex), interps, vars.map((v, value) => v.id -> expr(value))))
    } catch {
      case _: Unsupported => None
    }
    converted match {
      case None => super.eval(e0, model)
      case Some((se, interps, vars)) => timers.evaluators.recursive.runtime.run {
        val p = sp.copy(interpretations = list(interps))
        val ev = new Impl(maxSteps, model)
        val empty = S.Env(S.Nil(), S.Nil())
        val fuel = BigInt(Int.MaxValue)
        def run(env: S.Env, e: S.Expr): S.Value = ev.eval(p, fuel, env, e) match {
          case S.Ok(v) => v
          case _ => throw Unsupported()
        }
        try {
          val bindings = vars.map((id, value) => S.Binding(id, run(empty, value)))
          val v = run(S.Env(S.Nil(), list(bindings.reverse)), se)
          EvaluationResults.Successful(back(v, resultType)(using ev))
        } catch {
          // the evaluation went wrong, or too deep: the recursive evaluator says how
          case _: Unsupported | _: StackOverflowError => super.eval(e0, model)
          case EvalError(msg) => EvaluationResults.EvaluatorError(msg)
          case RuntimeError(msg) => EvaluationResults.RuntimeError(msg)
          case jre: java.lang.RuntimeException => EvaluationResults.RuntimeError(jre.getMessage)
        }
      }
    }
  }
}

object SemanticsEvaluator {

  def apply(p: InoxProgram, ctx: Context): SemanticsEvaluator { val program: p.type } = {
    class Impl(override val program: p.type)(using override val semantics: p.Semantics)
      extends SemanticsEvaluator(program, ctx) with HasDefaultGlobalContext with HasDefaultRecContext
    new Impl(p)(using p.getSemantics)
  }
}
