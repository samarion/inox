/* Copyright 2009-2018 EPFL, Lausanne */

package inox

import org.scalatest.funsuite.AnyFunSuite
import org.scalatest.concurrent._
import org.scalatest.matchers.should.Matchers
import org.scalatest.{Args, CancelAfterFailure, Status, Tag, exceptions}
import utils._

import scala.collection.mutable

trait TestSuite extends AnyFunSuite with Matchers with TimeLimits {

  protected def configurations: Seq[Seq[OptionValue[?]]] = Seq(Seq.empty)

  protected def createContext(options: Options): Context = inox.TestContext(options)

  private val counter = new UniqueCounter[Unit]
  counter.nextGlobal // Start at 1

  protected def optionsString(options: Options): String = {
    "solvr=" + options.findOptionOrDefault(optSelectedSolvers).head + " " +
    "lucky=" + options.findOptionOrDefault(solvers.unrolling.optFeelingLucky) + " " +
    "check=" + options.findOptionOrDefault(solvers.optCheckModels) + " " +
    "assum=" + options.findOptionOrDefault(solvers.unrolling.optUnrollAssumptions)
  }

  protected def test(name: String, tags: Tag*)(body: Context ?=> Unit): Unit =
    test(name, _ => Test, tags*)(body)

  // Whether this instance defers the registration of its tests, see [[TestSuite.deferringRegistration]]
  private val deferRegistration = TestSuite.deferring.get
  // The registrations that this instance deferred, by test name (which scalatest trims)
  private val deferredRegistrations = mutable.Map[String, () => Unit]()

  private def register(testName: String)(registration: => Unit): Unit =
    if (deferRegistration) deferredRegistrations(testName.trim) = () => registration
    else registration

  override def run(testName: Option[String], args: Args): Status = {
    if (deferRegistration) {
      // The instance only runs `testName`, if any, so it only registers that test
      testName.flatMap(deferredRegistrations.remove).foreach(_())
      deferredRegistrations.clear()
    }
    super.run(testName, args)
  }

  sealed abstract class FilterStatus
  case object Test extends FilterStatus
  case object Ignore extends FilterStatus
  case object Skip extends FilterStatus
  case class WithContext(ctx: Context) extends FilterStatus

  protected def test(name: String, filter: Context => FilterStatus, tags: Tag*)(body: Context ?=> Unit): Unit = {
    // Workaround for a compiler crash caused by calling super.ignore
    def superIgnore(self: AnyFunSuite, testName: String)(body: => Unit): Unit =
      self.ignore(testName)(body)
    // Ditto
    def superTest(self: AnyFunSuite, testName: String)(body: => Unit): Unit =
      self.test(testName)(body)

    for (config <- configurations) {
      val ctx = createContext(Options(config))
      import ctx.reporter

      filter(ctx) match {
        case status @ (Test | Ignore | _: WithContext) =>
          val newCtx = status match {
            case WithContext(newCtx) => newCtx
            case _ => ctx
          }

          val index = counter.nextGlobal
          if (status == Ignore || newCtx.options.findOptionOrDefault(optSelectedSolvers).exists { sname =>
            (sname == "nativez3" || sname == "unrollz3" || sname == "nativez3-opt") && !solvers.SolverFactory.hasNativeZ3 ||
            (sname == "smt-z3" || sname == "smt-z3-opt") && !solvers.SolverFactory.hasZ3 ||
            sname == "smt-cvc4" && !solvers.SolverFactory.hasCVC4
          }) {
            val testName = f"$index%3d: $name ${optionsString(newCtx.options)}"
            register(testName)(superIgnore(this, testName)(()))
          } else {
            val testName = f"$index%3d: $name ${optionsString(newCtx.options)}"
            try {
              register(testName)(superTest(this, testName)(body(using newCtx)))
            } catch {
              case err: FatalError =>
                reporter.error(err.msg)
                // If you got here while debugging the tests, use your debugger
                // to inspect the reporter (which should be of type TestSilentReporter)
                // "lastErrors" field.
                throw new exceptions.TestFailedException(err, 5)
            }
          }
        case Skip =>
      }
    }
  }

  protected def ignore(name: String, tags: Tag*)(body: Context ?=> Unit): Unit =
    test(name, _ => Ignore, tags*)(body)

  protected def ignore(name: String, filter: Context => FilterStatus, tags: Tag*)(body: Context ?=> Unit): Unit =
    test(name, ctx => filter(ctx) match {
      case Skip => Skip
      case _ => Ignore
    }, tags*)(body)
}

object TestSuite {
  private val deferring = new ThreadLocal[Boolean] {
    override def initialValue(): Boolean = false
  }

  /** Creates a suite that only registers the test that it runs.
    *
    * Scalatest's `ParallelTestExecution` runs each test of a suite in an instance of its own, which
    * it creates with `newInstance`, and each instance registers all the tests of the suite. As
    * scalatest appends each test it registers to a list, a suite of `n` tests spends a time
    * quadratic in `n` in each instance, and cubic in all: for Stainless's verification suites,
    * with thousands of tests, this took more time than some of the solving. Suites can override
    * `newInstance` to create their instances with this method, which only register the test they
    * run, when they run it.
    */
  def deferringRegistration[T](create: => T): T = {
    val previous = deferring.get
    deferring.set(true)
    try create finally deferring.set(previous)
  }
}
