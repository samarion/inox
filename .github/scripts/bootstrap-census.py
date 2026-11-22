#!/usr/bin/env python3
"""Run Stainless over Inox sources and measure how far it gets.

Two runs:
  * whole: all the files of the given packages as one program. A plugin crash on a file stops the
    compiler, so the crashing file is recorded and dropped, and the run is repeated without it.
  * per-file: each file alone, with the rest of Inox on the classpath, as in the 15 November census.
    This tells, for each file, the furthest stage it reaches.

usage: census.py --stainless BIN --src INOX_SRC_ROOT --classpath CP --out DIR [--jobs N] [--timeout S] [packages...]
Writes DIR/summary.json and DIR/summary.md, and the logs under DIR/logs/.
"""
import argparse, collections, concurrent.futures as cf, json, os, re, subprocess, sys, time

ANSI = re.compile(r'\x1b\[[0-9;]*m')
ERR = re.compile(r'^\[ Error  \] (\S+?\.scala):(\d+):(\d+): (.*)$')
CRASH = re.compile(r'unhandled exception while running stainless on (\S+\.scala)')
FRAGMENT = [r'Scala API .* is not directly supported', r'cannot be defined within', r'Only subclasses of stainless.lang.Exception',
            r'Method \w+ on Object is not supported', r'Auxiliary constructors', r'Multi-clauses classes', r'constructor parameters are not allowed',
            r'Variables are only allowed', r'try-(catch|finally)', r'simple type hierarchies', r'Classes can only be defined', r'is unsupported$',
            r'Fancy objects', r'ghost']

def rel(path, src):
    p = os.path.abspath(path)
    return os.path.relpath(p, src) if p.startswith(src) else path

def kind(msg):
    k = re.sub(r'`[^`]*`', '`_`', msg)
    k = re.sub(r'\b(on|to|of) [\w.]+(?= |$)', r'\1 _', k)
    k = re.sub(r'\d+', 'N', k)
    return k[:110]

def phase_of(msg):
    return 'fragment' if any(re.search(p, msg) for p in FRAGMENT) else 'extraction'

def run(args, files, log):
    if args.reparse:
        return parse(open(log).read(), args.src) | {'status': 0, 'seconds': 0.0}
    cmd = [args.stainless, f'--classpath={args.classpath}', '--solvers=smt-z3', f'--timeout={args.vc_timeout}',
           '--vc-cache=false', '--debug=stack'] + args.extra + files
    t = time.time()
    try:
        p = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=args.timeout, cwd=os.path.dirname(log))
        out, status = p.stdout.decode(errors='replace'), p.returncode
    except subprocess.TimeoutExpired as e:
        out, status = (e.stdout or b'').decode(errors='replace') + '\n[census] timed out\n', 'timeout'
    out = ANSI.sub('', out)
    open(log, 'w').write(out)
    return parse(out, args.src) | {'status': status, 'seconds': round(time.time() - t, 1)}

def parse(out, src):
    lines = out.splitlines()
    errors = []
    for l in lines:
        m = ERR.match(l)
        if m and not m.group(4).startswith('Hint:'):
            errors.append({'file': rel(m.group(1), src), 'line': int(m.group(2)), 'msg': m.group(4), 'phase': phase_of(m.group(4))})
    unpositioned = [l[len('[ Error  ] '):] for l in lines if l.startswith('[ Error  ] ') and not ERR.match(l)
                    and not re.search(r'terminated with an error|Debug output is available|^\s*$|^[\s|)^\u2500-\u257f]|^Hint:', l[len('[ Error  ] '):])]
    crash = CRASH.search(out)
    exc = None
    # Stainless ends a run with errors by throwing ExtractionFailed, which is not a crash
    m = re.search(r'^\[ Debug  \] ((?![\w.$]*ExtractionFailed)(?:[\w.$]+)(?:Error|Exception)\b.*)$', out, re.M)
    if m: exc = m.group(1)[:300]
    elif crash:
        m = re.search(r'^\s*((?:[\w.$]+)(?:Error|Exception)\b.*)$', out, re.M)
        if m: exc = m.group(1)[:300]
    v = None
    m = re.search(r'total:\s*(\d+)\s+valid:\s*(\d+).*?invalid:\s*(\d+)\s+unknown:\s*(\d+)\s+time:\s*([\d.]+)', out)
    if m: v = {'total': int(m.group(1)), 'valid': int(m.group(2)), 'invalid': int(m.group(3)), 'unknown': int(m.group(4)), 'time': float(m.group(5))}
    phases = re.findall(r'Running phase (\w+)', out)
    return {'errors': errors, 'unpositioned': unpositioned, 'crash_file': rel(crash.group(1), src) if crash else None,
            'exception': exc, 'verification': v, 'last_phase': phases[-1] if phases else None,
            'verified': 'Starting verification' in out}

def stage(r, f):
    """The furthest stage of a per-file run."""
    if r['status'] == 'timeout': return 'timeout'
    if r['crash_file'] or (r['exception'] and not r['verified']): return 'crash'
    if any(e['phase'] == 'fragment' for e in r['errors'] if e['file'] == f): return 'fragment checker'
    if any(e['file'] == f for e in r['errors']): return 'extraction'
    # Errors without a position come from the other Inox files, which Stainless reads from their TASTy
    if r['errors'] or r['unpositioned']: return 'blocked by other files'
    if not r['verified']: return 'later phases' if r['last_phase'] else 'extraction'
    if r['exception']: return 'crash'
    v = r['verification']
    if v and v['total'] and v['valid'] == v['total']: return 'verified'
    if v and v['total']: return 'verification'
    return 'verified (no VCs)'

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--stainless', required=True); ap.add_argument('--src', required=True)
    ap.add_argument('--classpath', required=True); ap.add_argument('--out', required=True)
    ap.add_argument('--jobs', type=int, default=os.cpu_count()); ap.add_argument('--timeout', type=int, default=1800)
    ap.add_argument('--vc-timeout', type=int, default=10); ap.add_argument('--extra', action='append', default=[])
    ap.add_argument('--no-per-file', action='store_true')
    ap.add_argument('--reparse', action='store_true', help='summarize the logs of an earlier run instead of running Stainless')
    ap.add_argument('packages', nargs='*', default=['ast', 'transformers'])
    args = ap.parse_args()
    args.src = os.path.abspath(args.src)
    logs = os.path.join(os.path.abspath(args.out), 'logs'); os.makedirs(logs, exist_ok=True)
    files = sorted(os.path.join(args.src, p, f) for p in args.packages for f in os.listdir(os.path.join(args.src, p)) if f.endswith('.scala'))

    # Whole program, dropping the files the plugin crashes on
    remaining, crashes, rounds = list(files), [], []
    while remaining:
        r = run(args, remaining, os.path.join(logs, f'whole-{len(rounds)}.log'))
        rounds.append({k: r[k] for k in ('status', 'seconds', 'last_phase', 'verification', 'crash_file', 'exception')} | {'errors': len(r['errors']), 'files': len(remaining)})
        if r['crash_file'] and os.path.join(args.src, r['crash_file']) in remaining:
            crashes.append({'file': r['crash_file'], 'exception': r['exception']})
            remaining.remove(os.path.join(args.src, r['crash_file']))
            continue
        whole = r
        break
    whole_errors = whole['errors']

    per_file = {}
    if not args.no_per_file:
        with cf.ThreadPoolExecutor(args.jobs) as ex:
            futs = {ex.submit(run, args, [f], os.path.join(logs, 'file-' + rel(f, args.src).replace('/', '_') + '.log')): f for f in files}
            for fut in cf.as_completed(futs):
                f = rel(futs[fut], args.src); r = fut.result()
                own = [e for e in r['errors'] if e['file'] == f]
                per_file[f] = {'stage': stage(r, f), 'errors': len(own), 'other_file_errors': len(r['errors']) - len(own) + len(r['unpositioned']),
                               'exception': r['exception'], 'verification': r['verification'], 'seconds': r['seconds'],
                               'unpositioned': r['unpositioned'][:3], 'dependency_error_kinds': dict(collections.Counter(kind(u) for u in r['unpositioned']).most_common(5))}

    by_file = collections.Counter(e['file'] for e in whole_errors)
    by_kind = collections.Counter(kind(e['msg']) for e in whole_errors)
    by_phase = collections.Counter(e['phase'] for e in whole_errors)
    stages = collections.Counter(v['stage'] for v in per_file.values())
    lines = sum(sum(1 for _ in open(f, errors='replace')) for f in files)
    summary = {
        'packages': args.packages, 'files': len(files), 'lines': lines,
        'whole': {'errors': len(whole_errors), 'errors_by_phase': dict(by_phase), 'files_with_errors': len(by_file),
                  'crashes': crashes, 'rounds': rounds, 'unpositioned': whole['unpositioned'][:20],
                  'last_phase': whole['last_phase'], 'verification': whole['verification'],
                  'errors_by_file': dict(by_file.most_common()), 'errors_by_kind': dict(by_kind.most_common())},
        'per_file': {'stages': dict(stages), 'files': dict(sorted(per_file.items()))},
    }
    json.dump(summary, open(os.path.join(args.out, 'summary.json'), 'w'), indent=2)

    md = []
    ok = sum(n for s, n in stages.items() if s.startswith('verified'))
    md.append(f"## Stainless on Inox {' and '.join(args.packages)}\n")
    md.append(f"{len(files)} files, {lines} lines.\n")
    md.append(f"**Tracked number: {len(whole_errors)} errors as one program, {len(crashes)} plugin crashes; "
              f"{ok} of {len(files)} files verify on their own.**\n" if per_file else
              f"**Tracked number: {len(whole_errors)} errors as one program, {len(crashes)} plugin crashes.**\n")
    md.append("### As one program\n")
    md.append(f"Errors by stage: " + (', '.join(f'{n} {p}' for p, n in by_phase.most_common()) or 'none') +
              f". Stainless " + (f"reached verification: {whole['verification']}" if whole['verified'] else
                                 f"stopped before verification (last phase: {whole['last_phase'] or 'none, it stopped in the frontend'}).") +
              f" Total time {sum(r['seconds'] for r in rounds):.0f} s over {len(rounds)} run(s).\n")
    if crashes:
        md.append("Plugin crashes (each file was dropped and the run repeated without it):\n")
        for c in crashes: md.append(f"- `{c['file']}`: `{c['exception']}`")
        md.append("")
    if whole['unpositioned']:
        md.append("Errors without a position: " + '; '.join(f"`{u}`" for u in whole['unpositioned']) + "\n")
    md.append("| Errors | Kind |\n|---:|---|")
    for k, n in by_kind.most_common(40): md.append(f"| {n} | {k.replace('|', '/')} |")
    md.append("")
    if per_file:
        md.append("### File by file\n")
        md.append("Stages reached: " + ', '.join(f'{n} {s}' for s, n in stages.most_common()) + "\n")
        md.append("Each file is given alone, with the rest of Inox on the classpath. Stainless also checks the other Inox files it reaches, from their TASTy, and reports their errors without a position: they are the errors elsewhere.\n")
        md.append("| File | Stage | Own errors | Errors elsewhere | VCs | Time (s) | Note |\n|---|---|---:|---:|---|---:|---|")
        for f, v in sorted(per_file.items()):
            vc = v['verification']; vcs = f"{vc['valid']}/{vc['total']} valid" if vc else ''
            note = (v['exception'] or ', '.join(f'{n} × {k}' for k, n in v['dependency_error_kinds'].items()) or '').replace('|', '/')[:160]
            md.append(f"| {f} | {v['stage']} | {v['errors']} | {v['other_file_errors']} | {vcs} | {v['seconds']} | {note} |")
    open(os.path.join(args.out, 'summary.md'), 'w').write('\n'.join(md) + '\n')
    print('\n'.join(md))

if __name__ == '__main__':
    main()
