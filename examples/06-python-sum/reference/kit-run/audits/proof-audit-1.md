# Proof audit 1

## Decision

Final status: `VALIDATED`.

This report summarizes the recorded independent audit in clean-room session
`4f14b139-8202-4fa2-bc9d-1e97c1a638f3`, pinned to `python-3-14-6@e5d24a5429a4`.
All positive claims closed, and the false-postcondition and executed-body
mutations were rejected. Gates A, B and C passed.

## Artifacts examined

- Original Python source and compiled `run` body in `../../../program/`.
- Original source SHA-256: `a6bd139ded079fe7a29109726ebfd77f81b9571a203012cad9f7b95035d10ee6`.
- Original bytecode SHA-256: `40999f14d492d5cf15b462f1b5a840fd7afaf93d9c2ff311a1b0a9e4f2bb2f1b`.
  The published copy normalizes only its source filename.
- `spec.k`, `verification.k`, `program-helper.k`, `SCOPE.md`, `prove.sh`.
- Approved specification baseline `audits/spec-audit-1.md`.
- Pinned Python 3.14.6 semantics and fresh validation/proof results.

Recorded proof-source hashes:

- `spec.k`: `3902fe86347493fc71476ef0ac66a0a0165232084a6b58f1024f040204671b99`.
- `verification.k`: `a5ee1cc6c2a07863f9d83c89bec40b3e1561b9e645bfb2e11c7644034fe8a800`.
- `program-helper.k`: `d12fe42fcc3d89a779677008f0b0ae194f3502cfce7d6ebfbd340c2c6d92a7b8`.

## Clean-room reconstruction

The audit created a separate session and copied the proof sources without
reusing construction results. The selected semantics was
`python-3-14-6@e5d24a5429a4`. The code helper matches all 30
opcode/argument pairs of the original compiled function. The packaged proof
sources retain the recorded hashes above.

## Positive proof commands and outputs

Clean-room session `4f14b139-8202-4fa2-bc9d-1e97c1a638f3` used
`python-3-14-6@e5d24a5429a4`. The commands below normalize executable and
project paths for portability. The invocations had no claim filter, depth
bound or trusted claims:

```sh
kprover validate --session 4f14b139-8202-4fa2-bc9d-1e97c1a638f3 --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/program-helper.k --project .
kprover prove --session 4f14b139-8202-4fa2-bc9d-1e97c1a638f3 --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/program-helper.k --project .
```

Validation task `8a32e095-0349-4bda-9e36-733bfb4f2151` completed with
`valid=true`, final tool exit 0. Proof task
`7b3e48eb-a57c-4b5c-8f98-50355b34878c` completed with `outcome=proved`,
final tool exit 0. Actual proof stdout:

```text
PROOF PASSED: SPEC.nonpositive
PROOF PASSED: SPEC.loop
PROOF PASSED: SPEC.entry-negative
PROOF PASSED: SPEC.entry-positive
```

The [validation result](../../evidence/4f14b139-8202-4fa2-bc9d-1e97c1a638f3/validation-001.json) and
[proof result](../../evidence/4f14b139-8202-4fa2-bc9d-1e97c1a638f3/proof-001.json) include the task metadata,
timings, stdout and stderr. `./prove.sh` starts a new pinned session to replay
the same positive claims with the locally configured Prover endpoint and
timeout; the recorded commands above identify the original audit.

The recorded audit also rejected a false postcondition and a changed program:

- Task c9eabcd3-f3b8-4232-a2f5-2a09125ef50c returned notProved, exit 1. At N=S=0, the program returns (0,0); the false postcondition requires (1,0). The mutation changes the first tuple field, and its residual reaches normal exit.
- Task a3ce9872-df5a-4a0e-83ec-40ba58625284 returned notProved, exit 2. Changing executed unit 2 from LOAD_SMALL_INT(0) to LOAD_SMALL_INT(1) makes n=1 return (1,s), contradicting the required (0,s+1).


## Proof-extension inventory

| Extension | Class | Role and justification |
|---|---|---|
| `targetRunCode()` | Definitional summary | Exact constant map of the 30 code units from the nested `run` code object. Fixed Python semantics fetches and executes it; it does not replace execution. |
| `heapMax(Map)` | Definitional summary | Computes the maximum Int key with floor 4095 over finite maps. The recursive equation removes one Int entry; the `owise` floor covers maps with none. Its proof-local simplification has the same right-hand side. |
| `pairResult`, `pairPayload` | Definitional summaries | Observe the last allocated object and require an exact two-reference tuple with integer values. Malformed shapes do not reduce to true. |
| Disjoint-key `objectAt` equation | Derived lemma | With `I =/= J`, removing map key `J` preserves lookup at `I`. It does not update state. |
| `in_keys` absence equation | Derived lemma | With `I > heapMax(M)`, the Int key `I` is absent. |
| Integer ring identity | Derived lemma | Simplifies `2*(S+N)+(N-1)*N` to `2*S+N*(N+1)`; true for all K integers. |

There are no operational bridges, priority rewrites, opaque result symbols,
or proof-local trusted claims. The loop, arithmetic, allocation, tuple build,
and return all execute through the pinned semantics.

## Gate A — real-program soundness: PASS

The entry code object uses the exact program-defined body. Fixed semantics
executes arithmetic, branches, loops, allocations, tuple construction and
return. There is no execution-skipping bridge or trusted K claim. The audit
reviewed the full guards, equation coverage and overlap for every extension.
The result observer constrains every field of the returned tuple.

### A5 non-vacuity

Task c9eabcd3-f3b8-4232-a2f5-2a09125ef50c returned notProved, exit 1. At
N=S=0, the program returns (0,0); the false postcondition requires (1,0). The
mutation changes the first tuple field, and its residual reaches normal exit.

### Program pinning and body sensitivity

Task a3ce9872-df5a-4a0e-83ec-40ba58625284 returned notProved, exit 2. Changing
executed unit 2 from LOAD_SMALL_INT(0) to LOAD_SMALL_INT(1) makes n=1 return
(1,s), contradicting the required (0,s+1).

## Residual Gate B — intent adequacy: PASS

The entry claims cover arbitrary mathematical integers `N` and `S`, with no
value bounds. The input references designate exact `#PyLongObject` values;
they may alias when the values agree. References may use cached integers or
heap objects. The initial object map contains the code object at address `C`
as an entry disjoint from `REST`; `C < Next` and `heapMax(REST) < Next`. The
allocator starts at or above 4096.

- `SPEC.entry-negative`: from code unit 0 with `N < 0`, normal return has
  first value `N` and second value whose double is `2*S`.
- `SPEC.entry-positive`: from code unit 0 with `N >= 0`, normal return has
  first value 0 and second value whose double is
  `2*S + N*(N+1)`.
- `SPEC.nonpositive` and `SPEC.loop` establish the corresponding body
  claims after the initial `RESUME` instruction. `SPEC.loop` is a K
  circularity claim proved by the backend, not an admitted trusted claim.

The postcondition reads the final allocated tuple through
`pairResult(FinalNext-1, FinalObjects, ...)`. Its second-value equation is
equivalent to the usual half-triangular-number expression over integers.

The entry partitions cover every original integer input in the prepared-frame
scope. Cached and dynamically allocated integer representations are admitted;
allocation-freshness conditions do not bound integer payloads. No finite
unrolling or trusted loop claim substitutes for the symbolic proof.

## Gate C — trust and evidence auditability: PASS

All four claims were proved under the immutable server semantics
`python-3-14-6`, commit `e5d24a5429a4`, using Prover K 7.1.337. The proof
is conditional on that fixed semantics and the soundness of the Prover/APR
implementation. No claim is marked trusted. The audit does not establish
that the semantics models every detail of a particular CPython build or its
physical resource limits.

The packaged evidence contains the successful construction proof, independent
positive replay and validation response, with their actual task IDs and logs.
The recorded negative checks are summarized above. Finite source checks are
separate from the universal claim:

```sh
python3 audits/check-source.py
```

165 source-versus-contract cases; zero mismatches.

## Excluded behavior

This theorem starts at the initialized frame for the nested `run` body. It
excludes argument binding, caller continuations, and top-level module
execution. It covers exact built-in integers, not booleans or int subclasses.
It does not claim behavior under physical memory exhaustion, object-address
limits, tracing, or traceback inspection. Heap shape is constrained only as
stated in the entry preconditions; unrelated external state is outside the
claim.

VERDICT: PASS
REASON: The recorded independent audit passed Gates A, B and C with final status VALIDATED.
