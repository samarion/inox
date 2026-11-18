/* Copyright 2009-2026 EPFL, Lausanne */

package inox
package solvers
package smtlib

import _root_.smtlib.trees.Commands.GetProof
import _root_.smtlib.trees.CommandsResponses.{Error => SMTError, GetProofResponseSuccess}
import _root_.smtlib.trees.Terms.SString

trait VikSolver extends SMTLIBSolver with VikTarget with ProofProducingSolver {

  /** The Lean proof of the last check that answered UNSAT, which Vik writes when it runs with
    * `--proofs` (see [[optLeanProofs]]). */
  def leanProof(): Either[String, String] = emit(GetProof()) match {
    case GetProofResponseSuccess(SString(lean)) => Right(lean)
    case SMTError(msg) => Left(msg)
    case other => Left(s"unexpected answer to (get-proof): $other")
  }
}
