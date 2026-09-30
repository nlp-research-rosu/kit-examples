VALIDATED

# Proof report

## What is proven

Under immutable bundled semantics `python-3-14-6` at commit `e5d24a5429a4`, booting the exact supplied `/app/program.kpyc` image and calling the `run` binding it creates with any three integer payloads `A`, `B`, and `R0` reaches a normal return whose exact three-element integer tuple is:

```text
(A, B, A * B + A - B)
```

The incoming `R0` is unrestricted and is overwritten. Standard output and standard error remain empty. The result is conditional on the trust boundaries recorded below.

## Formal claim

`SPEC` contains eight symbolic reachability claims:

```text
SPEC.run-sss  SPEC.run-ssh  SPEC.run-shs  SPEC.run-shh
SPEC.run-hss  SPEC.run-hsh  SPEC.run-hhs  SPEC.run-hhh
```

They share the same initial program, arbitrary K `Int` inputs, exact fixed-semantics call, and postcondition:

```text
?RA ==Int A
andBool ?RB ==Int B
andBool ?RR ==Int arithMix(A,B)

arithMix(A,B) = A *Int B +Int A -Int B
```

The labels partition only the fixed-semantics representation of the product, sum, and difference into `isSmallIntValue` (`s`) or its Boolean negation (`h`). The eight `{s,h}^3` cases are exhaustive and disjoint over all integer inputs; they do not bound or narrow the source contract.

The claim starts from the fixed standard boot configuration (`objects=.Map`, `nextId=4096`, empty output streams), executes the exact compiled module, looks up the resulting `run` binding, calls it through fixed semantics, and observes its exact returned tuple.

## Proof-extension inventory

| Extension | Classification | Justification and scope |
|---|---|---|
| `arithMix(A,B) => A *Int B +Int A -Int B` | Definitional summary | One total unconditional equation over all integers; exact source expression; no overlap or recursion; does not replace execution |
| `#program => #Kpyc(...)` | Definitional summary | One total unconditional equation equal to `/app/program.kpyc` byte-for-byte after ignoring only the helper line's newline |
| Entry rule from terminal module `#normalExit` to fixed `#callPython` | Trusted primitive: external verification caller boundary | Pins the actual `run` binding by globals-dictionary lookup; allocates exact integer objects for `A,B,R0`; fixed semantics performs binding, body evaluation, control, exceptions, and return |
| Small-static-int `#captureRun` rule | Trusted primitive: external observer boundary | Matches only exact `#cReturn(#captureRun,V) ~> #dispatch`; requires an exact 3-tuple containing the input addresses and a small-int static ID; derives payload as `Z-21` |
| Heap-int `#captureRun` rule | Trusted primitive: external observer boundary | Same exact control context; requires the third tuple address to map to `#PyObject(#idInt,false,#PyLongObject(R))`; records exact payload `R` |

No extension skips or summarizes the program-defined body. There are no priority rules, simplification rules, auxiliary claims, opaque program-derived symbols, or admitted/trusted K claims. The two observer rules are disjoint on every well-formed execution from the fixed initial configuration because static small-int IDs are `16..277`, while dynamic heap allocation starts at `4096`.

## Exact commands and actual outputs

### Clean-room session and validation

```sh
kprover session start --project /app --semantics python-3-14-6
```

Actual result:

```text
sessionId: ccf48e89-c2c8-4649-850b-70ed6b91fc91
semantics: python-3-14-6
commit: e5d24a5429a4
workspaceDir: /app/.kprover/sessions/ccf48e89-c2c8-4649-850b-70ed6b91fc91
```

Only `spec.k`, `verification.k`, and `program-helper.k` were initially copied into the clean-room `inputs/`; hashes matched the construction files.

```sh
kprover validate --session ccf48e89-c2c8-4649-850b-70ed6b91fc91 --project /app --semantics python-3-14-6 --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/program-helper.k --task-timeout 1800
```

Actual result:

```text
validation-001
task: e6d5adb8-de4e-4a44-9fff-7acb1b96309f
status: completed
valid: true
exit: 0
```

### Positive proof invocations

Each label was submitted with this exact command shape, substituting the displayed label:

```sh
kprover prove --session ccf48e89-c2c8-4649-850b-70ed6b91fc91 --project /app --semantics python-3-14-6 --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/program-helper.k --claim <LABEL> --task-timeout 1800
```

Actual definitive results and downloaded logs:

| Label | Evidence / task | Typed terminal result | Downloaded stdout | Downloaded stderr |
|---|---|---|---|---|
| `SPEC.run-sss` | `proof-001`, `863afb52-63bf-41e6-9eab-86a85f169ad9` | completed, `proved`, exit 0 | `PROOF PASSED: SPEC.run-sss` | empty |
| `SPEC.run-ssh` | `proof-002`, `7d569b8e-7f26-465b-8501-28ccfa53bc6b` | completed, `proved`, exit 0 | `PROOF PASSED: SPEC.run-ssh` | empty |
| `SPEC.run-shs` | `proof-003`, `e4f9d9c2-1470-42d8-8045-e7216557079b` | completed, `proved`, exit 0 | `PROOF PASSED: SPEC.run-shs` | empty |
| `SPEC.run-shh` | `proof-004`, `288ee61a-007b-4468-b083-09e7baa43530` | completed, `proved`, exit 0 | `PROOF PASSED: SPEC.run-shh` | empty |
| `SPEC.run-hss` | `proof-009`, `5c88461b-c803-4ad8-af40-2a4d75c2eba1` | completed, `proved`, exit 0 | `PROOF PASSED: SPEC.run-hss` | empty |
| `SPEC.run-hsh` | `proof-006`, `42601115-c55e-4ce5-9b9b-8d4880035742` | completed, `proved`, exit 0 | `PROOF PASSED: SPEC.run-hsh` | empty |
| `SPEC.run-hhs` | `proof-007`, `c37fa7ea-b05e-4d42-94c0-3d8f4385ee15` | completed, `proved`, exit 0 | `PROOF PASSED: SPEC.run-hhs` | empty |
| `SPEC.run-hhh` | `proof-008`, `918f4a84-72fb-432f-9f4a-d65fc01712d7` | completed, `proved`, exit 0 | `PROOF PASSED: SPEC.run-hhh` | empty |

No positive invocation used `--trusted` or `--depth`.

## Per-gate results

- Gate A — PASS. The exact compiled body executes under fixed semantics; binding, arguments, evaluation, tuple return, control, exceptions, output, and observable result are constrained. There is no program-skipping bridge or opaque result. Both body and postcondition mutations fail meaningfully.
- Gate B — PASS. The eight claims cover all integer triples without candidate narrowing and retain the approved theorem and summary meaning. The compiled behavior matches the requested tuple and arithmetic expression.
- Gate C — PASS. All unproved boundaries are ledgered, successful program proof IDs and logs are packaged, finite evidence is labeled finite, and proved, conditional, empirical, and excluded statements are separated.

## Trust boundary

The formal conclusion is conditional on:

1. correctness of bundled semantics `python-3-14-6` at `e5d24a5429a4`, K 7.1.337, and the Prover backend;
2. the explicitly inspected external caller/observer harness, which supplies exact integer objects, calls the actual bound function via fixed semantics, and projects the exact returned tuple; and
3. `/app/program.kpyc` being the supplied target artifact.

No program-defined helper, arithmetic result, auxiliary claim, or K claim is trusted or admitted.

## Empirically supported facts

```sh
python3 /app/.kprover/sessions/ccf48e89-c2c8-4649-850b-70ed6b91fc91/audit-tests/differential_oracle.py
```

The independently implemented host-Python oracle compared `/app/program.py` with `(a,b,a*b+a-b)` over 432 cases: 12 signed, cache-boundary, and very large values for each of `a` and `b`, crossed with three incoming `res` values. Actual result:

```text
cases=432
mismatches=0
```

This supports source-to-intent alignment and overwrite behavior only; it is not the universal proof.

## Excluded behavior

- Non-integer arguments.
- Arbitrary corrupt K states that violate fixed-semantics memory invariants.
- Physical resource exhaustion and implementation behavior absent from the bundled model.
- Any claim that 432 finite host-Python tests establish universal equivalence.
- Bundled semantics as a deliverable. The candidate-specific deliverables are `spec.k`, `verification.k`, and `program-helper.k`.
