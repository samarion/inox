/* Copyright 2009-2018 EPFL, Lausanne */

package inox
package solvers
package smtlib

import inox.OptionParsers._

object optCVC5Options extends SetOptionDef[String] {
  val name = "solver:cvc5"
  val default = Set[String]()
  val elementParser = stringParser
  val usageRhs = "<cvc5-opt>"
}

// In millions of cvc5 resource units
// An Int, so that the limit in resource units can't overflow the Long it is computed in
object optCVC5Rlimit extends IntOptionDef("cvc5-rlimit", -1, "<N>")

trait CVC5Solver extends CVCSolver with CVC5Target {
  import context.{given, _}

  override def optCVCOptions: SetOptionDef[String] = optCVC5Options

  /** Whether the program converts between bit-vectors and integers, see `CVC5Solver.convertsBVsAndInts`. */
  protected def bvIntConversions: Boolean = false

  override def interpreterOpts = {
    val rlimit = options.findOptionOrDefault(optCVC5Rlimit).toLong * 1000000L
    super.interpreterOpts ++ (if (rlimit >= 0) Seq(s"--rlimit-per=$rlimit") else Seq())
  }

  // Under `--strings-bmp`, restrict the string alphabet to the BMP (by default, cvc5 uses all
  // 0x30000 SMT-LIB characters).
  override protected def targetOpts: Seq[String] = {
    val strings = if (maxStringChar == 0xFFFF) Seq("--strings-alpha-card=65536") else Seq.empty
    // cvc5 can't relate a bit-vector to its integer value through `bv2nat` and `int2bv` in its
    // default mode: it doesn't prove `(a <s b) = (sbv_to_int(a) < sbv_to_int(b))` within minutes.
    // Translating the bit-vectors to integers proves these queries at once, but makes bit-level
    // reasoning much slower, so it is only enabled for the programs that convert. The option has to
    // be given when cvc5 starts, before the conversions show up in the unrolling, so it is decided on
    // the whole program: Stainless gives Inox only the dependencies of the functions it verifies.
    // An explicit `--solver:cvc5=--solve-bv-as-int=...` takes precedence.
    val userSet = options.findOptionOrDefault(optCVC5Options).exists(_.startsWith("--solve-bv-as-int="))
    val bvAsInt = if (bvIntConversions && !userSet) Seq("--solve-bv-as-int=sum") else Seq.empty
    strings ++ bvAsInt
  }
}

object CVC5Solver {
  private def isConversion(t: inox.ast.Trees)(e: t.Expr): Boolean = e match {
    case _: t.BVToInt | _: t.IntToBV => true
    case _ => false
  }

  /** Whether a function of `p`, which includes the invariants of its sorts, converts between
    * bit-vectors and integers. */
  def convertsBVsAndInts(p: Program): Boolean =
    p.symbols.functions.values.exists(fd => p.trees.exprOps.exists(isConversion(p.trees))(fd.fullBody))
}
