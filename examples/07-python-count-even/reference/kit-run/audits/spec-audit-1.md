# Specification audit

Same-agent specification review; the separate proof audit supplies the
independent final verdict.

## Inputs and contract

The review examined the original source and bytecode, `spec.k`,
`verification.k`, `program-helper.k` and `SCOPE.md`.

For arbitrary integer inputs `N`, `I` and `C`, prove partial correctness of `run(N, I, C)`: a normal return is `(N, 0, 0)` when `N < 0`, and `(N, N, (N + 1) // 2)` when `N >= 0`. Initial `I` and `C` are overwritten.

## Meaning and coverage

The entry claims cover all integer N and arbitrary initial integer I and C. For N >= 0, the loop invariant is 0 <= i <= N and 2*count = i + (i mod 2), including i=N. The negative entry bypasses the loop. The returned tuple is `(N,0,0)` for `N < 0`; `(N,N,(N+1)//2)` for `N >= 0`.

The source operations and complete returned tuple agree with the claim.
The prepared-frame boundary excludes module initialization and Python call
binding; it does not impose numeric input bounds or assert termination.

## Summary definitions

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

## Checks

The original review and final audit checked the 51 compiled code units
against the helper. The finite source check reports 1,848 source cases and 601 invariant boundary/step checks; zero mismatches.
These checks do not replace the universal proof.

## Approved baseline hashes

- `spec.k`: `ce6a732dde995af9ccdb478d582ae2dc53d62fc9dff51e986641be18050acb1a`.
- `verification.k`: `2b67ba66d060ed810f95aab648297bc9c058708c6ca4dcc896efc5abaf866b1c`.
- `program-helper.k`: `55fa781fe8acb6d1bbd7869f9ad4acd4b2f3aefe051e4c4263c0a835e1ff480e`.

VERDICT: PASS
REASON: The symbolic claims cover the original integer contract at the stated function-body boundary, with faithful helpers and complete tuple postconditions.
