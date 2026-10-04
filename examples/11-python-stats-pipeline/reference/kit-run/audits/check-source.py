from pathlib import Path
import importlib.util
import itertools
import json
import re
ROOT = Path(__file__).resolve().parent
values = [-2 ** 80, -257, -1, 0, 1, 256, 257, 2 ** 80]
lengths = [-2 ** 80, -2, -1, 0, 1, 2, 5, 12]
example = 'stats_pipeline'
root = Path(__file__).resolve().parents[1]
module_spec = importlib.util.spec_from_file_location(example, Path(__file__).resolve().parents[3] / 'program' / 'program.py')
module = importlib.util.module_from_spec(module_spec)
module_spec.loader.exec_module(module)
cases = 0
for a, b, n in itertools.product(values, values, lengths):
    for overwritten in [0, -2 ** 90, 2 ** 90]:
        got = module.run(a, b, n, *[overwritten] * 5)
        m, x = (min(a, b), max(a, b))
        expected = (a, b, n, m, x, x - m, max(n, 0), max(n, 0) * (x - m) + m)
        assert got == expected, (a, b, n, got, expected)
        cases += 1
loops = 0
for n, t in itertools.product(range(14), values):
    for i in range(n + 1):
        r = i * t
        if i < n:
            assert r + t == (i + 1) * t
        else:
            assert r == n * t
        loops += 1
codes = re.findall('#CoCodeValue\\((.*?)\\.CoCodeValueItems', (Path(__file__).resolve().parents[3] / 'program' / 'program.kpyc').read_text())
original = re.findall('([A-Z_]+\\(\\d+\\))', codes[1])
helper = re.findall('\\(\\d+ \\|-> ([A-Z_]+\\(\\d+\\))\\)', (root / 'program-helper.k').read_text())
assert original == helper
result = {'source_cases': cases, 'loop_cases': loops, 'code_units': len(original), 'status': 'passed', 'kind': 'finite evidence, not universal proof'}
print(example, json.dumps(result))
