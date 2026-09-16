# Proof audit 1 — StandardToken.transfer

Reviewer: same-agent review (inline fallback — the dispatched fresh-subagent audit
was interrupted by a server `STORAGE_EXHAUSTED` incident and its process was lost;
per `using-kit` the inline fallback re-checks strictly from the on-disk artifacts,
with a fresh clean-room session, replay, and a self-authored non-vacuity probe).
Construction reports were not used as evidence; the bytecode was re-disassembled
independently and constants re-derived.

## Sessions / server
- Construction session: `16dec4d8-3461-45d9-8112-23f9a0ec6c5b` (final proof `proof-003`, task `ed85c28c-e50d-4e3e-bd84-795136824ff1`, outcome `proved`).
- Clean-room AUDIT session: `8c86f354-0787-41a2-95ad-2d4e99c098d3`, `kprover session start --semantics evm` → pinned `evm@4f4c3843076c` (matches construction).
- Server `https://rv-prover.intentcomputing.org`, `kprover health` = ok, K 7.1.337. (The prior interrupted attempt used session `02ea26ba…` on a different instance; abandoned, not reused.)

## Artifacts examined
- `inputs/spec.k` (module SPEC, 5 claims), `inputs/verification.k` (VERIFICATION-SUMMARIES + VERIFICATION) — copied verbatim into the audit session (sha256 identical to construction copies).
- `SCOPE.md`, `prove.sh`, `audits/spec-audit-1.md`.
- Original inputs: `contract/StandardToken.inlined.bytes`, `contract/StandardToken.inlined.sol`, `eip-20.md`.

## Independent structural verification (own disassembler, `audit_disasm.py`)
- Dispatcher: `PUSH4 0xa9059cbb` at pc `0x58` → `PUSH2 0x0192; JUMPI` — transfer selector routes to `0x192`. ✓
- Non-payable guard at `0x193`: `CALLVALUE; ISZERO; PUSH 0x19d; JUMPI`, else `PUSH 0 DUP1 REVERT` (`0x199`–`0x19c`). ✓
- Balances slot: key computation at `0x60f` uses `PUSH1 0x01` (slot 1) then `mstore(key); mstore(0x01); sha3` → `balances[·]` at `#hashedLocation("Solidity",1,·)`. ✓
- Guard: `SLOAD balances[sender]; LT; ISZERO; … GT (value>0)`; combined `ISZERO; PUSH 0x76d; JUMPI` → false branch at `0x76d`. ✓
- False branch `0x76d`: `PUSH 0; SWAP1; POP; …; JUMP` — returns 0, **no REVERT**. ✓
- Recipient update `0x6f7`: `SLOAD; ADD; …; SSTORE` — **plain ADD, no overflow guard**. ✓

## Constant / macro checks (exact, against the source)
- `StandardTokenCode` `#parseByteStack("0x…")` == `StandardToken.inlined.bytes` **byte-for-byte** (4184 chars, string compare equal).
- `TransferTopic0 = 100389287136786176327247604509743168900146139575972864366142685224231313322991` = `0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef` = the `PUSH32` at pc `0x72e`, present in the bytecode. ✓

## Clean-room replay (positive claims)
Command:
```
kprover prove --session 8c86f354-0787-41a2-95ad-2d4e99c098d3 \
  --spec inputs/spec.k --spec-module SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION
```
Result: task `a0a462be-04c2-4730-90c5-37e199ec06e4`, status `completed`, outcome `proved`,
residual null, tool exit `[0,0]`, execution 756.9 s. stdout:
```
PROOF PASSED: SPEC.transfer-overflow
PROOF PASSED: SPEC.transfer-self
PROOF PASSED: SPEC.transfer-success
PROOF PASSED: SPEC.transfer-not-payable
PROOF PASSED: SPEC.transfer-insufficient
```
All five closed to `#Top` in my own session. Evidence: `.kprover/sessions/8c86f354…/proof-001/`.

## Proof-extension inventory (rebuilt from files)
`verification.k` adds **no** simplification rules, operational bridges, result-bearing
oracles, priority rules, or auxiliary claims. The VERIFICATION module's extension
section is empty; it only `imports EDSL`, `LEMMAS`, `EVM` (all bundled semantics).
The only additions are two **definitional constants** in VERIFICATION-SUMMARIES:
- `StandardTokenCode` (macro → the verified bytecode) — the program text the claims execute; not an execution-bypassing rule. Class: definitional/constant.
- `TransferTopic0` (macro → the verified event-sig integer) — a public constant. Class: definitional/constant.
No extension edits VERIFICATION-SUMMARIES post-spec-audit beyond these approved constants. The proof therefore closes essentially under the bundled semantics alone.

## Gate A — real-program soundness
- **A1 bodies execute:** the entry claims run `#execute` over `StandardTokenCode` (the exact runtime bytecode) to `#halt`; clean-room `#Top` and the mutation residual (below) show genuine symbolic execution of the code, not a summary. PASS.
- **A2/A3 operational bridges:** none exist — nothing preempts fixed execution. PASS (vacuous).
- **A4 result-bearing abstraction:** no summary functions; the only opaque symbol is `keccak`, supplied by the bundled semantics as an uninterpreted total function (not a candidate-added oracle). The macros are exact constants, not value oracles. PASS.
- **Program pinning:** entry `<k>` executes the real program term; `<output>`/`<storage>`/`<log>` are constrained to concrete intended values (not free variables), confirmed discriminating by A5. PASS.
- **A5 non-vacuity (self-authored):** `inputs/mutation-spec.k` module MUTATION = `transfer-success` with the sender-balance postcondition mutated to the false `BAL_FROM -Int VALUE +Int 1`. Command:
  ```
  kprover prove --session 8c86f354-… --spec inputs/mutation-spec.k --spec-module MUTATION \
    --verification inputs/verification.k --verification-module VERIFICATION
  ```
  Result: task `db9231b4-31ae-4802-beea-57e5844d9592`, outcome `notProved`, exit `[1]`,
  `PROOF FAILED: MUTATION.transfer-success-MUTATED`. Stuck node 4 fails matching on
  the `<storage>` cell with the unmet condition (path condition `#Top`, i.e. satisfiable):
  ```
  keccak(#buf(32, MSG_SENDER) +Bytes …0x…01) |-> BAL_FROM -Int VALUE
        #Implies                                 BAL_FROM -Int VALUE +Int 1
  ```
  The true execution stores `BAL_FROM -Int VALUE`; the false alternative is unreachable.
  This both establishes non-vacuity and independently confirms the storage key is
  `keccak(#buf(32,sender)+Bytes #buf(32,1))` = slot 1. PASS.

Gate A: **PASS.**

## Residual Gate B — intent adequacy (re-judged against the source, not the spec audit)
- The proven module is exactly the 5 requested claims; the final run was unfiltered and all closed. No proving-time narrowing (no strengthened `requires` added, no dropped claim, no bounded stand-in).
- Coverage of the positive-transfer space (`value>0`, sufficient balance) is complete across three claims: `to==sender` → transfer-self; `to≠sender ∧ no overflow` → transfer-success; `to≠sender ∧ overflow` → transfer-overflow. Failure/revert modes: `balances[sender]<value` → transfer-insufficient (return false, not revert — matches source `else return false` and the `0x76d` branch); `callvalue>0` → transfer-not-payable (revert). The `value==0 ∧ balance≥0` else-trigger is explicitly excluded from claim 3's "insufficient" reading in SCOPE.md — documented, not silent.
- transfer-overflow states the program's true wrapped result and remains `EVMC_SUCCESS`; it is a faithful **B4 implementation/spec discrepancy** vs EIP-20 (no SafeMath in this 0.4.x contract), not a false claim of correctness.

Gate B: **PASS.**

## Gate C — trust and evidence auditability
Named assumptions and dependents (all recorded in `SCOPE.md`):
1. **keccak collision-resistance** — claims `transfer-success`, `transfer-overflow` carry
   `#hashedLocation("Solidity",1,MSG_SENDER) =/=Int #hashedLocation("Solidity",1,TO)`
   alongside `MSG_SENDER =/=Int TO`. KEVM models `keccak` as an uninterpreted total
   function (`smtlib(smt_keccak)`), so distinct storage slots for distinct addresses is
   not derivable and is supplied as a precondition. It is a standard, universally-accepted
   EVM storage-aliasing assumption, is satisfiable (A5 witness discriminates under it),
   and — crucially — is stated as a scoped **precondition**, not as a global unsound
   simplification rule, so it cannot contaminate the other claims. Dependents: claims 1, 5 only.
2. **Execution environment** — `<schedule> ISTANBUL`, `<useGas> true` with infinite gas
   (`#gas(_VGAS)`), non-static call. Isolates functional correctness from gas exhaustion;
   all transfer opcodes exist under ISTANBUL. Dependents: all 5 claims.
Evidence: `prove.sh` present and matches the recorded run; construction `proof-003`
(`ed85c28c…`), audit replay `proof-001` (`a0a462be…`), mutation `proof-002` (`db9231b4…`)
all retained under their session evidence dirs. Constant checks are exact source
comparisons (no differential-test summary is needed — there are no summary functions).
Trust is fully documented and auditable.

Gate C: **PASS.**

## Status
Gates A, B, C all PASS → **VALIDATED**, conditional on the two named, standard,
recorded assumptions (keccak collision-resistance; ISTANBUL + infinite-gas environment).

## Verdict

VERDICT: PASS
REASON: All five transfer claims re-close to #Top in a clean-room session, no
execution-bypassing extensions exist, a self-authored false-postcondition mutation
is correctly rejected with a satisfiable residual, and intent/trust are adequate and
documented — status VALIDATED under the recorded keccak and gas/schedule assumptions.
