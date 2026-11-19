# Proofs of Inox's answers

[`semantics.md`](semantics.md) defines what an Inox expression means,
independently of any proof checker: the theorem that a proof of an UNSAT answer
states is that no values of the free variables make the query evaluate to
`true` under this semantics.

Its fenced `inox-sem` blocks are read by `inox.semantics.Codegen`, which writes
the semantics for each tool that needs it. Today that is a Scala evaluator,
[`../src/main/scala/inox/semantics/generated/Semantics.scala`](../src/main/scala/inox/semantics/generated/Semantics.scala),
which is part of Inox: `inox.evaluators.SemanticsEvaluator` runs it on Inox's
trees, and is Inox's default evaluator. `SemanticsSuite` compares it with
`RecursiveEvaluator` on the functions of the regression files. Lean and Eunoia
backends come next.

This directory is the sbt project `proofs`, which depends on Inox but is not
part of it: it is not published, and Inox's jars don't contain it. `sbt test`
runs its tests along with Inox's, and `sbt proofs/test` runs them alone.

After changing `semantics.md`, regenerate the embeddings and commit them with
it; a test fails while they are out of date:

```sh
sbt proofs/run
```
