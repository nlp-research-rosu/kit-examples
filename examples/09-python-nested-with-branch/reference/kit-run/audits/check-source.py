from pathlib import Path
import importlib.util
import itertools
import json
import re
root = Path(__file__).resolve().parent
example = 'nested_with_branch'
project = Path(__file__).resolve().parents[1]
loader = importlib.util.spec_from_file_location(example, Path(__file__).resolve().parents[3] / 'program' / 'program.py')
module = importlib.util.module_from_spec(loader)
loader.loader.exec_module(module)
cases = 0
originals = [-2 ** 80, -1, 0, 257, 2 ** 80]
for a, b, j in itertools.product(range(-3, 19), range(-3, 19), originals):
    got = module.run(a, b, 2 ** 80, j, -2 ** 80)
    expected = (a, b, min(a, 0), 0 if a > 0 and b > 0 else j, sum((i for i in range(1, a + 1) if i <= b)))
    assert got == expected
    cases += 1
inner_cases = 0
for i, j, count in itertools.product(range(1, 15), range(16), [-10, 0, 2 ** 80]):
    final = count + j + sum(range(1, i))
    assert 2 * final == 2 * count + 2 * j + i * (i - 1)
    if j > 0:
        assert 2 * (count + 1) + 2 * (j - 1) + i * (i - 1) == 2 * final
    elif i > 1:
        assert 2 * count + 2 * (i - 1) + (i - 1) * (i - 2) == 2 * final
    inner_cases += 1
codes = re.findall('#CoCodeValue\\((.*?)\\.CoCodeValueItems', (Path(__file__).resolve().parents[3] / 'program' / 'program.kpyc').read_text())
ops = re.findall('([A-Z_]+\\(\\d+\\))', codes[1])
helper = re.findall('\\(\\d+ \\|-> ([A-Z_]+\\(\\d+\\))\\)', (project / 'program-helper.k').read_text())
assert ops == helper
result = dict(source_cases=cases, inner_cases=inner_cases, code_units=len(ops), status='passed', kind='finite evidence, not universal proof')
print(example, json.dumps(result))
