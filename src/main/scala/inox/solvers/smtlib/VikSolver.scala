/* Copyright 2009-2026 EPFL, Lausanne */

package inox
package solvers
package smtlib

import _root_.smtlib.trees.Commands.GetProof
import _root_.smtlib.trees.CommandsResponses.{Error => SMTError, GetProofResponseSuccess}
import _root_.smtlib.trees.Terms.SString

trait VikSolver extends SMTLIBSolver with VikTarget with ProofProducingSolver {
  import program.trees._
  import SolverResponses._

  /** Vik doesn't answer `get-unsat-assumptions`, so the core of an UNSAT answer is all the
    * assumptions, which is a core, if not the smallest. */
  override def checkAssumptions(config: Configuration)(assumptions: Set[Expr]): config.Response[Model, Assumptions] = {
    val res: SolverResponse[Model, Assumptions] =
      super.checkAssumptions(Configuration(model = config.withModel, unsatAssumptions = false))(assumptions)
    config.cast(res match {
      case Unsat if config.withUnsatAssumptions => UnsatWithAssumptions(assumptions)
      case _ => res
    })
  }

  /** The Lean proof of the last check that answered UNSAT, which Vik writes when it runs with
    * `--proofs` (see [[optLeanProofs]]). */
  def leanProof(): Either[String, String] = emit(GetProof()) match {
    case GetProofResponseSuccess(SString(lean)) => Right(lean)
    case SMTError(msg) => Left(msg)
    case other => Left(s"unexpected answer to (get-proof): $other")
  }
}
