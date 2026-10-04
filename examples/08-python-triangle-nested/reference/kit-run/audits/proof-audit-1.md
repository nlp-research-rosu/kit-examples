# Proof audit 1

## Decision

Final status: `VALIDATED`.

This report summarizes the recorded independent audit in clean-room session
`c81c5d17-66f5-4438-ac21-a719c596d61a`, pinned to `python-3-14-6@e5d24a5429a4`.
All positive claims closed, and the false-postcondition and executed-body
mutations were rejected. Gates A, B and C passed.

## Artifacts examined

- Original Python source and compiled `run` body in `../../../program/`.
- Original source SHA-256: `300830d7a2011cbc8207daf97bf2e8917d2e0743526a76053425f0a19457e99a`.
- Original bytecode SHA-256: `4ea2f2604b97885fa40c8573fe57dd5b2e18195776e89127ff829c1911111d80`.
  The published copy normalizes only its source filename.
- `spec.k`, `verification.k`, `program-helper.k`, `SCOPE.md`, `prove.sh`.
- Approved specification baseline `audits/spec-audit-4.md`.
- Pinned Python 3.14.6 semantics and fresh validation/proof results.

Recorded proof-source hashes:

- `spec.k`: `cb3e29cedc298fd250e48605cda53fc99d1cb7f4dcedae4b41050a50bf546cd3`.
- `verification.k`: `971b3aff2b631df8fc650471b074bc0cbf84f280bac55318f17798f9aa697954`.
- `program-helper.k`: `2b2a7d5da3cf34799f9b4d59ce5b0f6c438b4c68f31a70af148544296762d8bf`.

## Clean-room reconstruction

The audit created a separate session and copied the proof sources without
reusing construction results. The selected semantics was
`python-3-14-6@e5d24a5429a4`. The code helper matches all 56
opcode/argument pairs of the original compiled function. The packaged proof
sources retain the recorded hashes above.

## Positive proof commands and outputs

Clean-room session `c81c5d17-66f5-4438-ac21-a719c596d61a` used
`python-3-14-6@e5d24a5429a4`. The commands below normalize executable and
project paths for portability. The invocations had no claim filter, depth
bound or trusted claims:

```sh
kprover validate --session c81c5d17-66f5-4438-ac21-a719c596d61a --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/program-helper.k
kprover prove --session c81c5d17-66f5-4438-ac21-a719c596d61a --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/program-helper.k
```

Validation task `17dddf53-4d22-4e58-ae1c-df7b034e3a78` completed with
`valid=true`, final tool exit 0. Proof task
`508851ee-3350-4ffa-ad80-fc4e75fe4647` completed with `outcome=proved`,
final tool exit 0. Actual proof stdout:

```text
PROOF PASSED: SPEC.inner
PROOF PASSED: SPEC.entry-nonpositive
PROOF PASSED: SPEC.outer
PROOF PASSED: SPEC.entry-positive
```

The [validation result](../../evidence/c81c5d17-66f5-4438-ac21-a719c596d61a/validation-001.json) and
[proof result](../../evidence/c81c5d17-66f5-4438-ac21-a719c596d61a/proof-001.json) include the task metadata,
timings, stdout and stderr. `./prove.sh` starts a new pinned session to replay
the same positive claims with the locally configured Prover endpoint and
timeout; the recorded commands above identify the original audit.

The recorded audit also rejected a false postcondition and a changed program:

- Task 73cafa9d-ae48-4e2f-9687-dbb3da8422f9 returned notProved, exit 1. The witness (n,i,j,count)=(0,10,-3,7) returns (0,0,-3,0), while the false postcondition requires count 1.
- Task 4ffd1a8c-6599-4a8a-96e8-879655285ff4 returned notProved, exit 1 after successful compilation. Changing executed unit 23 from addition to subtraction gives (1,0,0,-1) for n=1, contradicting the required count 1.


## Proof-extension inventory

- `targetRunCode()` defines the exact 56-unit code map. It is the code object
  executed by the claims, not an execution summary.
- `heapMax` is a terminating recursive finite-map maximum with base value
  4095. It supports fresh-address reasoning and does not affect the tuple.
- `tupleResult` and `tuplePayload` are result observers that read all four
  returned integer objects and express the exact doubled-count equality.
- The two integer distributivity equations are derived mathematical laws.
- The guarded `objectAt` map-tail equation is valid for unequal keys.
- The `heapMax` simplification repeats its defining recursion; the guarded
  `in_keys` equation is valid because no key exceeds a finite map's maximum.
- `inner` and `outer` carry the loop invariants. All four proof claims were
  proved; none was trusted. There are no operational bridges or opaque
  program-derived values.

## Gate A — real-program soundness: PASS

The entry code object uses the exact program-defined body. Fixed semantics
executes arithmetic, branches, loops, allocations, tuple construction and
return. There is no execution-skipping bridge or trusted K claim. The audit
reviewed the full guards, equation coverage and overlap for every extension.
The result observer constrains every field of the returned tuple.

### A5 non-vacuity

Task 73cafa9d-ae48-4e2f-9687-dbb3da8422f9 returned notProved, exit 1. The
witness (n,i,j,count)=(0,10,-3,7) returns (0,0,-3,0), while the false
postcondition requires count 1.

### Program pinning and body sensitivity

Task 4ffd1a8c-6599-4a8a-96e8-879655285ff4 returned notProved, exit 1 after
successful compilation. Changing executed unit 23 from addition to subtraction
gives (1,0,0,-1) for n=1, contradicting the required count 1.

## Residual Gate B — intent adequacy: PASS

The entry claims `entry-positive` and `entry-nonpositive` cover the complete
integer domain for `n`; `i`, `j`, and `count` are arbitrary integers. The
final tuple observer checks each of the four integer payloads. Its fourth
argument states twice the returned count, so the positive result condition
`2*count=n*(n+1)` is exactly the triangular-number result over integers.

The theorem starts at bytecode instruction 0 in a prepared frame with an
empty caller stack, one interpreter, one thread, and a fresh code address and
allocation cursor. Both static and dynamic integer references are allowed;
aliasing is allowed when payload constraints agree. Module initialization,
call argument binding, reference-count details, and a termination theorem are
outside the scope in `SCOPE.md`.

The entry partitions cover every original integer input in the prepared-frame
scope. Cached and dynamically allocated integer representations are admitted;
allocation-freshness conditions do not bound integer payloads. No finite
unrolling or trusted loop claim substitutes for the symbolic proof.

## Gate C — trust and evidence auditability: PASS

The proof depends on immutable `python-3-14-6` semantics at
`e5d24a5429a4`, the K/Prover implementation and backend, and their arithmetic
and symbolic-map support. All four claims depend on this base. The proof
establishes the result only relative to that semantics and the prepared runtime
state above. The code/source bytecode comparison and mutation witnesses are
audit evidence; they are not substituted for the universal proof claims.

The packaged evidence contains the successful construction proof, independent
positive replay and validation response, with their actual task IDs and logs.
The recorded negative checks are summarized above. Finite source checks are
separate from the universal claim:

```sh
python3 audits/check-source.py
```

725 source cases and 672 inner-loop boundary/step checks; zero mismatches.

## Excluded behavior

This report does not prove termination. It does not cover module initialization,
argument binding, reference-count implementation details, caller frames,
multiple interpreters or threads, or behavior outside the selected Python
semantics.

VERDICT: PASS
REASON: The recorded independent audit passed Gates A, B and C with final status VALIDATED.
