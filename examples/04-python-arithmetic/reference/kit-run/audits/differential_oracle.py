import importlib.util
from pathlib import Path


source = Path(__file__).resolve().parents[3] / "program/program.py"
spec = importlib.util.spec_from_file_location("audited_program", source)
module = importlib.util.module_from_spec(spec)
assert spec.loader is not None
spec.loader.exec_module(module)

values = [-10**40, -257, -6, -5, -1, 0, 1, 2, 3, 256, 257, 10**40]
res_values = [-10**50, 0, 10**50]
cases = [(a, b, r0) for a in values for b in values for r0 in res_values]

mismatches = []
for a, b, r0 in cases:
    actual = module.run(a, b, r0)
    expected = (a, b, a * b + a - b)
    if actual != expected:
        mismatches.append(((a, b, r0), actual, expected))

print(f"source={source}")
print(f"oracle=independent tuple (a, b, a*b+a-b) evaluated by host Python integers")
print(f"values={values}")
print(f"res_values={res_values}")
print(f"cases={len(cases)}")
print(f"mismatches={len(mismatches)}")
if mismatches:
    for mismatch in mismatches[:10]:
        print(mismatch)
    raise SystemExit(1)
