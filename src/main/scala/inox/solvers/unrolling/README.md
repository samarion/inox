# The unrolling procedure

This package implements the decision procedure formalized in Nicolas Voirol's
thesis, *Verified Functional Programming* (EPFL, thesis no. 9479, 2019).
Throughout this file, "the thesis" means that document. Chapter 1 covers
recursive functions and datatypes, Chapter 2 first-class functions, Chapter 3
dependent types, Chapter 4 quantifiers, and §6.1 the solver loop.

The procedure reduces a query over the Inox language (recursive functions,
lambdas, datatypes, dependent types and quantifiers) to a sequence of
quantifier-free SMT queries. Each query is checked by an underlying theory
solver (`../z3`, `../smtlib`, `../princess`). It is complete for
counterexamples and sound for both answers, under the assumptions listed
below.

## The formalization

### Blockers and unfolding (thesis Chapter 1)

Every expression is translated into a set of clauses over boolean *blockers*.
A blocker `b` guards the clauses that encode the body of one branch. Each
function call `f(args)` reached under blocker `b` is recorded, and its body is
not encoded yet. Unfolding the call means instantiating `f`'s template with
`args`, guarded by `b`.

At step *i*, the current clause set `Φi` over-approximates the query, because
every call that has not been unfolded is uninterpreted. Adding `block(Fi)`
(the negation of each blocker guarding a call that has not been unfolded) gives
an under-approximation, because it only keeps paths whose calls are all
encoded. The loop in `UnrollingSolver.scala` alternates between the two:

- `ModelCheck` checks `Φi` together with `satisfactionAssumptions` (the blocking
  literals). A model is a candidate counterexample and goes to `Validate`.
- `ProofCheck` checks `Φi` together with `refutationAssumptions`, which are
  empty. UNSAT here proves the query unsatisfiable.
- `Unroll` unfolds the pending calls of the oldest generation, so every call is
  eventually unfolded. This is the fairness condition that completeness relies
  on.

| Concept | Code |
|---|---|
| Expression to clause translation | `TemplateGenerator.mkExprClauses` |
| Function templates and call unfolding | `FunctionTemplates.scala` |
| Clause and blocker infrastructure | `Templates.scala` |
| Structural equality on datatypes | `EqualityTemplates.scala` |
| `choose` encoding | `ChooseEncoder.scala` |
| The check/unroll loop and model extraction | `UnrollingSolver.scala` |

### First-class functions (thesis Chapter 2)

Lambdas are closures. `normalizeStructure` (in `ast/SymbolOps.scala`) turns a
lambda into a structure plus a list of closed dependencies. Two lambdas with
the same structure are equal iff their dependencies are equal. Lambdas with
different structures are distinct, and this matches the evaluator's notion of
equality (`evaluators/RecursiveEvaluator.scala`).

Each application `f(x)` is dispatched to every known lambda template of the
right type and to every free function. The dispatch is guarded by
"`f` equals this lambda" (`LambdaTemplates.instantiateApp`), so the encoding
stays first-order. The thesis's incremental uninterpreted sort for lambdas
(§2.6.1) appears as the `order`/`lessThan` clauses in
`TypeTemplates.CaptureTemplate`. These clauses ensure that a closure cannot
capture itself. Lambda tracking (§2.6.2) is `LambdaTemplates.registerLambda`.

### Dependent types (thesis Chapter 3)

Types are encoded by the reducibility predicate `⟦τ⟧`, unfolded lazily like a
function call (`TemplateGenerator.mkTypeClauses`, `TypeTemplates.scala`):

- A refinement `{x: τ | p}` holds when `x ∈ ⟦τ⟧` and `p(x)` holds.
- A dependent pair `Σx: τ1. τ2` holds when its first component is in `⟦τ1⟧` and
  its second is in `⟦τ2[x/_1]⟧`.
- A dependent function `Πx: τ1. τ2` holds when every application to an argument
  in `⟦τ1⟧` returns a value in `⟦τ2⟧`.
- Datatypes unfold constructor by constructor. Inductive types are unfolded
  lazily and are blocked in `ModelCheck` like calls, which is the thesis's
  `block(Ri)`.

There are three ways to use a type, matching the thesis's three uses of
`⟦τ⟧`. `FreeGenerator` constrains a free variable to the type.
`ContractGenerator` assumes a value inhabits the type, for example a function's
return type. `CaptureGenerator` handles the type of a value captured in a
closure.

### Quantifiers (thesis Chapter 4)

`∀x: τ. p` is a `Boolean` expression; Inox has no separate `Prop` sort.

- **Positive polarity** (assumed true). The quantifier is instantiated on the
  ground terms that match its triggers, so each instance is `τ(t) ⇒ p[x/t]`.
- **Negative polarity** (assumed false). The quantifier gets a fresh skolem
  constant `c` and the clause `τ(c) ∧ ¬p[x/c]`.
- **Unknown polarity**, for example under an equality. Both templates are
  registered.

Both templates are in `QuantificationTemplates.scala`. A quantifier that is
assumed true only gives a counterexample when the model satisfies it
everywhere. `getFiniteRangeClauses` (the `FiniteRangeCheck` state) and
`checkForall` together decide that, for the essentially uninterpreted fragment
of the thesis (`model_i`). A model outside that fragment is reported as
`Unknown`.

## Guarantees

The semantics is the one implemented by `evaluators/RecursiveEvaluator`.

- **Proofs are sound.** If the procedure answers UNSAT, no assignment of the
  free variables makes the query evaluate to `true`.
- **Counterexamples are sound.** A model returned with SAT makes the query
  evaluate to `true`. Set `optCheckModels` to have each model re-checked with
  the evaluator before it is returned. It is off by default.
- **Counterexamples are complete.** If a satisfying assignment exists and its
  evaluation terminates, the procedure eventually finds a model, provided
  `optUnrollBound` is unbounded (the default) and the query stays in the
  fragment the thesis covers. Quantifiers must be in the essentially
  uninterpreted fragment, models of first-class functions must be
  extractable, and type parameters must be inhabited.

The procedure is a semi-decision procedure for satisfiability, so it may run
forever on unsatisfiable queries, and the soundness of proofs is relative to
terminating function definitions. Inox checks neither termination nor
positivity of datatypes; Stainless does both before it calls Inox.

## Departures from the thesis

Inox differs from the formalization in the ways below. These are relevant
when reading the proofs against the code.

### By design

- **Closure normalization.** `normalizeStructure` lifts every closed, pure
  subterm of a lambda as a dependency, where the thesis lifts only
  pseudo-values. The solver and the evaluator use the same normalization, so
  equality between lambdas is consistent across them. One consequence is that
  a nullary closure with a closed, pure body equals `() => result`, so models
  give a nullary function the closure `() => choose(...)`, with the `choose`
  mapped to its result, whenever inlining the result would make it equal to a
  distinct function (`nullaryClosure` in `ast/SymbolOps.scala`).
- **Model extraction.** First-class functions are rebuilt as `if`-chains over
  the applications seen in the SMT model, with a default branch. Cyclic
  functions are rebuilt with `choose`. The thesis instead builds named
  recursive functions.
- **Call merging.** `mkExprClauses` merges identical calls on different
  branches, so there are fewer templates than the thesis creates.
- **Features outside the formalization.** These include ADT invariants, custom
  equality on datatypes, `choose`, `assume`, the theories of bitvectors,
  strings, sets, bags and maps, and options such as `optFeelingLucky`,
  `optModelFinding` and `optUnrollAssumptions`. In the SMT theories, partial
  operations such as division by zero are left unconstrained. The thesis has
  no Nat-sized or intersection types.
- **Existential instances.** Inox's clause `bp ⇒ (τ(c) ∧ ¬p)` is correct. The
  printed thesis drops the negation.

### Where the implementation follows the thesis more strictly than it states

- **Refinement and Σ predicates are guarded by their base type.** The
  predicate `p` of `{x: τ | p}` is only asserted once `x ∈ ⟦τ⟧` holds, so an
  `assume` or precondition in `p` can't falsify the enclosing path. This is
  the guard missing from the proof of the thesis's Lemma 9.
- **Π codomains are assumed only inside the domain.** An application
  `f(a)` with `f: Πx: τ1. τ2` gives `f(a) ∈ ⟦τ2⟧` only when `a ∈ ⟦τ1⟧`. Membership
  in a function type that must be shown, rather than assumed, is checked at
  fresh arguments (`Membership` typings in `TypeTemplates.scala`).
- **Return types are assumed only for well-typed arguments.** At a call
  `f(args)`, the refined return type of `f` is assumed once `args` are shown
  to satisfy the refinements written in `f`'s parameter types. The thesis
  takes this from typing derivations (§3.6). Refinements that come from sort
  definitions or from instantiated type parameters are not checked, since
  Inox does not check them where values are constructed either. A front-end
  that checks call arguments itself can erase the refinements of its
  parameter types, so that the return type is assumed at every call.
  Stainless does this.
- **Type parameters may be empty.** The satisfaction check assumes that type
  parameters are inhabited, so models can be extracted, but an UNSAT answer is
  only returned once that assumption is dropped. When a model exists only with
  an empty type parameter, the answer is `Unknown`.

On the thesis side, the completeness argument of Chapter 2 relies on input
lambdas being re-encoded the same way at each step, and the claim in §3.7 that
counterexamples are sound in a fragment is stated without proof.
