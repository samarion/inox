/* Copyright 2009-2026 EPFL, Lausanne */

package inox
package solvers

/** Writes the Lean proof of each UNSAT answer to the given directory. Only solvers that produce
  * proofs ([[ProofProducingSolver]], `smt-vik`) can, and the proof is that of the last query the
  * unrolling solver sent to the SMT solver, not yet of the Inox query (see the design of proofs
  * of Inox answers). */
object optLeanProofs extends StringOptionDef("lean-proofs", "", "<dir>")

/** An SMT solver that can give a proof of its last UNSAT answer. */
trait ProofProducingSolver {

  /** The Lean proof of the last check that answered UNSAT, or why there is none. */
  def leanProof(): Either[String, String]
}

object ProofProducingSolver {
  private val counter = new java.util.concurrent.atomic.AtomicInteger(0)

  /** Writes the proof of `solver`'s last UNSAT answer to `dir`, as `proof-<n>.lean`, when `solver`
    * produces proofs; reports where it went, or why it couldn't be written. */
  def write(solver: Any, dir: String)(using ctx: Context): Unit = solver match {
    case p: ProofProducingSolver =>
      p.leanProof() match {
        case Right(lean) =>
          java.nio.file.Files.createDirectories(java.nio.file.Path.of(dir))
          // the first free name, so that the runs that share the directory keep their proofs
          val path = Iterator.continually(counter.incrementAndGet())
            .map(n => java.nio.file.Path.of(dir, s"proof-$n.lean"))
            .dropWhile(java.nio.file.Files.exists(_))
            .next()
          java.nio.file.Files.writeString(path, lean)
          ctx.reporter.info(s"Lean proof written to $path")
        case Left(why) =>
          ctx.reporter.warning(s"No Lean proof of the UNSAT answer: $why")
      }
    case _ =>
      ctx.reporter.warning(s"--${optLeanProofs.name} needs a solver that produces proofs (smt-vik)")
  }
}
