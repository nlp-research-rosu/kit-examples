VALIDATED

# Proof report

## What is proven

The four entry claims prove partial correctness of the exact compiled `run`
body: for arbitrary mathematical integer inputs, every normal return from
bytecode instruction 0 in the prepared state described by `SCOPE.md` has the
specified eight-field tuple. They do not claim a separate termination theorem.

## Formal claim

For all integer `a`, `b`, and `n`, the return value is

`(a, b, n, min(a,b), max(a,b), max(a,b)-min(a,b), max(n,0), max(n,0)*(max(a,b)-min(a,b))+min(a,b))`.

The initial `m`, `x`, `t`, `i`, and `res` values are overwritten. The four
entry claims partition both orderings of `a` and `b` and both signs of `n`.
The positive entry claims use the proved loop claim, whose invariant is
`0 <= I <= N` and `Res = I*T`, including its exit boundary.

## Proof-extension inventory

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

## Exact commands and actual outputs

Clean-room session `e92e3059-5fc0-417b-aba2-93dc39b5a2b6` used
`python-3-14-6@e5d24a5429a4`. The commands below normalize executable and
project paths for portability. The invocations had no claim filter, depth
bound or trusted claims:

```sh
kprover validate --session e92e3059-5fc0-417b-aba2-93dc39b5a2b6 --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/program-helper.k
kprover prove --session e92e3059-5fc0-417b-aba2-93dc39b5a2b6 --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/program-helper.k
```

Validation task `03c26a50-d469-4f4c-96bc-3d43b1d65202` completed with
`valid=true`, final tool exit 0. Proof task
`23cb20c4-f3d2-4be5-84f6-30421c279a1c` completed with `outcome=proved`,
final tool exit 0. Actual proof stdout:

```text
PROOF PASSED: SPEC.entry-ordered-nonpositive-n
PROOF PASSED: SPEC.loop
PROOF PASSED: SPEC.entry-reversed-nonpositive-n
PROOF PASSED: SPEC.entry-ordered-positive-n
PROOF PASSED: SPEC.entry-reversed-positive-n
```

The [validation result](../evidence/e92e3059-5fc0-417b-aba2-93dc39b5a2b6/validation-002.json) and
[proof result](../evidence/e92e3059-5fc0-417b-aba2-93dc39b5a2b6/proof-001.json) include the task metadata,
timings, stdout and stderr. `./prove.sh` starts a new pinned session to replay
the same positive claims with the locally configured Prover endpoint and
timeout; the recorded commands above identify the original audit.

The recorded audit also rejected a false postcondition and a changed program:

- Task 81397aa3-d58e-4fff-99a5-4219c4360654 returned notProved, exit 1. At a=0,b=1,n=1, adding 1 to the required final field contradicts the normal-return tuple.
- Task a76aeaae-0908-4079-9695-e7ee20fcb26e completed notProved, backend exit 1. Executed unit 24 changed from LOAD_SMALL_INT(0) to LOAD_SMALL_INT(1), giving the wrong accumulated result for a=0,b=1,n=1. A client polling error followed backend completion; it does not replace the retained terminal verdict.

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

The proof trusts the soundness of KProver and the fixed
`python-3-14-6` semantics at commit `e5d24a5429a4`. The theorem also uses the
prepared-frame, empty-caller-stack, freshness, integer-object, and heap-framing
conditions stated in `SCOPE.md`. These conditions concern the runtime state
and do not restrict integer payloads.

## Empirically supported facts

The finite source check reports 1,536 source cases and 840 loop boundary/step checks; zero mismatches.
The executed helper matches all 67 opcode/argument pairs in the
compiled function. Run the packaged check with:

```sh
python3 audits/check-source.py
```

These finite checks support source-to-contract alignment and bytecode pinning;
the universal result comes from the proved symbolic claims.

## Excluded behavior

Module initialization, argument binding, a separate termination theorem, and
reference-count implementation details are outside the theorem, as stated in
`SCOPE.md`.
