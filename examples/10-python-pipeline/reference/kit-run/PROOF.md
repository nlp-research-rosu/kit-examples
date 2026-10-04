VALIDATED

# Proof report

## What is proven

Under the pinned Python 3.14.6 semantics, every normal return from the
exact compiled body of `run(a, b, n, t, i, res)` in the specified prepared
runtime frame satisfies the tuple postcondition below. The six input slots
contain arbitrary mathematical integers. This is a partial-correctness claim;
no separate termination theorem is claimed. The returned tuple is
`(a, b, n, abs(a*b), max(n,0), max(n,0)*abs(a*b)+a)`.

The audit replay proved all five claims. No claim was admitted as trusted.

## Formal claim

The entry claims start at bytecode instruction 0 and partition all integer
values by the sign of `a*b` and whether `n` is positive. The loop claim
covers `0 <= i <= n` and `res = i*t`, including the loop exit boundary.
The final tuple observer constrains all six returned fields.

Fresh code/object addresses and a prepared single-interpreter frame establish
the runtime configuration needed for execution. They do not restrict the
integer payloads. No separate termination theorem is claimed.

## Proof-extension inventory

| Extension | Purpose |
|---|---|
| `targetRunCode()` | Exact code-unit map used by the entry code object; all 69 opcode/argument pairs match `program.kpyc`. |
| `heapMax(Map)` | Computes the maximum integer heap key, with floor 4095, for freshness conditions. |
| `tupleResult`, `tuplePayload` | Check the six integer fields of the returned tuple. |
| Three `VERIFICATION` simplifications | Exact unequal-key lookup, heapMax unfolding, and absence of a key above the computed maximum. |

No operational bridge or proof-local trusted claim is used.

## Exact commands and actual outputs

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

The [validation result](../evidence/58951fd9-54be-4faf-b7ca-8d715131a08f/validation-001.json) and
[proof result](../evidence/58951fd9-54be-4faf-b7ca-8d715131a08f/proof-001.json) include the task metadata,
timings, stdout and stderr. `./prove.sh` starts a new pinned session to replay
the same positive claims with the locally configured Prover endpoint and
timeout; the recorded commands above identify the original audit.

The recorded audit also rejected a false postcondition and a changed program:

- Task 2819d980-33a2-4638-aef8-d04c468e41fd returned notProved, exit 1. At a=b=n=1, the normal-exit tuple is (1,1,1,1,1,2); the false postcondition requires last field 3.
- Task e85215b8-8e10-4f32-9961-2cea65efffcc returned notProved, exit 1. Executed unit 38 changed from addition to subtraction; the same positive witness returns (1,1,1,1,1,0), violating the required last field 2.

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

The theorem is conditional on the pinned Python 3.14.6 semantics and the
soundness of the K/SMT proof tools. The proof does not establish that the
fixed semantics model every CPython implementation detail.

## Empirically supported facts

The finite source check reports 1,536 source cases and 840 loop boundary/step checks; zero mismatches.
The executed helper matches all 69 opcode/argument pairs in the
compiled function. Run the packaged check with:

```sh
python3 audits/check-source.py
```

These finite checks support source-to-contract alignment and bytecode pinning;
the universal result comes from the proved symbolic claims.

## Excluded behavior

Module initialization, argument binding, a separate termination theorem, and
reference-count implementation details are outside the prepared-frame scope.
