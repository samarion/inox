/* Copyright 2009-2026 EPFL, Lausanne */

package inox
package certificates

/** Checks that the clauses of a template of a certificate are those of its source: the body of a
  * function, or an expression that holds, such as the query (see `certificates/README.md`), once
  * the source is lowered to the syntax of the session (see [[Lowering]]).
  *
  * The clauses of a template name the values of the subexpressions of its source, and the paths
  * that lead to them:
  *  - a blocker is defined from the blocker of the path that it extends: `(= b (and p c))` or
  *    `(= (and p c) b)`, or is a condition on that path, `(=> p (= b c))`;
  *  - a merge blocker holds on any path of the blockers that it joins: `(= (or b1 .. bn) m)`, and a
  *    blocker is the same as another: `(= b m)`, either of which is the new one;
  *  - a symbol is the value of a subexpression on the path of a blocker: `(=> b (= v t))`;
  *  - an assumption of the source holds on its path: `(=> b c)`;
  *  - the call of a function is the value of its body, `(=> start (= call v))`, and an expression
  *    that holds does, `(=> start t)`;
  *  - a symbol that holds where a call fails only holds where the template is: `(=> fail start)`.
  *
  * The `where` of a source gives the meanings of its markers, such as the typing of a value, and
  * of symbols of the template that the source names, such as the lambdas that it holds; a meaning
  * is never that of a literal, nor given from itself.
  *
  * The checker gives each symbol a meaning, a term over the parameters of the template: a blocker
  * is the conjunction of the conditions of its path (a merge, the disjunction of those of its
  * blockers), and a symbol is the term that its definitions give, a conditional when they are on
  * the two branches of one, or the conjunction or disjunction of its operands when it is one,
  * whatever an assumption equates it with. A symbol that a clause states, `(=> b v)` or `(=> b (not v))`, means
  * true or false on that path, and a symbol defined under one branch only means the blocker of
  * that branch where nothing outside of it uses the symbol, and is false outside of it otherwise.
  * A symbol that a clause states and that nothing defines means what the clause states, and a
  * symbol that is defined from itself, such as an element of a set that is a union with it, has
  * no meaning: its clauses must hold as they are. A path whose condition doesn't hold
  * is not reached, and its clauses hold trivially. The meanings are a
  * guess, and the check doesn't rely on it: under them, each clause must hold for the source.
  * Terms are compared after inlining the meanings and the `let`s, dropping the assumptions, which
  * hold wherever evaluation reaches them, and taking the branch of each conditional whose
  * condition the path decides, or whose branches are the same.
  *
  * The checker refuses a certificate with a template that it can't relate to its source, and the
  * reason says which clause is in the way. */
object Sources {
  import Checker._

  /** What a template is of: `(function <call> <body>)` or `(expression <term>)`. */
  sealed trait Source { def expr: SExpr; def where: List[(SExpr, SExpr)] }
  final case class Function(call: SExpr, expr: SExpr, where: List[(SExpr, SExpr)] = Nil) extends Source
  final case class Expression(expr: SExpr, where: List[(SExpr, SExpr)] = Nil) extends Source

  object Source {
    /** The source `(function <call> <body> [(where (l r) ...)])` or
      * `(expression <term> [(where (l r) ...)])`, if `e` is one. */
    def unapply(e: SExpr): Option[Source] = e match {
      case SList(List(Atom("function"), call, body)) => Some(Function(call, body))
      case SList(List(Atom("function"), call, body, Where(w))) => Some(Function(call, body, w))
      case SList(List(Atom("expression"), expr)) => Some(Expression(expr))
      case SList(List(Atom("expression"), expr, Where(w))) => Some(Expression(expr, w))
      case _ => None
    }
  }

  private object Where {
    def unapply(e: SExpr): Option[List[(SExpr, SExpr)]] = e match {
      case SList(Atom("where") :: pairs) =>
        val ps = pairs.collect { case SList(List(l, r)) => l -> r }
        if (ps.size == pairs.size) Some(ps) else None
      case _ => None
    }
  }

  private final class Untraced(val why: String) extends Exception(why)
  private def untraced(why: String): Nothing = throw new Untraced(why)

  private val True = Atom("true")
  private val False = Atom("false")
  private def app(op: String, args: SExpr*): SExpr = SList(Atom(op) :: args.toList)

  private def atoms(e: SExpr): Set[Atom] = e match {
    case a: Atom => Set(a)
    case SList(items) => items.flatMap(atoms).toSet
  }

  private def substitute(e: SExpr, subst: Map[SExpr, SExpr]): SExpr = e match {
    case a: Atom => subst.getOrElse(a, a)
    case SList(List(Atom("let"), SList(bindings), body)) =>
      val bound = bindings.collect { case SList(List(x, _)) => x }
      SList(List(Atom("let"),
        SList(bindings.map { case SList(List(x, v)) => SList(List(x, substitute(v, subst))); case other => other }),
        substitute(body, subst -- bound)))
    case SList(items) => SList(items.map(substitute(_, subst)))
  }

  /** Reasoning on paths, where `siblings` gives the constructors of the datatype of each
    * constructor. */
  private final class Logic(siblings: Map[Atom, List[Atom]]) {
    /** The normal form of `e`, where a comparison is the negation of the opposite one, which the
      * condition of a blocker is when the source has the latter. */
    def normal(e: SExpr): SExpr = {
      def strict(e: SExpr): SExpr = e match {
        case SList(List(Atom("<="), x, y)) => app("not", app(">", strict(x), strict(y)))
        case SList(List(Atom("<"), x, y)) => app("not", app(">=", strict(x), strict(y)))
        case SList(items) => SList(items.map(strict))
        case a => a
      }
      Checker.normal(strict(e))
    }

    /** The conjuncts of the normal form of `e`, with what they say of the constructors of a
      * value: a value of one constructor is of none of the others, and a value of a datatype of
      * two constructors that is not of one is of the other. */
    def conjuncts(e: SExpr): Set[SExpr] = {
      val cs: Set[SExpr] = normal(e) match {
        case SList(Atom("and") :: es) => es.toSet
        case True => Set.empty
        case other => Set(other)
      }
      cs ++ cs.flatMap {
        case SList(List(Atom("is"), c: Atom, x)) =>
          siblings.getOrElse(c, Nil).filter(_ != c).map(o => app("not", app("is", o, x)))
        case SList(List(Atom("not"), SList(List(Atom("is"), c: Atom, x)))) => siblings.get(c) match {
          case Some(List(c1, c2)) => List(app("is", if (c1 == c) c2 else c1, x))
          case _ => Nil
        }
        case _ => Nil
      }
    }

    /** Whether `e` holds wherever the conditions `path` do. */
    def holds(path: Set[SExpr], e: SExpr): Boolean = {
      val n = normal(e)
      conjuncts(n).subsetOf(path) || (n match {
        // a disjunction with an operand that holds, or with an operand and its negation
        case SList(Atom("or") :: es) => es.exists(path) || es.exists(d => es.contains(normal(app("not", d))))
        case _ => false
      })
    }

    /** `e` without its `let`s and assumptions, where each conditional whose condition `path`
      * decides is its branch, and `meaning` gives the meaning of a symbol. */
    def reduce(e: SExpr, path: Set[SExpr], meaning: Atom => Option[SExpr]): SExpr = e match {
      case a: Atom => meaning(a) match {
        case Some(m) => reduce(m, path, _ => None)
        case None => a
      }
      case SList(List(Atom("let"), SList(bindings), body)) =>
        val subst = bindings.map {
          case SList(List(x, v)) => x -> reduce(v, path, meaning)
          case other => untraced(s"$other is not a binding")
        }.toMap[SExpr, SExpr]
        // the bound values are reduced, and the body's own symbols are not bound by the `let`
        reduce(substitute(body, subst), path, a => if (subst.contains(a)) None else meaning(a))
      case SList(List(Atom("assume"), _, body)) => reduce(body, path, meaning)
      case SList(List(Atom("ite"), c, a, b)) =>
        val cond = reduce(c, path, meaning)
        if (holds(path, cond)) reduce(a, path, meaning)
        else if (holds(path, app("not", cond))) reduce(b, path, meaning)
        else app("ite", cond, reduce(a, path ++ conjuncts(cond), meaning), reduce(b, path ++ conjuncts(app("not", cond)), meaning))
      case SList(items) => SList(items.map(reduce(_, path, meaning)))
    }

    /** The normal form of `e` where `path` holds: without the operands of its conjunctions and
      * disjunctions that the path, or the operands that are not themselves conjunctions or
      * disjunctions, decide. */
    def simplify(e: SExpr, path: Set[SExpr]): SExpr = normal(e) match {
      case n if holds(path, n) => True
      case n if holds(path, app("not", n)) => False
      case SList(Atom(op @ ("and" | "or")) :: es) =>
        val (junctions, others) = es.partition { case SList(Atom("and" | "or" | "ite") :: _) => true; case _ => false }
        val operands = (others ++ junctions).foldLeft((path, List.empty[SExpr])) { case ((p, acc), operand) =>
          val value = simplify(operand, p)
          (p ++ conjuncts(if (op == "or") app("not", value) else value), acc :+ value)
        }._2
        val n = normal(SList(Atom(op) :: operands))
        if (n == normal(SList(Atom(op) :: es))) n else simplify(n, path)
      case SList(List(Atom("="), a, b)) if simplify(a, path) == simplify(b, path) => True
      case SList(List(Atom("ite"), c, a, b)) if holds(path, c) => simplify(a, path)
      case SList(List(Atom("ite"), c, a, b)) if holds(path, app("not", c)) => simplify(b, path)
      // each branch where its condition holds
      case SList(List(Atom("ite"), c, a, b)) =>
        val cond = simplify(c, path)
        val (yes, no) = (simplify(a, path ++ conjuncts(cond)), simplify(b, path ++ conjuncts(app("not", cond))))
        // a conditional of equal branches is its branch
        // a conditional is the same as the one on the negation of its condition, and the one that
        // stands for both has the condition that prints first
        val negated = normal(app("not", cond))
        if (yes == no) yes
        else if (negated.toString < cond.toString) normal(app("ite", negated, no, yes))
        else normal(app("ite", cond, yes, no))
      case SList(items) => normal(SList(items.map(simplify(_, path))))
      case a => a
    }

    /** The subexpressions of `e` that evaluation reaches, each with the conditions of the path
      * that leads to it. A bound expression is reached where its `let` is, and its value is where
      * its variable is used. */
    def sites(e: SExpr, path: Set[SExpr], reduced: (SExpr, Set[SExpr]) => SExpr): List[(Set[SExpr], SExpr)] = (path -> e) :: (e match {
      case _: Atom => Nil
      case SList(List(Atom("let"), SList(bindings), body)) =>
        val bound = bindings.map {
          case SList(List(x, v)) => x -> v
          case other => untraced(s"$other is not a binding")
        }
        bound.flatMap(b => sites(b._2, path, reduced)) ++
          sites(substitute(body, bound.map(b => b._1 -> inlined(b._2)).toMap[SExpr, SExpr]), path, reduced)
      case SList(List(Atom("assume"), c, body)) =>
        sites(c, path, reduced) ++ sites(body, path ++ conjuncts(reduced(c, path)), reduced)
      case SList(List(Atom("ite"), c, a, b)) =>
        val cond = reduced(c, path)
        sites(c, path, reduced) ++ sites(a, path ++ conjuncts(cond), reduced) ++
          sites(b, path ++ conjuncts(app("not", cond)), reduced)
      case SList(Atom(op @ ("and" | "or" | "=>")) :: es) =>
        // the operands after the first are only reached when the ones before don't decide the result
        es.foldLeft((path, List.empty[(Set[SExpr], SExpr)])) { case ((p, acc), operand) =>
          val value = reduced(operand, p)
          val next = if (op == "or") app("not", value) else value
          (p ++ conjuncts(next), acc ++ sites(operand, p, reduced))
        }._2
      case SList(items) => items.flatMap(sites(_, path, reduced))
    })
  }

  /** `e` without its `let`s, which are inlined. */
  private def inlined(e: SExpr): SExpr = e match {
    case SList(List(Atom("let"), SList(bindings), body)) =>
      inlined(substitute(body, bindings.map {
        case SList(List(x, v)) => x -> inlined(v)
        case other => untraced(s"$other is not a binding")
      }.toMap[SExpr, SExpr]))
    case SList(items) => SList(items.map(inlined))
    case a => a
  }

  /** Checks that `clauses`, the clauses of a template of parameters `params`, the first of which
    * is its start blocker, are clauses of `source`. Gives why the checker can't tell when it
    * can't. */
  def check(params: List[SExpr], clauses: Seq[SExpr], source: Source, signature: Signature): Either[String, Ranks] =
    try Right(trace(params, clauses, source, signature)) catch { case u: Untraced => Left(u.why) }

  /** What the scripts of a certificate declare: its `functions`, with those without parameters
    * that templates define, and the constructor of each of
    * the `selectors` of its datatypes. */
  final case class Signature(functions: Set[Atom], selectors: Map[Atom, Atom], constructors: Map[Atom, List[Atom]] = Map.empty)

  object Signature {
    def apply(script: Seq[SExpr]): Signature = {
      // a datatype is the list of its constructors, or `(par (<sorts>) (<constructors>))`
      val datatypes = script.collect { case SList(List(Atom("declare-datatypes"), _, SList(datatypes))) =>
        datatypes.map {
          case SList(List(Atom("par"), _, SList(constructors))) => constructors
          case SList(constructors) => constructors
          case _ => Nil
        }.map(_.collect { case SList((c: Atom) :: fields) => c -> fields })
      }.flatten
      Signature(
        script.collect { case SList(List(Atom("declare-fun"), f: Atom, SList(_ :: _), _)) => f }.toSet,
        datatypes.flatten.flatMap { case (c, fields) => fields.collect { case SList(List(s: Atom, _)) => s -> c } }.toMap,
        datatypes.flatMap(cs => cs.map(c => c._1 -> cs.map(_._1))).toMap)
    }
  }

  /** What the rank clauses of a template take its symbols to be: the `ranks` of its function,
    * each the symbol of a function from the arguments of the function to the rank of its call,
    * the ranks of the functions that it `calls`, each with the functions that it calls on the
    * arguments of the clause, and the symbols that hold when a call `diverges`. A certificate
    * must give each function one rank, and each rank to one function. */
  final case class Ranks(ranks: Set[(Atom, Atom)], calls: Set[(Atom, Set[Atom])], diverges: Set[Atom])

  private def trace(params: List[SExpr], clauses: Seq[SExpr], source: Source, signature: Signature): Ranks = {
    val logic = new Logic(signature.constructors)
    import logic._
    var ranks = Set.empty[(Atom, Atom)]
    var calls = Set.empty[(Atom, Set[Atom])]
    var diverges = Set.empty[Atom]
    // the meanings that the source gives: of terms of its body, such as the typing of a value,
    // and of symbols of the template
    val termMeanings: Map[SExpr, SExpr] = source.where.collect { case (l: SList, r) => l -> r }.toMap
    def unmark(e: SExpr, seen: Set[SExpr] = Set.empty): SExpr = termMeanings.get(e) match {
      case Some(r) =>
        if (seen(e)) untraced(s"the meaning of $e is given from itself")
        unmark(r, seen + e)
      case None => e match {
        case SList(items) => SList(items.map(unmark(_, seen)))
        case a => a
      }
    }
    val symbolMeanings: Map[Atom, SExpr] = source.where.collect {
      case (l @ (True | False), _) => untraced(s"the source gives a meaning to $l")
      case (l: Atom, r) => l -> unmark(r)
    }.toMap
    val body = unmark(source.expr)

    val start = params.headOption match {
      case Some(a: Atom) => a
      case other => untraced(s"the template's start blocker is $other")
    }
    // the symbols that only the meanings of the source's terms have, such as the value of a
    // component of a typed value, are the template's to define
    val fixed: Set[Atom] = params.collect { case a: Atom => a }.toSet ++ atoms(source.expr) ++ symbolMeanings.keySet ++
      (source match { case Function(call, _, _) => atoms(call); case _ => Set.empty })

    // blockers: `(= b (and p c))` or `(= (and p c) b)`
    val blockers = scala.collection.mutable.LinkedHashMap[Atom, (Atom, SExpr)]()
    // the clauses of each blocker: `(=> b clause)`
    val guarded = scala.collection.mutable.ListBuffer[(Atom, SExpr)]()
    // blockers that merge the paths of others, where a call that they share is unrolled once:
    // `(= (or b1 b2 ...) bm)`, or `(= b1 bm)`
    val merges = scala.collection.mutable.LinkedHashMap[Atom, List[Atom]]()
    def merge(bs: List[SExpr], m: Atom): Unit = {
      if (blockers.contains(m) || merges.contains(m)) untraced(s"the blocker $m is defined twice")
      merges(m) = bs.map {
        case b: Atom => b
        case other => untraced(s"$other is not a blocker")
      }
    }
    val aliases = scala.collection.mutable.ListBuffer[(Atom, Atom)]()
    clauses.foreach {
      // a symbol that holds when a call fails, such as `fail`, only holds where the call is
      // reached: the clause holds where the template is, and elsewhere when the symbol doesn't
      case SList(List(Atom("=>"), v: Atom, `start`)) if v != start && !fixed(v) =>
      case SList(List(Atom("="), SList(List(Atom("and"), p: Atom, c)), b: Atom)) if !fixed(b) =>
        if (blockers.contains(b)) untraced(s"the blocker $b is defined twice")
        blockers(b) = (p, c)
      case SList(List(Atom("="), b: Atom, SList(Atom("and") :: (p: Atom) :: (cs @ (_ :: _))))) if !fixed(b) =>
        if (blockers.contains(b)) untraced(s"the blocker $b is defined twice")
        blockers(b) = (p, cs match { case List(c) => c; case _ => SList(Atom("and") :: cs) })
      // the blocker of a path whose condition never holds
      case SList(List(Atom("="), b: Atom, False)) if !fixed(b) =>
        if (blockers.contains(b)) untraced(s"the blocker $b is defined twice")
        blockers(b) = (start, False)
      case SList(List(Atom("=>"), b: Atom, clause)) => guarded += b -> clause
      case SList(List(Atom("="), SList(Atom("or") :: bs), m: Atom)) if !fixed(m) => merge(bs, m)
      case SList(List(Atom("="), b: Atom, m: Atom)) if !fixed(m) && m != start || !fixed(b) => aliases += b -> m
      case other => untraced(s"$other is neither the definition of a blocker nor a clause under one")
    }
    // `(= b m)` is a merge of one blocker, the blocker `b` of a path that has no condition of its
    // own, or the definition of a symbol `b` that no other clause has, such as the blocker of the
    // instantiations of a quantifier that its value is
    for ((b, m) <- aliases) {
      def isBlocker(a: Atom) = a == start || blockers.contains(a) || merges.contains(a) || aliases.exists(_._2 == a)
      def defined(a: Atom) = a == start || blockers.contains(a) || merges.contains(a)
      if (defined(m) && !fixed(b) && !defined(b)) {
        blockers(b) = (m, True)
      } else if (isBlocker(b) && !fixed(m) && m != start) {
        if (blockers.contains(m) || merges.contains(m)) untraced(s"the blocker $m is defined twice")
        blockers(m) = (b, True)
      } else if (fixed(b) || clauses.count(c => atoms(c)(b)) > 1)
        untraced(s"(= $b $m) is neither the definition of a blocker nor that of a symbol")
    }

    // a symbol that is a condition on the path of a blocker, and the blocker of clauses of its
    // own, is the blocker of that condition: `(=> b (= p c))` and `(=> p clause)`, such as the
    // condition of a dependency of a lambda or a quantifier
    val guards = guarded.map(_._1).toSet
    for (case (b, SList(List(Atom("="), p: Atom, c))) <- guarded.toList
         if guards(p) && !fixed(p) && p != b && !blockers.contains(p) && !merges.contains(p) && !atoms(c)(p))
      blockers(p) = (b, c)

    // the blockers from `b` up to the start blocker, through the blockers that all the paths of
    // a merge share
    def ancestors(b: Atom, seen: Set[Atom] = Set.empty): List[Atom] =
      if (seen(b)) untraced(s"the blocker $b is on its own path")
      else if (b == start) List(start)
      else (blockers.get(b), merges.get(b)) match {
        case (Some((p, _)), _) => b :: ancestors(p, seen + b)
        case (_, Some(bs)) =>
          b :: bs.map(ancestors(_, seen + b).reverse).reduce((p, q) => (p zip q).takeWhile(pq => pq._1 == pq._2).map(_._1)).reverse
        case _ => untraced(s"$b is not a blocker of the template")
      }

    // the blockers on any of the paths of `b`
    def above(b: Atom): Set[Atom] = (blockers.get(b), merges.get(b)) match {
      case (Some((p, _)), _) => above(p) + b
      case (_, Some(bs)) => bs.flatMap(above).toSet + b
      case _ => Set(b)
    }

    // whether `e` has `v` other than under a blocker of the paths through `b`: `(=> b' e')`
    def unguarded(e: SExpr, v: Atom, b: Atom): Boolean = e match {
      case SList(List(Atom("=>"), g: Atom, _)) if (blockers.contains(g) || merges.contains(g)) && above(g).contains(b) => false
      case SList(items) => items.exists(unguarded(_, v, b))
      case a => a == v
    }

    // the symbols that the clauses define: `(=> b (= v t))`, and what marks a conjunction or a
    // disjunction whose operands are on different paths: `(=> b (=> (not r) (not v)))` and
    // `(=> b (=> r v))`
    def definable(e: SExpr): Boolean = e match {
      case a: Atom => !fixed(a) && !blockers.contains(a) && !merges.contains(a) && a != start && a != True && a != False
      case _ => false
    }
    def isCall(t: SExpr): Boolean = source match { case Function(call, _, _) => t == call; case _ => false }
    val definitions = scala.collection.mutable.LinkedHashMap[Atom, List[(Atom, SExpr)]]()
    for ((b, clause) <- guarded) clause match {
      case SList(List(Atom("="), v: Atom, t)) if definable(v) && !atoms(t)(v) =>
        definitions(v) = definitions.getOrElse(v, Nil) :+ (b -> t)
      case SList(List(Atom("="), t, v: Atom)) if definable(v) && !definable(t) && !atoms(t)(v) && !isCall(t) =>
        definitions(v) = definitions.getOrElse(v, Nil) :+ (b -> t)
      case _ =>
    }

    // the meaning of each symbol, without those of the symbols of its own meaning
    val meanings = scala.collection.mutable.Map[Atom, SExpr]()
    val pending = scala.collection.mutable.Set[Atom]()
    val opaque = scala.collection.mutable.Set[Atom]()
    final class Cyclic(val v: Atom) extends Exception(s"the symbol $v is defined from itself")
    // that of a blocker is the conditions of its paths, those of the template's start aside
    val expanding = scala.collection.mutable.Set[Atom]()
    def meaning(v: Atom): Option[SExpr] = if (symbolMeanings.contains(v)) {
        if (expanding(v)) untraced(s"the meaning of $v is given from itself")
        expanding += v
        try Some(expand(symbolMeanings(v))) finally expanding -= v
      }
      else if (blockers.contains(v) || merges.contains(v)) Some(meanings.getOrElseUpdate(v, {
        def condition(b: Atom): SExpr = if (b == start) True else expand(b)
        (blockers.get(v), merges.get(v)) match {
          case (Some((p, c)), _) => app("and", condition(p), expand(c))
          case (_, Some(bs)) => SList(Atom("or") :: bs.map(condition))
          case _ => True
        }
      }))
      else if (!definitions.contains(v) || opaque(v)) None else meanings.get(v).orElse {
      if (pending(v)) throw new Cyclic(v)
      pending += v
      try { val m = definedMeaning(v); meanings(v) = m; Some(m) }
      // a symbol whose definitions are in terms of itself, such as an element of a set that is a
      // union with it, has no meaning, and the clauses that define it must hold as they are
      catch { case c: Cyclic if c.v == v => opaque += v; None }
      finally pending -= v
    }
    def definedMeaning(v: Atom): SExpr = definitions(v) match {
      case List((_, t)) => expand(t)
      case ds => untraced(s"the symbol $v has no meaning and ${ds.size} definitions")
    }
    // `t` with the meanings of its symbols
    def expand(t: SExpr): SExpr = t match {
      case a: Atom => meaning(a).getOrElse(a)
      case SList(items) => SList(items.map(expand))
    }

    def reduced(e: SExpr, path: Set[SExpr]): SExpr = simplify(reduce(e, path, meaning), path)

    // the conditions of each path of each blocker, of which a merge has those of its blockers
    val paths = scala.collection.mutable.Map[Atom, List[Set[SExpr]]](start -> List(Set.empty))
    def pathsOf(b: Atom): List[Set[SExpr]] = paths.getOrElseUpdate(b, {
      ancestors(b)
      (blockers.get(b), merges.get(b)) match {
        // without the paths where the condition can't hold
        case (Some((p, c)), _) => pathsOf(p).flatMap { above =>
          val cond = reduced(c, above)
          if (cond == False || holds(above, normal(app("not", cond)))) None else Some(above ++ conjuncts(cond))
        }
        case (_, Some(bs)) => bs.flatMap(pathsOf).distinct
        case _ => untraced(s"$b is not a blocker of the template")
      }
    })

    val reached = sites(body, Set.empty, reduced)
    val assumed = reached.collect { case (p, SList(List(Atom("assume"), c, _))) => p -> reduced(c, p) }
    // the conditions of `p` and the assumptions that evaluation reaches where they hold
    def assumptions(p: Set[SExpr]): Set[SExpr] = {
      val more = p ++ assumed.collect { case (ap, ac) if ap.subsetOf(p) => conjuncts(ac) }.flatten
      if (more == p) p else assumptions(more)
    }

    /** Whether `clause` states that the rank of the template's call is higher than that of a
      * call that its body reaches under `p`, unless a call diverges:
      * `(or (> (apply rank args) (apply rank' args')) diverges)`, or its first operand alone. */
    def decreases(clause: SExpr, p: Set[SExpr]): Boolean = {
      val (decrease, unless) = clause match {
        case SList(List(Atom("or"), d, u: Atom)) => (d, Some(u))
        case d => (d, None)
      }
      // the rank of a call, whose function has no parameters when the rank is a symbol
      def rank(e: SExpr): Option[(Atom, List[SExpr])] = e match {
        case SList(Atom(_) :: (r: Atom) :: args) => Some((r, args))
        case r: Atom => Some((r, Nil))
        case _ => None
      }
      // the template's call, which is a symbol when the function has no parameters
      val call = source match {
        case Function(SList((f: Atom) :: fargs), _, _) => Some((f, fargs))
        case Function(f: Atom, _, _) => Some((f, Nil))
        case _ => None
      }
      (decrease, call) match {
        case (SList(List(Atom(">"), rank1, rank2)), Some((f, fargs)))
            if rank(rank1).exists(_._2 == fargs) && fargs == params.tail.take(fargs.size) && rank(rank2).isDefined =>
          val r1 = rank(rank1).get._1
          val (r2, args2) = rank(rank2).get
          val args = args2.map(reduced(_, p))
          val called = reached.collect {
            case (cp, SList((g: Atom) :: gargs)) if signature.functions(g) && cp.subsetOf(assumptions(p)) && gargs.map(reduced(_, p)) == args => g
            case (cp, g: Atom) if args.isEmpty && signature.functions(g) && cp.subsetOf(assumptions(p)) => g
          }.toSet
          called.nonEmpty && {
            ranks += f -> r1
            calls += r2 -> called
            diverges ++= unless
            true
          }
        case _ => false
      }
    }

    /** Whether `c` is what an operation that the source reaches under `p` needs for its value:
      * a divisor is not zero, and the argument of a selector is of its constructor. */
    def needed(c: SExpr, p: Set[SExpr]): Boolean = reached.exists {
      case (cp, SList(List(Atom("div" | "mod" | "rem" | "/"), _, d))) if cp.subsetOf(assumptions(p)) =>
        val divisor = reduced(d, p)
        c == normal(app("not", app("=", divisor, Atom("0")))) || c == normal(app("not", app("=", divisor, app("/", Atom("0"), Atom("1")))))
      case (cp, SList(List(s: Atom, x))) if cp.subsetOf(assumptions(p)) =>
        signature.selectors.get(s).exists(constructor => c == app("is", constructor, reduced(x, p)))
      case _ => false
    }

    var related = false
    for ((b, clause) <- guarded; p <- pathsOf(b)) {
      def same(x: SExpr, y: SExpr): Boolean = reduced(x, p) == reduced(y, p)
      val justified = (clause, source) match {
        // the call of the function is the value of its body
        case (SList(List(Atom("="), call, v)), Function(c, _, _)) if b == start && call == c =>
          if (!same(v, body)) untraced(s"the value $v of the call is ${reduced(v, p)}, and its body is ${reduced(body, p)}")
          related = true
          true
        case (SList(List(Atom("="), x, y)), _) if same(x, y) => true
        case _ =>
          val c = reduced(clause, p)
          c == True || holds(p, c) || conjuncts(c).subsetOf(assumptions(p)) ||
            (source match {
              // the expression holds
              case Expression(_, _) if b == start && c == reduced(body, p) => related = true; true
              case _ => false
            }) || needed(normal(reduce(clause, p, meaning)), p) || needed(c, p) || decreases(clause, p)
      }
      if (!justified) untraced(s"the clause $clause under $b is not one of the source: under its path, it is ${reduced(clause, p)}")
    }

    source match {
      // an expression whose clause is `true` has no clause
      case Expression(_, _) if !related && reduced(body, Set.empty) == True => ()
      case _ if !related => untraced("no clause relates the template to its source")
      case _ => ()
    }
    Ranks(ranks, calls, diverges)
  }
}
