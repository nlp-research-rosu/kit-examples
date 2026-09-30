# Proof audit 1

## Artifacts examined

- Original contract and implementations: `/app/program.py` (`sha256 feac4b889b9504409e426831e85e3270becd7dd11e3316a30636f43454c8367d`) and `/app/program.kpyc` (`sha256 6e5a7a54d1f5d5c6b6bb169bf9ce8b6702fd81d06cc18a7082017d04fc36bcd4`).
- Candidate proof sources: `inputs/spec.k` (`203dab4a7154930184495a0b36136974a91424857adace8f623a33b89e1563a4`), `inputs/verification.k` (`c63823466432ab0525bd1c1c160c401e72a657e8207d9c7357d6182b284ac034`), and `inputs/program.k` (`1585ed5af8abc929ec1198393dfa6fd1b30bdf3806f019fbad134d53d4a9f8c4`).
- Scope and replay entry point: `inputs/SCOPE.md` (`6ec96f2a521ac7d97eb20156bd333b58d11a79b34ea33d29608ab659e99f36d7`) and `prove.sh` (`ab26b139f5c6adaf3041a0b6e1d8579805ed85ccbed18f55d7457a3555bac040`).
- Approved specification baseline: `audits/spec-audit-3.md`. Its approved `spec.k` and `verification.k` hashes still match the candidate exactly; in particular, construction did not alter `VERIFICATION-SUMMARIES` after approval.
- Supplied positive construction evidence: `proof-003/result.json`; it was treated only as an input artifact and not as replay evidence.
- Independent audit session `6b19174d-608c-484c-b547-0670ba36728d`, whose successful validation and replay results are packaged in `evidence/`. No constructor report was read.

The registry, construction session, and audit session all identify bundled semantics `python-3-14-6`, repository `https://github.com/nlp-research-rosu/semantics-python-3.14.6`, commit `e5d24a5429a4`. The fetched immutable sources show the fixed `#normalExit`, `#callPython`, argument binding, entry-frame, return, `globalRef`, `#idInt = 1026`, and `#idTuple = 1033` rules used below.

## Clean-room reconstruction

`kprover session start --project /app --semantics python-3-14-6` created audit session `6b19174d-608c-484c-b547-0670ba36728d`, pinned to `e5d24a5429a4`. Only `spec.k`, `verification.k`, and `program.k` were copied into its initial `inputs/`; their hashes equal the candidate hashes above.

Commands and results:

1. `kprover validate --session 6b19174d-608c-484c-b547-0670ba36728d --semantics python-3-14-6 --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/program.k --task-timeout 1800`
   - Shell/tool exit: 0.
   - Task `3b65214d-20c9-4f56-8838-6349016e3210`, `task.status=completed`, `task.result.valid=true`; final `kprove` tool exit 0.
   - Evidence: audit `validation-001/result.json`. The only diagnostics are unused final existential warnings for `?NEXT` and `?INTERPRETERS`.
2. `kprover prove --session 6b19174d-608c-484c-b547-0670ba36728d --semantics python-3-14-6 --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/program.k --task-timeout 1800`
   - Exit: 0.
   - Task `2a657432-62af-4292-b48f-8b68e8bb96af`, `task.status=completed`, `task.result.outcome=proved`; final tool exit 0.
   - Saved stdout: `PROOF PASSED: SPEC.swap-entry`. Saved stderr is empty. No `--trusted` or `--depth` option was used, and no `PROOF TRUSTED` line exists.
   - Evidence: audit `proof-001/result.json`.

This independently closes the only selected positive claim against the same immutable bundled definition.

## Rebuilt proof-extension inventory

### `programImage()`

- Class: definitional summary (a nullary constant abbreviation).
- Domain and equations: one unconditional equation, total over its sole nullary application; no overlap or recursion.
- Role and footprint: supplies the `<pyc>` term consumed by fixed `#boot`; it changes no cell by itself and does not replace execution.
- Value justification: removing `rule programImage() =>`'s prefix and comparing its 1,913-byte RHS with `/app/program.kpyc` using `cmp` returns exit 0. Thus the claim executes the exact supplied K-pyc image, not a restated algorithm.
- Dependents: `SPEC.swap-entry`.

### `isSwapResult(...)`

- Class: definitional summary.
- Domain and equations: the positive equation returns `true` exactly when the explicit map contains the input identities with `#PyLongObject(A/B/R)` and the result identity with `#PyTupleObject(ListItem(BID) ListItem(AID) ListItem(AID))`; the `[owise]` equation returns `false` on its complement.
- Coverage/overlap/descent: total coverage follows from positive-pattern plus `owise`; the equations do not overlap; there is no recursion or descent obligation.
- Role and footprint: it observes only its explicit `Map` argument. It does not occur in operational execution, create an opaque value, or rewrite program code. It affects only the final postcondition.
- Value justification: the equations themselves exhaustively define the Boolean observation and use the pinned concrete type identifiers confirmed in bundled `static.k` (`1026` and `1033`). There is no circular use of `isSwapResult` in the execution rules.
- Dependents: `SPEC.swap-entry`.

### External call harness

- Extensions: constructors `#verificationInputs(Int,Int,Int)` and `#verificationReturn(MemoryAddress,MemoryAddress,MemoryAddress)`, plus the single rule beginning with exact `<k> #normalExit => ... </k>`.
- Class: trusted primitive for the external caller/harness boundary. It initiates the contract's call after fixed module initialization; it neither summarizes nor replaces the program-defined `run` body. All module and function opcodes execute under fixed semantics.
- Complete match domain: exact whole `<k>` content `#normalExit` (no ellipsis and no admitted continuation suffix); exact `<preconfig>` marker carrying `A,B,R`; current `<fGlobals> G`; object map `Objs`; allocator `N`; and guard `globalRef(Objs,G,b"run") =/=Int 0`. Other configuration cells are framed and preserved.
- Binding/evaluation/control: the callable is the actual `run` object read through bundled `globalRef` after module initialization. The rule creates three fresh `#PyLongObject` entries at `N,N+1,N+2`, passes those exact pointers in `(A,B,R)` order, and delegates binding, frame creation, execution, return, and exception behavior to bundled `#callPython`, `initializeLocals`, `#pushFrame`, and entry-frame rules. The exact `#verificationReturn` continuation remains at the successful C-call boundary for the claim to observe.
- State footprint: reads globals, objects, allocator, and preconfiguration; writes the three argument objects, advances `nextId` by three, consumes the preconfiguration marker, and changes control from the module terminal to the external call. It preserves stdout, stderr, exception state, interpreter/frame cells, and all omitted cells until fixed call machinery changes them. Map concatenation additionally requires the three allocated keys to be fresh.
- Context containment: because the `<k>` cell is exact, a trailing computation cannot match. The rule is confined by the one-use preconfiguration marker and the nonzero actual binding guard. The fixed configuration would stop at `#normalExit`; the named trust contract is specifically that the external environment then makes the requested function call. This intended external action is not asserted to be equivalent to doing nothing at module exit.
- Dependents: `SPEC.swap-entry`.
- Validation: the clean proof reaches the fixed semantics' C-call return; changing the first two argument pointers caused the unchanged theorem to fail with the observed tuple `(AID,BID,BID)` (summarized below). This demonstrates sensitivity to exact binding/order. No result-bearing opaque symbol is introduced.

There are no auxiliary claims, trusted claims, priority rules, simplification rules, concrete rules, ordinary program-execution shortcuts, opaque program-derived values, or other proof-local imported modules.

## Gate A — real-program soundness

### A1 and program pinning

The entry claim starts from the full bundled initial configuration: exact supplied image, `#boot`, empty object memory, allocator 4096, empty runtime maps/output, and no interpreter. `programImage()` is byte-for-byte equal to `/app/program.kpyc`. Fixed boot executes the module, the harness selects the resulting runtime `run` binding, and every function opcode executes under the fixed semantics. The final return address and heap are constrained by `isSwapResult`, not free.

The recorded audit checked body sensitivity by changing the executed assignment
load from argument 1 to argument 0. The returned tuple became `(AID,AID,AID)`,
which the unchanged swap predicate rejected.

A1: PASS.

### A2–A4

The inventory above records the complete harness footprint, exact binding, argument order, control boundary, guards, and framed cells. The harness does not admit an arbitrary continuation and delegates call/return/exception behavior to the fixed semantics. Its external-caller meaning is explicit in the trust ledger rather than presented as an equivalence to normal module termination.

The recorded audit checked argument order by swapping the first two supplied
pointers. The returned tuple became `(AID,BID,BID)`, which the unchanged
postcondition rejected.

The two definitional functions have exhaustive, nonoverlapping, terminating equations. No program-derived abstraction or opaque result affects execution or the postcondition. A2: PASS. A3: PASS. A4: PASS.

### A5 non-vacuity

The recorded audit negated the final swap predicate and checked the satisfiable
witness `A=1, B=2, R=3`. Fixed execution returns `(2,1,1)`, satisfying the
original predicate and contradicting its negation. The audit passed this check.

A5: PASS. Gate A: PASS.

## Residual Gate B — intent adequacy

- B1: PASS. `A`, `B`, and `R` are independent unguarded K `Int` variables, matching the docstring's integer-only domain and Python's unbounded integer behavior for these assignments. There is no finite bound or strengthened `requires` clause.
- B2: PASS. The exact supplied 3.14.6 image uses represented module/function creation, local load/store, tuple construction, and return opcodes. K `Int` supplies the relevant unbounded values; no arithmetic, encoding, collection, external state, concurrency, or implementation-defined edge behavior is involved. The conditional fidelity of the bundled semantics remains in the trust ledger.
- B3: PASS. The total predicate states the final value and alias property directly: original `b`, then original `a` twice, with both last positions pointing to the same input object. It also retains the three input integer objects.
- B4: PASS. Source statements `r=a; a=b; b=r; return a,b,r`, the supplied image's load/store sequence, the positive proof residual, and the postcondition all agree on `(b0,a0,a0)`. The theorem did not narrow or shift the approved specification.

Gate B: PASS.

## Gate C — trust and evidence auditability

Trust ledger:

1. Bundled semantics `python-3-14-6@e5d24a5429a4` is trusted as an adequate model of the relevant CPython 3.14.6 behavior. It affects binding, control, heap state, and termination and is a dependency of the claim. Evidence: immutable pin, clean compilation/proof, direct inspection of the relevant bundled rules, and sensitivity residuals; this is not a proof of the semantics against CPython.
2. The external-call harness is trusted to encode an environment that allocates three integer argument objects and calls the actual module-global `run` binding after successful module initialization. It affects setup state, binding, and control and is a dependency of the claim. Evidence: complete static footprint review, delegation to fixed `#callPython` machinery, exact-context containment, and the argument-order mutation. The final result is reported conditional on this named harness contract.
3. Correspondence between `/app/program.py` and the supplied `/app/program.kpyc` is an adequacy boundary: the formal theorem executes the supplied image. Evidence: exact image-byte comparison, direct alignment of the short source with its decoded load/store/return sequence, embedded function name/docstring, body-sensitivity mutation, and the independent source-level test below. This evidence is strong but is not a verified compiler theorem.

Reproducible finite evidence:

- Artifact: construction `audits/test_contract.py`, hash `9ee480e3d2e29b704381fd3740a9436704d0052e446ab566f72fa28b1aa7d44d`.
- Command actually rerun: `PYTHONPATH=/app python3 /app/.kprover/sessions/2f8278f9-afcf-4fe6-b17b-882f0db1524d/audits/test_contract.py`.
- Oracle: direct execution of `/app/program.py` by the host Python implementation; it does not import or reproduce the K equations.
- Scope: Cartesian cube of 12 values `(-10**80,-1000,-6,-5,-1,0,1,255,256,257,1000,10**80)`, 1,728 calls total; it checks values and object identity.
- Actual output and exit: `checked=1728 mismatches=0`, exit 0.
- Interpretation: finite evidence for source behavior and alias intent only; it is not a universal proof and is not used as a connection theorem.

The final report separates the formal K theorem, named conditional boundaries, empirical evidence, and exclusions. Gate C: PASS.

## Final decision

Gate A PASS; Gate B PASS; Gate C PASS. Final status: `VALIDATED`. `PROOF.md` is issued.

VERDICT: PASS
REASON: All three gates pass; the clean-room proof closes the exact bytecode claim non-vacuously and the final status is VALIDATED.
