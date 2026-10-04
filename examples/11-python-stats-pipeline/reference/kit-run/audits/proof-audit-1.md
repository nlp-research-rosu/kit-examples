# Proof audit 1

## Decision

Final status: `VALIDATED`.

This report summarizes the recorded independent audit in clean-room session
`e92e3059-5fc0-417b-aba2-93dc39b5a2b6`, pinned to `python-3-14-6@e5d24a5429a4`.
All positive claims closed, and the false-postcondition and executed-body
mutations were rejected. Gates A, B and C passed.

## Artifacts examined

- Original Python source and compiled `run` body in `../../../program/`.
- Original source SHA-256: `5267723d6201747d9a0df2c3f840157712d4d44c613bd71d94d64372ab526fb0`.
- Original bytecode SHA-256: `7e15714deec3e034a50dcd1cfed36bd9dabcf07d07fbd9b6a389a47b29e48b34`.
  The published copy normalizes only its source filename.
- `spec.k`, `verification.k`, `program-helper.k`, `SCOPE.md`, `prove.sh`.
- Approved specification baseline `audits/spec-audit-1.md`.
- Pinned Python 3.14.6 semantics and fresh validation/proof results.

Recorded proof-source hashes:

- `spec.k`: `b52e81ebcf01585d8fd27f98ee0929572c86ae6f11386f76659483406e06b0aa`.
- `verification.k`: `26cfa045f9a634f21454088598c1eb0e2d4c0a6adbc0516e43c3cd3cca0c2268`.
- `program-helper.k`: `c2f07a0631f6e042a2764fdba88bcf6b339689a346cfe97bf589ccaccd64ac8c`.

## Clean-room reconstruction

The audit created a separate session and copied the proof sources without
reusing construction results. The selected semantics was
`python-3-14-6@e5d24a5429a4`. The code helper matches all 67
opcode/argument pairs of the original compiled function. The packaged proof
sources retain the recorded hashes above.

## Positive proof commands and outputs

Clean-room session `e92e3059-5fc0-417b-aba2-93dc39b5a2b6` used
`python-3-14-6@e5d24a5429a4`. The commands below normalize executable and
project paths for portability. The invocations had no claim filter, depth
bound or trusted claims:

```sh
kprover validate --session e92e3059-5fc0-417b-aba2-93dc39b5a2b6 --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/program-helper.k
kprover prove --session e92e3059-5fc0-417b-aba2-93dc39b5a2b6 --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/program-helper.k
```

Validation task `03c26a50-d469-4f4c-96bc-3d43b1d65202` completed with
`valid=true`, final tool exit 0. Proof task
`23cb20c4-f3d2-4be5-84f6-30421c279a1c` completed with `outcome=proved`,
final tool exit 0. Actual proof stdout:

```text
PROOF PASSED: SPEC.entry-ordered-nonpositive-n
PROOF PASSED: SPEC.loop
PROOF PASSED: SPEC.entry-reversed-nonpositive-n
PROOF PASSED: SPEC.entry-ordered-positive-n
PROOF PASSED: SPEC.entry-reversed-positive-n
```

The [validation result](../../evidence/e92e3059-5fc0-417b-aba2-93dc39b5a2b6/validation-002.json) and
[proof result](../../evidence/e92e3059-5fc0-417b-aba2-93dc39b5a2b6/proof-001.json) include the task metadata,
timings, stdout and stderr. `./prove.sh` starts a new pinned session to replay
the same positive claims with the locally configured Prover endpoint and
timeout; the recorded commands above identify the original audit.

The recorded audit also rejected a false postcondition and a changed program:

- Task 81397aa3-d58e-4fff-99a5-4219c4360654 returned notProved, exit 1. At a=0,b=1,n=1, adding 1 to the required final field contradicts the normal-return tuple.
- Task a76aeaae-0908-4079-9695-e7ee20fcb26e completed notProved, backend exit 1. Executed unit 24 changed from LOAD_SMALL_INT(0) to LOAD_SMALL_INT(1), giving the wrong accumulated result for a=0,b=1,n=1. A client polling error followed backend completion; it does not replace the retained terminal verdict.


## Proof-extension inventory

- `targetRunCode()` supplies the exact 67-instruction code map from the
  compiled function; the audited opcode/oparg sequence matches all 67 entries.
- `heapMax` recursively computes the maximum heap key, with the empty-map
  default 4095; its duplicate simplification equation has the same right-hand
  side.
- `tupleResult` and `tuplePayload` inspect the actual returned eight-element
  tuple and check each field as an integer object with the expected payload.
- `objectAt` skips a distinct map key under `I =/= J`.
- `in_keys` returns false for keys above the finite map's `heapMax`.

No execution-skipping rules, bridge claims, or trusted claims are used.

## Gate A — real-program soundness: PASS

The entry code object uses the exact program-defined body. Fixed semantics
executes arithmetic, branches, loops, allocations, tuple construction and
return. There is no execution-skipping bridge or trusted K claim. The audit
reviewed the full guards, equation coverage and overlap for every extension.
The result observer constrains every field of the returned tuple.

### A5 non-vacuity

Task 81397aa3-d58e-4fff-99a5-4219c4360654 returned notProved, exit 1. At
a=0,b=1,n=1, adding 1 to the required final field contradicts the
normal-return tuple.

### Program pinning and body sensitivity

Task a76aeaae-0908-4079-9695-e7ee20fcb26e completed notProved, backend exit 1.
Executed unit 24 changed from LOAD_SMALL_INT(0) to LOAD_SMALL_INT(1), giving
the wrong accumulated result for a=0,b=1,n=1. A client polling error followed
backend completion; it does not replace the retained terminal verdict.

## Residual Gate B — intent adequacy: PASS

For all integer `a`, `b`, and `n`, the return value is

`(a, b, n, min(a,b), max(a,b), max(a,b)-min(a,b), max(n,0), max(n,0)*(max(a,b)-min(a,b))+min(a,b))`.

The initial `m`, `x`, `t`, `i`, and `res` values are overwritten. The four
entry claims partition both orderings of `a` and `b` and both signs of `n`.
The positive entry claims use the proved loop claim, whose invariant is
`0 <= I <= N` and `Res = I*T`, including its exit boundary.

The entry partitions cover every original integer input in the prepared-frame
scope. Cached and dynamically allocated integer representations are admitted;
allocation-freshness conditions do not bound integer payloads. No finite
unrolling or trusted loop claim substitutes for the symbolic proof.

## Gate C — trust and evidence auditability: PASS

The proof trusts the soundness of KProver and the fixed
`python-3-14-6` semantics at commit `e5d24a5429a4`. The theorem also uses the
prepared-frame, empty-caller-stack, freshness, integer-object, and heap-framing
conditions stated in `SCOPE.md`. These conditions concern the runtime state
and do not restrict integer payloads.

The packaged evidence contains the successful construction proof, independent
positive replay and validation response, with their actual task IDs and logs.
The recorded negative checks are summarized above. Finite source checks are
separate from the universal claim:

```sh
python3 audits/check-source.py
```

1,536 source cases and 840 loop boundary/step checks; zero mismatches.

## Excluded behavior

Module initialization, argument binding, a separate termination theorem, and
reference-count implementation details are outside the theorem, as stated in
`SCOPE.md`.

VERDICT: PASS
REASON: The recorded independent audit passed Gates A, B and C with final status VALIDATED.
