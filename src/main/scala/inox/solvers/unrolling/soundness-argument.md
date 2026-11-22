# Why the unrolling's proofs are sound

This file is an informal argument that the procedure's proofs are sound. It
states what that soundness rests on: one
lemma for each rule of the kernel (`RuleKernel.scala`) and one for each open
conjunction or disjunction (`OpenJunctions.scala`). Each lemma is stated
against the intended interpretation below, and comes with the argument that
the code's comments give, the assumptions it makes and the part of the
thesis it corresponds to. It is the input to proofs of the rules, in Stainless
or elsewhere. The code is the reference: where this file and a comment of
`RuleKernel.scala` disagree, one of them has a bug.

"The thesis" is Nicolas Voirol, *Verified Functional Programming* (EPFL, thesis
no. 9479, 2019), as in [`README.md`](README.md). The semantics is that of
`evaluators/RecursiveEvaluator`.

## The theorem

A *solution* is an assignment σ of the query's free variables under which the
query evaluates to `true`, without failing (see
[`partial-execution.md`](partial-execution.md)).

Let Φᵢ be the clauses that the solver has asserted at a check *i* whose
unsatisfiable answer the solver returns as a proof (`ProofCheck`, or a
`ModelCheck` with nothing left to unroll and nothing blocked), and Aᵢ the
literals that the check assumes: the assumptions of the query and the
completeness assumptions that refutations may make.

**Theorem (sound proofs).** For every solution σ and every refutation check
*i*, there is an interpretation Iᵢ of the symbols of Φᵢ that extends σ and
satisfies Φᵢ ∪ Aᵢ. So if Φᵢ ∪ Aᵢ is unsatisfiable, the query has no solution.

The proof builds Iᵢ as the intended interpretation of σ at check *i* and
shows that it satisfies each clause (S1 of the plan) and each assumption (S2):

- every clause in Φᵢ comes from a rule application (checked at run time by
  `RuleChecker`, see [What is checked](#what-is-checked-and-what-is-argued));
- each lemma below shows that Iᵢ satisfies the clauses of one rule;
- the lemmas about open junctions show that Iᵢ satisfies the completeness
  assumptions in Aᵢ, and the query's assumptions hold under σ by definition of
  a solution.

The theorem says nothing about counterexamples (S3) or about fairness (F),
which are about model extraction and the scheduler.

## The intended interpretation

Iᵢ extends σ to the symbols that the unrolling introduces:

| Symbol | Iᵢ |
|---|---|
| A blocker of a path, including the root blocker `start` | true iff the evaluation of the query under σ reaches the path |
| The target of `Enables` (the definition blocker of a call, the blocker of an equality, the type blocker of an application result) | the disjunction of the conditions that enable it in Φᵢ |
| A call term `f(args)` | the value of the call, when it returns |
| An application term `k(args)` | the value of the application, when the function returns |
| A lambda's identifier | its value: its normalized body and closures (thesis Chapter 2) |
| The equality symbol of a type | the type's equality: its custom equality, or the structural one built from its fields |
| A typing result | whether the value lies in the type, restricted as the typing's rule states |
| A failure literal | whether the call, application or template fails |
| A literal of `Define` | the value it is defined as, under Iᵢ |
| A literal of `Hypothesis` | false |
| The `rest` of an open junction at check *i* | as each junction states (see [Open junctions](#open-junctions)) |
| A witness argument | an input on which the two functions differ, when they are distinct |
| A skolem of a quantification that doesn't hold | a counterexample to it; any value otherwise |
| The rank of a call | the depth of its evaluation |
| The order of a function value | its size |

A call or an application that the evaluation under σ reaches returns without
failing, as a solution evaluates the query without failing or diverging. One
that it doesn't reach has no value under σ: Iᵢ gives its term any value of
its type that the lemmas need, as the clauses that constrain it are guarded by
its blocker, which Iᵢ makes false.

`Define` literals are well defined because each literal is defined once
(checked by `RuleChecker`) and its value only mentions symbols introduced
before it, and the fresh `rest` of the next link of a junction, which is
defined later or assumed. The definitions are therefore acyclic.

## The rules

Each lemma reads: *for every solution σ, Iᵢ satisfies the clauses of every
application of the rule in Φᵢ*.

### Fresh symbols

**Define** (`guard ==> literal == value`). Holds by the definition of Iᵢ on
`literal`. *Obligation*: `literal` is fresh, and defined by one rule
application only. What `literal` stands for only matters for the assumptions
that mention it, which the open junctions' lemmas cover.
*Applied in*: typings of applications and free functions, `isFree`, the links
of open junctions, the guards of congruences and witnesses, conjunctions of
blockers (`BlockerGraph.encodeBlockers`), failures (`PartialFunctions`).

**Enables** (`blocker ==> target`). Holds by the definition of Iᵢ on `target`.
The instantiation under `target` must hold wherever one of the enabling
conditions does: that is the obligation of the rule that instantiates it
(`Unfold`), which holds for any blocker that implies the path it was created
for. *Thesis*: Chapter 1 (calls merged across branches are a departure, see
the README).

**Hypothesis** (`literal && condition ==> fact`). Holds since Iᵢ makes
`literal` false. *Obligation*: no refutation check assumes `literal` (checked by
`RuleChecker.checkRefutation`). *Applied in*: `WitnessTemplates`, for the
equality of two functions whose distinguishing input isn't instantiated yet.
*Not in the thesis* (see [`function-witnesses.md`](function-witnesses.md)).

### Unfolding

**Unfold** (the instantiation of a template on arguments, under a blocker).
The lemma splits in two:

1. *Generator*: the clauses that `TemplateGenerator` gives for an expression
   hold under the intended interpretation of any assignment of its free
   variables, whenever its blocker holds.
2. *Substitution*: substituting the arguments of the call (or the values of
   an application, a typing or an equality) for the template's parameters
   preserves them. For a call, Iᵢ on the call term is the value of the call,
   which is the value of the body on the arguments. For a ground call whose
   value the evaluator computed, that value is the call's value under every
   solution.

When `failure` is given, the body's failure literals are tied to the call's
failure literal instead of being ruled out. *Thesis*: Chapter 1 (calls),
Chapter 3 (typings, the reducibility predicate ⟦τ⟧). *Applied in*:
`FunctionTemplates`, `EqualityTemplates`, `TypeTemplates`, `LambdaTemplates`.

**Instance** (the clauses of an instantiation).

- `Expression`: as for `Unfold`, the generator gives clauses that hold for
  the expression whenever its blocker holds. These are the query and the
  typings of the free variables under the root blocker, the definitions of a
  witness under the condition that it needs one, and the closures of a lambda
  or quantification under the blocker where it is created. The applications
  that `exempt` picks are those that may fail.
- `OfAxiom`: the body of a quantification that holds where its path does,
  on terms its matchers matched, under an enabler that implies that path. A
  quantification that holds has all its instances. *Thesis*: Chapter 4,
  positive polarity.
- `Counterexample`: the body of a quantification that doesn't hold where its
  path does, on fresh symbols. Iᵢ makes them a counterexample when the
  quantification doesn't hold, and any value otherwise. *Thesis*: Chapter 4,
  negative polarity.

**Root** (`start`). Evaluation reaches the root of the query, and the values
of the free variables lie in their types. *Obligation*: `start` is introduced
once.

**Typed** (`blocker ==> typing == true`). The values of the free variables
lie in their types, and so do the values that they hold. Its typing may be
unfolded later (`TypeTemplates.deferredTypings`). *Thesis*: Chapter 3; empty
type parameters are a departure (README).

**Holds** (`blocker ==> quantification`). A solution makes the query hold,
so it makes a quantification hold where evaluation reaches it, when it occurs
where it must hold. *Thesis*: Chapter 4.

**Unreachable** (`!literal`, or `under ==> !literal`). No solution reaches
`literal`: it is the blocker of a call whose ground arguments fail to
evaluate, or a failure of a template that isn't a function or lambda body
(such as the query), or of a call or application on its paths. A solution
evaluates the query without failing. *See*
[`partial-execution.md`](partial-execution.md).

**Decreases** (`blocker ==> decrease || unless`). Two cases:

- the rank of a call is higher than that of a call its body reaches. Iᵢ ranks
  each call that returns by the depth of its evaluation, and `unless`
  (`diverges`) holds of a call that doesn't return. Without `unless`, the
  front-end has checked that every call returns (`optAssumeChecked`).
  *See* [`partial-execution.md`](partial-execution.md).
- a function that a lambda captures comes before the lambda. A lambda value
  contains the values it captures, so Iᵢ orders function values by size. This
  needs intensional equality, where `() => f()` isn't equal to `f`, and
  `LambdaTemplates` only orders captures under it.
  *Thesis*: §2.6.1, the incremental uninterpreted sort of lambdas.

### Functions and equality

**Congruence** (`premise1 && ... && premiseN ==> resultEq`). A call or an
application is a function of its callee and arguments, and a quantification
of its body and closures. *Assumption*: functions respect custom equalities.
*Thesis*: functional consistency, Chapters 1 and 2.

**Witness** (`start ==> distinguished`). Under extensional or unobservable
function equality, Iᵢ interprets functions extensionally, so two distinct
functions differ on some input, which Iᵢ gives the witness arguments. When the
functions may fail, they differ when one fails and the other doesn't, or when
neither fails and their results differ. *Not in the thesis* (see
[`function-witnesses.md`](function-witnesses.md)).

**Reflexivity**, **Symmetry**, **Transitivity**. Iᵢ interprets the equality
symbol of a type as its equality. *Assumption*: custom equalities are
equivalence relations. Nothing checks it. *Not in the thesis* (custom
equality).

### First-class functions

**Dispatched** (`!dispatch.rest ==> !blocker`). The caller of an application
that evaluation reaches is a function value: a lambda that evaluation creates,
or a free function. The head of the dispatch disjunction is the disjunction
of the conditions under which it is each of these, which Iᵢ makes true
whenever the application is reached (see `b_lambda` below). *Thesis*: §2.6.2,
lambda tracking.

**DispatchFailure** (`enabler ==> appFailure == bodyFailure`). An
application dispatched to a lambda evaluates its body on the arguments, so it
fails iff the body does.

**SameLambda** (`start ==> lambda == representative`). Lambdas with the same
type, normalized body and closures are the same value, which Iᵢ gives the
representative.

**LambdaEquality**. The value of a lambda is its normalized body and
closures. Under intensional equality, two lambdas are equal iff these are, so
lambdas with different bodies are distinct. Otherwise, lambdas with the same
body and equal closures are equal, and lambdas that differ may still be
equal. *Thesis*: Chapter 2.

## Open junctions

An open conjunction `op1 ∧ ... ∧ opN ∧ rest` or disjunction
`op1 ∨ ... ∨ opN ∨ rest` grows as the unrolling finds operands. Each
extension defines the current `rest` with `Define`, as the new operands and a
fresh `rest`. Assuming one complete assumes its last `rest` true (for a
conjunction) or false (for a disjunction). Each junction declares when that is
assumed (`AssumedComplete`):

- `ForModels`: only in model checks. Iᵢ interprets the last `rest` as the
  operands still to come, and nothing more needs to be shown for proofs.
- `Always`: in refutation checks too. Then Iᵢ must interpret the last `rest`
  as the neutral element, so the head means the operands found so far, and
  every clause that mentions the head must hold under that meaning.

| Junction | Kind | Assumed complete | Why it is sound |
|---|---|---|---|
| `b_lambda`, the dispatch of an application (`LambdaTemplates.instantiateApp`) | `OpenOr` | `ForModels` | Iᵢ makes the head "the caller is some function value", true whenever the application is reached, so `Dispatched` holds. Assuming it complete in a refutation would rule out lambdas still to come. |
| `b_next`, the lambdas that a free function equals (`LambdaTemplates.registerFunction`) | `OpenOr` | `Always` | Iᵢ interprets `isFree` as "`f` equals none of the lambdas found so far". The clauses about `isFree` only dispatch `f`'s applications to `f` itself, which leaves them uninterpreted, and that holds whatever `f` is. |
| `b_and`, the typings of a free function's application results (`LambdaTemplates.registerFunction`) | `OpenAnd` | `Always` | The typing result means "the results of the applications found so far lie in the codomain". The solution's functions lie in their types, so each conjunct holds whenever the full typing does. This keeps quantifying over an empty function type from leading to invalid proofs. |
| `r_and`, the typings of the reads of a collection (`TypeTemplates.registerCollection`) | `OpenAnd` | `Always` | The same, for the keys and elements that the query reads. |

*Obligation*: the clauses that mention the head of an `Always` junction hold
under its partial meaning. For `b_and` and `r_and`, the typing results come
from `Constraint` and `Collection` typings, which the generator assumes, so a
weaker meaning keeps them true. The typings that must be exact, such as
membership in the domain of a Π type, are `Membership` typings, which check
functions at fresh arguments instead (`TypeTemplates.Membership`). The domain
of a quantifier is a premise of its instances, where a weaker meaning would
instantiate the body on more terms, but a function-typed domain typing never
reaches `b_and`: it is checked at fresh grounds instead
(`TemplateGenerator.mkTypeClauses` keeps `inDomain` for function types only
when `ground` holds, and `TypeTemplates` doesn't send ground typings to
`registerFunction`). Reads typings (`r_and`) are made for contracts only
outside quantifier domains, but for free values in domains too
(`TemplateGenerator.storeReads`). These are the skolems of quantifiers under
negative polarity and the fresh grounds of quantifiers
(`QuantificationTemplates`, where an instance on a fresh ground has the
ground's typing as a premise). Both are fresh symbols, so Iᵢ picks their
values: a value of the type when the type is inhabited, where reads typings
hold. Set and bag types hold the empty collection, and a map type is empty
only when its value type is. The typing of a map conjoins the typing of its
default (`TemplateGenerator.mkTypeClauses`), which then gives false for every
value, whatever the reads typing means.

## Down to SMT terms

The theorem is about the clauses as Inox expressions. Two more steps lie
between a query and the terms that the SMT solver refutes:

1. **The theory encoders** (`solvers/theories`) rewrite the program before
   the unrolling, for the backends that lack a theory: strings as lists of
   bit-vector characters (`StringEncoder`), bags and sets as datatype terms
   whose multiplicities or memberships a recursive function computes
   (`BagEncoder`, `SetEncoder`), map merges as a map refined by its
   definition (`MapMergeEncoder`) and reals as fractions of integers
   (`RealEncoder`). Z3 needs
   none of them, cvc4 and cvc5 the bag and merge encoders, and Princess all of
   them (`theories.Z3`, `CVC`, `Princess`).
2. **The translation** turns the clauses into backend terms: `SMTLIBTarget`
   and its subclasses for the SMT-LIB solvers (`Z3Target`, `CVCTarget`,
   `BitwuzlaTarget`, `EldaricaTarget`), `Z3Native` for the native Z3 API and
   `AbstractPrincessSolver` for Princess.

With σ a solution of the query, the chain is: the encoded σ is a solution of
the encoded query (E1), the theorem gives Iᵢ for the encoded query, and the
translation of Iᵢ satisfies the translated clauses (E2). The SMT solver's
answer is then only trusted for SMT-LIB's semantics (assumption 4).

**E1 (theory encoders).** Each encoder maps values to values (a `Bijection`
for strings, and the encoding of the theory's values as datatypes or maps),
and evaluation commutes with it: evaluating the encoded expression under the
encoded assignment gives the encoding of the result, and fails iff the source
evaluation fails. Each encoder needs an invariant on the values in its range:

- `StringEncoder`: characters are at most `maxChar`, which the sort's
  invariant states when they need 18 bits;
- `BagEncoder` and `SetEncoder`: a bag or a set is any term whose `get` or
  `contains` gives its multiplicities or members, so their sorts have a custom
  equality (assumption 2), and the elements of a bag have non-negative
  multiplicities (the sort's invariant), as non-positive ones mean absent in
  the evaluator;
- `MapMergeEncoder`: a merge is an uninterpreted map refined by its
  definition, a refinement that the merged map satisfies;
- `RealEncoder`: denominators are positive, and divisions are guarded unless
  the front-end checked them (`optAssumeChecked`), as in the template
  generator. Otherwise a division by zero gives a value that only depends on
  the representation of the dividend, which only adds models.

The invariants of the encoders' sorts are checked where values are
constructed, like those of the program's sorts (see E2), so the encoders
only construct values that satisfy them.

**E2 (translation).** Values translate to SMT values: booleans, integers,
reals, bit-vectors and floating points to themselves, characters to 16-bit
vectors, strings to SMT-LIB strings, ADTs, tuples and `Unit` to datatypes,
type parameters to uninterpreted sorts, sets, bags and maps to arrays, and
functions to integers that the application symbols of their type interpret.
Each operation translates to an SMT term with the same value whenever the
evaluator defines it. The evaluator follows SMT-LIB where SMT-LIB is total
(bit-vector division and remainder by zero, euclidean integer division and
modulo, `str.substr` out of bounds), so the values agree on every input
except the ones where the evaluator fails.

Those failures are exactly the cases of `SymbolOps.definedness`: divisions,
remainders and modulos of integers and reals by zero, selectors on another
constructor, constructions that break the sort's invariant, and conversions
of non-finite floating points to reals. Where an operation fails, Iᵢ needs no
particular value for it: a reached failure contradicts σ being a solution,
unless it is the failure of a function body, which the failure literal of
`Rule.Define` states (`fail == !definedness`) whatever the operation's value.
So the SMT solver may give the operation any value. An operation that fails
in the evaluator but is missing from `definedness` breaks this, as a function
body that fails would be taken not to fail.

*Checked*: the semantics suites (`src/test/scala/inox/solvers/*SemanticsSuite`)
compare every operation on every backend with the evaluator, on literals and
on variables equal to them, so that the translation is exercised and not only
the simplifier. This tests E2 on points; a proof needs the SMT-LIB semantics
of each backend's theories.

## Assumptions

The theorem holds under these assumptions, which no code checks:

1. Under `optAssumeChecked`, the front-end has checked that every call
   terminates and that nothing fails, which `Decreases` without `unless` and
   the calls without domain checks rely on. Without it, nothing is assumed:
   a call that doesn't return satisfies `diverges`.
2. Custom equalities are equivalence relations, functions respect them, and
   they terminate on every pair of values that the query compares, so that
   Iᵢ can interpret the custom equality symbols by them.
3. The template generator is correct (part 1 of `Unfold`).
4. The SMT solvers are correct for SMT-LIB's semantics (and Princess and
   the native Z3 API for theirs): a term set they call unsatisfiable has no
   model.

## What is checked and what is argued

`RuleChecker` (on with `optCheckRules`, which the tests set) checks, as the
solver runs, the properties whose arguments span several places in the code:

- every clause that the solver asserts is built by a rule, and the clauses of
  `Unfold` and `Instance` are those the generator gave, once substituted;
- each `Define` and `Hypothesis` literal and each root blocker is introduced
  once;
- every refutation only assumes the query's assumptions and the completeness
  of `Always` junctions, and has no clauses that only restrict models (such
  as those of the finite range check).

The lemmas above are argued, not checked: a proof of each one against the
thesis's semantics, over a pure model of `Rule` and of Iᵢ, would make the
theorem hold for all inputs, with the generator, the encoder and the solver
as the trusted base.

## Open obligations

- `Unfold` part 1, the generator, is only argued expression by expression in
  `TemplateGenerator`.
- E1 is argued per encoder above, from the encoders' comments, and E2 per
  construct: neither is proven against a formal SMT-LIB semantics.
