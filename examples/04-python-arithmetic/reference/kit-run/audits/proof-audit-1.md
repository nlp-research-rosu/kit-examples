# Proof audit 1

## Decision

Final status: `VALIDATED`.

This audit independently reconstructed the proof in clean-room session `ccf48e89-c2c8-4649-850b-70ed6b91fc91`, pinned to bundled semantics `python-3-14-6` at commit `e5d24a5429a4`. All eight positive claims closed without `--trusted` or `--depth`; the false-postcondition and compiled-body mutations were both rejected with meaningful residuals. Gates A, B, and C pass.

## Artifacts examined

- Original contract: `run(a, b, res)` takes integer state bindings and returns final `(a, b, res)` after assigning `res = a * b + a - b`.
- `/app/program.py`, SHA-256 `dbf34c7630cdad0109ca1b6a4ce56a2b31ec52c7b31c80646c7fdbf7f98c6f5c`.
- `/app/program.kpyc`, SHA-256 `2a7d0dfee220a11e30e9b349b620d2d511a688ad715fb58f836633700e174903`.
- `inputs/spec.k`, SHA-256 `8b6a30a684a648d5403ec078fd4ec71d255991be485fef1e2fa6c71c8f25e56f`.
- `inputs/verification.k`, SHA-256 `1bb985043dcb59625794e12f451fcbe6bca6274e80b969b069ec8fe007b125a4`.
- `inputs/program-helper.k`, SHA-256 `af9189002f90c72fb7447cf4dd08c0b64dd4c56cbb1c7d478aa84ab58de2f8a6`.
- `inputs/SCOPE.md`, SHA-256 `3a7d89b36e83a4ccc72eab90764cccc00c313b0d953e07c52ecbc0153846f43d`.
- Approved residual-Gate-B baseline `audits/spec-audit-3.md`, SHA-256 `0cdf91bdabfce65847205b9f6c7db790db9c823166ce17e3bc55863923e9a858`.
- `prove.sh` as untrusted executable evidence.
- Immutable fetched semantics sources at `/home/node/.config/kprover/semantics/nlp-research-rosu/semantics-python-3.14.6/e5d24a5429a4`.

No constructor report or `EXTENSIONS.md` was read. No candidate artifact was repaired or modified.

## Clean-room reconstruction

The registry and construction session independently showed the same pin:

```text
semantics id: python-3-14-6
repo: https://github.com/nlp-research-rosu/semantics-python-3.14.6
commit: e5d24a5429a4
health: {"kVersion":"7.1.337","status":"ok"}
```

Fresh session command and actual result:

```sh
kprover session start --project /app --semantics python-3-14-6
```

```text
sessionId: ccf48e89-c2c8-4649-850b-70ed6b91fc91
workspaceDir: /app/.kprover/sessions/ccf48e89-c2c8-4649-850b-70ed6b91fc91
semantics.commit: e5d24a5429a4
attemptsUsed: 0
validationsUsed: 0
```

Only the three proof sources were initially copied to the audit session's `inputs/`. Their hashes matched the construction inputs exactly. Audit-authored mutation proof sources were added later under distinct names.

Candidate validation command:

```sh
kprover validate --session ccf48e89-c2c8-4649-850b-70ed6b91fc91 --project /app --semantics python-3-14-6 --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/program-helper.k --task-timeout 1800
```

Actual result: validation `validation-001`, task `e6d5adb8-de4e-4a44-9fff-7acb1b96309f`, `status=completed`, `task.result.valid=true`, final backend exit `0`.

The normalized helper/program identity check was:

```sh
cmp -s <(sed -n '8s/^  rule #program => //p' inputs/program-helper.k | head -c -1) /app/program.kpyc
```

Actual exit: `0`. The removed byte is only the newline added by `sed`; the `#Kpyc(...)` term itself is byte-for-byte identical.

## Positive proof commands and outputs

Every command below used no trusted claims and no depth bound:

```sh
kprover prove --session ccf48e89-c2c8-4649-850b-70ed6b91fc91 --project /app --semantics python-3-14-6 --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/program-helper.k --claim SPEC.run-sss --task-timeout 1800
kprover prove --session ccf48e89-c2c8-4649-850b-70ed6b91fc91 --project /app --semantics python-3-14-6 --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/program-helper.k --claim SPEC.run-ssh --task-timeout 1800
kprover prove --session ccf48e89-c2c8-4649-850b-70ed6b91fc91 --project /app --semantics python-3-14-6 --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/program-helper.k --claim SPEC.run-shs --task-timeout 1800
kprover prove --session ccf48e89-c2c8-4649-850b-70ed6b91fc91 --project /app --semantics python-3-14-6 --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/program-helper.k --claim SPEC.run-shh --task-timeout 1800
kprover prove --session ccf48e89-c2c8-4649-850b-70ed6b91fc91 --project /app --semantics python-3-14-6 --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/program-helper.k --claim SPEC.run-hss --task-timeout 1800
kprover prove --session ccf48e89-c2c8-4649-850b-70ed6b91fc91 --project /app --semantics python-3-14-6 --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/program-helper.k --claim SPEC.run-hsh --task-timeout 1800
kprover prove --session ccf48e89-c2c8-4649-850b-70ed6b91fc91 --project /app --semantics python-3-14-6 --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/program-helper.k --claim SPEC.run-hhs --task-timeout 1800
kprover prove --session ccf48e89-c2c8-4649-850b-70ed6b91fc91 --project /app --semantics python-3-14-6 --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/program-helper.k --claim SPEC.run-hhh --task-timeout 1800
```

Definitive fresh evidence:

| Claim | Evidence | Task ID | Status / outcome / exit | Saved stdout | Saved stderr |
|---|---|---|---|---|---|
| `SPEC.run-sss` | `proof-001/result.json` | `863afb52-63bf-41e6-9eab-86a85f169ad9` | completed / proved / 0 | `PROOF PASSED: SPEC.run-sss` | empty |
| `SPEC.run-ssh` | `proof-002/result.json` | `7d569b8e-7f26-465b-8501-28ccfa53bc6b` | completed / proved / 0 | `PROOF PASSED: SPEC.run-ssh` | empty |
| `SPEC.run-shs` | `proof-003/result.json` | `e4f9d9c2-1470-42d8-8045-e7216557079b` | completed / proved / 0 | `PROOF PASSED: SPEC.run-shs` | empty |
| `SPEC.run-shh` | `proof-004/result.json` | `288ee61a-007b-4468-b083-09e7baa43530` | completed / proved / 0 | `PROOF PASSED: SPEC.run-shh` | empty |
| `SPEC.run-hss` | `proof-009/result.json` | `5c88461b-c803-4ad8-af40-2a4d75c2eba1` | completed / proved / 0 | `PROOF PASSED: SPEC.run-hss` | empty |
| `SPEC.run-hsh` | `proof-006/result.json` | `42601115-c55e-4ce5-9b9b-8d4880035742` | completed / proved / 0 | `PROOF PASSED: SPEC.run-hsh` | empty |
| `SPEC.run-hhs` | `proof-007/result.json` | `c37fa7ea-b05e-4d42-94c0-3d8f4385ee15` | completed / proved / 0 | `PROOF PASSED: SPEC.run-hhs` | empty |
| `SPEC.run-hhh` | `proof-008/result.json` | `918f4a84-72fb-432f-9f4a-d65fc01712d7` | completed / proved / 0 | `PROOF PASSED: SPEC.run-hhh` | empty |

## Proof-extension inventory

The exhaustive source scan found no priority attributes, simplification rules, auxiliary claims, opaque value symbols, or trusted claims.

| Extension | Class | Domain and role | Context and state footprint | Value/control justification | Dependents and validation |
|---|---|---|---|---|---|
| `arithMix(A,B) => A *Int B +Int A -Int B` | Definitional summary | All `Int × Int`; names the source assignment value and does not replace execution | No cells; one unconditional terminating equation; no overlap | Exact integer expression used by the compiled multiply/add/subtract sequence | All eight claims; source inspection, body mutation, false-postcondition mutation |
| `#program => #Kpyc(...)` | Definitional summary | Singleton exact supplied compiled image | No cells; one unconditional terminating equation; no overlap | Normalized content is byte-identical to `/app/program.kpyc` | All eight claims; `cmp` exit 0 and body mutation changes this exact term |
| Entry harness rule at `verification.k:25` | Trusted primitive: external caller boundary | Only the verification caller, intentionally outside `run`; after exact module `#normalExit`, looks up `run` in actual module globals and invokes it through fixed `#callPython` | Exact terminal `<k>` context; reads `preconfig`, `fGlobals`, `objects`, `nextId`; adds three exact integer objects, advances allocator by 3, records their addresses, and otherwise frames state | Guard `dictGetItem(objectAt(G,Objs),"run") == found(F)` pins the binding; fixed semantics performs argument binding, evaluation, return, and exceptions | All eight claims; exact static comparison and body-sensitivity rejection. This rule does not summarize or replace any program-defined body |
| Small-int `#captureRun` observer at `verification.k:42` | Trusted primitive: external observer boundary | Exact fresh continuation introduced by the caller harness; observes a returned 3-tuple whose third element is a fixed-semantics small-int static ID | Exact `<k> #cReturn(#captureRun,V) ~> #dispatch </k>`; reads tuple object and `preconfig`; writes only `k` and `preconfig`; all other cells framed | `isSmallIntId(Z)` and fixed `#idSmallInt(N)=21+N` imply payload `Z-21`; tuple first elements must be the exact input addresses `X,Y` | All eight claims; positive proofs and both sensitivity probes |
| Heap-int `#captureRun` observer at `verification.k:53` | Trusted primitive: external observer boundary | Exact fresh continuation; observes a returned 3-tuple whose third element points to a dynamic `#PyLongObject(R)` | Same exact control suffix; additionally reads `Z |-> #PyObject(#idInt,false,#PyLongObject(R))`; writes only `k` and `preconfig` | Value is the exact stored integer payload `R` | All eight claims; positive proofs and both sensitivity probes |

The two observer cases are disjoint on every well-formed fixed-semantics execution from the specified initial state: static small-int IDs are `16..277`, while dynamic objects are allocated from `4096` upward and are stored in `<objects>`. Arbitrary corrupt K maps that place heap entries at static IDs are outside the fixed-semantics state invariant and outside the theorem.

The current `VERIFICATION-SUMMARIES` contains only the audited `arithMix` definition described in the approved spec baseline; no proving extension edited or shifted its meaning.

There is no operational bridge that skips or accelerates `run`: boot executes the exact module image, the harness calls the binding created by that execution, and fixed semantics executes every bytecode in `run`. Consequently no bridge connection theorem or opposite-interpretation oracle obligation arises. The caller/observer rules are explicitly ledgered external verification boundaries, not claims about a hidden program result.

## Gate A — real-program soundness: PASS

### A1 program identity and body sensitivity

The claim's `<pyc> #program </pyc>` reduces to the exact supplied compiled term. The function bytecode is the source sequence `BINARY_OP(5)` (multiply), `BINARY_OP(0)` (add), `BINARY_OP(10)` (subtract), `STORE_FAST(2)`, three loads, `BUILD_TUPLE(3)`, and `RETURN_VALUE`. Fixed semantics defines opcodes 5, 0, and 10 as `*Int`, `+Int`, and `-Int` respectively.

The recorded audit checked body sensitivity by changing subtraction to addition
while keeping the theorem unchanged. The resulting `(A,B,A*B+A+B)` did not
satisfy the required `(A,B,A*B+A-B)`, confirming sensitivity to the executed
subtraction bytecode.

### A2–A4 state, binding, control, and equations

- The caller boundary allocates exact integer payloads for `A`, `B`, and `R0`, pins the actual `run` binding by dictionary lookup in the globals produced by module execution, and enters the fixed call machinery.
- The active continuation is exact: entry starts only at terminal module `#normalExit`; observation matches only `#cReturn(#captureRun,V) ~> #dispatch`. No arbitrary continuation suffix, frame pop, exception suppression, return shortcut, or cleanup is admitted.
- Exceptions are not converted to success: a fixed-semantics exception follows `#cExcept`, for which the observer has no success rule.
- Returned tuple identity and both integer representations are inspected directly. No fresh or opaque result-bearing value occurs.
- `arithMix` and `#program` have single unconditional equations, complete coverage, no overlap, and immediate termination. There are no priority or simplification interactions.

### A5 non-vacuity

The satisfiable witness is `A=2`, `B=3`, `R0=0`: product `6`, sum `8`, and result `5` all satisfy the `sss` guards. `/app/program.py` returns `(2,3,5)`; the mutation demanded `(2,3,6)`.

The recorded audit increased the required result by one while keeping the
program unchanged. The witness above contradicted that altered target, and
the audit passed its non-vacuity check.

## Residual Gate B — intent adequacy: PASS

- `A`, `B`, and `R0` are unrestricted K `Int` variables. `R0` is overwritten and never constrains the claims.
- The eight guards are the complete Cartesian partition of small/static versus heap/dynamic representations for `P=A*B`, `Q=P+A`, and `R=Q-B`. Each dimension is `isSmallIntValue(X)` or its exact Boolean negation, so the union covers every mathematical integer pair and the cases are disjoint.
- Every claim has the same exact program, call boundary, and result property: tuple payloads `(A,B,A*B+A-B)` with empty stdout and stderr. Internal heap identities, dead frames, and allocator advancement are existentially framed, matching the contract's observables.
- No strengthened input precondition, finite bound, dropped branch, bounded unrolling, or shifted summary was introduced during proving.
- The compiled image and source intent agree: the image has three arguments named `a`, `b`, `res`, performs multiply/add/subtract, stores slot 2, and returns the three values in order.

The formal result is over every integer represented by the pinned semantics. Physical memory exhaustion, host implementation limits, and behavior outside this immutable model are model boundaries, not candidate domain restrictions.

## Gate C — trust and evidence auditability: PASS

### Trust ledger

| Assumption/boundary | Effect | Dependents | Evidence |
|---|---|---|---|
| Correctness of immutable `python-3-14-6` semantics at `e5d24a5429a4`, K 7.1.337, and the Prover backend | Language execution, control, allocation, and logical closure | All claims | Registry/session pin, fetched source inspection, fresh validation/proofs, mutation residuals |
| External verification caller/observer contract in the three harness rules | Supplies integer arguments, invokes actual bound `run`, and projects the exact returned tuple into `#runResult` | All claims | Complete rule/state-footprint inspection; exact binding guard; fixed `#callPython`; no hidden result; body and postcondition sensitivity |
| `/app/program.kpyc` is the supplied target artifact | Program identity | All claims | Exact normalized byte comparison with `#program`; SHA-256 recorded |

There are no admitted K claims, no unproved program summaries, no opaque program-derived values, and no differential test presented as universal proof.

### Empirical evidence

Audit artifact: `audit-tests/differential_oracle.py`.

```sh
python3 /app/.kprover/sessions/ccf48e89-c2c8-4649-850b-70ed6b91fc91/audit-tests/differential_oracle.py
```

Independent oracle: host-Python tuple `(a,b,a*b+a-b)`. Input scope: Cartesian product of 12 values `[-10**40,-257,-6,-5,-1,0,1,2,3,256,257,10**40]` for each of `a` and `b`, and three incoming `res` values `[-10**50,0,10**50]`, totaling 432 cases. Actual output:

```text
cases=432
mismatches=0
```

This finite run supports source-to-intent alignment and overwrite behavior only; it is not the universal proof.

## Excluded behavior

- Non-integer arguments are outside the stated integer contract.
- Arbitrary corrupt K configurations, including heap maps that violate the fixed static-ID/dynamic-allocation separation, are outside the fixed-semantics initial-state invariant.
- Physical out-of-memory/resource exhaustion and implementation behavior not modeled by the immutable semantics are not proved.
- The 432 host-Python cases are finite evidence only.
- Bundled semantics are not candidate deliverables. The required candidate-specific deliverables are `spec.k`, `verification.k`, and `program-helper.k`.

VERDICT: PASS
REASON: Gates A, B, and C pass, so the independently reconstructed proof has final status VALIDATED.
