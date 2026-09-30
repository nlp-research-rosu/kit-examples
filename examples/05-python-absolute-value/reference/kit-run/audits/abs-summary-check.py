#!/usr/bin/env python3
"""Independent finite check of absSpec and the supplied Python source."""

import runpy
from pathlib import Path


def k_summary(value: int) -> int:
    if value < 0:
        return 0 - value
    return value


samples = [
    -(10**100),
    -513,
    -257,
    -256,
    -2,
    -1,
    0,
    1,
    2,
    256,
    257,
    513,
    10**100,
]
samples.extend(range(-1000, 1001))

mismatches = [(value, k_summary(value), abs(value)) for value in samples if k_summary(value) != abs(value)]
run = runpy.run_path(str(Path(__file__).resolve().parents[3] / "program/program.py"))["run"]
program_mismatches = [
    (value, run(value, 123456789), (value, abs(value)))
    for value in samples
    if run(value, 123456789) != (value, abs(value))
]
print(
    f"samples={len(samples)} "
    f"summary_mismatches={len(mismatches)} "
    f"program_mismatches={len(program_mismatches)}"
)
if mismatches:
    print(mismatches[:10])
    raise SystemExit(1)
if program_mismatches:
    print(program_mismatches[:10])
    raise SystemExit(1)
