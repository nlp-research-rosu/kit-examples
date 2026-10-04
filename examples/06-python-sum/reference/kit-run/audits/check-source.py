import json, platform, runpy
from pathlib import Path
run = runpy.run_path(str(Path(__file__).resolve().parents[3] / "program/program.py"))["run"]
ns = [-257, -6, -5, -1, 0, 1, 2, 5, 255, 256, 257, 258, 511, 512, 1000]
ss = [-10**30, -257, -6, -5, -1, 0, 1, 255, 256, 257, 10**30]
failures = []
for n in ns:
    for s in ss:
        actual_n, actual_s = run(n, s)
        expected_n = n if n <= 0 else 0
        expected_twice_s = 2*s if n <= 0 else 2*s+n*(n+1)
        if actual_n != expected_n or 2*actual_s != expected_twice_s:
            failures.append([n, s, actual_n, actual_s])
print(json.dumps({"python": platform.python_version(), "n_inputs": ns,
                  "sum_inputs": ss, "checks": len(ns)*len(ss),
                  "mismatches": failures}, indent=2))
assert not failures
