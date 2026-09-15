# Proof audit 1 — StandardToken ERC20 (EVM bytecode, KEVM)

Auditor: validating-proof subagent. Clean-room, dynamic + static.
Construction session (untrusted evidence): `787a58a8-8dc5-4b9e-93ed-40e49f22bedf`.
Clean-room audit session (mine): `ec1b5850-5f8b-477d-885d-9f7eafb6de99`.
Date: 2026-09-16.

Constructor's report was NOT read. All conclusions are from on-disk artifacts,
the original contract/EIP, and my own fresh prover runs.

## Artifacts examined

- `inputs/spec.k` (18 reachability claims), sha256 `058025103f81…34136`
- `inputs/verification.k` (extensions), sha256 `e3e8b907b2b1…2f473`
- `SCOPE.md`, `gen_spec.py`, `prove.sh`, `eip-20.md`
- `contract/StandardToken.inlined.sol`, `contract/StandardToken.inlined.bytes`
- recorded proof `proof-002/result.json` (18-claim `proved`), `proof-001` (4-claim subset)
- pinned semantics sources: `hashed-locations.md`, `serialization.md`,
  `lemmas/lemmas.k` at commit `4f4c3843076c`

## Commands run (clean room), with exit status

| # | Command | Result | Exit |
|---|---|---|---|
| 1 | `kprover health` | `{"kVersion":"7.1.337","status":"ok"}` | 0 |
| 2 | `kprover semantics` | `evm` pinned `4f4c3843076c` (matches) | 0 |
| 3 | `kprover session start --semantics evm` | session `ec1b5850…`, commit `4f4c3843076c` | 0 |
| 4 | `kprover session show ec1b5850…` | pin `4f4c3843076c` confirmed | 0 |
| 5 | `kprover validate --session ec1b5850… --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION` | `valid: true`, defId `7_1_337-haskell-evm-4f4c3843076c-bedddccf…adfb` | 0 |
| 6 | `kprover prove …` (all 18, no depth bound) | `outcome: proved`, `residual: null`, task `46f4cc81-940d-4b4d-9110-46e9271b1816`, 18× `PROOF PASSED` | 0 |
| 7 | `kprover prove … --spec inputs/spec_mut.k --spec-module SPEC_MUT …` (false-postcondition mutant) | `outcome: notProved`, `PROOF FAILED`, task `0234c459-1519-4d44-884a-c900feb28827` | 1 |

Bytecode identity check (python): `StandardTokenCode` constant in verification.k
is byte-identical to `contract/StandardToken.inlined.bytes` (both 4184 hex chars,
`MATCH: True`). Selectors recomputed from function signatures via keccak-256
match the dispatcher table AND the `dispatch-unknown-selector` exclusion set
exactly: approve 0x095ea7b3 / transferFrom 0x23b872dd / balanceOf 0x70a08231 /
transfer 0xa9059cbb / allowance 0xdd62ed3e = {157198259, 599290589, 1889567281,
2835717307, 3714247998}.

## Clean-room reconstruction (dynamic half)

Semantics confirmed independently: my session's pinned commit `4f4c3843076c`
equals the construction session's, and the compiled `definitionId` matches the
recorded run. Sources copied byte-identical (sha256 verified) into my
`inputs/`. Fresh `prove` closed all 18 claims: `proved`, K exit 0, raw outcome
with `residual: null`. Per-claim stdout listed exactly the 18 expected labels
(no missing, no extra). A claim counts as closed here on my own task, not on any
reused content address. PASS.

## Proof-extension inventory (rebuilt from files, not the construction record)

Three extension groups contribute to closure. None edits the spec-approved
`VERIFICATION-SUMMARIES` beyond its definitional content; the keccak lemmas live
in a separate `ERC20-KECCAK-LEMMAS [symbolic]` module.

### E1. `#StandardTokenCode` (Definitional summary — the program constant)
- Rule `#StandardTokenCode => #parseByteStack("0x6060…0029")`.
- Class: definitional summary (names the runtime bytecode). Not an operational
  bridge: it never rewrites a program term in `<k>`; it only supplies the
  `<program>`/`<code>` bytes that fixed semantics then executes from `pc 0`.
- Justification: byte-for-byte equal to the target `.bytes` (checked). Program
  pinning holds — the `<k>` cell runs `#execute` over this exact code.

### E2. `#bal(A)`, `#alw(A,B)` (Definitional summary — storage-slot aliases)
- `#bal(A) => #hashedLocation("Solidity", 1, A)`,
  `#alw(A,B) => #hashedLocation("Solidity", 2, A B)`.
- Class: definitional summary. `#hashedLocation` is defined by the fixed
  semantics itself (`hashed-locations.md`, the Solidity rule is `[simplification]`
  and expands to `keccak(#bufStrict(32,OFFSET) +Bytes #bufStrict(32,BASE))`).
- Semantic role: reasons about storage keys only; appears exclusively inside
  `<storage>` cells (11 occurrences, none inside `<k>`, verified by grep). It
  does not replace execution. The running bytecode independently computes the
  same keccak slot; the symbolic keys then unify. The mutant residual (below)
  shows the real expansion `keccak(#buf(32,SPENDER) +Bytes keccak(#buf(32,
  CALLER_ID) +Bytes …\x02))` for `allowed[caller][spender]` at slot 2, i.e. the
  alias is faithful to the layout SCOPE.md/§3 records.

### E3. `ERC20-KECCAK-LEMMAS` (Trusted primitive — keccak collision-freedom)
- `keccak(A)==Int keccak(B) => A==K B` (+ ML form); `keccak(sym)==Int conc =>
  false`, `keccak(sym)=/=Int conc => true` (+ ML forms).
- Class: trusted primitive / named cryptographic assumption. In the pinned
  semantics `keccak` is `[symbol(keccak), function, total]` with a single
  `[concrete]` rule (`serialization.md:60-62`): a symbolic argument stays an
  uninterpreted term, and the bundled `lemmas.k` supplies ONLY range bounds
  (`0 <= keccak(_) < pow256`), no injectivity. So these lemmas genuinely add the
  standard collision-freedom idealization; they are not theorems of the model.
- Value influence: they conclude ONLY equalities/inequalities among storage
  keys (distinct mapping slots are distinct; a symbolic slot ≠ concrete slot 0).
  They never mention balances, allowances, VALUE, output, statusCode, or logs —
  so they cannot state or entail the ERC20 postcondition. Delete-test: they do
  not encode the target property (their statements are about `keccak`, not the
  program result), so they are legitimate assumptions, not the theorem-as-axiom.
- Trust ledger: recorded in SCOPE.md §6 and in verification.k comments as
  assumptions. No collision witness is exhibitable, so no realizable
  false-conclusion witness exists → recorded as a trust-boundary item (Gate C),
  not a Gate A soundness failure.

No operational bridges exist (no rule rewrites a program term mid-execution),
so the operational-bridge context procedure has no subject. No fresh/opaque
result-bearing program-derived abstraction is introduced (returned words are
tied to stored symbols the bytecode itself produces, e.g. `balanceOf` output
`#buf(32,BAL)` with `#bal(OWNER) |-> BAL`), so the result-bearing abstraction
procedure yields only the E3 trusted-boundary classification above.

## Gate A — Real-program soundness: PASS

- A1 program identity / body sensitivity: every claim's `<k>` is `#execute` at
  `pc 0` over `<program>#StandardTokenCode</program>`, which equals the target
  bytecode. Body sensitivity is demonstrated by the mutant run (command 7): the
  prover executed the real approve() body and derived `allowed[caller][spender]
  = VALUE`; the false postcondition failed to match. A material change to the
  asserted result changes the proof outcome. PASS.
- A2/A3 state preservation, binding, control: no bridge skips execution;
  fixed semantics runs the whole dispatcher + body to `#halt`. The observed
  cells (`output`, `statusCode`, `log`, `storage`, and `refund 0`,
  `callStack .List`) are the callee frame's real halting configuration. PASS.
- A4 rule validity: E1/E2 are truthful expansions. E3 equations are the
  collision-freedom idealization; their guards (`symbolic`/`concrete`,
  `comm`, priority 30) are internally consistent and confined to keccak terms.
  No off-path globally-false program rule. The one non-theorem (keccak
  injectivity) is a named assumption, ledgered — not a hidden false rule that
  enables a wrong ERC20 branch. PASS (with E3 as a Gate C trust item).
- A5 result constraint + non-vacuity: postconditions are concrete
  (`#buf(32,·)`, `EVMC_*`, explicit log append) — genuine constraints, not free
  variables. Non-vacuity established by command 7 (below). PASS.

### A5 non-vacuity (audit-authored mutation)

Mutation (on a COPY, distinct module `SPEC_MUT`, distinct file
`inputs/spec_mut.k`): in `approve-success`, storage RHS
`(#alw(CALLER_ID,SPENDER) |-> VALUE)` → `|-> (VALUE +Int 1)`. False for a
satisfiable witness, e.g. ACCT_ID=1, CALLER_ID=1, SPENDER=2, VALUE=0,
OLD_ALW=0: approve stores 0 but the mutant asserts 1.

Result: `outcome: notProved`, exit 1, task `0234c459-1519-4d44-884a-c900feb28827`.
`PROOF FAILED: SPEC_MUT.approve-success-mut`, 1 failing node. Residual (verbatim
storage cell of the stuck node, path condition `#Top`):

```
<storage>
  keccak ( #buf ( 32 , SPENDER:Int ) +Bytes #buf ( 32 , keccak ( #buf ( 32 , CALLER_ID:Int ) +Bytes b"…\x02" ) ) ) |-> VALUE:Int #Implies VALUE:Int +Int 1 REST:Map
</storage>
Path condition:
  #Top
```

The prover computed the real stored value `VALUE`; the implication
`VALUE #Implies VALUE +Int 1` failed under `#Top`, i.e. a genuine off-by-one
falsification over the full (satisfiable) domain. Not a parse error, timeout, or
unreachable-claim artifact. The precondition is realizable and the write is
reached (full bytecode present in the `<code>` cell). Non-vacuity: PASS.

## Residual Gate B — intent adequacy: PASS (with recorded EIP-20 divergences)

- B1 input domain: addresses `#rangeAddress` (faithful — the code masks every
  address arg with 20-byte AND), uint256 `#rangeUInt(256,·)`, storage words
  ranged. `callDepth <= 1024`. Call-value axis split: functional/fail claims
  fix `callValue 0` (non-payable), `-revert-value` claims cover `callValue > 0`
  — jointly complete. No candidate-caused narrowing below the source contract.
- Domain completeness (checked): transfer partition on the code guard
  `(bal>=v && v>0)`: false → `transfer-fail`; true → success family split by
  `TO==CALLER` (self) and, for `TO!=CALLER`, `BAL_TO+VALUE < pow256`
  (no-overflow) vs `>= pow256` (overflow). Exhaustive. transferFrom analogous
  with the added `allowed>=v` conjunct. Dispatcher: `dispatch-short-calldata`
  (`lengthBytes(CD)<4`, symbolic CD) + `dispatch-unknown-selector`
  (`#buf(4,SEL)`, `0<=SEL<2^32`, SEL disjoint from the 5 real selectors,
  independently recomputed). Together with the 5 functions the dispatcher domain
  is covered.
- B2 language model: KEVM SHANGHAI, `useGas false` (documented modeling choice
  — removes out-of-gas branches; a well-funded caller observes exactly these
  behaviors). uint256 arithmetic is exact chop; the overflow claims state the
  genuine unchecked-ADD wrap (`BAL_TO+VALUE-pow256`). Adequate.
- B3/B4 summary-to-property and implementation-vs-spec: SCOPE.md §5 honestly
  records the EIP-20 divergences the theorem states as ACTUAL bytecode behavior,
  not as EIP-20 idealizations: (i) insufficient balance returns `false`+SUCCESS
  rather than the EIP "SHOULD throw"; (ii) zero-value transfer takes the false
  branch (no Transfer event, returns false) rather than EIP's MUST-fire. These
  are correctly reported as implementation/specification discrepancies; the
  proof does not claim behavior the program lacks. This is faithful adequacy,
  not narrowing. PASS.

## Gate C — trust and evidence auditability: see trust ledger

- C1 trust ledger — one named assumption: `ERC20-KECCAK-LEMMAS` (keccak
  collision-freedom / injectivity). Affects value only through storage-key
  identity/disjointness; every functional claim that reads/writes ≥2 distinct
  mapping slots depends on it (all transfer/transferFrom/approve/allowance
  success + balanceOf). Evidence: it is the industry-standard idealization for
  Solidity storage reasoning; keccak is otherwise opaque on symbolic input in
  this model. No collision witness exists, so no false ERC20 conclusion is
  enabled. Recorded, conditional.
- C2 reproducible evidence: all commands above have task IDs, evidence dirs,
  exit codes, and verbatim outputs retained (clean-room `proof-001` = positive,
  `proof-002` = mutant). Non-vacuity is a fresh audit-authored artifact.
- C3 honest result language: proved facts (18 claims of actual bytecode
  behavior) vs the one conditional assumption (keccak) vs excluded behavior
  (constructor, reentrancy, caller-side rollback, gas) are separated in PROOF.md.
- No differential-testing bridge is claimed for a program-derived summary, so
  the differential-test procedure has no subject; the only trusted item (keccak)
  is a fixed external primitive, correctly handled as an interpretation boundary
  rather than via finite tests.

Gate C passes: the sole unproved component is honestly ledgered with its
dependents and rationale, and every claimed artifact is reproducible.

## Per-gate results

- Gate A: PASS (extensions sound about the real program; non-vacuity confirmed)
- Gate B: PASS (domain complete over the actual bytecode; EIP-20 divergences are
  faithfully-reported implementation discrepancies, not narrowing)
- Gate C: PASS (single keccak assumption ledgered; evidence reproducible)

Final status: **VALIDATED** (conditional on the standard keccak
collision-freedom assumption recorded in the trust ledger).

## Findings

No unsound extension found; no false-conclusion witness exists for any
extension. The keccak lemmas are the standard, honestly-scoped cryptographic
assumptions and do not smuggle in the conclusion (they speak only about `keccak`
terms, never about the ERC20 result). No claim is vacuous: the mutation probe
demonstrates the postconditions are discriminating and the preconditions are
satisfiable and reached.

```text
VERDICT: PASS
REASON: All 18 claims re-proved in a clean room at the matching pin; extensions are sound (keccak = ledgered standard assumption, no operational bridges), the false-postcondition mutant returns notProved with an off-by-one residual under #Top, and the domain is complete over the actual bytecode — final status VALIDATED.
```
