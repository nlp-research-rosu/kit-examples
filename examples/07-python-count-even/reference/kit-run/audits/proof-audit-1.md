# Proof audit 1

## Decision

Final status: `VALIDATED`.

This report summarizes the recorded independent audit in clean-room session
`273e8b13-70fc-4b4d-b74d-48cd38ccace4`, pinned to `python-3-14-6@e5d24a5429a4`.
All positive claims closed, and the false-postcondition and executed-body
mutations were rejected. Gates A, B and C passed.

## Artifacts examined

- Original Python source and compiled `run` body in `../../../program/`.
- Original source SHA-256: `ff77fe50f01c305a6d493641fcf1ef4acff5774f252b0336f5e4b8834f451241`.
- Original bytecode SHA-256: `cf786ab4e19ee4324c76af98daebce4057af482d68736a7cd1354f9f5b980d75`.
  The published copy normalizes only its source filename.
- `spec.k`, `verification.k`, `program-helper.k`, `SCOPE.md`, `prove.sh`.
- Approved specification baseline `audits/spec-audit-1.md`.
- Pinned Python 3.14.6 semantics and fresh validation/proof results.

Recorded proof-source hashes:

- `spec.k`: `ce6a732dde995af9ccdb478d582ae2dc53d62fc9dff51e986641be18050acb1a`.
- `verification.k`: `2b67ba66d060ed810f95aab648297bc9c058708c6ca4dcc896efc5abaf866b1c`.
- `program-helper.k`: `55fa781fe8acb6d1bbd7869f9ad4acd4b2f3aefe051e4c4263c0a835e1ff480e`.

## Clean-room reconstruction

The audit created a separate session and copied the proof sources without
reusing construction results. The selected semantics was
`python-3-14-6@e5d24a5429a4`. The code helper matches all 51
opcode/argument pairs of the original compiled function. The packaged proof
sources retain the recorded hashes above.

## Positive proof commands and outputs

Clean-room session `273e8b13-70fc-4b4d-b74d-48cd38ccace4` used
`python-3-14-6@e5d24a5429a4`. The commands below normalize executable and
project paths for portability. The invocations had no claim filter, depth
bound or trusted claims:

```sh
kprover validate --session 273e8b13-70fc-4b4d-b74d-48cd38ccace4 --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/program-helper.k
kprover prove --session 273e8b13-70fc-4b4d-b74d-48cd38ccace4 --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/program-helper.k
```

Validation task `33f880e9-2a62-41ba-9e7f-58c793f32a94` completed with
`valid=true`, final tool exit 0. Proof task
`9d44ec6f-93e4-4568-86bc-d63c98ebeaa7` completed with `outcome=proved`,
final tool exit 0. Actual proof stdout:

```text
PROOF PASSED: SPEC.loop
PROOF PASSED: SPEC.entry-negative
PROOF PASSED: SPEC.entry-nonnegative
```

The [validation result](../../evidence/273e8b13-70fc-4b4d-b74d-48cd38ccace4/validation-001.json) and
[proof result](../../evidence/273e8b13-70fc-4b4d-b74d-48cd38ccace4/proof-001.json) include the task metadata,
timings, stdout and stderr. `./prove.sh` starts a new pinned session to replay
the same positive claims with the locally configured Prover endpoint and
timeout; the recorded commands above identify the original audit.

The recorded audit also rejected a false postcondition and a changed program:

- Task 3008c7aa-d13d-4892-8c29-24b4d6ba2d97 returned notProved, exit 1. For n=-1 the false postcondition requires twice the returned count to equal 1. The body returns count 0, and the residual reaches normal exit with that unmet condition.
- Task ba52df88-2eb7-46f3-b2e9-d8cd8c6b89f1 returned notProved, exit 1. Executed unit 26 changes from LOAD_SMALL_INT(1) to LOAD_SMALL_INT(2). With n=1 and initial i=count=0, the changed body returns (1,1,2), contradicting the required count 1.


## Proof-extension inventory

| Extension | Class and role | Review |
|---|---|---|
| `targetRunCode()` | Definitional encoding of code data | One total equation contains the 51 compiled units; fixed semantics executes them. It is not an execution bridge. |
| `heapMax` equations | Definitional summary | Recursive maximum over finite map keys, with 4095 for the empty map. The duplicate simplification has the same right side. |
| `objectAt` map-tail simplification | Derived map lemma | Guard `I =/= J` preserves ordinary map lookup. |
| `I in_keys(M) => false` when `I > heapMax(M)` | Derived map lemma | The guard places `I` above every key in the finite map. |
| `tripleResult`, `triplePayload` | Definitional result observer | Reads the final allocated tuple, verifies three integer objects, and checks its values including `2 * count == TwiceCount`. Non-tuple shapes remain unmatched. |

There is no operational bridge, priority rule, opaque result, or auxiliary
claim. `SPEC.entry-nonnegative` depends on `SPEC.loop`; `SPEC.entry-negative`
does not. The loop invariant covers `0 <= i <= n` and
`2*count = i + (i mod 2)`, including `i=n`.

The observer points to `FinalNext - 1`. In the fixed semantics,
`BUILD_TUPLE` at code unit 49 is the final allocation and `RETURN_VALUE` at
unit 50 consumes that reference on the top-level normal-exit path. Thus the
observed heap object is the returned tuple in the stated empty-caller-frame
scope.

## Gate A — real-program soundness: PASS

The entry code object uses the exact program-defined body. Fixed semantics
executes arithmetic, branches, loops, allocations, tuple construction and
return. There is no execution-skipping bridge or trusted K claim. The audit
reviewed the full guards, equation coverage and overlap for every extension.
The result observer constrains every field of the returned tuple.

### A5 non-vacuity

Task 3008c7aa-d13d-4892-8c29-24b4d6ba2d97 returned notProved, exit 1. For n=-1
the false postcondition requires twice the returned count to equal 1. The body
returns count 0, and the residual reaches normal exit with that unmet
condition.

### Program pinning and body sensitivity

Task ba52df88-2eb7-46f3-b2e9-d8cd8c6b89f1 returned notProved, exit 1. Executed
unit 26 changes from LOAD_SMALL_INT(1) to LOAD_SMALL_INT(2). With n=1 and
initial i=count=0, the changed body returns (1,1,2), contradicting the
required count 1.

## Residual Gate B — intent adequacy: PASS

The entry claims cover all integer N and arbitrary initial integer I and C. For N >= 0, the loop invariant is 0 <= i <= N and 2*count = i + (i mod 2), including i=N. The negative entry bypasses the loop. The returned tuple is `(N,0,0)` for `N < 0`; `(N,N,(N+1)//2)` for `N >= 0`.

The entry partitions cover every original integer input in the prepared-frame
scope. Cached and dynamically allocated integer representations are admitted;
allocation-freshness conditions do not bound integer payloads. No finite
unrolling or trusted loop claim substitutes for the symbolic proof.

## Gate C — trust and evidence auditability: PASS

The result is conditional on the pinned fixed semantics and on the soundness
of the K/Prover execution of the submitted reachability claims. No additional
candidate-local abstraction is left unproved. The theorem covers a single
prepared interpreter/thread frame with no caller frame and a fresh allocation
cursor; it does not model module creation, argument binding, or reference
count implementation details.

The packaged evidence contains the successful construction proof, independent
positive replay and validation response, with their actual task IDs and logs.
The recorded negative checks are summarized above. Finite source checks are
separate from the universal claim:

```sh
python3 audits/check-source.py
```

1,848 source cases and 601 invariant boundary/step checks; zero mismatches.

## Excluded behavior

The proof does not establish termination as a separate theorem. It does not
cover module initialization, call binding, reference-count details, caller
frames, multiple interpreters or threads, or semantics revisions other than
`python-3-14-6` at `e5d24a5429a4`. Its input domain is fixed-semantics integer
objects (`#idInt`), not other Python value classes.

VERDICT: PASS
REASON: The recorded independent audit passed Gates A, B and C with final status VALIDATED.
