#!/usr/bin/env python3
"""Collects what the solvers spent on each Stainless benchmark, and compares two builds.

usage:
  resource_usage.py collect <out.json> <dir>...
      Reads the records that Stainless's integration tests write with
      `-Dresource-usage=<dir>` (one JSON file per benchmark and configuration
      of a suite, see Calibration in Stainless's Budgets.scala) and writes, for
      each test, the resources and unrollings of all its checks.
  resource_usage.py section <label> <head.json> <base.json> [<history.json>...]
      Prints, as JSON, the comparison of the build `head` with the build of
      main `base`, for the comment (see scripts/pr_comment.py). The earlier
      builds of main (history) show which tests vary between builds of the
      same code.
  resource_usage.py covered <head.json> <base.json>
      Prints the tests whose resources both builds have records of, one per
      line: the comment compares their work instead of their durations.

Unlike durations, the work of a solver doesn't depend on the runner: z3 and
cvc5 count it in the units of their resource limits (`--z3-rlimit`,
`--cvc5-rlimit`), and the unrolling solver counts its unrollings
(`--unroll-bound`). Two builds of the same code spend about the same on each
test, so a change of a few tests stands out without statistics, where the
durations of the same tests vary by several times between runners.

They can still vary a little, as the solvers' choices depend on the names of
the symbols, which depend on the order in which tests run. So a test is only
listed when its usage changes by at least 2× (resources) or 1.25×
(unrollings), and by more than it varied between the earlier builds of main.
Without 2 earlier builds of main, which show the tests that vary, the factor
of the resources is 1.5 times larger. (Two local runs of 702 tests of Stainless's ImperativeSuite and
smaller suites, in another order: the unrollings of every test and the
resources of 593 of 606 tests were the same, and the others differed by at
most 2.4×, against 42 of the 63 tests over 1 s whose durations differed by
1.5× or more.)
"""

import json
import math
import os
import re
import sys

from test_timings import SAFE

MILLION = 1_000_000
# Listed tests change by at least this factor and this much.
RESOURCES_FACTOR = 2.0
RESOURCES_MIN = 1 * MILLION
UNROLLINGS_FACTOR = 1.25
UNROLLINGS_MIN = 3
# Much more work: tests whose usage grows by at least this factor and this
# much, and tests with more inconclusive verification conditions.
MAJOR_RESOURCES_FACTOR = 5.0
MAJOR_RESOURCES_MIN = 25 * MILLION
MAJOR_UNROLLINGS_FACTOR = 3.0
MAJOR_UNROLLINGS_MIN = 20
# Without this many earlier builds of main, the factor of the resources is
# this much larger.
MIN_HISTORY = 2
NO_HISTORY_MARGIN = 1.5
# The changed tests kept in the comment's data.
MAX_STORED = 40

METRICS = {
    "resources": (RESOURCES_FACTOR, RESOURCES_MIN, MAJOR_RESOURCES_FACTOR, MAJOR_RESOURCES_MIN),
    "unrollings": (UNROLLINGS_FACTOR, UNROLLINGS_MIN, MAJOR_UNROLLINGS_FACTOR, MAJOR_UNROLLINGS_MIN),
}


def test_key(u):
    # The name of the test as JUnit reports it, as for the durations (see
    # scripts/test_timings.py), with the suite's package.
    if isinstance(u.get("test"), str):
        return re.sub(r"^(.*? :: )\s*\d+: ", r"\1", u["test"]).strip()
    return f"{u.get('suite')} :: {u.get('benchmark')} solver={u.get('solver')} config={u.get('configuration')}"


def number(x):
    return x if isinstance(x, (int, float)) and not isinstance(x, bool) and x >= 0 else None


def collect(out, dirs):
    tests = {}
    for d in dirs:
        for root, dirnames, files in os.walk(d):
            dirnames.sort()
            for f in sorted(files):
                if not f.endswith(".json"):
                    continue
                try:
                    u = json.load(open(os.path.join(root, f)))
                except (ValueError, OSError):
                    continue
                if not isinstance(u, dict):
                    continue
                tests[test_key(u)] = {
                    "solver": str(u.get("solver", "")),
                    "resources": number(u.get("totalResources")),
                    "unrollings": number(u.get("totalUnrollings")),
                    "conditions": number(u.get("conditions")) or 0,
                    "inconclusive": number(u.get("inconclusive")) or 0,
                }
    json.dump({"tests": tests}, open(out, "w"), indent=0, sort_keys=True)


def load(path):
    try:
        tests = json.load(open(path)).get("tests", {})
    except (ValueError, OSError):
        return {}
    return tests if isinstance(tests, dict) else {}


def label(s):
    return SAFE.sub("?", s)[:60].replace("<", "‹").replace(">", "›").replace("&", "+")


def compare(title, head, base, history):
    common = sorted(head.keys() & base.keys())
    job = {"label": label(title), "count": len(common), "history": len(history),
           "new": len(head.keys() - base.keys()), "gone": len(base.keys() - head.keys()),
           "tests": [], "major": []}
    for m in METRICS:
        both = [k for k in common if number(head[k].get(m)) is not None and number(base[k].get(m)) is not None]
        job[m] = {"count": len(both), "base": sum(base[k][m] for k in both), "head": sum(head[k][m] for k in both)}

    changed, major = [], []
    for k in common:
        h, b = head[k], base[k]
        change = {}
        big = False
        for m, (fac, least, major_fac, major_least) in METRICS.items():
            if m == "resources" and len(history) < MIN_HISTORY:
                fac *= NO_HISTORY_MARGIN
            hv, bv = number(h.get(m)), number(b.get(m))
            if hv is None or bv is None:
                continue
            # What the test spent in the builds of main: a change must leave
            # that range by the factor.
            seen = [bv] + [v for v in (number(x.get(k, {}).get(m)) for x in history) if v is not None]
            lo, hi = min(seen), max(seen)
            more = hv >= fac * hi and hv - bv >= least
            less = fac * hv <= lo and bv - hv >= least
            if more or less:
                change[m] = [bv, hv]
                if more and hv >= major_fac * hi and hv - bv >= major_least:
                    big = True
        hi_inc, bi_inc = h.get("inconclusive") or 0, b.get("inconclusive") or 0
        if hi_inc != bi_inc:
            change["inconclusive"] = [bi_inc, hi_inc]
            if hi_inc > bi_inc:
                big = True
        if change:
            entry = {"key": k, **change}
            (major if big else changed).append(entry)

    def weight(e):
        # Sorted by how much more (or less) work, relative to the thresholds.
        return max(abs(math.log((e[m][1] + 1) / (e[m][0] + 1))) for m in METRICS if m in e) if any(
            m in e for m in METRICS) else 0

    major.sort(key=lambda e: (-(e.get("inconclusive", [0, 0])[1] - e.get("inconclusive", [0, 0])[0]), -weight(e)))
    changed.sort(key=lambda e: -weight(e))
    job["major"] = major[:MAX_STORED]
    job["tests"] = changed[:MAX_STORED]
    job["changed"] = {"more": sum(1 for e in changed if more_work(e)), "less": sum(1 for e in changed if not more_work(e))}
    return job


def more_work(e):
    """Whether the change `e` of a test is mostly more work."""
    if "inconclusive" in e and e["inconclusive"][1] > e["inconclusive"][0]:
        return True
    logs = [math.log((e[m][1] + 1) / (e[m][0] + 1)) for m in METRICS if m in e]
    return sum(logs) > 0 if logs else False


def section(title, head_path, base_path, history_paths):
    head, base = load(head_path), load(base_path)
    history = [load(p) for p in history_paths]
    history = [h for h in history if h]
    # Nothing without records of both builds, which removes the comment's section.
    if head and base:
        json.dump(compare(title, head, base, history), sys.stdout, ensure_ascii=False)
        print()


def covered(head_path, base_path):
    head, base = load(head_path), load(base_path)
    for k in sorted(head.keys() & base.keys()):
        # The unrollings alone don't say how long a solver searched: Princess
        # counts no resources, so its tests keep their durations.
        if number(head[k].get("resources")) is not None and number(base[k].get("resources")) is not None:
            print(k)


def main(args):
    if len(args) >= 3 and args[0] == "collect":
        collect(args[1], args[2:])
    elif len(args) >= 4 and args[0] == "section":
        section(args[1], args[2], args[3], args[4:])
    elif len(args) == 3 and args[0] == "covered":
        covered(args[1], args[2])
    else:
        sys.exit(__doc__)


if __name__ == "__main__":
    main(sys.argv[1:])
