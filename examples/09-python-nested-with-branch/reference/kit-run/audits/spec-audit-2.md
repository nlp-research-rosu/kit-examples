# Specification audit

Same-agent specification review; the separate proof audit supplies the
independent final verdict.

## Inputs and contract

The review examined the original source and bytecode, `spec.k`,
`verification.k`, `program-helper.k` and `SCOPE.md`.

For arbitrary integer inputs `A`, `B`, `I`, `J` and `R`, prove partial correctness of `run(A, B, I, J, R)`: a normal return is `(A, B, min(A, 0), J_final, L * (L + 1) // 2)`, where `L = max(0, min(A, B))`. `J_final` is 0 if `A > 0` and `B > 0`, otherwise the incoming `J`. Initial `I` and `R` are overwritten.

## Meaning and coverage

The returned tuple is `(a, b, min(a, 0), j_final, r)`, where
`j_final = 0` when `a > 0` and `b > 0`, and otherwise `j_final` is the incoming
`j`. The final count satisfies
`2 * r = L * (L + 1)`, with `L = max(0, min(a, b))`. This is the triangular
count property expressed without division. The returned first four fields are
observed directly, and the observer checks the fifth field using the doubled
count equation. Incoming `i` and `res` are overwritten by the body.

All five incoming locals contain arbitrary mathematical `Int` payloads. The
preconditions admit cached and dynamic integer representations and permit
aliasing where the aliased payload constraints agree. They constrain code
address and allocation freshness for a well-formed runtime state, not the
numeric values of the input integers. The four entry claims partition all
integer `a,b`: `a <= 0`, `a > 0` with `b <= 0`, `0 < a <= b`, and `0 < b < a`.

The source operations and complete returned tuple agree with the claim.
The prepared-frame boundary excludes module initialization and Python call
binding; it does not impose numeric input bounds or assert termination.

## Summary definitions

The clean source inventory contains no operational bridge, opaque result,
trusted claim, or priority rule. `targetRunCode` is a total function that
defines the exact 65 compiled code units used in the initial `PyCodeObject`;
it does not skip execution or summarize a result. The observer functions
`tupleResult` and `tuplePayload` inspect the allocated five-element tuple and
its integer payloads. `heapMax` is a total map traversal with a 4095 floor,
used for the fresh-allocation precondition.

The proof-local simplifications are two generic integer distributivity
identities, the guarded map-lookup equation that skips a different key, the
recursive `heapMax` equation (also present as its function definition), and
the rule that a key greater than `heapMax(M)` is absent from `M`. The
arithmetic identities are true over unbounded K `Int`; their expansion
overlaps yield the same polynomial. The map lookup equation follows from
`I != J`. The membership rule follows from the maximum-key definition and
guard. The duplicate `heapMax` equation has the same right-hand side. None
changes the imported `VERIFICATION-SUMMARIES` definitions or alters fixed
Python execution. The generated final counter in the tuple observer identifies
the tuple allocation at `FinalNext - 1`; it is not a free result abstraction.

## Checks

The original review and final audit checked the 65 compiled code units
against the helper. The finite source check reports 2,420 source cases and 672 inner-loop boundary/step checks; zero mismatches.
These checks do not replace the universal proof.

## Approved baseline hashes

- `spec.k`: `d132f4a135cab8ef70a635e95cf7d9bf2b6ddf090db4b9155d00b4b873cb79d8`.
- `verification.k`: `4fe7a4e8538e55a36e230f967a2d8cd9afcd7755b3f0c8ace2289c9e61831626`.
- `program-helper.k`: `30dff54fddf1ab6ce62c6f7bbdf7f83ab1487a10413c0f270647a4d692a92eb8`.

VERDICT: PASS
REASON: The symbolic claims cover the original integer contract at the stated function-body boundary, with faithful helpers and complete tuple postconditions.
