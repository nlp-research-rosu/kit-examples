# Proof audit 1

## Decision

Final status: `VALIDATED`.

This report summarizes the recorded independent audit in clean-room session
`58951fd9-54be-4faf-b7ca-8d715131a08f`, pinned to `python-3-14-6@e5d24a5429a4`.
All positive claims closed, and the false-postcondition and executed-body
mutations were rejected. Gates A, B and C passed.

## Artifacts examined

- Original Python source and compiled `run` body in `../../../program/`.
- Original source SHA-256: `dc319cf8ad857f1386f206f54f5f2944d8b99dfe4bcbb5e7c96a1fce993f6ab1`.
- Original bytecode SHA-256: `53a7a718284b88e8aa775bbc9f794ba9fbf1bd1e64d7f092afaad744177d372f`.
  The published copy normalizes only its source filename.
- `spec.k`, `verification.k`, `program-helper.k`, `SCOPE.md`, `prove.sh`.
- Approved specification baseline `audits/spec-audit-1.md`.
- Pinned Python 3.14.6 semantics and fresh validation/proof results.

Recorded proof-source hashes:

- `spec.k`: `1a337a11620598890dfa43348f9065ad8e4387e41136a13806eb52a690d08681`.
- `verification.k`: `54475a9fe3342059a16e8fbe81a338fa54e0609ad0b319d79bb0d720d4335e61`.
- `program-helper.k`: `57e593e9db8fd598f271482d92f5d7387e5c20b4b08e08b3747ae969747f78ba`.

## Clean-room reconstruction

The audit created a separate session and copied the proof sources without
reusing construction results. The selected semantics was
`python-3-14-6@e5d24a5429a4`. The code helper matches all 69
opcode/argument pairs of the original compiled function. The packaged proof
sources retain the recorded hashes above.

## Positive proof commands and outputs

Clean-room session `58951fd9-54be-4faf-b7ca-8d715131a08f` used
`python-3-14-6@e5d24a5429a4`. The commands below normalize executable and
project paths for portability. The invocations had no claim filter, depth
bound or trusted claims:

```sh
kprover validate --session 58951fd9-54be-4faf-b7ca-8d715131a08f --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/program-helper.k
kprover prove --session 58951fd9-54be-4faf-b7ca-8d715131a08f --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/program-helper.k
```

Validation task `54ff0d43-c00e-4327-8a6e-5d75a705672b` completed with
`valid=true`, final tool exit 0. Proof task
`19d6b184-6ee2-4eb5-96ce-658f2b59d884` completed with `outcome=proved`,
final tool exit 0. Actual proof stdout:

```text
PROOF PASSED: SPEC.loop
PROOF PASSED: SPEC.entry-nonnegative-product-nonpositive-n
PROOF PASSED: SPEC.entry-negative-product-nonpositive-n
PROOF PASSED: SPEC.entry-negative-product-positive-n
PROOF PASSED: SPEC.entry-nonnegative-product-positive-n
```

The [validation result](../../evidence/58951fd9-54be-4faf-b7ca-8d715131a08f/validation-001.json) and
[proof result](../../evidence/58951fd9-54be-4faf-b7ca-8d715131a08f/proof-001.json) include the task metadata,
timings, stdout and stderr. `./prove.sh` starts a new pinned session to replay
the same positive claims with the locally configured Prover endpoint and
timeout; the recorded commands above identify the original audit.

The recorded audit also rejected a false postcondition and a changed program:

- Task 2819d980-33a2-4638-aef8-d04c468e41fd returned notProved, exit 1. At a=b=n=1, the normal-exit tuple is (1,1,1,1,1,2); the false postcondition requires last field 3.
- Task e85215b8-8e10-4f32-9961-2cea65efffcc returned notProved, exit 1. Executed unit 38 changed from addition to subtraction; the same positive witness returns (1,1,1,1,1,0), violating the required last field 2.


## Proof-extension inventory

| Extension | Purpose |
|---|---|
| `targetRunCode()` | Exact code-unit map used by the entry code object; all 69 opcode/argument pairs match `program.kpyc`. |
| `heapMax(Map)` | Computes the maximum integer heap key, with floor 4095, for freshness conditions. |
| `tupleResult`, `tuplePayload` | Check the six integer fields of the returned tuple. |
| Three `VERIFICATION` simplifications | Exact unequal-key lookup, heapMax unfolding, and absence of a key above the computed maximum. |

No operational bridge or proof-local trusted claim is used.

## Gate A — real-program soundness: PASS

The entry code object uses the exact program-defined body. Fixed semantics
executes arithmetic, branches, loops, allocations, tuple construction and
return. There is no execution-skipping bridge or trusted K claim. The audit
reviewed the full guards, equation coverage and overlap for every extension.
The result observer constrains every field of the returned tuple.

### A5 non-vacuity

Task 2819d980-33a2-4638-aef8-d04c468e41fd returned notProved, exit 1. At
a=b=n=1, the normal-exit tuple is (1,1,1,1,1,2); the false postcondition
requires last field 3.

### Program pinning and body sensitivity

Task e85215b8-8e10-4f32-9961-2cea65efffcc returned notProved, exit 1. Executed
unit 38 changed from addition to subtraction; the same positive witness
returns (1,1,1,1,1,0), violating the required last field 2.

## Residual Gate B — intent adequacy: PASS

The entry claims start at bytecode instruction 0 and partition all integer
values by the sign of `a*b` and whether `n` is positive. The loop claim
covers `0 <= i <= n` and `res = i*t`, including the loop exit boundary.
The final tuple observer constrains all six returned fields.

Fresh code/object addresses and a prepared single-interpreter frame establish
the runtime configuration needed for execution. They do not restrict the
integer payloads. No separate termination theorem is claimed.

The entry partitions cover every original integer input in the prepared-frame
scope. Cached and dynamically allocated integer representations are admitted;
allocation-freshness conditions do not bound integer payloads. No finite
unrolling or trusted loop claim substitutes for the symbolic proof.

## Gate C — trust and evidence auditability: PASS

The theorem is conditional on the pinned Python 3.14.6 semantics and the
soundness of the K/SMT proof tools. The proof does not establish that the
fixed semantics model every CPython implementation detail.

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
reference-count implementation details are outside the prepared-frame scope.

VERDICT: PASS
REASON: The recorded independent audit passed Gates A, B and C with final status VALIDATED.
