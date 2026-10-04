# Specification audit

Same-agent specification review; the separate proof audit supplies the
independent final verdict.

## Inputs and contract

The review examined the original source and bytecode, `spec.k`,
`verification.k`, `program-helper.k` and `SCOPE.md`.

For arbitrary integer inputs `N`, `I`, `J` and `C`, prove partial correctness of `run(N, I, J, C)`: a normal return is `(N, N, J, 0)` when `N <= 0`, and `(N, 0, 0, N * (N + 1) // 2)` when `N > 0`. Initial `I` and `C` are overwritten.

## Meaning and coverage

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

The source operations and complete returned tuple agree with the claim.
The prepared-frame boundary excludes module initialization and Python call
binding; it does not impose numeric input bounds or assert termination.

## Summary definitions

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

## Checks

The original review and final audit checked the 56 compiled code units
against the helper. The finite source check reports 725 source cases and 672 inner-loop boundary/step checks; zero mismatches.
These checks do not replace the universal proof.

## Approved baseline hashes

- `spec.k`: `cb3e29cedc298fd250e48605cda53fc99d1cb7f4dcedae4b41050a50bf546cd3`.
- `verification.k`: `971b3aff2b631df8fc650471b074bc0cbf84f280bac55318f17798f9aa697954`.
- `program-helper.k`: `2b2a7d5da3cf34799f9b4d59ce5b0f6c438b4c68f31a70af148544296762d8bf`.

VERDICT: PASS
REASON: The symbolic claims cover the original integer contract at the stated function-body boundary, with faithful helpers and complete tuple postconditions.
