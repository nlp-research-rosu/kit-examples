# Proof audit 1

## Decision

Final status: `VALIDATED`.

This report summarizes the recorded independent audit in clean-room session
`03008422-572b-4ea7-bc9c-a37ff47fef2e`, pinned to `python-3-14-6@e5d24a5429a4`.
All positive claims closed, and the false-postcondition and executed-body
mutations were rejected. Gates A, B and C passed.

## Artifacts examined

- Original Python source and compiled `run` body in `../../../program/`.
- Original source SHA-256: `537c4fc18fa6af0971ff19e6262b7bcbbd8e677d64004f4b1662580958a3f3d4`.
- Original bytecode SHA-256: `9ff51f832461cb60f971b3f0990577be93b1615eee75c0d55cc2096992ab88a5`.
  The published copy normalizes only its source filename.
- `spec.k`, `verification.k`, `program-helper.k`, `SCOPE.md`, `prove.sh`.
- Approved specification baseline `audits/spec-audit-2.md`.
- Pinned Python 3.14.6 semantics and fresh validation/proof results.

Recorded proof-source hashes:

- `spec.k`: `d132f4a135cab8ef70a635e95cf7d9bf2b6ddf090db4b9155d00b4b873cb79d8`.
- `verification.k`: `4fe7a4e8538e55a36e230f967a2d8cd9afcd7755b3f0c8ace2289c9e61831626`.
- `program-helper.k`: `30dff54fddf1ab6ce62c6f7bbdf7f83ab1487a10413c0f270647a4d692a92eb8`.

## Clean-room reconstruction

The audit created a separate session and copied the proof sources without
reusing construction results. The selected semantics was
`python-3-14-6@e5d24a5429a4`. The code helper matches all 65
opcode/argument pairs of the original compiled function. The packaged proof
sources retain the recorded hashes above.

## Positive proof commands and outputs

Clean-room session `03008422-572b-4ea7-bc9c-a37ff47fef2e` used
`python-3-14-6@e5d24a5429a4`. The commands below normalize executable and
project paths for portability. The invocations had no claim filter, depth
bound or trusted claims:

```sh
kprover validate --session 03008422-572b-4ea7-bc9c-a37ff47fef2e --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/program-helper.k
kprover prove --session 03008422-572b-4ea7-bc9c-a37ff47fef2e --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/program-helper.k
```

Validation task `ccdcd241-2449-4acf-8721-fc1bb8e4d16f` completed with
`valid=true`, final tool exit 0. Proof task
`2d5a58dc-0bc5-40e1-8362-f5bbffac5466` completed with `outcome=proved`,
final tool exit 0. Actual proof stdout:

```text
PROOF PASSED: SPEC.inner-a
PROOF PASSED: SPEC.inner-b
PROOF PASSED: SPEC.outer-disabled
PROOF PASSED: SPEC.entry-nonpositive-a
PROOF PASSED: SPEC.outer-within-a
PROOF PASSED: SPEC.outer-within-b
PROOF PASSED: SPEC.entry-disabled
PROOF PASSED: SPEC.entry-within
PROOF PASSED: SPEC.outer-above
PROOF PASSED: SPEC.entry-above
```

The [validation result](../../evidence/03008422-572b-4ea7-bc9c-a37ff47fef2e/validation-001.json) and
[proof result](../../evidence/03008422-572b-4ea7-bc9c-a37ff47fef2e/proof-001.json) include the task metadata,
timings, stdout and stderr. `./prove.sh` starts a new pinned session to replay
the same positive claims with the locally configured Prover endpoint and
timeout; the recorded commands above identify the original audit.

The recorded audit also rejected a false postcondition and a changed program:

- Task 206e2b45-4380-4fbc-96b8-5eba21d79924 returned notProved, exit 1. For a=b=1 the false observer requires doubled count 4, while the normal-return result has doubled count 2. The residual has a satisfiable #Top path condition.
- Task 5c8510ed-7f87-4164-8327-3cea06c8c83c returned notProved, exit 1 after successful compilation. Changing executed unit 29 from addition to subtraction yields (1,1,0,0,-1) for a=b=1. Both loops execute, and the original result condition fails.


## Proof-extension inventory

The clean source inventory contains no operational bridge, opaque result,
trusted claim, or priority rule. `targetRunCode` is a total function that
defines the exact 65 compiled code units used in the initial `PyCodeObject`;
it does not skip execution or summarize a result. The observer functions
`tupleResult` and `tuplePayload` inspect the allocated five-element tuple and
its integer payloads. `heapMax` is a total map traversal with a 4095 floor,
used for the fresh-allocation precondition.

The proof-local simplifications are two generic integer distributivity
identities, the guarded map-lookup equation that skips a different key, the
recursive `heapMax` equation (also present as its function definition), and
the rule that a key greater than `heapMax(M)` is absent from `M`. The
arithmetic identities are true over unbounded K `Int`; their expansion
overlaps yield the same polynomial. The map lookup equation follows from
`I != J`. The membership rule follows from the maximum-key definition and
guard. The duplicate `heapMax` equation has the same right-hand side. None
changes the imported `VERIFICATION-SUMMARIES` definitions or alters fixed
Python execution. The generated final counter in the tuple observer identifies
the tuple allocation at `FinalNext - 1`; it is not a free result abstraction.

## Gate A — real-program soundness: PASS

The entry code object uses the exact program-defined body. Fixed semantics
executes arithmetic, branches, loops, allocations, tuple construction and
return. There is no execution-skipping bridge or trusted K claim. The audit
reviewed the full guards, equation coverage and overlap for every extension.
The result observer constrains every field of the returned tuple.

### A5 non-vacuity

Task 206e2b45-4380-4fbc-96b8-5eba21d79924 returned notProved, exit 1. For
a=b=1 the false observer requires doubled count 4, while the normal-return
result has doubled count 2. The residual has a satisfiable #Top path
condition.

### Program pinning and body sensitivity

Task 5c8510ed-7f87-4164-8327-3cea06c8c83c returned notProved, exit 1 after
successful compilation. Changing executed unit 29 from addition to subtraction
yields (1,1,0,0,-1) for a=b=1. Both loops execute, and the original result
condition fails.

## Residual Gate B — intent adequacy: PASS

The returned tuple is `(a, b, min(a, 0), j_final, r)`, where
`j_final = 0` when `a > 0` and `b > 0`, and otherwise `j_final` is the incoming
`j`. The final count satisfies
`2 * r = L * (L + 1)`, with `L = max(0, min(a, b))`. This is the triangular
count property expressed without division. The returned first four fields are
observed directly, and the observer checks the fifth field using the doubled
count equation. Incoming `i` and `res` are overwritten by the body.

All five incoming locals contain arbitrary mathematical `Int` payloads. The
preconditions admit cached and dynamic integer representations and permit
aliasing where the aliased payload constraints agree. They constrain code
address and allocation freshness for a well-formed runtime state, not the
numeric values of the input integers. The four entry claims partition all
integer `a,b`: `a <= 0`, `a > 0` with `b <= 0`, `0 < a <= b`, and `0 < b < a`.

The entry partitions cover every original integer input in the prepared-frame
scope. Cached and dynamically allocated integer representations are admitted;
allocation-freshness conditions do not bound integer payloads. No finite
unrolling or trusted loop claim substitutes for the symbolic proof.

## Gate C — trust and evidence auditability: PASS

The result is conditional on the fixed `python-3-14-6` semantics at commit
`e5d24a5429a4`, K's proof engine, and the stated prepared-frame preconditions.
The proof does not rely on a trusted claim, external oracle, finite testing,
or an unchecked result abstraction. The code map and tuple observer are
explicit definitions in the proof inputs.

The packaged evidence contains the successful construction proof, independent
positive replay and validation response, with their actual task IDs and logs.
The recorded negative checks are summarized above. Finite source checks are
separate from the universal claim:

```sh
python3 audits/check-source.py
```

2,420 source cases and 672 inner-loop boundary/step checks; zero mismatches.

## Excluded behavior

The theorem covers only the prepared single-interpreter, single-thread frame
and normal exit. Module initialization, argument binding, a separate
termination theorem, and reference-count implementation details are outside
scope. The preconditions require a fresh code address and allocation cursor;
they do not bound integer payloads.

VERDICT: PASS
REASON: The recorded independent audit passed Gates A, B and C with final status VALIDATED.
