# Specification audit 3

## Artifacts examined

- `/app/program.py`
- `/app/program.kpyc`
- construction-session `inputs/spec.k`, `inputs/verification.k`, and `inputs/subject.k`
- `/app/SCOPE.md`
- `/app/audits/abs-summary-check.py`
- pinned semantics `python-3-14-6` revision `e5d24a5429a4`

Review mode: same-agent review, performed from the final on-disk artifacts. This audit supersedes spec audits 1 and 2.

## Formal contract and domain

The single `SPEC.run-abs` claim starts the exact compiled `run` code object at bytecode dispatch with two arbitrary unbounded Python-integer payloads, `A` and `RES`. It reaches the semantics' terminal `#normalExit` state after executing every instruction. There is no precondition, finite bound, trusted claim, loop, or circularity; `RES` is arbitrary because both source branches overwrite it.

The final locals preserve the original `a` object and bind `res` to the representation of `absSpec(A)`. The complete final object map also retains the exact two-element tuple allocated by `BUILD_TUPLE`, so the theorem constrains the returned pair even though top-level `RETURN_VALUE` consumes its stack pointer. Module initialization and caller-side binding are expressly outside the invocation boundary and recorded in `SCOPE.md`.

## Summary and representation faithfulness

`absSpec` partitions integers with the disjoint, exhaustive guards `A < 0` and `not (A < 0)`, producing `0 - A` and `A` respectively.

`absFinalObjects`, `absFinalTupleId`, `absFinalNextId`, and `absFinalResultId` further partition only the semantics' object representation:

1. nonnegative `A`: the existing `a` object is reused as tuple element 2 and one tuple is allocated;
2. negative `A` with a small-int result: the semantics' static small-int object is used and one tuple is allocated;
3. negative `A` with a non-small result: a fresh integer object followed by a fresh tuple is allocated.

Those cases are exhaustive and pairwise disjoint because `isSmallIntValue(absSpec(A))` and its Boolean negation partition the negative branch. `absFinalInstructionPointer` and `absFinalNextInstruction` exactly name the two source return sites (19/20 for the negative branch, 24/25 for the nonnegative branch). The equations terminate and appear only in the theorem's definitional target layer; they do not rewrite or replace program execution.

## Mechanical and independent checks

1. `kprover validate --session 35db469f-c5f8-4f79-8efd-b94e254c92fe --project /app --semantics python-3-14-6 --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/subject.k --task-timeout 1800`
   - Exit status: 0.
   - Task: `926fa2f6-d48c-4cad-ac77-1a45841ee451`.
   - Result: `status=completed`, `valid=true`, final tool exit code 0.
   - Evidence: construction-session `validation-010/result.json`.
2. `python3 /app/audits/abs-summary-check.py`
   - Exit status: 0.
   - Output: `samples=2014 summary_mismatches=0 program_mismatches=0`.
   - Oracle: Python's built-in `abs` plus direct execution of `/app/program.py`; scope includes both signs, zero, small-int boundaries, every integer from -1000 through 1000, and ±10^100.
3. Exact embedded-image comparison using `pathlib`.
   - Exit status: 0.
   - Output: `embedded_bytes=2146 supplied_bytes=2146 exact_match=True`.

## Findings

No adequacy, faithfulness, coverage, overlap, claim-reuse, identifier, or compilation finding remains. The three object-representation cases do not narrow the mathematical input domain and collectively cover every integer.

VERDICT: PASS
REASON: The final symbolic claim covers all integer inputs, executes the exact supplied bytecode to normal exit, and structurally constrains both returned tuple components with faithful exhaustive summaries.
