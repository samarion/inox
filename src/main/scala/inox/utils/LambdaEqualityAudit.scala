/* Copyright 2009-2021 EPFL, Lausanne */

package inox
package utils

import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.atomic.AtomicLong

/** Temporary instrumentation: reports the lambda equalities that the current normalization
  * establishes and that normalizing ground values as variables would lose. */
object LambdaEqualityAudit {
  private val seen = ConcurrentHashMap.newKeySet[String]()
  private val counts = new ConcurrentHashMap[String, AtomicLong]()

  private def count(key: String): Unit =
    counts.computeIfAbsent(key, _ => new AtomicLong).incrementAndGet()

  def check(kind: String): Unit = count(kind + ".checked")

  def report(kind: String, details: => String): Unit = {
    count(kind + ".lost")
    val d = details
    if (seen.add(kind + "\n" + d)) {
      System.err.println(s"[lambda-eq-audit] $kind\n$d\n[lambda-eq-audit-end]")
    }
  }

  Runtime.getRuntime.addShutdownHook(new Thread(() => {
    import scala.jdk.CollectionConverters._
    val summary = counts.asScala.toSeq.sortBy(_._1).map((k, v) => s"  $k = ${v.get}").mkString("\n")
    for (r <- seen.asScala.toSeq.sorted) System.err.println(s"[lambda-eq-audit-final] $r\n[lambda-eq-audit-end]")
    System.err.println(s"[lambda-eq-audit-summary]\n$summary\n  distinct reports = ${seen.size}\n[lambda-eq-audit-summary-end]")
  }))
}
