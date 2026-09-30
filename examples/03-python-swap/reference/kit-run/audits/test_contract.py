from pathlib import Path
import runpy

run = runpy.run_path(str(Path(__file__).resolve().parents[3] / "program/program.py"))["run"]


VALUES = (-10**80, -1000, -6, -5, -1, 0, 1, 255, 256, 257, 1000, 10**80)

checked = 0
for a in VALUES:
    for b in VALUES:
        for r in VALUES:
            result = run(a, b, r)
            assert result == (b, a, a)
            assert result[0] is b
            assert result[1] is a
            assert result[2] is a
            checked += 1

print(f"checked={checked} mismatches=0")
