# Solvers

A solver takes a set of boolean Inox expressions and decides whether some
assignment of their free variables makes them all evaluate to `true`. The
reference semantics is the evaluator in `../evaluators/RecursiveEvaluator`.
A solver can answer in three ways:

- **`Unsat`** means no such assignment exists. This is how a VC is proven:
  Inox checks the VC's negation and gets `Unsat`.
- **`SatWithModel(m)`** means `m` is such an assignment, which is a
  counterexample when the input is a negated VC. Set `optCheckModels` to have
  every model re-evaluated before it is returned (it is off by default).
- **`Unknown`** is returned on timeouts, when the unroll bound is reached, and
  for models that cannot be validated, for example models of quantifiers
  outside the supported fragment.

The layers, from the top:

| Directory | Role |
|---|---|
| `combinators/` | Wrappers: timeouts, portfolios, solver pools |
| `evaluating/` | Gives solvers access to the evaluator, for model checking |
| `invariant/` | Invariant inference through Horn clauses (Eldarica), outside the unrolling procedure |
| `unrolling/` | The decision procedure for recursive functions, lambdas, dependent types and quantifiers |
| `theories/` | Encodings of strings, bags, real division and so on into what each backend supports |
| `z3/`, `smtlib/`, `princess/` | Quantifier-free backends: native Z3, SMT-LIB processes, Princess |

[`unrolling/README.md`](unrolling/README.md) presents the formalization
behind the procedure (Voirol, EPFL thesis no. 9479). It covers the guarantees
the procedure gives and where the implementation departs from the thesis.
