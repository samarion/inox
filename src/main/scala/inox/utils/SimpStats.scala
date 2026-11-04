/* Copyright 2009-2018 EPFL, Lausanne */

package inox
package utils

import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.atomic.AtomicLong
import scala.jdk.CollectionConverters._

/** Research-only instrumentation for simplification cost measurements.
  *
  * The `inox.simp` system property selects which phases of `simplifyFormula` run:
  * a comma-separated list of phases to disable among
  * `assumptions`, `foralls`, `expr`, `ground`, or `off` to disable all of them.
  */
object SimpStats {
  private val times = new ConcurrentHashMap[String, AtomicLong]()
  private val counts = new ConcurrentHashMap[String, AtomicLong]()

  /** Default for CI variant branches, overridden by the `inox.simp` property. */
  val defaultMode: String = "ground,assumptions"

  lazy val disabled: Set[String] =
    Option(System.getProperty("inox.simp")).getOrElse(defaultMode).split(",").map(_.trim).filter(_.nonEmpty).toSet

  if (System.getProperty("inox.simpstats.report", "true") == "true") {
    Runtime.getRuntime.addShutdownHook(new Thread(() => {
      val snap = snapshot
      if (snap.nonEmpty) {
        val lines = snap.toSeq.sortBy(_._1).map { case (k, (n, ms)) => f"  $k%-32s n=$n%-10d ms=$ms%.1f" }
        System.err.println((s"[SimpStats] mode='${disabled.mkString(",")}'" +: lines).mkString("\n"))
      }
    }))
  }

  def enabled(phase: String): Boolean = !disabled(phase) && !disabled("off")

  def add(key: String, nanos: Long): Unit = {
    times.computeIfAbsent(key, _ => new AtomicLong()).addAndGet(nanos)
    counts.computeIfAbsent(key, _ => new AtomicLong()).incrementAndGet()
  }

  def count(key: String, n: Long = 1): Unit =
    counts.computeIfAbsent(key, _ => new AtomicLong()).addAndGet(n)

  def time[T](key: String)(body: => T): T = {
    val start = System.nanoTime()
    try body finally add(key, System.nanoTime() - start)
  }

  def reset(): Unit = { times.clear(); counts.clear() }

  /** Snapshot: key -> (count, millis) */
  def snapshot: Map[String, (Long, Double)] = {
    val keys = times.keySet.asScala ++ counts.keySet.asScala
    keys.map { k =>
      k -> (Option(counts.get(k)).map(_.get).getOrElse(0L), Option(times.get(k)).map(_.get / 1e6).getOrElse(0.0))
    }.toMap
  }
}
