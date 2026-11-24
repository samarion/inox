/* Copyright 2009-2026 EPFL, Lausanne */

package inox
package certificates

/** Lowers the sources of the templates of a certificate, which Inox's SMT-LIB 3 printer prints,
  * to the syntax of the solver's session, in which the clauses of the templates are, so that
  * [[Sources]] can relate them (see `certificates/README.md`).
  *
  * The lowering only reads the certificate's symbol tables:
  *  - the `source-definitions`: the datatypes and the definitions of the functions that the
  *    sources name, in SMT-LIB 3, whose bodies are the sources of the templates of those
  *    functions (see [[Sources.Definition]]);
  *  - the `source-symbols`: the Inox definition that each symbol of the sources stands for, and
  *    the SMT-LIB 3 sort of each variable;
  *  - the `solver-symbols`: the Inox definition that each symbol of the session stands for,
  *    and for the symbols that a type determines (sorts, constructors, selectors, testers,
  *    dynamic applications and instances of generic functions), the SMT-LIB 3 sort of that type
  *    (for an instance, the list of the sorts of its type arguments).
  *
  * It infers the sort of each subterm of a source bottom-up, from the sorts of the literals,
  * the variables, the qualifiers `(as f S)` and the declarations, and picks the session symbol
  * for each symbol of the source whose session symbol depends on a type: the symbol of the same
  * Inox definition whose sort is the inferred one. Sorts are compared without their refinements
  * (the `:var` and `:restrict` attributes), which the session's sorts don't have; they keep
  * `:unsigned`. The lowering relies on distinct types printing as distinct sorts, which the
  * solver checks as it prints them.
  *
  * Each construct lowers as follows, where `t'` is the lowering of `t` and `S'` that of the sort
  * `S`:
  *  - literals, variables, `let`, `assume`, `ite`, and the Boolean, arithmetic, bit-vector and
  *    array operations are the same; `(! t :unsigned)`, `(! t :signed)` and `(! t :char)` are `t'`;
  *  - `C`, `(as C S)`, `(C ts)` and `((as C S) ts)` are the session's constructor of the same
  *    constructor and sort, applied to `ts'`, and `(tuple ts)` the session's tuple constructor of
  *    the sort; `(s t)` and `((_ tuple.select i) t)` are the session's selector of the same field
  *    and of the sort of `t`, and `((_ is C) t)` its tester;
  *  - `f`, `(as f S)`, `(f ts)` and `((as f S) ts)` are the session's instance of the function `f`
  *    at the sorts of its type arguments, which unifying its signature with the sorts of `ts`
  *    and `S` gives, and an uninterpreted function without type parameters its session's symbol;
  *  - `(@ f ts)` is `(f ts')` when the session declares `f` as a function of its own (a
  *    predicate), and `(d f' ts')` for the session's dynamic application `d` of the sort of `f`;
  *  - `(forall ((x S) ..) t)` is `(forall ((x S') ..) t')`, and `(exists ((x S) ..) t)` is
  *    `(not (forall ((x S') ..) u'))` where `u` is `(not t)`, or `v` when `t` is `(not v)`;
  *  - `(as emptyset S)` is `(as set.empty (Set S'))`, `(insert s t)` is `(set.insert t' s')`, and
  *    the set `(insert (as emptyset S) t1 .. tn)` is `(set.insert t2' .. tn' (set.singleton t1'))`
  *    when `t1` has no variable, and `(set.insert t1' .. tn' (as set.empty (Set S')))` otherwise,
  *    as the session builds them. With one element `t1` and no variable, this is also how the
  *    printer prints adding `t1` to the empty set, which is the same set; `member`, `union`,
  *    `intersection`, `setminus` and `subset` are `set.member`, `set.union`, `set.inter`,
  *    `set.minus` and `set.subset`;
  *  - the markers of the sources, `((as m S) ts)` and `(as m S)` for the uninterpreted functions
  *    that the source declarations don't declare, keep their head, and their arguments lower;
  *  - the sorts lower to themselves for `Bool`, `Int`, `Real`, `String` and the bit vectors,
  *    `(_ BitVec 16)` for `Char`, `Int` for the function sorts `(-> ..)`, elementwise for `Array`
  *    and `Set`, and to the session's sort of the same SMT-LIB 3 sort otherwise.
  *
  * It refuses a source that it can't type, a symbol of which the session has no symbol, or one
  * for which it has several, and the constructs that the corpus doesn't use and that it doesn't
  * lower: lambdas, `tuple.unit`, bags, strings operations and floating points. */
object Lowering {
  import Checker._

  final class Refused(val why: String) extends Exception(why)
  private def refuse(why: String): Nothing = throw new Refused(why)

  private val Bool = Atom("Bool")
  private val IntSort = Atom("Int")
  private def app(op: String, args: SExpr*): SExpr = SList(Atom(op) :: args.toList)

  private def quoted(e: SExpr): Boolean = e match {
    case Atom(t) => t.startsWith("\"")
    case _ => false
  }

  /** A symbol of a table: its name, its kind, the descriptions of the Inox definition that it
    * stands for, and the SMT-LIB 3 sort that it records, if any. */
  final case class Entry(name: Atom, kind: String, descriptions: List[String], sort: Option[SExpr])

  /** The entry of the line `(name kind "description".. [sort])` of a symbol table. */
  def entry(line: SExpr): Entry = line match {
    case SList((name: Atom) :: Atom(kind) :: rest) =>
      val (descriptions, sort) = rest.span(quoted)
      sort match {
        case Nil => Entry(name, kind, descriptions.map(_.toString), None)
        case List(s) => Entry(name, kind, descriptions.map(_.toString), Some(erase(s)))
        case _ => fail(s"$line doesn't describe a symbol")
      }
    case other => fail(s"$other doesn't describe a symbol")
  }

  /** The sort `s` without its refinements: the attributes `:var` and `:restrict` of its
    * annotations `(! ..)`, which the session's sorts don't have. */
  def erase(s: SExpr): SExpr = s match {
    case SList(Atom("!") :: base :: attributes) =>
      def kept(as: List[SExpr]): List[SExpr] = as match {
        case Atom(":var" | ":restrict") :: _ :: rest => kept(rest)
        case a :: rest => a :: kept(rest)
        case Nil => Nil
      }
      kept(attributes) match {
        case Nil => erase(base)
        case as => SList(Atom("!") :: erase(base) :: as)
      }
    case SList(items) => SList(items.map(erase))
    case atom => atom
  }

  private def bitVector(n: Int): SExpr = SList(List(Atom("_"), Atom("BitVec"), Atom(n.toString)))
  private def unsigned(s: SExpr): SExpr = SList(List(Atom("!"), s, Atom(":unsigned")))

  /** The size of the bit vector sort `s`, and whether it is unsigned. */
  private def bitVectorOf(s: SExpr): Option[(Int, Boolean)] = s match {
    case SList(List(Atom("_"), Atom("BitVec"), Atom(n))) if n.forall(_.isDigit) => Some((n.toInt, false))
    case SList(List(Atom("!"), b, Atom(":unsigned"))) => bitVectorOf(b).collect { case (n, false) => (n, true) }
    case _ => None
  }
  private def withSign(n: Int, isUnsigned: Boolean): SExpr = if (isUnsigned) unsigned(bitVector(n)) else bitVector(n)

  /** A constructor of a datatype of the sources, of type parameters `params`. */
  private final case class Constructor(datatype: Atom, params: List[Atom], fields: List[(Atom, SExpr)]) {
    def sort(args: List[SExpr]): SExpr = if (params.isEmpty) datatype else SList(datatype :: args)
  }
  /** The signature of a function of the sources, of type parameters `params`. */
  private final case class Signature(params: List[Atom], domain: List[SExpr], range: SExpr)
  /** The definition of a function of the sources, of type parameters `params`. */
  private final case class Definition(params: List[Atom], arguments: List[(Atom, SExpr)], range: SExpr, body: SExpr)

  /** The tables of a certificate: its `script` (with that of its templates), its session's
    * `solverSymbols`, and its `declarations` and `sourceSymbols`. */
  final class Tables(script: Seq[SExpr], solverSymbols: Seq[SExpr], declarations: Seq[SExpr], sourceSymbols: Seq[SExpr]) {
    private val session: Seq[Entry] = solverSymbols.map(entry)
    private val sessionNames: Map[Atom, Entry] = session.map(e => e.name -> e).toMap
    private val sources: Map[Atom, Entry] = sourceSymbols.map(entry).map(e => e.name -> e).toMap

    /** The constructors of the sources' datatypes, with the constructor and index of each selector. */
    private val (constructors: Map[Atom, Constructor], selectors: Map[Atom, (Atom, Int)]) = {
      val cs = declarations.collect {
        case SList(List(Atom("declare-datatypes"), SList(sorts), SList(datatypes))) if sorts.size == datatypes.size =>
          (sorts zip datatypes).flatMap {
            case (SList(List(d: Atom, _)), datatype) =>
              val (params, cons) = datatype match {
                case SList(List(Atom("par"), SList(ps), SList(cs))) => (ps.map { case p: Atom => p; case p => fail(s"$p is not a sort parameter") }, cs)
                case SList(cs) => (Nil, cs)
                case other => fail(s"$other is not a datatype")
              }
              cons.map {
                case SList((c: Atom) :: fields) => c -> Constructor(d, params, fields.map {
                  case SList(List(s: Atom, sort)) => s -> erase(sort)
                  case other => fail(s"$other is not a field")
                })
                case other => fail(s"$other is not a constructor")
              }
            case (other, _) => fail(s"$other is not a datatype's sort")
          }
      }.flatten
      (cs.toMap, cs.flatMap { case (c, cons) => cons.fields.zipWithIndex.map { case ((s, _), i) => s -> (c, i) } }.toMap)
    }

    /** The definitions of the sources' functions: `define-fun` and `define-fun-rec` of
      * `f ((x S) ..) R body` or of `(par (A ..) (f ((x S) ..) R body))`, and `define-funs-rec` of
      * the lists of the signatures, each `(f ((x S) ..) R)` or `(par (A ..) (f ((x S) ..) R))`,
      * and of the bodies. */
    private val definitions: Map[Atom, Definition] = {
      def parameters(ps: List[SExpr]): List[(Atom, SExpr)] = ps.map {
        case SList(List(x: Atom, s)) => x -> s
        case other => fail(s"$other is not a parameter")
      }
      def sortParameters(ps: List[SExpr]): List[Atom] = ps.map { case p: Atom => p; case p => fail(s"$p is not a sort parameter") }
      def signature(dec: SExpr): (Atom, List[Atom], List[(Atom, SExpr)], SExpr) = dec match {
        case SList(List(Atom("par"), SList(ps), SList(List(f: Atom, SList(xs), range)))) => (f, sortParameters(ps), parameters(xs), range)
        case SList(List(f: Atom, SList(xs), range)) => (f, Nil, parameters(xs), range)
        case other => fail(s"$other is not the signature of a function")
      }
      declarations.flatMap {
        case SList(List(Atom("define-fun" | "define-fun-rec"), f: Atom, SList(xs), range, body)) =>
          List(f -> Definition(Nil, parameters(xs), range, body))
        case SList(List(Atom("define-fun" | "define-fun-rec"), SList(List(Atom("par"), SList(ps), SList(List(f: Atom, SList(xs), range, body)))))) =>
          List(f -> Definition(sortParameters(ps), parameters(xs), range, body))
        case SList(List(Atom("define-funs-rec"), SList(decs), SList(bodies))) if decs.size == bodies.size =>
          (decs zip bodies).map { case (dec, body) =>
            val (f, ps, xs, range) = signature(dec)
            f -> Definition(ps, xs, range, body)
          }
        case d @ SList(Atom("define-fun" | "define-fun-rec" | "define-funs-rec") :: _) => fail(s"$d is not a definition")
        case _ => Nil
      }.toMap
    }

    private val functions: Map[Atom, Signature] = declarations.collect {
      case SList(List(Atom("declare-fun"), f: Atom, SList(domain), range)) => f -> Signature(Nil, domain.map(erase), erase(range))
      case SList(List(Atom("declare-fun"), SList(List(Atom("par"), SList(ps), SList(List(f: Atom, SList(domain), range)))))) =>
        f -> Signature(ps.collect { case p: Atom => p }, domain.map(erase), erase(range))
      case SList(List(Atom("declare-const"), c: Atom, sort)) => c -> Signature(Nil, Nil, erase(sort))
    }.toMap ++ definitions.map { case (f, d) => f -> Signature(d.params, d.arguments.map(a => erase(a._2)), erase(d.range)) }

    /** The session's functions of their own, which `(@ f ts)` applies directly. */
    private val predicates: Set[Atom] =
      script.collect { case SList(List(Atom("declare-fun"), f: Atom, SList(_ :: _), _)) => f }.toSet

    private def source(a: Atom, kind: String): Option[Entry] = sources.get(a).filter(_.kind == kind)
    /** A marker: an uninterpreted function of the sources that the declarations don't declare. */
    private def isMarker(a: Atom): Boolean = source(a, "uninterpreted").nonEmpty && !functions.contains(a)

    /** The one session symbol that `p` holds of. */
    private def unique(what: => String, p: Entry => Boolean): Atom = session.filter(p) match {
      case Seq(e) => e.name
      case Seq() => refuse(s"the session has no $what")
      case es => refuse(s"the session has several ${what}s: ${es.map(_.name).mkString(", ")}")
    }

    /** The session's sort of the sort `s` (see [[Lowering]]). */
    def lowerSort(s: SExpr): SExpr = erase(s) match {
      case b @ Atom("Bool" | "Int" | "Real" | "String") => b
      case Atom("Char") => bitVector(16)
      case SList(Atom("->") :: _) => IntSort
      case SList(List(Atom("Array"), k, v)) => app("Array", lowerSort(k), lowerSort(v))
      case SList(List(Atom("Set"), e)) => app("Set", lowerSort(e))
      case b if bitVectorOf(b).nonEmpty => bitVector(bitVectorOf(b).get._1)
      case other => unique(s"sort $other", e => e.kind == "sort" && e.sort.contains(other))
    }

    private def bind(pattern: SExpr, sort: SExpr, params: Set[Atom], subst: Map[Atom, SExpr]): Option[Map[Atom, SExpr]] = (pattern, sort) match {
      case (p: Atom, _) if params(p) => subst.get(p) match {
        case Some(s) => if (s == sort) Some(subst) else None
        case None => Some(subst + (p -> sort))
      }
      case (SList(ps), SList(ss)) if ps.size == ss.size =>
        (ps zip ss).foldLeft(Option(subst)) { case (acc, (p, s)) => acc.flatMap(bind(p, s, params, _)) }
      case _ => if (pattern == sort) Some(subst) else None
    }

    private def instantiate(s: SExpr, subst: Map[Atom, SExpr]): SExpr = s match {
      case a: Atom => subst.getOrElse(a, a)
      case SList(items) => SList(items.map(instantiate(_, subst)))
    }

    /** The values of `params` that make `patterns` the sorts `sorts`. */
    private def unify(what: => String, params: List[Atom], patterns: List[SExpr], sorts: List[SExpr]): List[SExpr] = {
      if (patterns.size != sorts.size) refuse(s"$what has ${sorts.size} arguments, not ${patterns.size}")
      val subst = (patterns zip sorts).foldLeft(Option(Map.empty[Atom, SExpr])) {
        case (acc, (p, s)) => acc.flatMap(bind(p, s, params.toSet, _))
      }.getOrElse(refuse(s"the sorts ${sorts.mkString(", ")} of $what are not those of its declaration"))
      params.map(p => subst.getOrElse(p, refuse(s"the sorts of $what don't determine its type parameter $p")))
    }

    private def constructor(c: Atom): Constructor = constructors.getOrElse(c, refuse(s"$c is not a declared constructor"))

    /** The sort of the constructor `c` applied to arguments of sorts `args`, of sort `qualifier` if given. */
    private def constructorSort(c: Atom, args: List[SExpr], qualifier: Option[SExpr]): SExpr = {
      val cons = constructor(c)
      qualifier.getOrElse(cons.sort(unify(s"the constructor $c", cons.params, cons.fields.map(_._2), args)))
    }

    /** The type arguments of the function `f` applied to arguments of sorts `args`, of sort `qualifier` if given. */
    private def typeArguments(f: Atom, args: List[SExpr], qualifier: Option[SExpr]): List[SExpr] = {
      val sig = functions.getOrElse(f, refuse(s"$f is not a declared function"))
      unify(s"the function $f", sig.params, sig.domain ++ qualifier.map(_ => sig.range), args ++ qualifier)
    }
    private def functionSort(f: Atom, args: List[SExpr], qualifier: Option[SExpr]): SExpr = {
      val sig = functions.getOrElse(f, refuse(s"$f is not a declared function"))
      qualifier.getOrElse(instantiate(sig.range, (sig.params zip typeArguments(f, args, None)).toMap))
    }

    private def datatypeArguments(s: SExpr): List[SExpr] = s match {
      case SList(_ :: args) => args
      case _ => Nil
    }

    private def isFunction(a: Atom): Boolean = source(a, "function").nonEmpty || (source(a, "uninterpreted").nonEmpty && !isMarker(a))

    private val booleans = Set("not", "and", "or", "=>", "xor", "=", "distinct", "<", "<=", ">", ">=",
      "bvult", "bvule", "bvugt", "bvuge", "bvslt", "bvsle", "bvsgt", "bvsge", "member", "subset", "forall", "exists")
    private val firsts = Set("+", "-", "*", "div", "mod", "abs", "bvadd", "bvsub", "bvmul", "bvudiv", "bvsdiv",
      "bvurem", "bvsrem", "bvsmod", "bvneg", "bvnot", "bvand", "bvor", "bvxor", "bvshl", "bvashr", "bvlshr",
      "union", "intersection", "setminus", "insert", "store")
    /** The operations that lower to themselves, applied to their lowered arguments. */
    private val same = booleans ++ firsts -- Set("member", "subset", "forall", "exists", "union", "intersection", "setminus", "insert") ++
      Set("/", "bv2nat", "ite", "select")
    private val setOperations = Map("member" -> "set.member", "subset" -> "set.subset", "union" -> "set.union",
      "intersection" -> "set.inter", "setminus" -> "set.minus")

    private def bindings(bs: List[SExpr], env: Map[Atom, SExpr]): List[(Atom, SExpr)] = bs.map {
      case SList(List(x: Atom, s)) => x -> s
      case other => refuse(s"$other is not a binding")
    }

    private def isLiteral(t: String): Boolean =
      t == "true" || t == "false" || t.nonEmpty && t.forall(_.isDigit) || t.matches("[0-9]+\\.[0-9]+") ||
      t.matches("#b[01]+") || t.matches("#x[0-9a-fA-F]+") || t.startsWith("\"")

    /** The sort of `e`, without its refinements, where `env` gives the sorts of the bound variables. */
    def sortOf(e: SExpr, env: Map[Atom, SExpr] = Map.empty): SExpr = e match {
      case Atom("true" | "false") => Bool
      case Atom(t) if t.nonEmpty && t.forall(_.isDigit) => IntSort
      case Atom(t) if t.matches("[0-9]+\\.[0-9]+") => Atom("Real")
      case Atom(t) if t.matches("#b[01]+") => bitVector(t.length - 2)
      case Atom(t) if t.matches("#x[0-9a-fA-F]+") => bitVector(4 * (t.length - 2))
      case Atom(t) if t.startsWith("\"") => Atom("String")
      case a: Atom if env.contains(a) => env(a)
      case a: Atom if source(a, "variable").exists(_.sort.nonEmpty) => source(a, "variable").get.sort.get
      case a: Atom if constructors.contains(a) => constructorSort(a, Nil, None)
      case a: Atom if functions.contains(a) => functionSort(a, Nil, None)
      case a: Atom => refuse(s"the sort of $a is unknown")

      case SList(List(Atom("!"), t, Atom(":unsigned"))) => bitVectorOf(sortOf(t, env)) match {
        case Some((n, _)) => withSign(n, true)
        case None => refuse(s"$t is not a bit vector")
      }
      case SList(List(Atom("!"), t, Atom(":signed"))) => bitVectorOf(sortOf(t, env)) match {
        case Some((n, _)) => withSign(n, false)
        case None => refuse(s"$t is not a bit vector")
      }
      case SList(List(Atom("!"), _, Atom(":char"))) => Atom("Char")

      case SList(List(Atom("as"), Atom("emptyset"), s)) => app("Set", erase(s))
      case SList(List(Atom("as"), m: Atom, _)) if isMarker(m) => Bool
      case SList(List(Atom("as"), _, s)) => erase(s)
      case SList(SList(List(Atom("as"), m: Atom, _)) :: _) if isMarker(m) => Bool
      case SList(SList(List(Atom("as"), _, s)) :: _) => erase(s)

      case SList(List(SList(List(Atom("_"), Atom("is"), _)), _)) => Bool
      case SList(List(SList(List(Atom("_"), Atom("tuple.select"), Atom(i))), t)) => sortOf(t, env) match {
        case SList(Atom("Tuple") :: ts) if i.forall(_.isDigit) && i.toInt < ts.size => ts(i.toInt)
        case other => refuse(s"$t, of sort $other, has no component $i")
      }
      case SList(List(SList(List(Atom("_"), Atom("int2bv"), Atom(n))), _)) => bitVector(n.toInt)
      case SList(List(SList(List(Atom("_"), Atom("zero_extend" | "sign_extend"), Atom(k))), t)) => bitVectorOf(sortOf(t, env)) match {
        case Some((n, u)) => withSign(n + k.toInt, u)
        case None => refuse(s"$t is not a bit vector")
      }
      case SList(List(SList(List(Atom("_"), Atom("extract"), Atom(i), Atom(j))), t)) => bitVectorOf(sortOf(t, env)) match {
        case Some((_, u)) => withSign(i.toInt - j.toInt + 1, u)
        case None => refuse(s"$t is not a bit vector")
      }

      case SList(List(Atom("let"), SList(bs), body)) =>
        sortOf(body, env ++ bindings(bs, env).map { case (x, v) => x -> sortOf(v, env) })
      case SList(List(Atom("assume"), _, body)) => sortOf(body, env)
      case SList(List(Atom("ite"), _, thenn, _)) => sortOf(thenn, env)
      case SList(Atom(op) :: _) if booleans(op) => Bool
      case SList(Atom(op) :: first :: _) if firsts(op) => sortOf(first, env)
      case SList(Atom("/") :: _) => Atom("Real")
      case SList(Atom("bv2nat") :: _) => IntSort
      case SList(List(Atom("select"), a, _)) => sortOf(a, env) match {
        case SList(List(Atom("Array"), _, v)) => v
        case other => refuse(s"$a, of sort $other, is not an array")
      }
      case SList(Atom("tuple") :: ts) => SList(Atom("Tuple") :: ts.map(sortOf(_, env)))
      case SList(Atom("@") :: f :: _) => sortOf(f, env) match {
        case SList(Atom("->") :: ss) if ss.nonEmpty => ss.last
        case other => refuse(s"$f, of sort $other, is not a function")
      }
      case SList((c: Atom) :: args) if constructors.contains(c) => constructorSort(c, args.map(sortOf(_, env)), None)
      case SList(List(s: Atom, t)) if selectors.contains(s) =>
        val (c, i) = selectors(s)
        val cons = constructor(c)
        val sort = sortOf(t, env)
        instantiate(cons.fields(i)._2, (cons.params zip datatypeArguments(sort)).toMap)
      case SList((f: Atom) :: args) if functions.contains(f) => functionSort(f, args.map(sortOf(_, env)), None)
      case other => refuse(s"the sort of $other is unknown")
    }

    private def isVariable(a: Atom, env: Map[Atom, SExpr]): Boolean = env.contains(a) || source(a, "variable").nonEmpty

    /** Whether `e` has no variable, for a set's first element. */
    private def ground(e: SExpr, env: Map[Atom, SExpr]): Boolean = e match {
      case a: Atom => !isVariable(a, env)
      case SList(items) => items.forall(ground(_, env))
    }

    private def constructorSymbol(c: Atom, sort: SExpr): Atom = {
      val id = source(c, "constructor").getOrElse(refuse(s"$c is not a constructor of the sources")).descriptions.head
      unique(s"constructor $id of sort $sort", e => e.kind == "constructor" && e.descriptions.size == 2 &&
        e.descriptions.head == id && e.sort.contains(sort))
    }

    private def functionSymbol(f: Atom, args: List[SExpr], qualifier: Option[SExpr]): Atom =
      if (source(f, "uninterpreted").nonEmpty) {
        if (functions(f).params.nonEmpty) refuse(s"the uninterpreted function $f has type parameters")
        val id = source(f, "uninterpreted").get.descriptions
        unique(s"uninterpreted function ${id.mkString(" ")}", e => e.kind == "uninterpreted" && e.descriptions == id)
      } else {
        val id = source(f, "function").getOrElse(refuse(s"$f is not a function of the sources")).descriptions.head
        val tps = SList(typeArguments(f, args, qualifier.map(erase)))
        unique(s"instance of $id at $tps", e => e.kind == "function" && e.descriptions.headOption.contains(id) && e.sort.contains(tps))
      }

    /** The instantiated body `body` of a definition whose type parameters are `typeArgs`, where
      * each uninterpreted function that has them in its type arguments is the function of the
      * instantiated type arguments: each instantiation of an uninterpreted function is a symbol
      * of its own, whose entry ends with its type arguments. */
    private def instance(body: SExpr, typeArgs: Map[Atom, SExpr]): SExpr = {
      def target(u: Atom): Option[Atom] = for {
        e <- source(u, "uninterpreted")
        tps <- e.sort
        at = erase(instantiate(tps, typeArgs)) if at != erase(tps)
      } yield sources.values.filter(o => o.kind == "uninterpreted" && o.descriptions == e.descriptions && o.sort.map(erase).contains(at)).toList match {
        case List(o) => o.name
        case Nil => refuse(s"the sources have no instance of the uninterpreted function $u at $at")
        case os => refuse(s"the sources have several instances of the uninterpreted function $u at $at")
      }
      def generic(u: Atom) = functions.get(u).exists(_.params.nonEmpty)
      def rec(t: SExpr): SExpr = t match {
        case SList(List(Atom("as"), u: Atom, s)) if target(u).nonEmpty =>
          val v = target(u).get
          if (generic(v)) SList(List(Atom("as"), v, s)) else v
        case u: Atom => target(u).getOrElse(u)
        case SList(items) => SList(items.map(rec))
      }
      rec(body)
    }

    private def applied(head: SExpr, args: List[SExpr]): SExpr = if (args.isEmpty) head else SList(head :: args)

    /** The lowering of the term `e`, where `env` gives the sorts of the bound variables. */
    def lower(e: SExpr, env: Map[Atom, SExpr] = Map.empty): SExpr = {
      def rec(t: SExpr) = lower(t, env)
      e match {
        case Atom(t) if isLiteral(t) => e
        case a: Atom if env.contains(a) => a
        case a: Atom if source(a, "variable").nonEmpty =>
          for (s <- sessionNames.get(a) if s.kind != "variable" || s.descriptions != source(a, "variable").get.descriptions)
            refuse(s"the variable $a of the sources is ${s.kind} ${s.descriptions.mkString(" ")} in the session")
          a
        case a: Atom if constructors.contains(a) => constructorSymbol(a, sortOf(a, env))
        case a: Atom if isFunction(a) => functionSymbol(a, Nil, None)
        case a: Atom => refuse(s"$a is no symbol of the sources")

        case SList(List(Atom("!"), t, Atom(":unsigned" | ":signed" | ":char"))) => rec(t)

        case SList(List(Atom("as"), Atom("emptyset"), s)) => app("as", Atom("set.empty"), app("Set", lowerSort(s)))
        case SList(List(Atom("as"), m: Atom, _)) if isMarker(m) => e
        case SList(List(Atom("as"), c: Atom, s)) if constructors.contains(c) => constructorSymbol(c, erase(s))
        case SList(List(Atom("as"), f: Atom, s)) if isFunction(f) => functionSymbol(f, Nil, Some(s))
        case SList((q @ SList(List(Atom("as"), m: Atom, _))) :: args) if isMarker(m) => SList(q :: args.map(rec))
        case SList(List(SList(List(Atom("as"), Atom("const"), s)), d)) => SList(List(app("as", Atom("const"), lowerSort(s)), rec(d)))
        case SList(SList(List(Atom("as"), c: Atom, s)) :: args) if constructors.contains(c) =>
          SList(constructorSymbol(c, erase(s)) :: args.map(rec))
        case SList(SList(List(Atom("as"), f: Atom, s)) :: args) if isFunction(f) =>
          SList(functionSymbol(f, args.map(sortOf(_, env)), Some(s)) :: args.map(rec))

        case SList(List(SList(List(Atom("_"), Atom("is"), c: Atom)), t)) =>
          val id = source(c, "constructor").getOrElse(refuse(s"$c is not a constructor of the sources")).descriptions.head
          val sort = sortOf(t, env)
          SList(List(unique(s"tester of $id of sort $sort", s => s.kind == "tester" && s.descriptions.size == 2 &&
            s.descriptions.head == id && s.sort.contains(sort)), rec(t)))
        case SList(List(SList(List(Atom("_"), Atom("tuple.select"), Atom(i))), t)) =>
          val sort = sortOf(t, env)
          SList(List(unique(s"selector $i of sort $sort", s => s.kind == "selector" && s.descriptions.size == 2 &&
            s.descriptions(1) == "\"" + i + "\"" && s.sort.contains(sort)), rec(t)))
        case SList(List(head @ SList(Atom("_") :: Atom("int2bv" | "zero_extend" | "sign_extend" | "extract") :: _), t)) =>
          SList(List(head, rec(t)))

        case SList(List(Atom("let"), SList(bs), body)) =>
          val bound = bindings(bs, env)
          SList(List(Atom("let"), SList(bound.map { case (x, v) => SList(List(x, rec(v))) }),
            lower(body, env ++ bound.map { case (x, v) => x -> sortOf(v, env) })))
        case SList(List(Atom(q @ ("forall" | "exists")), SList(bs), body)) =>
          val bound = bindings(bs, env)
          val lowered = SList(bound.map { case (x, s) => SList(List(x, lowerSort(s))) })
          val inner = env ++ bound.map { case (x, s) => x -> erase(s) }
          if (q == "forall") SList(List(Atom("forall"), lowered, lower(body, inner)))
          else app("not", SList(List(Atom("forall"), lowered, lower(body match {
            case SList(List(Atom("not"), b)) => b
            case b => app("not", b)
          }, inner))))

        case SList(List(Atom("insert"), SList(List(Atom("as"), Atom("emptyset"), s)), first, rest*)) =>
          if (ground(first, env)) {
            val singleton = app("set.singleton", rec(first))
            if (rest.isEmpty) singleton else SList(Atom("set.insert") :: rest.map(rec).toList ::: List(singleton))
          } else SList(Atom("set.insert") :: (first :: rest.toList).map(rec) ::: List(rec(SList(List(Atom("as"), Atom("emptyset"), s)))))
        case SList(List(Atom("insert"), s, t)) => app("set.insert", rec(t), rec(s))
        case SList(Atom(op) :: args) if setOperations.contains(op) => SList(Atom(setOperations(op)) :: args.map(rec))

        case SList(List(Atom("assume"), p, body)) => app("assume", rec(p), rec(body))
        case SList(Atom(op) :: args) if same(op) => SList(Atom(op) :: args.map(rec))

        case SList(Atom("tuple") :: ts) =>
          val sort = sortOf(e, env)
          SList(unique(s"tuple constructor of sort $sort", s => s.kind == "constructor" && s.descriptions.size == 1 &&
            s.sort.contains(sort)) :: ts.map(rec))
        case SList(Atom("@") :: (f: Atom) :: args) if predicates(f) && isVariable(f, env) => SList(f :: args.map(rec))
        case SList(Atom("@") :: f :: args) =>
          val sort = sortOf(f, env)
          SList(unique(s"application of sort $sort", s => s.kind == "application" && s.sort.contains(sort)) :: (f :: args).map(rec))

        case SList((c: Atom) :: args) if constructors.contains(c) => applied(constructorSymbol(c, sortOf(e, env)), args.map(rec))
        case SList(List(s: Atom, t)) if selectors.contains(s) =>
          val (c, i) = selectors(s)
          val id = source(c, "constructor").getOrElse(refuse(s"$c is not a constructor of the sources")).descriptions.head
          val sort = sortOf(t, env)
          SList(List(unique(s"selector $i of $id of sort $sort", x => x.kind == "selector" && x.descriptions.size == 3 &&
            x.descriptions.head == id && x.descriptions(2) == "\"" + i + "\"" && x.sort.contains(sort)), rec(t)))
        case SList((f: Atom) :: args) if isFunction(f) => applied(functionSymbol(f, args.map(sortOf(_, env)), None), args.map(rec))

        case other => refuse(s"$other can't be lowered")
      }
    }

    /** The lowering of the source `s`, and of its `where`: a symbol of the template that the left
      * of a pair names is kept. */
    def lower(s: Sources.Source): Sources.Source = {
      def pairs = s.where.map {
        case (l: Atom, r) => l -> lower(r)
        case (l, r) => lower(l) -> lower(r)
      }
      s match {
        case Sources.Function(call, body, _) => Sources.Function(lower(call), lower(body), pairs)
        case Sources.Expression(expr, _) => Sources.Expression(lower(expr), pairs)
        case Sources.Definition(call, names, _) => Sources.Function(lower(call), lower(defined(call, names)), pairs)
      }
    }

    /** The source of the template of the call `call` of a defined function: the body of the
      * function's definition at the sorts of its type arguments, which the sorts of the
      * arguments of the call give, and at these arguments, where each outermost subterm that
      * is the right of a pair of `names` is the left of the pair. Sorts are compared without
      * their refinements. It refuses a name that names no subterm of the body. */
    // (see `instance` for the uninterpreted functions of the body)
    private def defined(call: SExpr, names: List[(SExpr, SExpr)]): SExpr = {
      val (f, args, qualifier) = call match {
        case SList(List(Atom("as"), f: Atom, sort)) => (f, Nil, Some(sort))
        case SList(SList(List(Atom("as"), f: Atom, sort)) :: args) => (f, args, Some(sort))
        case SList((f: Atom) :: args) => (f, args, None)
        case f: Atom => (f, Nil, None)
        case other => refuse(s"$other is not the call of a function")
      }
      val definition = definitions.getOrElse(f, refuse(s"the function $f has no definition"))
      if (definition.arguments.size != args.size) refuse(s"$call has ${args.size} arguments, not ${definition.arguments.size}")
      val sorts = typeArguments(f, args.map(sortOf(_)), qualifier)
      val typeArgs = (definition.params zip sorts).toMap
      val body = instance(erase(instantiate(definition.body, typeArgs ++ (definition.arguments.map(_._1) zip args))), typeArgs)
      val named = names.map { case (name, original) => erase(original) -> name }
      if (named.map(_._1).distinct.size != named.size) refuse(s"the names of $call name a subterm twice")
      val table = named.toMap
      var used = Set.empty[SExpr]
      def rec(t: SExpr): SExpr = table.get(t) match {
        case Some(name) => used += t; name
        case None => t match {
          case SList(items) => SList(items.map(rec))
          case atom => atom
        }
      }
      val source = rec(body)
      for ((original, _) <- named if !used(original)) refuse(s"the body of $f has no subterm $original")
      source
    }
  }
}
