VALIDATED

# Proof report

## What is proven

This is a partial-correctness theorem under the fixed `python-3-14-6`
semantics. For the unchanged bytecode body of `run(n, sum)`, when execution
reaches normal return from any initialized frame in the stated domain, the
two-item tuple contains the intended integer values. For `n <= 0`, the tuple
is `(n, sum)`. For `n > 0`, it is `(0, sum+n(n+1)/2)`. No separate
termination theorem is claimed.

This is a function-body theorem. The initial frame already has its two local
slots populated and has no caller frame. It does not prove argument binding,
caller behavior, or execution of the module-level function definition.

## Formal claim

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

## Exact commands and actual outputs

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

The [validation result](../evidence/4f14b139-8202-4fa2-bc9d-1e97c1a638f3/validation-001.json) and
[proof result](../evidence/4f14b139-8202-4fa2-bc9d-1e97c1a638f3/proof-001.json) include the task metadata,
timings, stdout and stderr. `./prove.sh` starts a new pinned session to replay
the same positive claims with the locally configured Prover endpoint and
timeout; the recorded commands above identify the original audit.

The recorded audit also rejected a false postcondition and a changed program:

- Task c9eabcd3-f3b8-4232-a2f5-2a09125ef50c returned notProved, exit 1. At N=S=0, the program returns (0,0); the false postcondition requires (1,0). The mutation changes the first tuple field, and its residual reaches normal exit.
- Task a3ce9872-df5a-4a0e-83ec-40ba58625284 returned notProved, exit 2. Changing executed unit 2 from LOAD_SMALL_INT(0) to LOAD_SMALL_INT(1) makes n=1 return (1,s), contradicting the required (0,s+1).

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

All four claims were proved under the immutable server semantics
`python-3-14-6`, commit `e5d24a5429a4`, using Prover K 7.1.337. The proof
is conditional on that fixed semantics and the soundness of the Prover/APR
implementation. No claim is marked trusted. The audit does not establish
that the semantics models every detail of a particular CPython build or its
physical resource limits.

## Empirically supported facts

The finite source check reports 165 source-versus-contract cases; zero mismatches.
The executed helper matches all 30 opcode/argument pairs in the
compiled function. Run the packaged check with:

```sh
python3 audits/check-source.py
```

These finite checks support source-to-contract alignment and bytecode pinning;
the universal result comes from the proved symbolic claims.

## Excluded behavior

This theorem starts at the initialized frame for the nested `run` body. It
excludes argument binding, caller continuations, and top-level module
execution. It covers exact built-in integers, not booleans or int subclasses.
It does not claim behavior under physical memory exhaustion, object-address
limits, tracing, or traceback inspection. Heap shape is constrained only as
stated in the entry preconditions; unrelated external state is outside the
claim.
