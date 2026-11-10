/* Copyright 2009-2026 EPFL, Lausanne */

package inox
package solvers
package smtlib

import _root_.smtlib.interpreters.ProcessInterpreter

import java.util.ArrayDeque
import java.util.concurrent.{ConcurrentHashMap, LinkedBlockingQueue, ThreadFactory, ThreadPoolExecutor, TimeUnit}
import java.util.concurrent.atomic.AtomicInteger

import scala.util.control.NonFatal

/** Idle solver processes, which new solvers reuse instead of starting processes of their own.
  *
  * Starting a solver process and having it set up its first context takes several milliseconds
  * (about 10ms for Z3), which is often more than the queries of a solver take: Inox starts a
  * solver for each query, and for each quantifier it evaluates in a model. The process of a solver
  * that is freed without having been interrupted is reset in the background (see [[recycle]]),
  * then left here for the next solver started with the same command line.
  *
  * At most one idle process per processor is kept for each command line, the others are freed.
  */
object ProcessPool {
  private val maxIdle = Runtime.getRuntime.availableProcessors.max(1)

  // each queue is only accessed while holding its lock, so that `give` never exceeds `maxIdle`
  private val idle = new ConcurrentHashMap[Seq[String], ArrayDeque[ProcessInterpreter]]

  private def processes(key: Seq[String]): ArrayDeque[ProcessInterpreter] =
    idle.computeIfAbsent(key, _ => new ArrayDeque[ProcessInterpreter])

  /** An idle process started with the command line `key`, which the caller now owns. */
  def take(key: Seq[String]): Option[ProcessInterpreter] = {
    val queue = processes(key)
    Option(queue.synchronized(queue.pollFirst()))
  }

  // processes handed to `recycle` and not yet in the pool, so that at most `maxIdle` wait for it
  private val recycling = new AtomicInteger

  private val recycler = {
    val factory: ThreadFactory = { r =>
      val thread = new Thread(r, "inox-process-pool")
      thread.setDaemon(true)
      thread
    }
    val executor = new ThreadPoolExecutor(maxIdle, maxIdle, 1, TimeUnit.SECONDS, new LinkedBlockingQueue[Runnable], factory)
    executor.allowCoreThreadTimeOut(true)
    executor
  }

  /** Leaves the process `interpreter`, started with the command line `key`, for another solver
    * once `prepare` returns true on it, which runs in the background so that the solver that freed
    * the process doesn't wait for it. `prepare` must leave the process as a new one would be,
    * and the process is freed if it returns false or throws. */
  def recycle(key: Seq[String], interpreter: ProcessInterpreter)(prepare: ProcessInterpreter => Boolean): Unit = {
    if (recycling.incrementAndGet() > maxIdle) {
      recycling.decrementAndGet()
      interpreter.free()
    } else {
      recycler.execute { () =>
        val ready = try prepare(interpreter) catch { case NonFatal(_) => false }
        recycling.decrementAndGet()
        if (ready) give(key, interpreter)
        else try interpreter.free() catch { case NonFatal(_) => }
      }
    }
  }

  /** Leaves the idle process `interpreter`, started with the command line `key` and reset by the
    * caller, for another solver. */
  private def give(key: Seq[String], interpreter: ProcessInterpreter): Unit = {
    val queue = processes(key)
    val kept = queue.synchronized {
      queue.size < maxIdle && { queue.addFirst(interpreter); true }
    }
    // freed outside of the lock, so that the other solvers don't wait for it
    if (!kept) interpreter.free()
  }
}
