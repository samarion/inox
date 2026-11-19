/* Copyright 2009-2026 EPFL, Lausanne */

package inox
package solvers

/** Writes the proof certificate of each UNSAT answer to the given directory. Only solvers that
  * produce proofs ([[ProofProducingSolver]], `smt-vik`) can, and the certificate is that of the
  * last query the unrolling solver sent to the SMT solver, not yet of the Inox query (see the
  * design of proofs of Inox answers). Vik's `proofs` project writes it as Lean files. */
object optProofs extends StringOptionDef("proofs", "", "<dir>")

/** An SMT solver that can give a proof of its last UNSAT answer. */
trait ProofProducingSolver {

  /** The certificate of the last check that answered UNSAT, as an S-expression, or why there is
    * none. */
  def proof(): Either[String, String]
}

object ProofProducingSolver {
  private val counter = new java.util.concurrent.atomic.AtomicInteger(0)

  /** Writes the certificate of `solver`'s last UNSAT answer to `dir`, as `proof-<n>.sexp`, when `solver`
    * produces proofs; reports where it went, or why it couldn't be written. */
  def write(solver: Any, dir: String)(using ctx: Context): Unit = solver match {
    case p: ProofProducingSolver =>
      p.proof() match {
        case Right(certificate) =>
          java.nio.file.Files.createDirectories(java.nio.file.Path.of(dir))
          // the first free name, so that the runs that share the directory keep their proofs
          val path = Iterator.continually(counter.incrementAndGet())
            .map(n => java.nio.file.Path.of(dir, s"proof-$n.sexp"))
            .dropWhile(java.nio.file.Files.exists(_))
            .next()
          java.nio.file.Files.writeString(path, certificate)
          ctx.reporter.info(s"Proof certificate written to $path")
        case Left(why) =>
          ctx.reporter.warning(s"No proof certificate of the UNSAT answer: $why")
      }
    case _ =>
      ctx.reporter.warning(s"--${optProofs.name} needs a solver that produces proofs (smt-vik)")
  }
}
