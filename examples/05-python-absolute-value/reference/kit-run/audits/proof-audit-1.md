# Proof audit 1

## Verdict scope and stance

This is an independent clean-room audit of the proof sources, not a review of
the constructor's reasoning.  The construction proof result was treated as
untrusted recorded evidence.  The verdict below rests on the on-disk K sources,
the approved specification baseline, the original program and scope, and fresh
tasks in audit session `a4284896-cf66-424f-9b7b-660707e9d5fa`.

## Artifacts examined

- `/app/.kprover/sessions/35db469f-c5f8-4f79-8efd-b94e254c92fe/inputs/spec.k`
  (SHA-256 `5fd9ae7fb1259a93de3edfc2b3fbe276f7c04f8068a914487161d0e3c18eaf13`)
- `/app/.kprover/sessions/35db469f-c5f8-4f79-8efd-b94e254c92fe/inputs/verification.k`
  (SHA-256 `ce2efb784fbc2e9fd8681e526bacdbb44a94349efb4454c3ada1a7e1ab227589`)
- `/app/.kprover/sessions/35db469f-c5f8-4f79-8efd-b94e254c92fe/inputs/subject.k`
  (SHA-256 `1b16832395dd7e6ca5f6f79812dbfbefface875173c7dae7ca3fc70f74806c78`)
- `/app/SCOPE.md`, `/app/prove.sh`, `/app/program.kpyc`, and `/app/program.py`
- `/app/audits/spec-audit-3.md`, the approved specification baseline
- `/app/audits/abs-summary-check.py`, the independent finite-check artifact
- Construction record
  `/app/.kprover/sessions/35db469f-c5f8-4f79-8efd-b94e254c92fe/proof-007/result.json`;
  it records `proved`, exit 0, and `PROOF PASSED`, but it was not used in place
  of the clean-room replay.
- Fresh audit evidence under
  `/app/.kprover/sessions/a4284896-cf66-424f-9b7b-660707e9d5fa/`.

No constructor narrative or non-approved audit was read.

## Semantics and clean-room reconstruction

The registry, construction session, and audit session independently identify
the same immutable semantics:

- ID: `python-3-14-6`
- repository: `https://github.com/nlp-research-rosu/semantics-python-3.14.6`
- commit: `e5d24a5429a4`

Only `spec.k`, `verification.k`, and `subject.k` were copied into the clean-room
session before the positive validation/proof.  Their clean-room hashes are
identical to the three hashes above.  The proof selected only
`SPEC.run-abs`, used no `--trusted` and no `--depth`, and passed with backend
stdout `PROOF PASSED: SPEC.run-abs`.

The approved baseline describes the same claim, direct-entry boundary,
unrestricted integer variables, and final-summary equations found in the
audited files.  No rule was added to or removed from the approved
`VERIFICATION-SUMMARIES` surface.

## Rebuilt proof-extension inventory

There are 31 local equations and one reachability claim.  There are no local
priority, simplification, concrete, ordinary `<k>` rewrite, auxiliary-claim,
opaque-result, or trusted-claim extensions.  No local rule preempts or replaces
fixed-semantics bytecode execution.

| Extension | Class and domain | Semantic role, context, and footprint | Justification, dependents, and validation |
|---|---|---|---|
| `absSubjectProgram()` (one equation) | Definitional summary; nullary, total | Names the exact `KPyc` subject image.  It supplies `<pyc>` and the boot image; it does not rewrite `<k>`. | The equation's `#Kpyc(...)` bytes compare exactly with `/app/program.kpyc`.  Used by `absHarnessBootPlan` and `SPEC.run-abs`.  The body mutation proves the claim is sensitive to this term. |
| `absSubjectCode(#Kpyc(_,_,_,CODE))` (one equation) | Definitional constructor projection | Projects the marshal code used by `bootLoad`; no state or control effect. | Exact constructor projection, used by `absHarnessBootPlan`. |
| `absHarnessBootPlan()` (one equation) | Definitional summary | Calls bundled `bootLoad` on the exact program, `.Map`, and base ID `4096`; defines the fixed initial object graph. | Evaluated by the pinned semantics during the fresh proof.  Used by all harness projections. |
| `absHarnessModuleCodeId`, `absHarnessGlobalsId`, `absHarnessBuiltinsId`, `absHarnessObjects`, `absHarnessNextId` (five equations) | Definitional constructor projections over `#bootPlan` | Read one boot-plan field each; no write, control, or value abstraction. | Exact, non-overlapping projections.  Used by the entry configuration and later harness equations. |
| `absHarnessRunCodeId()` (one equation) | Definitional summary | Selects constant 0 of the module code object's `coConsts`, the embedded `run` code object, for `<fExecutable>`. | The supplied image has `run` in constant slot 0.  Used by the claim's current frame; body-sensitivity mutation of that selected code invalidated the proof. |
| `absHarnessAId()` and `absHarnessResId()` (two equations) | Definitional summaries | Allocate names `N` and `N+1`, where `N` is boot plan `nextId`; affect only the entry object/pointer formulas. | Integer definitions, disjoint object IDs.  Used by entry objects, locals, and final target. |
| `absHarnessInputObjects(A,RES)` (one equation) | Definitional summary over all `A, RES : Int` | Adds exact Python-int objects at the two fresh IDs to the complete boot object map. | K map updates plus the fresh-ID construction define a realizable entry heap.  Used on the claim LHS and as the base of the final map. |
| `absHarnessInitialNextId()` (one equation) | Definitional summary | Defines allocator state `N+2` after the two input objects. | Exact arithmetic definition, used on both sides of the claim and by final summaries. |
| `absSpec(A)` (two equations) | Definitional summary; `A<0` gives `0-A`, `notBool(A<0)` gives `A` | Names the result value only on the target side; it never replaces the executed comparison or subtraction.  It influences the final integer object and result pointer. | Guards are disjoint and exhaustive for `Int`; RHSs are the mathematical absolute value and terminate immediately.  `SPEC.run-abs` is the bridge-free universal connection theorem.  The finite oracle found zero mismatches. |
| `absFinalObjects(A,RES)` (three equations) | Definitional summary; nonnegative, negative/small result, negative/non-small result | Describes the complete post-heap: reuse `a` for nonnegative input, use a static small-int object for a negative input with small absolute value, or allocate an int then tuple otherwise. | The three guards are pairwise disjoint and exhaustive.  Each equation preserves the full input/boot map and records every allocation.  Fresh symbolic proof leaves cover all three cases. |
| `absFinalTupleId(A)` (three equations) | Definitional summary with the same three guards | Names the tuple ID for each representation case. | Truthful, disjoint, exhaustive, terminating; currently unused by `SPEC.run-abs`, so it contributes no closure. |
| `absFinalNextId(A)` (three equations) | Definitional summary with the same three guards | Constrains the allocator to `N+1` when only a tuple is allocated and `N+2` when an int and tuple are allocated. | Truthful, disjoint, exhaustive; used in `<nextId>` target. |
| `absFinalResultId(A)` (three equations) | Definitional summary with the same three guards | Constrains the final local `res` pointer: original `a`, a static small-int ID, or newly allocated integer ID. | Truthful, disjoint, exhaustive; used in `<localsplus>`.  The A5 mutation demanding the stale input-`res` pointer was rejected. |
| `absFinalInstructionPointer(A)` (two equations) | Definitional summary; negative/nonnegative partition | Constrains completed opcode address to return site 19 or 24. | Exact return sites in the supplied image; disjoint/exhaustive; proved by fixed execution. |
| `absFinalNextInstruction(A)` (two equations) | Definitional summary; negative/nonnegative partition | Constrains next-instruction cursor to 20 or 25. | Exact successors of the two return sites; disjoint/exhaustive; proved by fixed execution. |
| `SPEC.run-abs` | Reachability claim, not an admitted lemma; all `A, RES : Int`, no `requires` | Executes `<k> #dispatch => #normalExit` with the exact `run` code object and two bound int objects.  Constrains the complete object map and allocator, final locals, stack, control/IP fields, exception state, and terminal control; other cells are framed by the claim. | Fresh validation and unbounded proof pass.  No dependency/trust attribute exists.  False-result and executed-body mutations are both rejected with reachable residuals. |

### Operational-bridge and result-abstraction review

There is no operational bridge, so no local extension has a broader
continuation, abrupt control effect, weakened binding context, or state
footprint requiring a bridge connection theorem.  Every program instruction is
executed by the bundled fixed semantics between `#dispatch` and `#normalExit`.

There is no fresh or opaque result oracle.  `absSpec` is fully fixed by two
exhaustive equations and occurs only in the target layer.  The main claim is
itself a universal, bridge-free connection from fixed execution to that value.
The body mutation supplies an opposite-behavior witness on negative inputs:
changing subtraction to addition changes the concrete symbolic result and makes
the unchanged `absSpec` target fail.

## Commands and actual results

All live `validate` and `prove` invocations used `--task-timeout 1800`.

1. `kprover health`
   - Exit 0; output: `{"kVersion":"7.1.337","status":"ok"}` (pretty-printed by the client).
2. `kprover semantics`
   - Exit 0; the `python-3-14-6` entry is repository
     `https://github.com/nlp-research-rosu/semantics-python-3.14.6`, commit
     `e5d24a5429a4`.
3. `kprover session show 35db469f-c5f8-4f79-8efd-b94e254c92fe --project /app`
   - Exit 0; construction session pin matches the ID/repository/commit above.
4. `kprover session start --project /app --semantics python-3-14-6`
   - Exit 0; created audit session
     `a4284896-cf66-424f-9b7b-660707e9d5fa` with the same pin.
5. `sha256sum` over both sets of `spec.k`, `verification.k`, and `subject.k`
   - Exit 0; corresponding hashes are identical and are listed under
     “Artifacts examined”.
6. Positive validation:

   ```sh
   kprover validate --session a4284896-cf66-424f-9b7b-660707e9d5fa --project /app --semantics python-3-14-6 --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/subject.k --claim SPEC.run-abs --task-timeout 1800
   ```

   Exit 0; task `b1f35056-0dbc-47d3-b1e2-deb62c4f7d72`,
   `status=completed`, `valid=true`, final tool exit 0.  Full output:
   `validation-001/result.json`.
7. Positive proof:

   ```sh
   kprover prove --session a4284896-cf66-424f-9b7b-660707e9d5fa --project /app --semantics python-3-14-6 --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/subject.k --claim SPEC.run-abs --task-timeout 1800
   ```

   Exit 0; task `e95b5af3-57ca-44b8-8c3c-b27bef802fac`,
   `status=completed`, `outcome=proved`, final tool exit 0.  Exact stdout:
   `PROOF PASSED: SPEC.run-abs`.  The three symbolic leaves cover the
   nonnegative, negative/small-result, and negative/non-small-result cases.
   Full output: `proof-001/result.json`.
8. Exact subject-image comparison:

   ```sh
   sed -n '10s/^.*=> //p' inputs/subject.k | cmp -s - /app/program.kpyc
   ```

   Exit 0; recorded output: `subject_program_exact_match=true`.
9. Independent finite oracle:

   ```sh
   python3 /app/audits/abs-summary-check.py
   ```

   Exit 0; exact output:
   `samples=2014 summary_mismatches=0 program_mismatches=0`.

## Gate A — real-program soundness: PASS

- **A1 / identity and body sensitivity:** The `<pyc>` term is byte-for-byte the
  supplied `.kpyc`; the selected code object is constant 0 of that boot image;
  its two local slots are bound to the exact fresh `a` and `res` int objects.
  No local execution rule exists.  The subtraction-to-addition mutation changes
  the term actually booted/executed and is rejected specifically on the
  negative branch.
- **A2–A3 / state, binding, evaluation, and control:** There is no operational
  bridge.  Fixed semantics executes the comparison, branch, arithmetic, store,
  tuple construction, and return.  The claim observes terminal control, both
  local pointers, full objects, allocator, stack, instruction cursors,
  exception state, and frame identity.  No local rule can skip evaluation,
  change binding, discard a continuation, or suppress an exception.
- **A4 / equations:** Every multi-rule symbol uses either the two-way integer
  sign partition or its three-way refinement by `isSmallIntValue` and Boolean
  complement.  Guards are exhaustive and pairwise disjoint; RHSs agree with the
  exact representation case, are nonrecursive, and terminate.  Single-rule
  constructors/projections have no overlap.
- **A5 / non-vacuity:** `A=1, RES=7` realizes the unrestricted entry state.  The
  recorded audit rejected a false target demanding the stale input-result
  pointer. Fixed execution overwrites that pointer, so this check confirmed
  that the theorem constrains a reachable result.
- **Program pinning:** The claim executes the actual program term and constrains
  `res`, returned tuple representation, control, memory, and allocator to
  `absSpec(A)` rather than a free variable or tautology.

## Residual Gate B — intent adequacy: PASS

- **B1:** There is no `requires` clause, magnitude bound, finite unrolling, or
  dropped branch.  `A` and initial `RES` range over every K `Int`; `RES` is
  irrelevant only because fixed execution overwrites it on both branches.
- **B2:** The theorem uses the pinned Python 3.14.6 semantics and the exact
  supplied 3.14.6 bytecode.  The relevant behavior is unbounded integer
  comparison/subtraction and object allocation, all represented by this model;
  no candidate-created model restriction remains.
- **B3:** `absSpec`'s exhaustive equations are exactly the intended absolute
  value, while the remaining summaries describe only its Python-object and
  control representation.  Fixed execution, not a bridge, proves the
  connection.  Finite testing is reported only as corroboration.
- **B4:** The bytecode sequence has the same branch, assignment, and returned
  pair as `program.py`.  The formal boundary is one direct invocation of `run`,
  as approved; module definition/import and caller-side binding are excluded,
  not silently narrowed inside the function contract.
- The proven theorem is the approved `SPEC.run-abs`; proving did not strengthen
  a precondition, omit a claim, add a depth bound, or alter summary meaning.

## Gate C — trust and evidence auditability: PASS

### Trust ledger

| Named assumption | Effect and dependents | Evidence/status |
|---|---|---|
| Correctness of bundled semantics `python-3-14-6` at `e5d24a5429a4` as a model of the intended Python 3.14.6 bytecode behavior | Affects all execution, state, control, exception, and allocation conclusions in `SPEC.run-abs`. | Immutable registry/session pin, exact repository/commit, clean-room replay.  Bundled semantics is not included among candidate K helpers and was not modified. |
| Correctness of K compilation, the Haskell backend, PyK APR orchestration, and its constraint solving | Affects formal closure of the selected claim and interpretation of residuals. | Retained server tasks, definition IDs, typed outcomes, tool exits, stdout/stderr, and symbolic-leaf metrics.  No claim was admitted. |
| Supplied `.kpyc` is the compiled representation intended to correspond to `program.py` | Source-level reading depends on this; the formal theorem itself is directly about the exact `.kpyc` term. | Exact `.kpyc` embedding comparison, direct inspection of its named bytecode instructions, source execution over the documented finite sample, and body-sensitivity evidence.  This correspondence is not promoted to a separately proved compiler theorem. |
| Python's built-in `abs` and normal `program.py` execution are valid executable oracles for the finite differential check | Affects empirical corroboration only, not formal closure. | Reproducible artifact and zero-mismatch output below. |

There are no `--trusted` claims, trusted local primitives, operational bridges,
or program-derived opaque values.

### Reproducible empirical evidence

`/app/audits/abs-summary-check.py` independently uses Python's built-in `abs`
as the value oracle and executes `/app/program.py`.  Its complete input list is
`-(10**100), -513, -257, -256, -2, -1, 0, 1, 2, 256, 257, 513, 10**100`
plus every integer from `-1000` through `1000` (2,014 listed samples, including
duplicates at overlap).  It checks both `k_summary(value) == abs(value)` and
`run(value, 123456789) == (value, abs(value))`.  Exit 0 and zero mismatches
support only those finite inputs; they do not replace the universal proof.

The successful proof commands, exact subject-image comparison, and finite check
are recorded above. The original audit also passed body-sensitivity and
non-vacuity checks, summarized in Gate A. Formal, conditional, empirical, and
excluded conclusions are kept separate.

## Final status

Gate A: PASS.  Gate B: PASS.  Gate C: PASS.  The decidable proof-report status
is `VALIDATED`; `/app/PROOF.md` is issued.

VERDICT: PASS
REASON: Gates A, B, and C pass; the clean-room proof is VALIDATED with no trusted claims or execution-replacing extensions.
