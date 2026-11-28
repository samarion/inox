#!/usr/bin/env bash
# Compares the test durations of a pull request build with those of main, for
# the pull request comment. Called by the coverage comment workflow.
#
# usage: test-timings-comment.sh <workflow files> <run id> <artifact prefix> <mode> <label> <out.json> [<usage.json>]
#
# Writes the rows of the comment's table of test durations, as JSON (see
# scripts/test_timings.py section), labelled with <label>.
# The build's artifacts named <artifact prefix>* hold the timings collected by
# scripts/test_timings.py, with the files that say what was tested (pr-number,
# pr-head-sha, base-sha, tested-sha, merged-prs). With mode `per-artifact`,
# each artifact is compared separately (the jobs of Inox CI run the same tests
# on different runners). With mode `merged`, the artifacts are merged first
# (the jobs of the Stainless downstream CI run different tests).
#
# The build is compared with the build of main at the commit it was merged
# into (or else the latest build of main), and earlier builds of main give the
# variation between builds of the same code. Builds of main are those that
# tested main without merging pull requests into it, in any of the workflows
# of the comma-separated <workflow files> (newest first), so that a job that
# moves to another workflow keeps its history.
#
# With <usage.json>, also writes the comparison of the work that the solvers
# spent on each test (see scripts/resource_usage.py), from the `usage.json` of
# the artifacts, for the builds that recorded it. The durations of the tests
# whose work is compared are then only checked for major slowdowns.
#
# Writes nothing when the build has no timings. Prints the pull request
# number and head commit that the build tested, if any, to stdout.
set -euo pipefail

workflows=$1 run=$2 prefix=$3 mode=$4 title=$5 out=$6 usage_out=${7:-}
work=$(mktemp -d)
: > "$out"
[ -z "$usage_out" ] || : > "$usage_out"

# The artifacts come from pull request builds: only read plain files.
read_meta() { [ -f "$1" ] && head -c 200 "$1" | tr -cd '0-9a-f \n' | head -n 1 || true; }

download() {  # <run id> <dir>
  gh run download "$1" --repo "$GITHUB_REPOSITORY" --pattern "$prefix*" --dir "$2" 2>/dev/null &&
    [ -n "$(ls -A "$2" 2>/dev/null)" ]
}

# Combines the artifacts of a build into one timings file per group.
groups() {  # <dir>
  local dir=$1
  if [ "$mode" = merged ]; then
    python3 scripts/test_timings.py merge "$dir/all.timings" "$dir"/"$prefix"*/timings.json
    # The solvers' work, when the build recorded it.
    local usages=("$dir"/"$prefix"*/usage.json)
    if [ -f "${usages[0]}" ]; then
      python3 scripts/test_timings.py merge "$dir/all.usage" "${usages[@]}"
    fi
  else
    for a in "$dir"/"$prefix"*/; do
      a=${a%/}
      [ -f "$a/timings.json" ] && cp "$a/timings.json" "$dir/${a##*/}.timings"
    done
  fi
}

download "$run" "$work/head" || { echo "No test timings in run $run" >&2; exit 0; }
meta=$(ls -d "$work/head/$prefix"*/ | head -n 1)
pr=$(read_meta "$meta/pr-number")
pr_head=$(read_meta "$meta/pr-head-sha")
base_sha=$(read_meta "$meta/base-sha")
groups "$work/head"

# Builds of main, newest first. For each group of timings, the base is the
# newest of them at base_sha that has the group, and up to 6 others that have
# it are the history. The workflows can run the same push separately, and
# each has only its own groups (Inox CI has no Linux JDK 21 timings, which the
# coverage workflow has), so the base is chosen group by group.
main_runs=() base_runs=()
while read -r id; do
  [ "$id" = "$run" ] && continue
  dir="$work/main-$id"
  [ -e "$dir" ] && continue
  download "$id" "$dir" || continue
  m=$(ls -d "$dir/$prefix"*/ | head -n 1)
  # Only builds of main itself, without pull requests merged into it.
  if [ -n "$(read_meta "$m/pr-number")" ] || [ -n "$(read_meta "$m/merged-prs" | tr -d ' ')" ]; then
    continue
  fi
  groups "$dir"
  main_runs+=("$id")
  [ "$(read_meta "$m/tested-sha")" = "$base_sha" ] && base_runs+=("$id")
  [ "${#base_runs[@]}" -gt 0 ] && [ "${#main_runs[@]}" -ge 12 ] && break
done < <(IFS=,; for workflow in $workflows; do
           gh run list --repo "$GITHUB_REPOSITORY" --workflow "$workflow" --branch main --status completed \
             --limit 20 --json databaseId,createdAt --jq '.[] | "\(.createdAt) \(.databaseId)"'
         done | sort -r | head -n 20 | cut -d' ' -f2)

if [ "${#main_runs[@]}" -eq 0 ]; then
  echo "_No build of \`main\` with test durations to compare with yet ($title)._" > "$work/note.md"
  : > "$work/groups.tsv"
  python3 scripts/test_timings.py section "$work/groups.tsv" "$work/note.md" > "$out"
  echo "$pr $pr_head"
  exit 0
fi

note=
base_run= history_runs=()   # those of the last group, for the merged mode
groups="$work/groups.tsv"
: > "$groups"
for head in "$work/head"/*.timings; do
  name=$(basename "$head" .timings)
  group_base=
  for id in "${base_runs[@]}"; do
    [ -f "$work/main-$id/$name.timings" ] && { group_base=$id; break; }
  done
  if [ -z "$group_base" ]; then
    # The latest build of main that has the group, compared with the others.
    for id in "${main_runs[@]}"; do
      [ -f "$work/main-$id/$name.timings" ] && { group_base=$id; break; }
    done
    [ -n "$group_base" ] || continue
    note="_Compared with the latest build of \`main\` (none at this build's base), so later changes to \`main\` count too ($title)._"
  fi
  group_history=()
  for id in "${main_runs[@]}"; do
    [ "$id" != "$group_base" ] && [ -f "$work/main-$id/$name.timings" ] && group_history+=("$id")
  done
  group_history=("${group_history[@]:0:6}")
  base_run=$group_base history_runs=("${group_history[@]}")
  if [ "$mode" = merged ]; then
    label=$title
  else
    label="$title $(echo "${name#"$prefix"}" | sed 's/-jdk/ /')"
  fi
  line="$label"$'\t'"$head"$'\t'"$work/main-$group_base/$name.timings"
  for id in "${group_history[@]}"; do
    line+=$'\t'"$work/main-$id/$name.timings"
  done
  echo "$line" >> "$groups"
done
# The Stainless downstream CI tests the Stainless main of the day.
head_stainless=$(read_meta "$meta/stainless-sha")
base_stainless=
[ -n "$base_run" ] && base_stainless=$(read_meta "$(ls -d "$work/main-$base_run/$prefix"*/ | head -n 1)/stainless-sha")
if [ -n "$head_stainless" ] && [ "$head_stainless" != "$base_stainless" ]; then
  note="${note:+$note }_The two builds tested different Stainless commits, so Stainless changes count too._"
fi
# The solvers' work, compared with the same builds of main as the durations.
: > "$work/covered.txt"
if [ -n "$usage_out" ] && [ "$mode" = merged ] && [ -n "$base_run" ] && [ -f "$work/head/all.usage" ] &&
   [ -f "$work/main-$base_run/all.usage" ]; then
  history=()
  for id in "${history_runs[@]}"; do
    [ -f "$work/main-$id/all.usage" ] && history+=("$work/main-$id/all.usage")
  done
  python3 scripts/resource_usage.py section "$title" "$work/head/all.usage" "$work/main-$base_run/all.usage" \
    "${history[@]}" > "$usage_out"
  python3 scripts/resource_usage.py covered "$work/head/all.usage" "$work/main-$base_run/all.usage" > "$work/covered.txt"
fi
echo "$note" > "$work/note.md"
python3 scripts/test_timings.py section "$groups" "$work/note.md" "$work/covered.txt" > "$out"
echo "$pr $pr_head"
