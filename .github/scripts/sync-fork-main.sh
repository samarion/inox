#!/usr/bin/env bash
# Fork-only: rebuild this fork's main as upstream main plus one fork-only commit.
#
# Usage: sync-fork-main.sh <fork-main-ref> <upstream-main-ref>
#
# Leaves the rebuilt main checked out on the branch `fork-main-synced` and
# prints one of these on its last line:
#   up-to-date    fork main is already upstream main + one commit; nothing to push
#   rebuilt       fork-main-synced holds the new main; push it
#   conflict      the fork-only changes don't apply on top of upstream main
#
# The fork-only changes are everything fork main has that the upstream commits
# it contains don't: diff(merge-base(fork, upstream), fork). This holds whatever
# the fork's history looks like: one squashed commit, fork PRs merged on top, or
# merge commits from GitHub's "Sync fork" button or manual syncs. Upstream
# commits that the fork already had under other hashes (cherry-picks, squashed
# upstream PRs) apply as no-ops.
set -euo pipefail

FORK="$(git rev-parse --verify "$1^{commit}")"
UPSTREAM="$(git rev-parse --verify "$2^{commit}")"

DEFAULT_MESSAGE="Fork-only setup: GitHub-hosted CI and CLAUDE.md

Everything that differs between this fork's main and upstream main. It is
rebuilt on top of upstream main by .github/workflows/sync-fork-main.yml and
must never be upstreamed."

# Already in shape: a single non-merge commit directly on top of upstream main.
if [ "$(git rev-list --count "$UPSTREAM..$FORK")" = 1 ] \
   && [ "$(git rev-parse "$FORK^")" = "$UPSTREAM" ]; then
  git checkout -q -B fork-main-synced "$FORK"
  echo up-to-date
  exit 0
fi

BASE="$(git merge-base "$FORK" "$UPSTREAM")"

# Keep the message of the current fork-only commit when there is one: the
# first-parent chain's oldest commit after BASE (the previous squash).
MESSAGE="$DEFAULT_MESSAGE"
FIRST="$(git rev-list --first-parent --reverse "$BASE..$FORK" | head -n 1)"
if [ -n "$FIRST" ] && [ "$(git rev-list --no-walk --count --merges "$FIRST")" = 0 ] \
   && git log -1 --format=%s "$FIRST" | grep -q '^Fork-only setup'; then
  MESSAGE="$(git log -1 --format=%B "$FIRST")"
fi

if git diff --quiet "$BASE" "$FORK"; then
  # Nothing fork-only (should not happen on this fork): plain fast-forward.
  git checkout -q -B fork-main-synced "$UPSTREAM"
  echo rebuilt
  exit 0
fi

# One commit holding all the fork-only changes, on top of the upstream commit
# they were made against, then cherry-picked (a three-way merge) onto upstream.
SQUASHED="$(git commit-tree "$FORK^{tree}" -p "$BASE" -m "$MESSAGE")"
git checkout -q -B fork-main-synced "$UPSTREAM"
if ! git cherry-pick --allow-empty "$SQUASHED" >/dev/null; then
  git diff --name-only --diff-filter=U >&2 || true
  git cherry-pick --abort
  git checkout -q --detach "$FORK"
  echo conflict
  exit 0
fi
echo rebuilt
