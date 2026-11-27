/* Copyright 2009-2018 EPFL, Lausanne */

package inox
package solvers
package smtlib

import _root_.smtlib.trees.Terms.{SExpr, SList, SSymbol, SNumeral}
import _root_.smtlib.printer.RecursivePrinter

import scala.collection.mutable.ArrayBuffer

/** The commands that the SMT-LIB solvers of a run send to their processes, along with the answers
  * they get, so that a second run can be checked to send the same commands without solving anything.
  *
  * A transcript first records: each solver adds its commands and their answers to a session of the
  * transcript. Once [[replay]] is called, the solvers answer their commands from the recorded sessions
  * and leave their processes idle. A replayed session follows the recorded sessions that start with
  * the same commands, so that the order in which solvers are created doesn't matter (solvers may run
  * in parallel). A command that no recorded session sends at that point is a mismatch: it is reported
  * in [[mismatches]], and the solver fails with an error.
  *
  * The commands are compared as printed, so that the symbols must have the same names in both runs.
  * The answers are given back as they were parsed in the first run.
  */
final class SMTTranscript {
  import SMTTranscript._

  private val recorded = ArrayBuffer.empty[ArrayBuffer[Entry]]
  private var replaying = false
  // the recorded sessions that a replayed session ended with
  private val claimed = scala.collection.mutable.Set.empty[Int]
  private val mismatchesBuffer = ArrayBuffer.empty[String]

  /** Ends the recording: the sessions started from now on replay the recorded ones. */
  def replay(): Unit = synchronized { replaying = true }

  /** The commands of the replay that differ from the recorded ones, as messages. */
  def mismatches: Seq[String] = synchronized(mismatchesBuffer.toSeq)

  /** The number of recorded sessions. */
  def sessions: Int = synchronized(recorded.size)

  /** The number of recorded sessions that no replayed session went through. */
  def unreplayed: Int = synchronized(recorded.size - claimed.size)

  private[smtlib] def session(): Session = synchronized {
    if (replaying) new ReplaySession
    else {
      val entries = ArrayBuffer.empty[Entry]
      recorded += entries
      new RecordSession(entries)
    }
  }

  private def mismatch(msg: String): Unit = synchronized { mismatchesBuffer += msg }

  private[smtlib] sealed abstract class Session {
    /** The answer to `cmd`: that of `run` while recording, and the recorded one while replaying. An
      * error of `run` is recorded as well, and replayed by throwing it again. */
    def apply(cmd: SExpr)(run: => SExpr): SExpr

    /** A count that the solver gets from its process without a command, such as the resources it spent. */
    def value(name: String)(count: => Option[Long]): Option[Long] =
      apply(SList(SSymbol("inox-count"), SSymbol(name)))(count.map(n => SNumeral(BigInt(n))).getOrElse(SSymbol("none"))) match {
        case SNumeral(n) => Some(n.toLong)
        case _ => None
      }
    /** Ends the session, once the solver is freed. */
    def close(): Unit
  }

  private final class RecordSession(entries: ArrayBuffer[Entry]) extends Session {
    // the commands that a count sends are part of the count
    private var depth = 0

    def apply(cmd: SExpr)(run: => SExpr): SExpr = if (depth > 0) run else {
      val command = RecursivePrinter.toString(cmd)
      depth += 1
      val res = try Right(run) catch { case e: Exception => Left(e) } finally depth -= 1
      SMTTranscript.this.synchronized { entries += Entry(command, res) }
      res.fold(throw _, identity)
    }

    def close(): Unit = ()
  }

  private final class ReplaySession extends Session {
    // the recorded sessions that start with the commands of this one
    private var candidates: Seq[Int] = SMTTranscript.this.synchronized(recorded.indices)
    private var position = 0
    private var failed = false

    private def entries(i: Int): ArrayBuffer[Entry] = recorded(i)

    def apply(cmd: SExpr)(run: => SExpr): SExpr = SMTTranscript.this.synchronized {
      val command = RecursivePrinter.toString(cmd)
      if (failed) throw new MismatchException("a previous command of this session differs from the recorded ones")
      val matching = candidates.filter(i => position < entries(i).size && entries(i)(position).command == command)
      if (matching.isEmpty) {
        failed = true
        val expected = candidates.filter(position < entries(_).size).map(entries(_)(position).command).distinct
        val previous = candidates.headOption.filter(_ => position > 0).map(entries(_)(position - 1).command)
        val msg =
          s"command ${position + 1} of a solver session differs from the recorded ones:\n" +
          previous.map(p => s"  after:    ${clip(p)}\n").getOrElse("") +
          (if (expected.isEmpty) "  recorded: (end of session)\n"
           else expected.take(3).map(e => s"  recorded: ${clip(e)}\n").mkString) +
          s"  replayed: ${clip(command)}"
        mismatch(msg)
        throw new MismatchException(msg)
      }
      candidates = matching
      position += 1
      entries(matching.head)(position - 1).response.fold(throw _, identity)
    }

    def close(): Unit = SMTTranscript.this.synchronized {
      if (!failed) {
        val ended = candidates.filter(i => entries(i).size == position)
        ended.find(i => !claimed(i)).orElse(ended.headOption) match {
          case Some(i) => claimed += i
          case None =>
            val next = candidates.headOption.map(entries(_)(position).command).getOrElse("")
            mismatch(s"a solver session ended after ${position} commands, where the recorded ones go on with:\n" +
              s"  recorded: ${clip(next)}")
        }
      }
    }
  }
}

object SMTTranscript {
  private case class Entry(command: String, response: Either[Exception, SExpr])

  final class MismatchException(msg: String) extends Exception(msg)

  private def clip(s: String): String = {
    val line = s.replaceAll("\\s+", " ")
    if (line.length > 300) line.take(300) + "..." else line
  }
}

/** The transcript that the SMT-LIB solvers record to or replay from (see [[SMTTranscript]]). It can
  * only be given programmatically. */
object optSMTTranscript extends OptionDef[Option[SMTTranscript]] {
  val name = "smt-transcript"
  val default = None
  val parser: OptionParsers.OptionParser[Option[SMTTranscript]] = _ => None
  val usageRhs = ""
}
