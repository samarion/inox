# Partial execution: functions that fail or diverge

This note describes how the unrolling procedure treats evaluation that doesn't return a value,
either because it gets stuck on an error or because it never terminates. It complements the
guarantees in [`README.md`](README.md), whose semantics is the one of
`evaluators/RecursiveEvaluator`.

## 1. Semantics

A query is satisfiable when some assignment of its free variables makes it evaluate to `true`.
Evaluation can also end without a value, in two ways:

- **Stuck.** Evaluation reaches a `RuntimeError`: an `Error(tpe, msg)`, an `Assume` whose condition
  doesn't hold, an integer or real division, remainder or modulo by zero, or an ADT whose invariant
  fails when the value is built.
- **Divergent.** A chain of calls never returns. The evaluator reports this as running out of
  steps.

No Inox expression can observe the difference between the two: a query that reaches either one
doesn't evaluate to `true`. The procedure therefore treats both as the same undefined result, written
⊥ below.

Lambdas are values whatever their bodies do: `x => error[T]` and `x => loop(x)` are values, and only
applying them may give ⊥. Function types are read partially accordingly:

> `f` lies in `Pi(x: A). B` when, for every `a` in `A`, if `f(a)` evaluates to a value `b`,
> then `b` lies in `B[a]`.

Under this reading every function type is inhabited, as `x => error[B]` lies in `A => B` even when
`B` is empty. This is the reading that `SymbolOps.hasInstance` uses: it holds function and Pi types
to be inhabited. The total reading, where `f(a)` must also return, can't be checked by evaluation,
since it would need the evaluator to prove that `f` terminates.

## 2. How the encoding handles ⊥

The encoding only ever needs to know where evaluation is defined. A clause that mentions the result
of an expression is guarded by the blocker of the path that evaluates it, so it only constrains
assignments under which evaluation reaches that expression. On such a path, every result that the
query uses was returned, and the clauses hold for these results.

| Construct | Encoding | Why it's right under the partial reading |
|---|---|---|
| `Error`, failed `Assume` | The path that reaches it is infeasible (`TemplateGenerator.mkExprClauses`) | Evaluation along that path doesn't return |
| Call `f(a)` | Unfolded as `f(a) = body[a]`, guarded by the call's blocker | The equation holds whenever `f(a)` returns |
| Call `f(x)` inside the body of `f` on its own parameters | The path that reaches it is infeasible (`FunctionTemplate.apply`, §3) | Evaluation is deterministic, so it would reach the same call again |
| Application of a free function, `f(a) ∈ B` | Assumed at each application (`LambdaTemplates.registerApplication`) | The application is reached, so `f(a)` returned |
| Return type of a call | Assumed of the result, for arguments in the parameter types | Only constrains a result that was returned |
| Membership of a function value in `Pi(x: A). B` | Checked at a witness `x0` under a free guard `w`: `w ==> B(f(x0))` (`TemplateGenerator.mkTypeClauses`) | Where `f(x0)` is ⊥, the guard's path is infeasible, so `x0` can't refute membership |

The last row is where the partial reading shows. A function that fails or diverges at some point
still lies in the type, as long as it returns values of the type wherever it returns:

```scala
// h: (BigInt => {v: BigInt | v > 0}) => {b: Boolean | b}
!h((x: BigInt) => error[BigInt])                           // UNSAT: the lambda is in h's domain
!h((x: BigInt) => if (x > 0) x else loop(x))               // UNSAT: likewise
!h((x: BigInt) => if (x > 0) x else 0)                     // not UNSAT: 0 is outside the codomain
```

`PartialExecutionSuite` checks these cases.

## 3. Calls that reach themselves

`Template.extractCalls` drops the calls that equal the template's own call `f(x)`, so that the left
side of the definitional equation `f(x) = body` isn't registered as a call to unfold. Without further
care, this also drops a call `f(x)` that the body itself makes on the same parameters. For
`def loop(x: BigInt): BigInt = loop(x)`, the template is then `loop(x) = loop(x)` with no call left to
unfold. The call counts as fully unfolded, and its result is unconstrained. The solver can then
return a model that relies on, say, `loop(0) = -1`, which only `--check-models` rejects. It also
can't prove anything that relies on `loop` never returning.

`FunctionTemplate.apply` therefore makes the paths of the body that reach `f` on its own parameters
infeasible. This is sound under the semantics of §1: evaluation is deterministic, so evaluating
`f(x)` while evaluating `f(x)` never returns. It gives these loops their least fixpoint:

```scala
def loopPos(x: BigInt): BigInt = if (x > 0) loopPos(x) else x

loopPos(k) == 5   // UNSAT: loopPos only returns non-positive values
loopPos(k) == 0   // SAT, with k = 0
loop(k) == 0      // UNSAT
```

Only the body's own paths are considered: the calls in lambdas and quantifiers that the body
contains belong to their own templates, and the calls in type checks aren't evaluated by the
evaluator. One exception: the refinements of an uninterpreted call's result type are assumed on the
body's paths, though the evaluator never evaluates them, so a self-call in such a refinement would
also make its path infeasible.

## 4. Limits

**Loops through other functions keep a fixpoint semantics.** The rule of §3 only catches a function
that calls itself on its own parameters within its own body. A loop through other functions on the
same arguments, such as `f(x)` calling `g(x)`, which calls `f(x)`, closes the same way the self-call
used to: unfolding `g(x)` reaches the call `f(x)`, which is already unfolded, so no call is left
pending. The equations `f(x) = g(x)` and `g(x) = f(x)` are then satisfied by any value, and the solver
may return a model that relies on one, say `f(2) = 0`, which only `--check-models` rejects. Proofs stay
sound, since a successful evaluation satisfies every equation it reaches. Following the chain of
blockers from a call back to its own definition would catch these loops as well.

**Loops on changing arguments stay blocked.** A loop such as `def f(x: BigInt): BigInt = f(x + 1)`
reaches a new call at each unfolding, so some call is always pending. `ModelCheck` blocks the
pending calls, so no model relies on a value that `f` never returns. The solver doesn't terminate on
such a query instead. Proofs that need the call to diverge are out of reach, though:
`x => if (x > 0) x else f(x)` lies in `BigInt => {v: BigInt | v > 0}`, but showing it means showing
that `f(x)` never returns a value, which needs induction. Unrolling doesn't do induction.

**Partial operations are total in the solvers.** The evaluator fails on a division, remainder or
modulo by zero, while the solvers encode these operations as total SMT terms. A model that divides by
zero relies on a value of `x / 0` that evaluation never produces, and only `--check-models` rejects
it. The same goes for a selector applied to another constructor, which the evaluator rejects.

**Definedness is never encoded positively.** The procedure knows that an expression is defined on a
path because the path is feasible, but it has no literal for "`f(a)` is defined". So it can't reason
about where a function is undefined. A three-valued encoding with such a literal would make errors
observable, but not divergence: every finite unrolling is consistent with a call returning at the
next step, so "diverges" could never be established, only "returns" and "fails".

**Extensional equality reads functions totally.** Under `--function-equality=extensional`, functions
into a type with a single value are equal without being applied, so `(x: BigInt) => error[Unit]`
equals `(x: BigInt) => ()`. A Kleene equality, where `⊥` only equals `⊥`, would need the definedness
literal above.

**Models of functions into empty types.** A free function `f: A => B` with an empty `B` lies in its
type under the partial reading, through `x => error[B]`. `SymbolOps.simplestValue` doesn't produce
that value yet, so a query whose model needs such a function gives unknown.

**Front-ends that rely on totality.** A front-end that checks that every function terminates and
never fails, as Stainless does, could let Inox assume the total reading. That reading would empty
function types into empty codomains and make more proofs go through. Inox has no option for it.
