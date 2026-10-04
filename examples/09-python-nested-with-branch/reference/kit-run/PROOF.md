VALIDATED

# Proof report

## What is proven

The ten claims in `spec.k` prove partial correctness for the exact compiled
`run` bytecode in a prepared, single-interpreter, single-thread frame. Under the
stated frame and integer-object preconditions, every normal return from the
stated entry satisfies the returned-tuple property. The proof uses the fixed
Python 3.14.6 semantics and the program's full symbolic integer domain. No
separate termination theorem is claimed.

## Formal claim

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

## Proof-extension inventory

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

## Exact commands and actual outputs

Clean-room session `03008422-572b-4ea7-bc9c-a37ff47fef2e` used
`python-3-14-6@e5d24a5429a4`. The commands below normalize executable and
project paths for portability. The invocations had no claim filter, depth
bound or trusted claims:

```sh
kprover validate --session 03008422-572b-4ea7-bc9c-a37ff47fef2e --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/program-helper.k
kprover prove --session 03008422-572b-4ea7-bc9c-a37ff47fef2e --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/program-helper.k
```

Validation task `ccdcd241-2449-4acf-8721-fc1bb8e4d16f` completed with
`valid=true`, final tool exit 0. Proof task
`2d5a58dc-0bc5-40e1-8362-f5bbffac5466` completed with `outcome=proved`,
final tool exit 0. Actual proof stdout:

```text
PROOF PASSED: SPEC.inner-a
PROOF PASSED: SPEC.inner-b
PROOF PASSED: SPEC.outer-disabled
PROOF PASSED: SPEC.entry-nonpositive-a
PROOF PASSED: SPEC.outer-within-a
PROOF PASSED: SPEC.outer-within-b
PROOF PASSED: SPEC.entry-disabled
PROOF PASSED: SPEC.entry-within
PROOF PASSED: SPEC.outer-above
PROOF PASSED: SPEC.entry-above
```

The [validation result](../evidence/03008422-572b-4ea7-bc9c-a37ff47fef2e/validation-001.json) and
[proof result](../evidence/03008422-572b-4ea7-bc9c-a37ff47fef2e/proof-001.json) include the task metadata,
timings, stdout and stderr. `./prove.sh` starts a new pinned session to replay
the same positive claims with the locally configured Prover endpoint and
timeout; the recorded commands above identify the original audit.

The recorded audit also rejected a false postcondition and a changed program:

- Task 206e2b45-4380-4fbc-96b8-5eba21d79924 returned notProved, exit 1. For a=b=1 the false observer requires doubled count 4, while the normal-return result has doubled count 2. The residual has a satisfiable #Top path condition.
- Task 5c8510ed-7f87-4164-8327-3cea06c8c83c returned notProved, exit 1 after successful compilation. Changing executed unit 29 from addition to subtraction yields (1,1,0,0,-1) for a=b=1. Both loops execute, and the original result condition fails.

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

The result is conditional on the fixed `python-3-14-6` semantics at commit
`e5d24a5429a4`, K's proof engine, and the stated prepared-frame preconditions.
The proof does not rely on a trusted claim, external oracle, finite testing,
or an unchecked result abstraction. The code map and tuple observer are
explicit definitions in the proof inputs.

## Empirically supported facts

The finite source check reports 2,420 source cases and 672 inner-loop boundary/step checks; zero mismatches.
The executed helper matches all 65 opcode/argument pairs in the
compiled function. Run the packaged check with:

```sh
python3 audits/check-source.py
```

These finite checks support source-to-contract alignment and bytecode pinning;
the universal result comes from the proved symbolic claims.

## Excluded behavior

The theorem covers only the prepared single-interpreter, single-thread frame
and normal exit. Module initialization, argument binding, a separate
termination theorem, and reference-count implementation details are outside
scope. The preconditions require a fresh code address and allocation cursor;
they do not bound integer payloads.
