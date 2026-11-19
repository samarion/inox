/* Copyright 2009-2026 EPFL, Lausanne */

package inox
package solvers
package smtlib

import _root_.smtlib.interpreters.ProcessInterpreter

/** Vik (https://github.com/mbovel/vik) through SMT-LIB, run as `vik -in`.
  *
  * Vik covers uninterpreted functions, datatypes, arrays, linear integer and real arithmetic, and
  * bit-vectors. The other theories are encoded before they reach it (see [[theories.Vik]]).
  */
trait VikTarget extends SMTLIBTarget with SMTLIBDebugger {
  import context.{given, _}

  def targetName = "vik"

  protected def interpreterOpts: Seq[String] =
    Seq("-in") ++ (if (options.findOptionOrDefault(optProofs).nonEmpty) Seq("--proofs") else Seq())

  override protected val interpreter: ProcessInterpreter = {
    val opts = interpreterOpts
    reporter.debug("Invoking solver " + targetName + " with " + opts.mkString(" "))
    new PipelinedVikInterpreter(targetName, opts.toArray)
  }
}
