VALIDATED

## What is proven

Under bundled semantics `python-3-14-6` at immutable commit `e5d24a5429a4`, the exact supplied `/app/program.kpyc` image is booted from the complete initial configuration. After fixed module initialization creates the actual global `run` binding, the named external-call harness supplies arbitrary independent integer values `A`, `B`, and `R` as three Python integer objects and calls that binding through the bundled `#callPython` machinery.

For every K integer triple, a successful return through the C-call boundary has a tuple object containing the original `B` object followed by the original `A` object twice. Thus the returned values are `(b0,a0,a0)`, and the last two positions alias the same object. The original three integer objects retain payloads `A`, `B`, and `R`. `stdout` and `stderr` remain empty.

This is a partial-correctness theorem. It does not separately claim termination, behavior on non-integer arguments, or properties of framed heap/interpreter bookkeeping beyond the stated observations.

## Formal claim

The proved claim is `SPEC.swap-entry` in `inputs/spec.k` (`sha256 203dab4a7154930184495a0b36136974a91424857adace8f623a33b89e1563a4`), using `inputs/verification.k` (`c63823466432ab0525bd1c1c160c401e72a657e8207d9c7357d6182b284ac034`) and `inputs/program.k` (`1585ed5af8abc929ec1198393dfa6fd1b30bdf3806f019fbad134d53d4a9f8c4`). There is no `requires` clause: `A`, `B`, and `R` range independently over all K integers.

The initial `<k>` term is `#boot` with `programImage()` in `<pyc>`, empty object memory, allocator 4096, empty runtime maps and output, and no interpreters. The final `<k>` term is `#cReturn(#verificationReturn(?AID,?BID,?RID),?TUPLE) ~> #dispatch`. The total `isSwapResult` predicate constrains the final heap and returned tuple; the result is neither free nor tautological.

`programImage()`'s 1,913-byte RHS compares byte-for-byte equal to `/app/program.kpyc` (`sha256 6e5a7a54d1f5d5c6b6bb169bf9ce8b6702fd81d06cc18a7082017d04fc36bcd4`).

## Proof-extension inventory

### Definitional summary: `programImage()`

One unconditional, total, nonrecursive equation names the exact supplied K-pyc image. It has no state footprint and does not replace program execution. Fixed `#boot` consumes the resulting image.

### Definitional summary: `isSwapResult(...)`

The positive equation is true exactly for a heap containing the three original integer objects and a tuple at the return identity with references `(BID,AID,AID)`. The `[owise]` equation is false on the complement. Together they are exhaustive, nonoverlapping, total, and nonrecursive. The symbol occurs only in the postcondition and does not influence operational execution.

### Trusted primitive: external call harness

`#verificationInputs` carries the mathematical input values through module initialization. The one harness rule matches exact whole control `#normalExit`, that one-use marker, the current globals, objects, and allocator, and requires a nonzero `globalRef(...,b"run")`. It allocates three fresh `#PyLongObject` values, passes their pointers in `(A,B,R)` order to the actual global binding, and delegates all argument binding, frame setup, bytecode execution, return, and exception control to bundled `#callPython` machinery. `#verificationReturn` is the C continuation observed by the final claim.

The rule reads globals, objects, `nextId`, and the marker; writes three fresh objects, advances `nextId`, consumes the marker, and initiates the call. Its `<k>` pattern admits no trailing continuation. Other cells, including output, are framed. This is explicitly an external-caller contract, not an assertion that a normal module exit itself performs a call.

There are no auxiliary claims, admitted/trusted proof claims, priority or simplification rules, concrete rules, operational shortcuts over `run`, or opaque program-derived result symbols.

## Commands and actual outputs

Clean-room audit session: `6b19174d-608c-484c-b547-0670ba36728d`, pinned independently to `python-3-14-6@e5d24a5429a4`. Its initial proof-source hashes exactly match the candidate.

Validation:

```sh
kprover validate --session 6b19174d-608c-484c-b547-0670ba36728d --semantics python-3-14-6 --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/program.k --task-timeout 1800
```

Task `3b65214d-20c9-4f56-8838-6349016e3210`: `status=completed`, `valid=true`, final tool exit 0. Evidence: audit session `validation-001/result.json`.

Positive proof:

```sh
kprover prove --session 6b19174d-608c-484c-b547-0670ba36728d --semantics python-3-14-6 --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/program.k --task-timeout 1800
```

Task `2a657432-62af-4292-b48f-8b68e8bb96af`: `status=completed`, `outcome=proved`, final tool exit 0. Actual stdout:

```text
PROOF PASSED: SPEC.swap-entry
```

Stderr is empty. No `--trusted` or `--depth` was used. Evidence: audit session `proof-001/result.json`.

## Gate results

- Gate A — PASS. The exact supplied program body executes under fixed semantics; all extension state/control effects are inventoried; binding and argument order are constrained; equations are total and valid; body and harness mutations are discriminating; and the fresh false postcondition is rejected with a reachable residual.
- Gate B — PASS. The theorem covers every integer triple with no bound or strengthened precondition, uses represented language features, and states exactly the source contract's final `(b0,a0,a0)` value and alias property. It remains identical to the approved specification baseline.
- Gate C — PASS. Every assumption and dependency is ledgered below, successful program proof evidence is packaged with exact commands and results, and formal, conditional, empirical, and excluded statements are separated.

## Trust boundary

The formal result is conditional on these named components:

1. `python-3-14-6@e5d24a5429a4` adequately models the relevant CPython 3.14.6 module loading, local variable, tuple, call, heap, and return behavior. All formal claims depend on it. This semantics-to-implementation fidelity is trusted, not proved here.
2. The external-call harness accurately represents a caller allocating three integer objects and invoking the actual post-initialization global `run` binding. It affects setup state, binding, and control. Its complete context and footprint were inspected, and an argument-order mutation demonstrates sensitivity.
3. The supplied `/app/program.kpyc` corresponds to `/app/program.py`. The formal theorem directly pins and executes the supplied image. Source/image correspondence is supported by direct source/opcode alignment, embedded metadata, byte pinning, body sensitivity, and the finite source test below; it is not a verified compiler theorem.

No theorem conclusion is conditional on an unlisted trusted K claim, opaque oracle, or program summary.

## Empirically supported facts

Artifact `audits/test_contract.py` (`sha256 9ee480e3d2e29b704381fd3740a9436704d0052e446ab566f72fa28b1aa7d44d`) was rerun as:

```sh
PYTHONPATH=/app python3 /app/.kprover/sessions/2f8278f9-afcf-4fe6-b17b-882f0db1524d/audits/test_contract.py
```

Actual output, exit 0:

```text
checked=1728 mismatches=0
```

The executable oracle directly calls `/app/program.py`. It covers the Cartesian cube of 12 boundary/representative integers, including very large positive and negative values and 255/256/257, and checks both returned values and object identities. This is finite evidence for source behavior and alias intent, not a universal proof and not a substitute for the formal K result.

## Excluded behavior

- Non-integer inputs, because the source docstring restricts all three bindings to integers.
- Total-correctness/termination claims beyond the stated reachability theorem.
- External mutable state interpretations of “state bindings”; the verified bindings are the three function parameters, as the source uses local rebinding.
- Properties of heap entries and interpreter bookkeeping that the claim frames, except the three input objects, returned tuple, and empty stdout/stderr explicitly observed.
- A verified equivalence theorem between the bundled semantics and CPython, or between the Python compiler and the supplied K-pyc image; these are named trust boundaries above.
