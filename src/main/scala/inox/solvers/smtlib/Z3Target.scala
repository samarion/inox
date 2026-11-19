/* Copyright 2009-2018 EPFL, Lausanne */

package inox
package solvers
package smtlib

import _root_.smtlib.trees.Terms.{Identifier => SMTIdentifier, Let => SMTLet, _}
import _root_.smtlib.extensions.tip.Terms.{Lambda => SMTLambda, _}
import _root_.smtlib.trees.Commands.{FunDef => SMTFunDef, _}
import _root_.smtlib.trees.CommandsResponses.{Error => SMTError, _}
import _root_.smtlib.extensions.tip.Parser
import _root_.smtlib.extensions.tip.Lexer
import _root_.smtlib.lexer.Tokens
import _root_.smtlib.interpreters.Z3Interpreter
import _root_.smtlib.theories.Core.{Equals => SMTEquals, _}
import _root_.smtlib.theories.Operations._
import _root_.smtlib.theories._

import utils._
import utils.CaseSplit.*

// In millions of z3 resource units
// An Int, so that the limit in resource units can't overflow the Long it is computed in
object optZ3Rlimit extends IntOptionDef("z3-rlimit", -1, "<N>")

trait Z3Target extends ArrayCollectionsTarget with SMTLIBDebugger {
  import context.{given, _}
  import program._
  import program.trees._
  import program.symbols.{given, _}

  def targetName = "z3"

  protected def interpreterOpts = {
    // z3 takes the limit as an unsigned 32-bit integer
    val rlimit = options.findOptionOrDefault(optZ3Rlimit).toLong * 1000000L min 0xFFFFFFFFL
    Seq(
      "-in",
      "-smt2"
    ) ++ (if (rlimit >= 0) Seq(s"rlimit=$rlimit") else Seq())
  }

  // the parser doesn't refer to the target, so that the processes left for other solvers don't
  // keep it alive
  protected type Z3Parser = Z3Target.Z3Parser

  // The processes are reused by solvers started with the same command line and string encoding,
  // as Z3 keeps its options when it is reset
  private def processKey: Seq[String] =
    (targetName +: interpreterOpts) :+ s"encoding=${if (maxStringChar == 0xFFFF) "bmp" else "default"}"

  protected val interpreter = {
    val opts = interpreterOpts
    takeIdle().getOrElse {
      reporter.debug("Invoking solver "+targetName+" with "+opts.mkString(" "))
      new PipelinedZ3Interpreter(targetName, opts.toArray, out => new Z3Parser(new Lexer(out)))
    }
  }

  // an idle process whose reset succeeded, the others are freed
  @scala.annotation.tailrec
  private def takeIdle(): Option[PipelinedZ3Interpreter] = ProcessPool.take(processKey) match {
    case Some(z3: PipelinedZ3Interpreter) if z3.awaitReset() => Some(z3)
    case Some(process) => process.free(); takeIdle()
    case None => None
  }

  override protected def recycle(): Boolean = interpreter match {
    // the process resets while it is idle, and the next solver to take it waits for that
    case z3: PipelinedZ3Interpreter =>
      z3.resetLater()
      ProcessPool.give(processKey, z3)
      true
    case _ => false
  }

  // Z3 version 4.5.1 has disabled producing unsat assumptions by default,
  // so make sure it is enabled at this point.
  emit(SetOption(ProduceUnsatAssumptions(true)))

  /* Z3 answers a check without scopes or assumptions with a non-incremental solver, whose models
   * give the variables that its preprocessing eliminated as terms. Equalities of arrays built with
   * `(_ map f)`, as for `s1.subsetOf(s2)` or `s1 ++ s2 == s3`, are left unevaluated in these terms,
   * so their values can't be extracted. Once such an array shows up, Z3 uses its incremental
   * solver, whose models evaluate them. The non-incremental solver is kept otherwise, as it is much
   * faster on floating point. The option outlives `reset`, so each solver sets it, and older
   * versions of Z3 that don't know it ignore it. */
  private var ignoringSolver1 = false
  private def setIgnoreSolver1(ignore: Boolean): Unit =
    emit(SetOption(AttributeOption(Attribute(SKeyword(Z3Target.ignoreSolver1), Some(SSymbol(ignore.toString))))), rawOut = true)
  setIgnoreSolver1(false)

  protected def ignoreSolver1(): Unit = if (!ignoringSolver1) {
    ignoringSolver1 = true
    setIgnoreSolver1(true)
  }

  // Under `--strings-bmp`, restrict the string alphabet to the BMP (the default `unicode` encoding
  // ranges up to 0x2FFFF, as SMT-LIB). Older versions of Z3 don't know the option, so we ignore
  // errors here.
  if (maxStringChar == 0xFFFF)
    emit(SetOption(AttributeOption(Attribute(SKeyword("encoding"), Some(SSymbol("bmp"))))), rawOut = true)


  protected class Version(val major: Int, val minor: Int, rest: String) extends Ordered[Version] {
    override def compare(that: Version): Int = {
      import scala.math.Ordering.Implicits._
      summon[Ordering[(Int, Int)]].compare((major, minor), (that.major, that.minor))
    }

    override def toString: String = s"$major.$minor.$rest"
  }

  protected object Version {
    def apply(major: Int, minor: Int): Version = new Version(major, minor, "")
  }

  protected lazy val version = emit(GetInfo(VersionInfoFlag())) match {
    case GetInfoResponseSuccess(VersionInfoResponse(version), _) =>
      val major +: minor +: rest = version.split("\\.").toSeq: @unchecked
      new Version(major.toInt, minor.toInt, rest.mkString("."))
    case r =>
      Version(0, 0) // We use 0.0 as an unknown default version
  }

  protected val extSym = SSymbol("_")

  // Z3's sets are arrays to Booleans under a parametric sort of their own, `InoxSet`
  protected lazy val inoxSet: SSymbol = {
    val s = SSymbol("InoxSet")
    val t = SSymbol("T")

    val arraySort = Sort(
      SMTIdentifier(SSymbol("Array")),
      Seq(Sort(SMTIdentifier(t)), BoolSort())
    )

    val cmd = DefineSort(s, Seq(t), arraySort)
    emit(cmd)
    s
  }

  override protected def setSort(base: Sort): Sort = Sort(SMTIdentifier(inoxSet), Seq(base))

  override protected def usingArrayMaps(): Unit = ignoreSolver1()

  override protected def id2sym(id: Identifier): SSymbol = {
    // @nv: Z3 uses identifiers of the shape 'k!\d+' to represent
    //      its array functions, so we have to make sure to avoid collisions!
    if (id.name == "k") {
      SSymbol(s"k0!${id.id}")
    } else {
      super.id2sym(id)
    }
  }

  override protected def fromSMT(t: Term, otpe: Option[Type] = None)(using context: Context): Expr =
    fromSMTZ3Core(t, otpe) otherwise super.fromSMT(t, otpe)

  /** Z3-specific testers, unspecified values, strings and characters. */
  protected def fromSMTZ3Core(t: Term, otpe: Option[Type])(using context: Context): Expr = (t, otpe) match {
    case (FunctionApplication(
      QualifiedIdentifier(SMTIdentifier(SSymbol("is"), Seq(SSymbol(name))), None),
      Seq(e)
    ), _) if version >= Version(4, 6) && testers.containsB(SSymbol("is-" + name)) =>
      testers.toA(SSymbol("is-" + name)) match {
        case ac @ ADTCons(id, _) =>
          IsConstructor(fromSMT(e, ac.getType), id)
        case t =>
          unsupported(t, "woot? tester for non-adt type")
      }

    case (QualifiedIdentifier(SimpleIdentifier(SSymbol("#unspecified")), None), None) =>
      throw new MissformedSMTException(t, "Cannot extract #unspecified symbol when type is unknown")

    case (QualifiedIdentifier(SimpleIdentifier(SSymbol("#unspecified")), None), Some(tpe)) =>
      exprOps.freshUninterpretedCall("unspecified", Seq.empty, tpe)

    case (FunctionApplication(QualifiedIdentifier(SimpleIdentifier(SSymbol("seq.unit")), None), Seq(SHexadecimal(hex))), _) =>
      StringLiteral(utils.StringUtils.decode(hex.repr))

    case (FunctionApplication(QualifiedIdentifier(SimpleIdentifier(SSymbol("seq.unit")), None),
        Seq(QualifiedIdentifier(SMTIdentifier(SSymbol("Char"), Seq(SNumeral(n))), None))), Some(StringType())) =>
      StringLiteral(Seq(n.toInt))

    case (FunctionApplication(QualifiedIdentifier(SimpleIdentifier(SSymbol("str.++")), None), strs), _) =>
      val strings = strs.map(fromSMT(_, Some(StringType())))
      if (strings.isEmpty) StringLiteral(Seq())
      else strings.tail.foldRight(strings.head)(StringConcat(_, _))

    case (QualifiedIdentifier(SMTIdentifier(SSymbol("Char"), Seq(SNumeral(n))), None), Some(CharType())) =>
      CharLiteral(n.toChar)

    case _ => unhandled
  }

  override protected def toSMT(e: Expr)(using bindings: Map[Identifier, Term]): Term = e match {

    case IsConstructor(e, id) if version >= Version(4, 6) =>
      val tpe @ ADTType(_, tps) = e.getType: @unchecked
      declareSort(tpe)
      val SSymbol(name) = testers.toB(ADTCons(id, tps))
      FunctionApplication(
        QualifiedIdentifier(SMTIdentifier(SSymbol("is"), Seq(SSymbol(name.drop(3)))), None),
        Seq(toSMT(e))
      )

    case _ =>
      super.toSMT(e)
  }
}

object Z3Target {
  /** The option that makes Z3 always use its incremental solver (see `Z3Target.ignoreSolver1()`). */
  val ignoreSolver1: String = "combined_solver.ignore_solver1"

  class Z3Parser(lexer: Lexer) extends Parser(lexer) {
    // Z3 uses a non-standard version of get-unsat-assumptions-response that
    // returns prop literals instead of symbols directly
    override def parseGetUnsatAssumptionsResponse: GetUnsatAssumptionsResponse = {
      nextToken() match {
        case Tokens.SymbolLit("unsupported") => Unsupported
        case t =>
          check(t, Tokens.OParen)
          peekToken match {
            case Tokens.SymbolLit("error") =>
              eat(Tokens.SymbolLit("error"))
              val msg = parseString.value
              eat(Tokens.CParen)
              SMTError(msg)
            case _ =>
              val props = parseUntil(Tokens.CParen)(() => parsePropLit)
              GetUnsatAssumptionsResponseSuccess(props)
          }
      }
    }
  }
}
