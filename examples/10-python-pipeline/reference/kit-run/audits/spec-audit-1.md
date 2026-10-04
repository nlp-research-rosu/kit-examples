# Specification audit

Same-agent specification review; the separate proof audit supplies the
independent final verdict.

## Inputs and contract

The review examined the original source and bytecode, `spec.k`,
`verification.k`, `program-helper.k` and `SCOPE.md`.

For arbitrary integer inputs `A`, `B`, `N`, `T`, `I` and `R`, prove partial correctness of `run(A, B, N, T, I, R)`: every normal return is `(A, B, N, abs(A * B), max(N, 0), max(N, 0) * abs(A * B) + A)`. Initial `T`, `I` and `R` are overwritten.

## Meaning and coverage

The entry claims start at bytecode instruction 0 and partition all integer
values by the sign of `a*b` and whether `n` is positive. The loop claim
covers `0 <= i <= n` and `res = i*t`, including the loop exit boundary.
The final tuple observer constrains all six returned fields.

Fresh code/object addresses and a prepared single-interpreter frame establish
the runtime configuration needed for execution. They do not restrict the
integer payloads. No separate termination theorem is claimed.

The source operations and complete returned tuple agree with the claim.
The prepared-frame boundary excludes module initialization and Python call
binding; it does not impose numeric input bounds or assert termination.

## Summary definitions

| Extension | Purpose |
|---|---|
| `targetRunCode()` | Exact code-unit map used by the entry code object; all 69 opcode/argument pairs match `program.kpyc`. |
| `heapMax(Map)` | Computes the maximum integer heap key, with floor 4095, for freshness conditions. |
| `tupleResult`, `tuplePayload` | Check the six integer fields of the returned tuple. |
| Three `VERIFICATION` simplifications | Exact unequal-key lookup, heapMax unfolding, and absence of a key above the computed maximum. |

No operational bridge or proof-local trusted claim is used.

## Checks

The original review and final audit checked the 69 compiled code units
against the helper. The finite source check reports 1,536 source cases and 840 loop boundary/step checks; zero mismatches.
These checks do not replace the universal proof.

## Approved baseline hashes

- `spec.k`: `1a337a11620598890dfa43348f9065ad8e4387e41136a13806eb52a690d08681`.
- `verification.k`: `54475a9fe3342059a16e8fbe81a338fa54e0609ad0b319d79bb0d720d4335e61`.
- `program-helper.k`: `57e593e9db8fd598f271482d92f5d7387e5c20b4b08e08b3747ae969747f78ba`.

VERDICT: PASS
REASON: The symbolic claims cover the original integer contract at the stated function-body boundary, with faithful helpers and complete tuple postconditions.
