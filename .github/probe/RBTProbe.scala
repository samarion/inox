package stainless
package verification

import scala.concurrent.duration.*
import stainless.utils.YesNoOnly

abstract class RBTProbeBase(checkModels: Boolean) extends VerificationComponentTestSuite {
  def lp: ComponentTestSuite.LoadedPrograms
  def label: String

  override def configurations: Seq[Seq[inox.OptionValue[?]]] = Seq(Seq(
    inox.optSelectedSolvers(Set("smt-z3")),
    inox.optTimeout(120.seconds),
    optStrictArithmetic(false),
    frontend.optBatchedProgram(true),
    termination.optInferMeasures(false),
    termination.optCheckMeasures(YesNoOnly.No),
    optFailInvalid(false),
    optFailEarly(false),
    inox.solvers.optCheckModels(checkModels),
    evaluators.optCodeGen(false),
    inox.solvers.unrolling.optFeelingLucky(false),
  ))

  override def filter(ctx: inox.Context, name: String): FilterStatus =
    if (name.endsWith("/RedBlackTree2")) Test else Skip

  testAll("verification/invalid", lp) { (analysis, _, _, _) =>
    for ((vc, res) <- analysis.vrs) {
      println(s"PROBE[$label] ${vc.fid} ${vc.kind} ${res.status} ${res.time.getOrElse(-1L)}ms")
      if (vc.kind == VCKind.Postcondition && vc.fid.name == "buggyAdd")
        println(s"PROBE-VC[$label] ${vc.condition}")
    }
  }
}

object RBTProbe {
  lazy val isolated = ComponentTestSuite.loadPrograms("verification/invalid", keepOnly = _.endsWith("RedBlackTree2.scala"))
  lazy val full = ComponentTestSuite.loadPrograms("verification/invalid")
}

class RBTProbeIsolated extends RBTProbeBase(true) {
  def lp = RBTProbe.isolated
  def label = "isolated"
}

class RBTProbeFull extends RBTProbeBase(true) {
  def lp = RBTProbe.full
  def label = "full"
}

class RBTProbeFullNoModels extends RBTProbeBase(false) {
  def lp = RBTProbe.full
  def label = "full-nomodels"
}
