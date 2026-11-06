/* Copyright 2009-2026 EPFL, Lausanne */

package inox
package smtlib3

import solvers._
import solvers.unrolling._

/** Prototype: runs the SMT-LIB 3 regression benchmarks. */
class RegressionPrototypeSuite extends UnrollingTestSuite with ResourceUtils {
  override protected def optionMatrix = List(
    (false, false, false),
    (true,  true,  false),
    (false, false, true ),
  ).map { case (c, l, u) => Seq(optCheckModels(c), optFeelingLucky(l), optUnrollAssumptions(u)) }

  private val flags = Seq(optCheckModels, optFeelingLucky, optUnrollAssumptions, optAssumeChecked, optNoSimplifications)
    .map(o => o.name -> o).toMap

  for (dir <- Seq("quantifiers", "choose"); file <- resourceFiles(s"regression/smtlib3/$dir", _.endsWith(".smt3"))) {
    val src = scala.io.Source.fromFile(file).mkString
    val status = """\(set-info :status (\w+)\)""".r.findFirstMatchIn(src).map(_.group(1)).get
    val opts = """\(set-option :([\w-]+) (\w+)\)""".r.findAllMatchIn(src).map(m => flags(m.group(1))(m.group(2).toBoolean)).toSeq
    val mayBeUnknown = src.contains("(set-info :inox-may-be-unknown true)")
    test(s"$dir/${file.getName} ($status)") { ctx0 ?=>
      given ctx: Context = ctx0.withOpts(opts*)
      for ((program, expr) <- Parser(file).parseScript) {
        val res = SimpleSolverAPI(program.getSolver).solveSAT(expr)
        status match {
          case "sat" => assert(if (mayBeUnknown) !res.isUNSAT else res.isSAT, res)
          case "unsat" => assert(if (mayBeUnknown) !res.isSAT else res.isUNSAT, res)
          case _ => assert(!res.isSAT && !res.isUNSAT, res)
        }
      }
    }
  }
}
