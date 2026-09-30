VALIDATED

## What is proven

Under bundled semantics `python-3-14-6` pinned to repository
`https://github.com/nlp-research-rosu/semantics-python-3.14.6` at commit
`e5d24a5429a4`, one direct invocation of the exact `run` code object embedded in
`/app/program.kpyc` terminates normally for every pair of mathematical-integer
inputs `A` and `RES`.  It preserves `a` and overwrites `res` with

```text
0 - A  when A < 0
A      otherwise
```

so the returned two-element tuple denotes `(A, abs(A))`.  The theorem also
constrains final local object pointers, the complete object-memory map, tuple
and possible integer allocation, allocator `nextId`, empty stack, return-site
instruction fields, and normal terminal control.

## Formal claim

The proved claim is `SPEC.run-abs` in `inputs/spec.k`.  Its entry configuration:

- uses `absSubjectProgram()`, whose `#Kpyc(...)` term exactly matches
  `/app/program.kpyc`;
- selects the embedded `run` code object in the current frame;
- binds two fresh Python-int objects containing arbitrary `A` and `RES` to the
  `a` and `res` local slots; and
- starts at `<k> #dispatch` with no `requires` restriction.

Its target is `<k> #normalExit` with `a` still pointing to the input `a` object,
`res` pointing to the correct representation of `absSpec(A)`, and the exact
final heap/control/allocator state.  No claim was trusted and no depth bound was
used.

The required candidate-specific K deliverables are exactly:

- `inputs/spec.k` — module `SPEC` and claim `SPEC.run-abs`;
- `inputs/verification.k` — modules `VERIFICATION-SUMMARIES` and `VERIFICATION`;
- `inputs/subject.k` — module `ABS-SUBJECT`, containing the exact candidate
  image and entry-harness definitions.

Bundled `semantics.k` is intentionally not a candidate deliverable.

## Proof-extension inventory

The audited local theory contains only definitional equations plus the main
reachability claim:

- `ABS-SUBJECT`: `absSubjectProgram`, `absSubjectCode`, `absHarnessBootPlan`,
  five boot-plan field projections, `absHarnessRunCodeId`, `absHarnessAId`,
  `absHarnessResId`, `absHarnessInputObjects`, and
  `absHarnessInitialNextId` (13 equations).  These construct/project the exact
  initial term and do not rewrite execution.
- `VERIFICATION-SUMMARIES`: `absSpec` (2 equations), `absFinalObjects` (3),
  `absFinalTupleId` (3, unused by the claim), `absFinalNextId` (3),
  `absFinalResultId` (3), `absFinalInstructionPointer` (2), and
  `absFinalNextInstruction` (2), for 18 equations.  These define target values
  using disjoint exhaustive sign and small-int-representation partitions.
- `SPEC.run-abs`: one universal reachability claim executing fixed semantics
  from `#dispatch` to `#normalExit`.

There are no operational bridges, derived auxiliary claims, priority rules,
simplification shortcuts, opaque result functions, or trusted primitives in
the candidate theory.  No rule rewrites `<k>` or replaces an instruction.
`absSpec` occurs only in the final characterization, has exhaustive truthful
equations, and is connected to program behavior by the bridge-free main claim.
The full per-symbol contract record is in `/app/audits/proof-audit-1.md`.

## Exact commands and actual outputs

Fresh audit session: `a4284896-cf66-424f-9b7b-660707e9d5fa`.  All live
validation/proof tasks used `--task-timeout 1800`.

### Positive validation

```sh
kprover validate --session a4284896-cf66-424f-9b7b-660707e9d5fa --project /app --semantics python-3-14-6 --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/subject.k --claim SPEC.run-abs --task-timeout 1800
```

Actual result: exit 0; task
`b1f35056-0dbc-47d3-b1e2-deb62c4f7d72`; `status=completed`, `valid=true`, final
tool exit 0.  Retained output:
`/app/.kprover/sessions/a4284896-cf66-424f-9b7b-660707e9d5fa/validation-001/result.json`.

### Positive proof

```sh
kprover prove --session a4284896-cf66-424f-9b7b-660707e9d5fa --project /app --semantics python-3-14-6 --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/subject.k --claim SPEC.run-abs --task-timeout 1800
```

Actual result: exit 0; task
`e95b5af3-57ca-44b8-8c3c-b27bef802fac`; `status=completed`,
`outcome=proved`, final tool exit 0.  Exact stdout:

```text
PROOF PASSED: SPEC.run-abs
```

The retained metrics contain three goal-covering symbolic leaves: nonnegative,
negative with a small-int result, and negative with a non-small result.  Full
output:
`/app/.kprover/sessions/a4284896-cf66-424f-9b7b-660707e9d5fa/proof-001/result.json`.

### Independent finite evidence

```sh
python3 /app/audits/abs-summary-check.py
```

Actual exit 0 and output:

```text
samples=2014 summary_mismatches=0 program_mismatches=0
```

Successful proof commands, hashes, and recorded audit conclusions are in
`/app/audits/proof-audit-1.md`.

## Per-gate results

- **Gate A — PASS.** The actual program term executes under fixed semantics;
  there is no operational bridge or opaque result oracle; equation guards are
  disjoint/exhaustive; exact program and binding are pinned; the proof is
  sensitive to the subtraction instruction; and the well-formed false target
  is rejected with a reachable residual.
- **Gate B — PASS.** The claim covers all `A, RES : Int` with no precondition or
  bound, both branches, both tuple components, and exact object/control effects.
  It is the approved claim and was not narrowed during proving.
- **Gate C — PASS.** Assumptions and dependents are ledgered below; successful
  program proof and empirical evidence is packaged; result language separates
  formal, conditional, finite, and excluded facts.

## Trust boundary

The formal result is conditional on:

1. the pinned bundled K semantics faithfully modeling the relevant Python
   3.14.6 bytecode operations and runtime state;
2. correctness of K compilation, the Haskell backend, PyK APR orchestration,
   and constraint solving; and
3. for a source-level reading, the supplied `.kpyc` image corresponding to
   `/app/program.py`.  The formal theorem itself directly embeds and proves the
   exact `.kpyc`; exact comparison, instruction inspection, source execution,
   and sensitivity testing support the source correspondence, but no compiler
   correctness theorem is claimed.

There are no trusted K claims or candidate-local trusted primitives.

## Empirically supported facts

The finite check uses Python's built-in `abs` as an independently implemented
value oracle and executes `program.py`.  It covers explicit values
`-(10**100), -513, -257, -256, -2, -1, 0, 1, 2, 256, 257, 513, 10**100` and
every integer in `[-1000, 1000]`, with zero mismatches.  This supports only the
tested inputs and is not used as a universal proof.

## Excluded behavior

- Module import/initialization and caller-side argument binding are outside the
  direct-function-entry theorem.
- Non-integer arguments are outside the stated integer-state contract.
- Runtime cells framed by the claim, including unrelated interpreter/global
  state and I/O cells, are not independently characterized; fixed execution
  preserves or evolves them according to bundled semantics, and this function
  performs no I/O.
- Behavior of other functions, other bytecode images, other Python versions,
  and other semantics revisions is not proved.
- The reports do not prove the K semantics implementation, backend, SMT solver,
  or Python compiler correct.
