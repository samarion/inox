# Working on this fork

This is `samarion/inox`, a fork of `epfl-lara/inox`. This file lives only on the
fork's `main` and must never end up in a branch meant for upstream.

## Branches and PRs

- Base every feature branch on epfl-lara's `main`, not on this fork's `main`.
  The fork's `main` carries fork-only commits (this file, the CI setup) that
  must not be upstreamed.
- Open PRs against this fork's `main`. CI uses the base branch's workflow, so
  feature branches get the fork CI without containing it.
- To update a PR, rebase it onto epfl-lara's `main`. Never merge the fork's
  `main` into a feature branch.
- Work that depends on an unmerged fix stacks on that fix's branch.
- Upstreaming is a PR from the feature branch to `epfl-lara/inox:main`.

## Building and testing

- `sbt test` runs the unit tests (`src/test`), and `sbt it:test` runs the
  integration tests (`src/it`). `-Dtest-parallelism=N` runs suites in
  parallel.
- Solver-dependent tests need `z3`, `cvc4`, `cvc5` and `bitwuzla` on the
  `PATH`. `scripts/install_solvers.sh <dir>` installs them. Princess and
  Eldarica come in through Maven.
- In cloud sessions sbt isn't preinstalled, and some hosts are unreachable.
  The local workarounds are in `/mnt/project-files/sbt-setup/`: a Maven
  Central mirror, remapping `uuverifiers` to `io.github.uuverifiers`, and
  bumped sbt plugins. Never commit them.

## CI on the fork

- `Inox CI` runs on GitHub-hosted runners: Linux on JDK 17 and macOS ARM64 on
  JDK 21.
- To test several PRs together, run `Inox CI` manually with the `prs` input,
  e.g. `2 3`. It merges those PR heads into `main` before testing.
- `Stainless downstream CI` builds epfl-lara/stainless against this Inox and
  runs its tests (Bolts excluded) on `ubuntu-latest`. It takes about 40
  minutes, so it only runs when triggered manually, with the same `prs` input:
  `gh workflow run stainless-downstream-CI.yml -R samarion/inox -f prs="1 2"`.
  Run it before opening an upstream PR that could affect Stainless.
