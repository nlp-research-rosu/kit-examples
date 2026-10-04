VALIDATED

# Proof report

## What is proven

Under the fixed `python-3-14-6` semantics at `e5d24a5429a4`, for every
mathematical integer `n`, if the exact compiled `run` body terminates normally
from the prepared frame in `SCOPE.md`, its result is `(n,n,ceil(n/2))` for
`n >= 0` and `(n,0,0)` for `n < 0`. Initial integer values in `i` and
`count` are unrestricted and overwritten by the body.

## Formal claim

The entry claims cover all integer N and arbitrary initial integer I and C. For N >= 0, the loop invariant is 0 <= i <= N and 2*count = i + (i mod 2), including i=N. The negative entry bypasses the loop. The returned tuple is `(N,0,0)` for `N < 0`; `(N,N,(N+1)//2)` for `N >= 0`.

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

## Exact commands and actual outputs

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

The [validation result](../evidence/273e8b13-70fc-4b4d-b74d-48cd38ccace4/validation-001.json) and
[proof result](../evidence/273e8b13-70fc-4b4d-b74d-48cd38ccace4/proof-001.json) include the task metadata,
timings, stdout and stderr. `./prove.sh` starts a new pinned session to replay
the same positive claims with the locally configured Prover endpoint and
timeout; the recorded commands above identify the original audit.

The recorded audit also rejected a false postcondition and a changed program:

- Task 3008c7aa-d13d-4892-8c29-24b4d6ba2d97 returned notProved, exit 1. For n=-1 the false postcondition requires twice the returned count to equal 1. The body returns count 0, and the residual reaches normal exit with that unmet condition.
- Task ba52df88-2eb7-46f3-b2e9-d8cd8c6b89f1 returned notProved, exit 1. Executed unit 26 changes from LOAD_SMALL_INT(1) to LOAD_SMALL_INT(2). With n=1 and initial i=count=0, the changed body returns (1,1,2), contradicting the required count 1.

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

The result is conditional on the pinned fixed semantics and on the soundness
of the K/Prover execution of the submitted reachability claims. No additional
candidate-local abstraction is left unproved. The theorem covers a single
prepared interpreter/thread frame with no caller frame and a fresh allocation
cursor; it does not model module creation, argument binding, or reference
count implementation details.

## Empirically supported facts

The finite source check reports 1,848 source cases and 601 invariant boundary/step checks; zero mismatches.
The executed helper matches all 51 opcode/argument pairs in the
compiled function. Run the packaged check with:

```sh
python3 audits/check-source.py
```

These finite checks support source-to-contract alignment and bytecode pinning;
the universal result comes from the proved symbolic claims.

## Excluded behavior

The proof does not establish termination as a separate theorem. It does not
cover module initialization, call binding, reference-count details, caller
frames, multiple interpreters or threads, or semantics revisions other than
`python-3-14-6` at `e5d24a5429a4`. Its input domain is fixed-semantics integer
objects (`#idInt`), not other Python value classes.
