package inox
package bench

import solvers._
import utils.SimpStats

/** Research harness: runs TIP benchmarks and dumps per-query simplification stats.
  * Usage: SimpBench <solver> <timeoutSec> <passes> <out.csv> [dirs...]
  */
object SimpBench {
  def main(args: Array[String]): Unit = {
    val solver = args(0)
    val timeout = args(1).toLong * 1000
    val passes = args(2).toInt
    val out = new java.io.PrintWriter(args(3))
    val base = "src/it/resources/regression/tip"
    val dirs = if (args.length > 4) args.drop(4).toSeq else Seq("SAT", "UNSAT", "UNKNOWN")
    val files = dirs.flatMap(d => Option(new java.io.File(s"$base/$d").listFiles).toSeq.flatten.filter(_.getName.endsWith(".tip")).sortBy(_.getName).map(d -> _))
    val skip = Set("ForallAssoc.scala-0.tip", "Soundness3.scala-0.tip")
    val keys = Seq("simplify.function", "simplify.inst", "simp.assumptions", "simp.foralls", "simp.expr", "simp.ground",
      "foralls.inlineFunctions", "foralls.inlineForalls", "foralls.inlinePosts", "foralls.inlineLambdas",
      "foralls.simplifyAssumptions", "foralls.simplifyMatchers", "foralls.normalizeClauses", "solver.check", "solver.unroll")
    out.println((Seq("pass", "dir", "file", "idx", "result", "wallMs", "unrolls", "tmplFunctions", "sizeIn", "sizeOut") ++ keys).mkString(","))
    for (pass <- 1 to passes; (dir, file) <- files if !skip(file.getName)) {
      given ctx: Context = TestContext(Options(Seq(optSelectedSolvers(Set(solver)), optCheckModels(dir == "SAT"))))
      try {
        for (((program, expr), idx) <- tip.Parser(file).parseScript.zipWithIndex) {
          SimpStats.reset()
          val t0 = System.nanoTime()
          val res = try {
            val sf = program.getSolver.withTimeout(timeout)
            val r = SimpleSolverAPI(sf).solveSAT(expr)
            if (r.isSAT) "SAT" else if (r.isUNSAT) "UNSAT" else "UNKNOWN"
          } catch { case t: Throwable => "ERROR:" + t.getClass.getSimpleName }
          val wall = (System.nanoTime() - t0) / 1e6
          val snap = SimpStats.snapshot
          def ms(k: String) = f"${snap.get(k).map(_._2).getOrElse(0.0)}%.2f"
          def cnt(k: String) = snap.get(k).map(_._1).getOrElse(0L)
          out.println((Seq(pass.toString, dir, file.getName, idx.toString, res, f"$wall%.1f", cnt("solver.unroll").toString,
            cnt("tmpl.function").toString, cnt("size.in").toString, cnt("size.out").toString) ++ keys.map(ms)).mkString(","))
          out.flush()
        }
      } catch { case t: Throwable => out.println(s"$pass,$dir,${file.getName},-1,PARSEERROR:${t.getClass.getSimpleName}"); out.flush() }
    }
    out.close()
    sys.exit(0)
  }
}
