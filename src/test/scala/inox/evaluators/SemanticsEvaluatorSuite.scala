/* Copyright 2009-2026 EPFL, Lausanne */

package inox
package evaluators

/** The evaluator suites, run on the evaluator generated from Inox's semantics. */
class SemanticsEvaluatorSuite extends EvaluatorSuite {
  override def mkEvaluator(p: InoxProgram, c: Context): RecursiveEvaluator { val program: p.type } =
    SemanticsEvaluator(p, c)
}

class SemanticsRecursiveEvaluatorSuite extends RecursiveEvaluatorSuite {
  override def mkEvaluator(p: InoxProgram, c: Context): RecursiveEvaluator { val program: p.type } =
    SemanticsEvaluator(p, c)
}

class SemanticsSolvingEvaluatorSuite extends SolvingEvaluatorSuite {
  override def mkEvaluator(p: InoxProgram, c: Context): RecursiveEvaluator { val program: p.type } =
    SemanticsEvaluator(p, c)
}
