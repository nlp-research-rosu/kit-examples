# Specification audit

Same-agent specification review; the separate proof audit supplies the
independent final verdict.

## Inputs and contract

The review examined the original source and bytecode, `spec.k`,
`verification.k`, `program-helper.k` and `SCOPE.md`.

For arbitrary integer inputs `A`, `B`, `N`, `M`, `X`, `T`, `I` and `R`, prove partial correctness of `run(A, B, N, M, X, T, I, R)`: every normal return is `(A, B, N, min(A, B), max(A, B), D, max(N, 0), max(N, 0) * D + min(A, B))`, where `D = max(A, B) - min(A, B)`. Initial `M`, `X`, `T`, `I` and `R` are overwritten.

## Meaning and coverage

For all integer `a`, `b`, and `n`, the return value is

`(a, b, n, min(a,b), max(a,b), max(a,b)-min(a,b), max(n,0), max(n,0)*(max(a,b)-min(a,b))+min(a,b))`.

The initial `m`, `x`, `t`, `i`, and `res` values are overwritten. The four
entry claims partition both orderings of `a` and `b` and both signs of `n`.
The positive entry claims use the proved loop claim, whose invariant is
`0 <= I <= N` and `Res = I*T`, including its exit boundary.

The source operations and complete returned tuple agree with the claim.
The prepared-frame boundary excludes module initialization and Python call
binding; it does not impose numeric input bounds or assert termination.

## Summary definitions

- `targetRunCode()` supplies the exact 67-instruction code map from the
  compiled function; the audited opcode/oparg sequence matches all 67 entries.
- `heapMax` recursively computes the maximum heap key, with the empty-map
  default 4095; its duplicate simplification equation has the same right-hand
  side.
- `tupleResult` and `tuplePayload` inspect the actual returned eight-element
  tuple and check each field as an integer object with the expected payload.
- `objectAt` skips a distinct map key under `I =/= J`.
- `in_keys` returns false for keys above the finite map's `heapMax`.

No execution-skipping rules, bridge claims, or trusted claims are used.

## Checks

The original review and final audit checked the 67 compiled code units
against the helper. The finite source check reports 1,536 source cases and 840 loop boundary/step checks; zero mismatches.
These checks do not replace the universal proof.

## Approved baseline hashes

- `spec.k`: `b52e81ebcf01585d8fd27f98ee0929572c86ae6f11386f76659483406e06b0aa`.
- `verification.k`: `26cfa045f9a634f21454088598c1eb0e2d4c0a6adbc0516e43c3cd3cca0c2268`.
- `program-helper.k`: `c2f07a0631f6e042a2764fdba88bcf6b339689a346cfe97bf589ccaccd64ac8c`.

VERDICT: PASS
REASON: The symbolic claims cover the original integer contract at the stated function-body boundary, with faithful helpers and complete tuple postconditions.
