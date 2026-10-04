# Specification audit

Same-agent specification review; the separate proof audit supplies the
independent final verdict.

## Inputs and contract

The review examined the original source and bytecode, `spec.k`,
`verification.k`, `program-helper.k` and `SCOPE.md`.

For arbitrary integer inputs `N` and `S`, prove partial correctness of `run(N, S)`: a normal return is `(N, S)` when `N <= 0`, and `(0, S + N * (N + 1) // 2)` when `N > 0`.

## Meaning and coverage

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

The source operations and complete returned tuple agree with the claim.
The prepared-frame boundary excludes module initialization and Python call
binding; it does not impose numeric input bounds or assert termination.

## Summary definitions

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

## Checks

The original review and final audit checked the 30 compiled code units
against the helper. The finite source check reports 165 source-versus-contract cases; zero mismatches.
These checks do not replace the universal proof.

## Approved baseline hashes

- `spec.k`: `3902fe86347493fc71476ef0ac66a0a0165232084a6b58f1024f040204671b99`.
- `verification.k`: `a5ee1cc6c2a07863f9d83c89bec40b3e1561b9e645bfb2e11c7644034fe8a800`.
- `program-helper.k`: `d12fe42fcc3d89a779677008f0b0ae194f3502cfce7d6ebfbd340c2c6d92a7b8`.

VERDICT: PASS
REASON: The symbolic claims cover the original integer contract at the stated function-body boundary, with faithful helpers and complete tuple postconditions.
