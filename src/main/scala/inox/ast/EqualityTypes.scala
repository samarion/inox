/* Copyright 2009-2018 EPFL, Lausanne */

package inox
package ast

import utils.Lazy

/** Tracks which types admit equality.
  *
  * Functions can't be compared, so neither can values of types that contain them, such as tuples
  * or ADTs with function fields. Sets and bags compare their elements and maps their keys, so these
  * are only well formed over types that admit equality.
  *
  * Inside its owner, a type parameter admits equality. The type parameters on which a function or
  * sort needs equality are inferred, and every instantiation of them must admit equality.
  *
  * These rules are checked on definitions (see `ensureWellFormed`) and on the expressions given to
  * solvers. They don't affect `getType`, since solvers compare functions internally, for instance
  * to bind a function-typed `let`.
  */
trait EqualityTypes {
  protected val trees: Trees
  import trees._
  protected val symbols: Symbols

  /** The type parameters (by index in `owner`) that `tpe` needs to admit equality, or `None` if
    * `tpe` never admits equality. Type parameters not in `owner` admit equality. */
  private def equalityDependencies(
    tpe: Type,
    owner: Map[TypeParameter, Int],
    sorts: Identifier => Option[Set[Int]]
  ): Option[Set[Int]] = {
    def all(tpes: Seq[Type]): Option[Set[Int]] =
      tpes.foldLeft(Option(Set.empty[Int])) { (acc, tpe) => acc.flatMap(s => rec(tpe).map(s ++ _)) }

    def rec(tpe: Type): Option[Set[Int]] = tpe match {
      case tp: TypeParameter => Some(owner.get(tp).toSet)
      case _: FunctionType | _: PiType => None
      case RefinementType(vd, _) => rec(vd.tpe)
      case SigmaType(params, to) => all(params.map(_.tpe) :+ to)
      case ADTType(id, tps) =>
        if (symbols.lookupSort(id).exists(_.tparams.size == tps.size)) {
          sorts(id).flatMap(js => all(js.toSeq.map(tps)))
        } else {
          Some(Set.empty)
        }
      case NAryType(tps, _) => all(tps)
    }

    rec(tpe)
  }

  /** For each sort, the type parameters (by index) that equality on the sort needs, or `None` if
    * the sort has a field that never admits equality. This is a greatest fixpoint, so recursive
    * sorts admit equality unless one of their fields prevents it. */
  private val _sortEqualities: Lazy[Map[Identifier, Option[Set[Int]]]] = Lazy {
    var current: Map[Identifier, Option[Set[Int]]] = symbols.sorts.map(_._1 -> Some(Set.empty[Int]))
    var changed = true
    while (changed) {
      val next = symbols.sorts.map { case (id, sort) =>
        val owner = sort.typeArgs.zipWithIndex.toMap
        id -> (if (sort.flags.exists(_.isInstanceOf[HasADTEquality])) {
          Some(Set.empty[Int])
        } else {
          sort.constructors.flatMap(_.fields).foldLeft(Option(Set.empty[Int])) { (acc, vd) =>
            acc.flatMap(s => equalityDependencies(vd.tpe, owner, current(_)).map(s ++ _))
          }
        })
      }
      changed = next != current
      current = next
    }
    current
  }

  /** Whether values of type `tpe` can be compared. Type parameters admit equality. */
  def admitsEquality(tpe: Type): Boolean =
    equalityDependencies(tpe, Map.empty, _sortEqualities.get.getOrElse(_, Some(Set.empty))).isDefined

  /** The types that `tpe` needs to admit equality to be well formed: the elements of a set or bag,
    * and the keys of a map. */
  private def equalityOperands(tpe: Type): Seq[Type] = tpe match {
    case SetType(base) => Seq(base)
    case BagType(base) => Seq(base)
    case MapType(from, _) => Seq(from)
    case _ => Seq.empty
  }

  private class EqualityUses(owner: Map[TypeParameter, Int], required: Identifier => Set[Int])
    extends ConcreteSelfTreeTraverser {
    var result: Set[Int] = Set.empty

    private def need(tpe: Type): Unit =
      equalityDependencies(tpe, owner, _sortEqualities.get.getOrElse(_, Some(Set.empty))).foreach(result ++= _)

    private def instantiate(id: Identifier, tps: Seq[Type]): Unit =
      for (j <- required(id) if j < tps.size) need(tps(j))

    override def traverse(e: Expr): Unit = {
      e match {
        case Equals(lhs, _) => need(lhs.getType(using symbols))
        case FunctionInvocation(id, tps, _) => instantiate(id, tps)
        case ADT(id, tps, _) => symbols.lookupConstructor(id).foreach(c => instantiate(c.sort, tps))
        case _ =>
      }
      super.traverse(e)
    }

    override def traverse(tpe: Type): Unit = {
      tpe match {
        case ADTType(id, tps) => instantiate(id, tps)
        case _ => equalityOperands(tpe).foreach(need)
      }
      super.traverse(tpe)
    }
  }

  /** For each function and sort, the type parameters (by index) on which it needs equality: it
    * compares values whose type mentions them, or it instantiates such a type parameter of another
    * definition with a type that mentions them. This is a least fixpoint over the definitions. */
  private val _equalityRequirements: Lazy[Map[Identifier, Set[Int]]] = Lazy {
    var current: Map[Identifier, Set[Int]] = Map.empty
    var changed = true
    while (changed) {
      val required: Identifier => Set[Int] = current.getOrElse(_, Set.empty)
      val functions = symbols.functions.map { case (id, fd) =>
        val uses = new EqualityUses(fd.typeArgs.zipWithIndex.toMap, required)
        uses.traverse(fd)
        id -> uses.result
      }
      val sorts = symbols.sorts.map { case (id, sort) =>
        val uses = new EqualityUses(sort.typeArgs.zipWithIndex.toMap, required)
        uses.traverse(sort)
        val invariant = sort.flags.collect { case HasADTInvariant(inv) => required(inv) }.flatten
        id -> (uses.result ++ invariant)
      }
      val next = (functions ++ sorts).filter(_._2.nonEmpty)
      changed = next != current
      current = next
    }
    current
  }

  /** The type parameters (by index) of function or sort `id` whose instantiations must admit equality. */
  def equalityRequirements(id: Identifier): Set[Int] = _equalityRequirements.get.getOrElse(id, Set.empty)

  /** Finds the comparisons, sets, bags, maps and instantiations of type parameters that need
    * equality on types that don't admit it. */
  private class EqualityViolations extends ConcreteSelfTreeTraverser {
    var result: Seq[String] = Seq.empty

    private def show(t: Tree): String = t.asString(using PrinterOptions())

    private def check(id: Identifier, tps: Seq[Type]): Unit =
      for (j <- equalityRequirements(id).toSeq.sorted if j < tps.size && !admitsEquality(tps(j))) {
        result :+= s"${id.asString(using PrinterOptions())} compares values of its type parameter, " +
          s"which ${show(tps(j))} doesn't allow"
      }

    private def checkOperand(what: String, tpe: Type): Unit =
      if (!admitsEquality(tpe)) result :+= s"$what can't have type ${show(tpe)}, which doesn't admit equality"

    override def traverse(e: Expr): Unit = {
      e match {
        case Equals(lhs, rhs) =>
          val tpe = symbols.leastUpperBound(lhs.getType(using symbols), rhs.getType(using symbols))
          if (tpe != Untyped && !admitsEquality(tpe)) {
            result :+= s"${show(e)} compares values of type ${show(tpe)}, which doesn't admit equality"
          }
        case FiniteSet(_, base) => checkOperand("Set elements", base)
        case FiniteBag(_, base) => checkOperand("Bag elements", base)
        case FiniteMap(_, _, from, _) => checkOperand("Map keys", from)
        case FunctionInvocation(id, tps, _) => check(id, tps)
        case ADT(id, tps, _) => symbols.lookupConstructor(id).foreach(c => check(c.sort, tps))
        case _ =>
      }
      super.traverse(e)
    }

    override def traverse(tpe: Type): Unit = {
      tpe match {
        case ADTType(id, tps) => check(id, tps)
        case SetType(base) => checkOperand("Set elements", base)
        case BagType(base) => checkOperand("Bag elements", base)
        case MapType(from, _) => checkOperand("Map keys", from)
        case _ =>
      }
      super.traverse(tpe)
    }
  }

  /** The uses of equality in `e` on types that don't admit it, as error messages. The solver's own
    * encodings may compare any values, so this only applies to the input of the solver. */
  def equalityViolations(e: Expr): Seq[String] = {
    val violations = new EqualityViolations
    violations.traverse(e)
    violations.result
  }

  def equalityViolations(fd: FunDef): Seq[String] = {
    val violations = new EqualityViolations
    violations.traverse(fd)
    violations.result
  }

  def equalityViolations(sort: ADTSort): Seq[String] = {
    val violations = new EqualityViolations
    violations.traverse(sort)
    violations.result
  }
}
