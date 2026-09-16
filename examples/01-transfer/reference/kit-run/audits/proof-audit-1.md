# Proof audit 1 — `transfer(address,uint256)` of StandardToken (EVM bytecode)

**Mode:** independent clean-room proof audit (validating-proof skill). The
on-disk candidate proof is untrusted evidence; no constructor report was read.
Fresh audit session started; construction session `5acb1515-…` and its task IDs
were NOT reused. Construction inputs left unmodified.

## Audit session and semantics confirmation

- **Audit session:** `65dd4426-936e-4f21-adc2-4680c4b98d2f`
  (`kprover session start --project …/01-transfer --semantics evm`).
- **Semantics pin (independently confirmed):** `evm`,
  repo `https://github.com/nlp-research-rosu/semantics-evm`, commit
  `4f4c3843076c` — matches `kprover semantics` server listing and SCOPE.md
  (`evm` / `4f4c3843076c`). `kprover health` → `{"status":"ok","kVersion":"7.1.337"}`.
- Definition id used by every task: `7_1_337-haskell-evm-4f4c3843076c-…`.

## Artifacts examined

- `.kprover/sessions/5acb1515-…/inputs/spec.k` (module `TRANSFER-SPEC`, 5 claims)
- `.kprover/sessions/5acb1515-…/inputs/verification.k`
  (`VERIFICATION-SUMMARIES` + `VERIFICATION`)
- `SCOPE.md`, `prove.sh`, `audits/spec-audit-1.md`
- `contract/StandardToken.inlined.sol`, `contract/StandardToken.inlined.bytes`,
  `eip-20.md`
- Pinned semantics sources (`kprover semantics fetch evm`):
  `edsl.md`, `lemmas/lemmas.k`, `abi.md`, `evm.md`, `hashed-locations.md`.

Audit inputs were copied into
`.kprover/sessions/65dd4426-…/inputs/{spec.k,verification.k}` and verified
byte-identical (sha256) to the construction originals. `verification.k` embeds
the bytecode; no extra source files are required.

## Commands run (every command, exit status, task ID)

| # | Command (abbrev.) | Task ID | Exit | Result |
|---|---|---|---|---|
| 1 | `kprover session start --project …/01-transfer --semantics evm` | — | 0 | session `65dd4426-…`, pin `evm@4f4c3843076c` |
| 2 | `kprover session show 65dd4426-…` | — | 0 | pin confirmed `evm@4f4c3843076c` |
| 3 | `kprover semantics` | — | 0 | `evm` pinned server-side at `4f4c3843076c` |
| 4 | `kprover health` | — | 0 | `status ok`, kVersion 7.1.337 |
| 5 | `kprover semantics fetch evm` | — | 0 | sources at `…/semantics-evm/4f4c3843076c` |
| 6 | `kprover validate --session 65dd4426-… --spec inputs/spec.k --spec-module TRANSFER-SPEC --verification inputs/verification.k --verification-module VERIFICATION` | `9ef4b97b-ab29-42c9-8a8e-fb37cfcb12c1` | 0 | `valid: true` (validation-001) |
| 7 | `kprover prove --session 65dd4426-… --spec inputs/spec.k --spec-module TRANSFER-SPEC --verification inputs/verification.k --verification-module VERIFICATION` | `976eaa90-cdd6-43f3-84ef-a3694a8f05dd` | 0 | `outcome: proved`, residual null, 5/5 PASSED (proof-001) |
| 8 | `kprover prove --session 65dd4426-… --spec inputs/spec_mut.k --spec-module MUTANT --verification inputs/verification.k --verification-module VERIFICATION` | `830f41d8-6b96-456c-9248-b274327f7c36` | 1 | `outcome: notProved`, 1 failing node (proof-002) — A5 mutation |

### Positive run raw result (proof-001/result.json, stdout)

```
PROOF PASSED: TRANSFER-SPEC.transfer-overflow
PROOF PASSED: TRANSFER-SPEC.transfer-self
PROOF PASSED: TRANSFER-SPEC.transfer-success
PROOF PASSED: TRANSFER-SPEC.transfer-not-payable
PROOF PASSED: TRANSFER-SPEC.transfer-insufficient
```
`result.outcome = "proved"`, `residual = null`, kprove `exitCode 0`. All five
claims (`transfer-success`, `transfer-self`, `transfer-insufficient`,
`transfer-not-payable`, `transfer-overflow`) close in my own clean-room session
with the exact `prove.sh` invocation (all five together, no depth bound).

## Proof-extension inventory (rebuilt from files, not from construction record)

Full proof-local surface of `verification.k` (`grep` of every
`rule/claim/syntax/context/configuration/imports`):

- **`VERIFICATION-SUMMARIES`** (`imports EVM`):
  - `syntax Bytes ::= "StandardTokenRuntime" [function, symbol(StandardTokenRuntime)]`
  - `rule StandardTokenRuntime => #parseByteStack("0x6060…0029")`
  - No other rule/claim/context/configuration.
- **`VERIFICATION`** (`imports EDSL`, `imports LEMMAS`,
  `imports VERIFICATION-SUMMARIES`): imports only, no rules.
- **`spec.k` / `TRANSFER-SPEC`**: the 5 reachability claims, no rules.

| Extension | Class | Justification / finding |
|---|---|---|
| `StandardTokenRuntime => #parseByteStack("0x…")` | Definitional constant | Names the code under proof. Verified byte-for-byte equal to `contract/StandardToken.inlined.bytes` (2091 bytes / 4184 hex chars, `0x`-prefixed; Python sha/compare: EXACT MATCH). `#parseByteStack` is a stock semantics symbol. It supplies bytecode, it does **not** rewrite any program term before `#execute`. |
| `imports EDSL` | Generic semantics import | `EDSL` module is defined in the pinned semantics (`edsl.md`); supplies `#abiCallData`, `#abiEventLog`, `#hashedLocation`, `#buf`, `#lookup`, storage helpers. Not proof-local. |
| `imports LEMMAS` | Generic semantics import | `LEMMAS [symbolic]` defined in pinned semantics (`lemmas/lemmas.k`); byte/integer/storage simplifications. Not proof-local. |

The `requires "edsl.md"` / `requires "lemmas/lemmas.k"` in `verification.k`
resolve to files that exist in the pinned semantics tree
(`…/evm-semantics/edsl.md`, `…/evm-semantics/lemmas/lemmas.k`) — not to
proof-local copies.

**No operational bridge and no result-bearing abstraction exist.** No
proof-local rule rewrites a program term; the semantics executes `#execute`
over the real bytecode to `#halt`. Note verification.k imports `EDSL` (generic
helpers), NOT the semantics' `EDSL-SUMMARY`/`EDSL-SUM` modules — so no
summarization/bridge machinery is engaged. `VERIFICATION-SUMMARIES` is not
edited relative to the spec-audit-approved form (still contains only the
bytecode constant; the module comment states the theorem is summary-free
because `transfer` is loop-free — confirmed).

## Gate A — Real-program soundness: PASS

- **A1 program identity / body sensitivity.** Every claim's `<k>` is
  `(#execute => #halt) ~> _`, `<program>`/`<code>` bound to
  `StandardTokenRuntime` (the real bytecode), `<pc> 0`,
  `<callData> = #abiCallData("transfer", #address(TO), #uint256(VALUE))`. The
  real dispatcher (incl. the non-payable `CALLVALUE ISZERO` guard) executes.
  No program-defined body is replaced by a summary. Body sensitivity is
  witnessed by the A5 mutation: the storage postcondition tracks the value the
  real bytecode writes (see residual below).
- **A2 operational-state preservation.** No bridge skips execution; the
  semantics carries all cells. Observable postconditions constrain
  `<output>`, `<statusCode>`, the token account `<storage>`, and `<log>`;
  scratch cells (`<wordStack>`, `<localMem>`, `<pc>`, `<gas>`, `<memoryUsed>`,
  `<refund>`, `<origStorage>`) are `?_` per SCOPE.md — not part of the property.
- **A3 binding / control / value fidelity.** No operational bridge and no
  result-bearing opaque abstraction to connect; every value-bearing symbol
  (`#lookup`, `chop`, `#hashedLocation`, `#buf`, `#abiEventLog`) is a stock
  KEVM definitional helper, so §"result-bearing abstraction" and
  §"operational-bridge" obligations are vacuously satisfied (no such extension
  present).
- **A4 logical consistency.** The single proof-local rule is a nullary constant
  with no guard and no overlapping companion; no equational hazard.
- **A5 result constraint / non-vacuity — PASS (mutation authored and run).**
  - **Mutation (authored by auditor):** file
    `inputs/spec_mut.k`, module `MUTANT`, claim `transfer-success-mut` — a copy
    of `transfer-success` with ONE false change: the recipient slot RHS is
    `BAL_TO +Int VALUE +Int 1` instead of `BAL_TO +Int VALUE`. False for every
    satisfiable input.
  - **Satisfiable witness:** `ACCTID = CALLER_ID = 1`, `TO = 2`, `VALUE = 1`,
    `BAL_FROM = 1`, `BAL_TO = 0`, `ACCT_STORAGE` with those two slots — all
    preconditions hold (`CALLER≠TO`, slots distinct, `VALUE>0`,
    `BAL_FROM≥VALUE`, `BAL_TO+VALUE<pow256`).
  - **Command:** `kprover prove --session 65dd4426-… --spec inputs/spec_mut.k
    --spec-module MUTANT --verification inputs/verification.k
    --verification-module VERIFICATION`
  - **Exit / outcome:** exit **1**, `outcome: notProved`, task
    `830f41d8-6b96-456c-9248-b274327f7c36` (proof-002).
    `PROOF FAILED: MUTANT.transfer-success-mut`, `1 Failure nodes. (0 pending
    and 1 failing)`.
  - **Residual (unmet condition, `<storage>` cell match failure, path
    condition `#Top`):** the antecedent (real execution) writes
    `#lookup(ACCT_STORAGE, keccak(#buf(32,TO)+Bytes …01)) +Int VALUE` to the
    recipient slot, while the consequent (mutant) demands
    `… +Int VALUE +Int VALUE +Int 1` (KEVM re-expresses
    `BAL_TO ==Int #lookup(…)`, so the extra `+Int 1` — and the doubled VALUE
    from substituting the recipient's own prior balance — surfaces as an
    unsatisfiable equality). The mutation is rejected exactly at the recipient
    balance update, confirming the success claim genuinely constrains the
    recipient balance to `BAL_TO + VALUE`.

Gate A PASS: the proof's only extension is a faithful bytecode constant plus
generic semantics imports; execution is real; results are non-vacuously
constrained.

## Residual Gate B — intent adequacy: PASS

Rechecked against `contract/StandardToken.inlined.sol` `transfer` and `eip-20.md`,
independently of spec-audit-1's verdict; also compared the proven theorem to
the approved spec (unchanged — proving added no equations, strengthened no
`requires`, dropped no claim, used no depth bound).

- **B1 input domain.** `balances` slot = 1 (source order totalSupply=0,
  balances=1, allowed=2; confirmed by bytecode `6001…SLOAD` mapping accesses and
  the `#hashedLocation("Solidity",1,·)` addressing). The five claims partition
  the `transfer` selector's reachable behaviour:
  success/overflow together cover `to≠caller ∧ value>0 ∧ bal[caller]≥value`
  (split on the recipient-wrap predicate, no gap); self covers `to=caller`;
  insufficient covers `bal[caller]<value` (which forces `value>0`, so the
  else-branch is reached cleanly); not-payable covers `callValue>0`. These are
  exactly the five requested properties.
- **B2 model adequacy.** KEVM ISTANBUL, `useGas=true`, symbolic `#gas`. Unchecked
  0.4.x wrap is modelled by `chop` (mod 2^256); `transfer-overflow`'s RHS uses
  `chop(BAL_TO+VALUE)`, the faithful form. No model boundary asserted without
  a witness.
- **B3 summary-to-property.** No summary function exists; each postcondition is
  stated directly over configuration cells, so there is no summary→property
  bridge to trust.
- **B4 implementation-vs-intent.** The theorem states what the code does:
  returns `false` on low balance (not revert), silent recipient overflow, and
  rejects `value==0` (guard `value>0`). Deviations from EIP-20 SHOULDs
  (throw-on-insufficient; zero-value transfers as normal) are recorded as
  implementation/spec discrepancies in SCOPE.md, not asserted as compliance.
  `value==0` is a stated, deliberate exclusion from the positive theorem.

No domain narrowing beyond the disclosed, contract-honest exclusions. Gate B PASS.

## Gate C — trust and evidence auditability: PASS

- **C1 trust ledger.** One named assumption:
  `#hashedLocation("Solidity",1,CALLER_ID) =/=Int
  #hashedLocation("Solidity",1,TO)` (keccak collision-resistance / storage-slot
  distinctness). KEVM models `keccak` as an uninterpreted SMT function with no
  injectivity axiom, so `CALLER_ID =/= TO` alone does not entail slot
  distinctness. Recorded in SCOPE.md.
  - **Dependents:** `transfer-success`, `transfer-overflow` (the distinct-account
    claims). **Independent of it:** `transfer-self`, `transfer-insufficient`,
    `transfer-not-payable`.
  - Affects: value/state (which storage slot the recipient write lands in). No
    control/termination assumption.
- **C2 reproducible evidence.** All evidence is retained under the audit
  session: positive run `proof-001/result.json` (task `976eaa90-…`), mutation
  `proof-002/result.json` (task `830f41d8-…`), validation `validation-001`
  (task `9ef4b97b-…`). Bytecode equality check reproduced by
  byte comparison against `contract/StandardToken.inlined.bytes`. No
  differential-test artifact is claimed (no summary/abstraction to
  differentially test) — none required.
- **C3 honest result language.** Reflected in PROOF.md: formally-proved facts
  vs the one assumption-conditional pair vs excluded behaviour are separated.

Gate C PASS.

## Findings

No finding rises to FAIL. All five claims reconstruct to `#Top`/proved in the
clean room; the sole proof extension is a byte-faithful bytecode constant plus
stock EDSL/LEMMAS imports (no bridge, no opaque result-bearing abstraction); the
authored A5 mutation is correctly rejected with a storage-slot residual; the
keccak-distinctness assumption is the only trust-ledger entry, disclosed in
SCOPE.md and confined to the two distinct-account claims.

```text
VERDICT: PASS
REASON: All five claims independently reconstruct to proved/#Top under the pinned evm@4f4c3843076c semantics; the only proof extension is a byte-faithful runtime-bytecode constant plus generic EDSL/LEMMAS imports (no operational bridge or opaque abstraction), the authored false-postcondition mutation is correctly rejected with a stuck storage residual, and the single keccak-distinctness assumption is ledgered — Gates A, B, C all PASS, final status VALIDATED.
```
