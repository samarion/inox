/* Copyright 2009-2026 EPFL, Lausanne */

package inox
package solvers
package smtlib

import _root_.smtlib.trees.Commands.GetProof
import _root_.smtlib.trees.CommandsResponses.{Error => SMTError, GetProofResponseSuccess}
import _root_.smtlib.printer.RecursivePrinter

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

  /** The certificate of the last check that answered UNSAT, `(vik-proof 1 ...)`, which Vik gives
    * when it runs with `--proofs` (see [[optProofs]]). */
  def proof(): Either[String, String] = emit(GetProof()) match {
    case GetProofResponseSuccess(certificate) => Right(RecursivePrinter.toString(certificate))
    case SMTError(msg) => Left(msg)
    case other => Left(s"unexpected answer to (get-proof): $other")
  }
}
