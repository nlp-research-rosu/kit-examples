VALIDATED

# Proof report

## What is proven

For every prepared state with four arbitrary mathematical integer inputs, the
exact compiled `run` body, when it reaches normal exit under the selected
Python 3.14.6 K semantics, returns the full tuple required by the source
contract. For `n>0` the result is `(n,0,0,n*(n+1)/2)`. For `n<=0` the result
is `(n,n,j,0)`, where `j` is the incoming value. This is a partial-correctness
theorem; it does not establish termination.

## Formal claim

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

## Exact commands and actual outputs

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

The [validation result](../evidence/c81c5d17-66f5-4438-ac21-a719c596d61a/validation-001.json) and
[proof result](../evidence/c81c5d17-66f5-4438-ac21-a719c596d61a/proof-001.json) include the task metadata,
timings, stdout and stderr. `./prove.sh` starts a new pinned session to replay
the same positive claims with the locally configured Prover endpoint and
timeout; the recorded commands above identify the original audit.

The recorded audit also rejected a false postcondition and a changed program:

- Task 73cafa9d-ae48-4e2f-9687-dbb3da8422f9 returned notProved, exit 1. The witness (n,i,j,count)=(0,10,-3,7) returns (0,0,-3,0), while the false postcondition requires count 1.
- Task 4ffd1a8c-6599-4a8a-96e8-879655285ff4 returned notProved, exit 1 after successful compilation. Changing executed unit 23 from addition to subtraction gives (1,0,0,-1) for n=1, contradicting the required count 1.

## Per-gate results

- **Gate A — PASS.** The exact compiled body executes under fixed semantics.
  The added equations are definitions or guarded mathematical/map facts.
  The independent false-postcondition and body mutations were rejected.
- **Gate B — PASS.** The entry claims cover the original integer input domain
  and constrain every returned tuple field within the prepared-frame scope.
- **Gate C — PASS.** The independent replay closed every claim without
  trusted claims. Successful proof and validation evidence is packaged;
  the recorded negative checks are summarized in the audit report.

## Trust boundary

The proof depends on immutable `python-3-14-6` semantics at
`e5d24a5429a4`, the K/Prover implementation and backend, and their arithmetic
and symbolic-map support. All four claims depend on this base. The proof
establishes the result only relative to that semantics and the prepared runtime
state above. The code/source bytecode comparison and mutation witnesses are
audit evidence; they are not substituted for the universal proof claims.

## Empirically supported facts

The finite source check reports 725 source cases and 672 inner-loop boundary/step checks; zero mismatches.
The executed helper matches all 56 opcode/argument pairs in the
compiled function. Run the packaged check with:

```sh
python3 audits/check-source.py
```

These finite checks support source-to-contract alignment and bytecode pinning;
the universal result comes from the proved symbolic claims.

## Excluded behavior

This report does not prove termination. It does not cover module initialization,
argument binding, reference-count implementation details, caller frames,
multiple interpreters or threads, or behavior outside the selected Python
semantics.
