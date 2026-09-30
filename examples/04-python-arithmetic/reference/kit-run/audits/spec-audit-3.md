# Specification audit 3

## Artifacts examined

- `/app/program.py` and `/app/program.kpyc`
- partitioned `inputs/spec.k`
- `inputs/verification.k`, including unchanged `VERIFICATION-SUMMARIES`
- `inputs/program-helper.k`
- revised `inputs/SCOPE.md`
- immutable semantics `python-3-14-6` at `e5d24a5429a4`

## Formal contract and domain

Every claim has the same initial exact program image, symbolic integer inputs, execution boundary, and postcondition: the returned integer payload triple is `(A, B, arithMix(A,B))`. The only difference among the eight claims is the representation guard for the three fixed-semantics intermediate values:

```text
P = A * B
Q = P + A
R = Q - B
```

For each value independently, a claim uses either `isSmallIntValue` (`s`) or its Boolean negation (`h`). The labels enumerate `sss`, `ssh`, `shs`, `shh`, `hss`, `hsh`, `hhs`, and `hhh`, which is the complete Cartesian product `{s,h}^3`. Since `isSmallIntValue` is a total Boolean function in the fixed semantics and `h` is exactly `notBool s`, every integer pair `(A,B)` satisfies at least one claim and cannot satisfy two different labels. `R0` remains arbitrary in every claim. The partition is symbolic and unbounded; it is not finite enumeration of inputs or domain narrowing.

## Summary and program identity

`arithMix` remains the one unconditional equation `A *Int B +Int A -Int B`, with full coverage, no overlaps, and direct faithfulness to the assignment. The exact compiled-image helper is unchanged; the audit-1 byte-for-byte comparison remains reproducible. The signed, zero, overwritten-`res`, and large-integer differential cases remain unchanged and all passed.

## Mechanical check

Command:

```sh
kprover validate --session 308551e7-85d3-4ceb-8100-62ae50a3b825 --project /app --semantics python-3-14-6 --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/program-helper.k --task-timeout 1800
```

`validation-009` exited 113 because the first partition draft placed `requires` after `ensures`; the clauses were reordered without changing their formulas. `validation-010` exited 0 with `task.status: completed` and `task.result.valid: true`; evidence is `validation-010/result.json`.

All eight stable labels resolve as `SPEC.run-*`. The source has no loops, so no circularity or cross-claim dependency is required. The claims collectively constitute the full program-entry theorem.

## Findings

No remaining adequacy, summary-faithfulness, partition-coverage, overlap, label, or mechanical finding.

VERDICT: PASS
REASON: The eight validated symbolic entry claims form an exhaustive disjoint representation partition while preserving the full unbounded integer contract and identical postcondition.
