/* Copyright 2009-2018 EPFL, Lausanne */

package inox

trait Semantics { self =>
  val trees: ast.Trees
  val symbols: trees.Symbols
  val program: Program { val trees: self.trees.type; val symbols: self.symbols.type }

  private val solverCache = new utils.LruCache[Context, solvers.SolverFactory {
    val program: self.program.type
    type S <: solvers.combinators.TimeoutSolver { val program: self.program.type }
  }](5)

  private val evaluatorCache = new utils.LruCache[Context, evaluators.DeterministicEvaluator {
    val program: self.program.type
  }](5)

  protected def createSolver(ctx: Context): solvers.SolverFactory {
    val program: self.program.type
    type S <: solvers.combinators.TimeoutSolver { val program: self.program.type }
  }

  protected def createEvaluator(ctx: Context): evaluators.DeterministicEvaluator {
    val program: self.program.type
  }

  def getSolver(using ctx: Context): solvers.SolverFactory {
    val program: self.program.type
    type S <: solvers.combinators.TimeoutSolver { val program: self.program.type }
  } = solverCache.cached(ctx, createSolver(ctx))

  def getEvaluator(using ctx: Context): evaluators.DeterministicEvaluator {
    val program: self.program.type
  } = evaluatorCache.cached(ctx, createEvaluator(ctx))

  /** The semantics under which the values of `model` are typed and evaluated: these semantics
    * when the model defines no functions, and otherwise those of the program extended with the
    * model's definitions (see [[Model.symbols]]).
    *
    * Semantics that support models with definitions override this, typically by building the
    * extended program's semantics with the provider that created them.
    */
  def forModel(model: program.Model): inox.Semantics { val trees: self.trees.type } =
    if (model.defs.isEmpty) this
    else throw FatalError("These semantics do not support models that define functions")
}

trait SemanticsProvider { self =>
  val trees: ast.Trees
  def getSemantics(p: Program { val trees: self.trees.type }): p.Semantics
}
