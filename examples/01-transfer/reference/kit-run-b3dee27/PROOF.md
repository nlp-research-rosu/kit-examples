VALIDATED

# Proof — StandardToken.transfer at EVM bytecode level

Status **VALIDATED**, conditional on two named, standard, recorded assumptions
(keccak collision-resistance; ISTANBUL schedule + infinite gas). All five requested
claims for `transfer(address,uint256)` were proved to `#Top` under KEVM and
independently re-proved in a clean-room audit session, a self-authored
false-postcondition mutation was correctly rejected, and Gates A/B/C all pass.

Review mode: construction by KIT pipeline; final proof audit performed as
**same-agent review** (inline fallback — the dispatched fresh-subagent audit was
interrupted by a server incident; the inline audit used a fresh clean-room session,
independent disassembly, independent replay, and a self-authored non-vacuity probe).

- Semantics: `evm` @ commit `4f4c3843076c` (KEVM, K 7.1.337), server `rv-prover.intentcomputing.org`.
- Target: runtime bytecode `contract/StandardToken.inlined.bytes` (2091 bytes). Claims are against this bytecode.
- Sources: `.kprover/sessions/16dec4d8-3461-45d9-8112-23f9a0ec6c5b/inputs/spec.k`, `…/inputs/verification.k`. Scope: `SCOPE.md`. Evidence script: `prove.sh`.

## What is proven

For an external call to selector `0xa9059cbb` (`transfer(address,uint256)`) on this
bytecode, observed at the bytecode level (storage, calldata, output, status, logs):

1. **Success** (`transfer-success`) — when `msg.sender ≠ _to`, `_value > 0`,
   `balances[msg.sender] ≥ _value`, and `balances[_to] + _value < 2²⁵⁶`: the call
   succeeds (`EVMC_SUCCESS`), `balances[msg.sender]` decreases by `_value`,
   `balances[_to]` increases by `_value`, ABI output is `#buf(32,1)` (true), and a
   single `Transfer(msg.sender,_to,_value)` `LOG3` entry is emitted.
2. **Self-transfer** (`transfer-self`) — when `_to == msg.sender`, `_value > 0`,
   `balances[msg.sender] ≥ _value`: the balances slot is unchanged, output is
   `#buf(32,1)`, and `Transfer(sender,sender,_value)` is emitted.
3. **Insufficient balance** (`transfer-insufficient`) — when
   `balances[msg.sender] < _value`: output is `#buf(32,0)` (false), storage and log
   are unchanged, and the call **returns normally (`EVMC_SUCCESS`), it does not
   revert**. (The source `else` returns `false`; the bytecode false branch at pc
   `0x76d` does a normal `RETURN`.)
4. **Not payable** (`transfer-not-payable`) — when the call carries `callvalue > 0`:
   the call **reverts** (`EVMC_REVERT`) with empty output; storage and log unchanged.
5. **Recipient overflow** (`transfer-overflow`) — when `msg.sender ≠ _to`, `_value > 0`,
   `balances[msg.sender] ≥ _value`, and `balances[_to] + _value ≥ 2²⁵⁶`: the recipient
   balance **silently wraps** to `chop(balances[_to] + _value) = balances[_to] + _value − 2²⁵⁶`,
   the call still succeeds and emits `Transfer`. This is a faithful record of the
   contract's missing overflow check (Solidity 0.4.x, no SafeMath) — an
   implementation/spec discrepancy versus the EIP-20 intent, not a claim that the
   behaviour is correct.

Storage layout used: `balances` is at slot 1 (`#hashedLocation("Solidity",1,addr)`),
confirmed both by disassembly (`PUSH1 0x01` before each `sha3` key hash) and by the
actual symbolic-execution residual (`keccak(#buf(32,addr)+Bytes #buf(32,1))`).

## Formal claims

Module `SPEC` (in `spec.k`), one reachability claim each:
`transfer-success`, `transfer-self`, `transfer-insufficient`,
`transfer-not-payable`, `transfer-overflow`. Each runs `<k> (#execute => #halt) ~> _`
over `<program>/<code> = StandardTokenCode` (the exact runtime bytecode) with
`<callData> #abiCallData("transfer", #address(TO), #uint256(VALUE))`, and constrains
the final `<output>`, `<statusCode>`, contract-account `<storage>`, and `<log>` cells
as summarized above. Full preconditions are in `spec.k`; scope and readings in `SCOPE.md`.

There is **no loop-invariant claim**: `transfer` is straight-line bytecode.

## Proof-extension inventory

None of substance. `verification.k`'s `VERIFICATION` module adds no simplification
rules, operational bridges, result-bearing oracles, priority rules, or auxiliary
claims; it only imports the bundled `EDSL`, `LEMMAS`, and `EVM`. The proof closes
under the bundled semantics. The only additions are two **definitional constants** in
`VERIFICATION-SUMMARIES`, both verified against the source:
- `StandardTokenCode` → `#parseByteStack("0x…")`, equal byte-for-byte to
  `StandardToken.inlined.bytes` (the program the claims execute).
- `TransferTopic0` → `100389287136786176327247604509743168900146139575972864366142685224231313322991`
  = `0xddf252ad…3b3ef` = `keccak256("Transfer(address,address,uint256)")`, the `PUSH32`
  at pc `0x72e`.

## Commands and actual outputs

Construction final proof (session `16dec4d8…`, `prove.sh`), task
`ed85c28c-e50d-4e3e-bd84-795136824ff1`: outcome `proved`, exit 0, all 5 `PROOF PASSED`
(~700 s). Evidence: `.kprover/sessions/16dec4d8…/proof-003/`.

Clean-room audit replay (session `8c86f354-0787-41a2-95ad-2d4e99c098d3`):
```
kprover prove --session 8c86f354-0787-41a2-95ad-2d4e99c098d3 \
  --spec inputs/spec.k --spec-module SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION
```
→ task `a0a462be-04c2-4730-90c5-37e199ec06e4`, status `completed`, outcome `proved`,
residual `null`, exit `[0,0]`, 756.9 s. stdout:
```
PROOF PASSED: SPEC.transfer-overflow
PROOF PASSED: SPEC.transfer-self
PROOF PASSED: SPEC.transfer-success
PROOF PASSED: SPEC.transfer-not-payable
PROOF PASSED: SPEC.transfer-insufficient
```

Non-vacuity mutation (`inputs/mutation-spec.k`, module `MUTATION`: `transfer-success`
with the sender-balance postcondition falsified to `BAL_FROM -Int VALUE +Int 1`):
```
kprover prove --session 8c86f354-0787-41a2-95ad-2d4e99c098d3 \
  --spec inputs/mutation-spec.k --spec-module MUTATION \
  --verification inputs/verification.k --verification-module VERIFICATION
```
→ task `db9231b4-31ae-4802-beea-57e5844d9592`, outcome `notProved`, exit `[1]`,
`PROOF FAILED: MUTATION.transfer-success-MUTATED`. Stuck node 4, `<storage>` match
failure, path condition `#Top` (satisfiable):
```
keccak(#buf(32, MSG_SENDER) +Bytes …01) |-> BAL_FROM -Int VALUE
      #Implies                              BAL_FROM -Int VALUE +Int 1
```
The proof is discriminating: the true value is `BAL_FROM -Int VALUE`.

## Per-gate results

- **Gate A (soundness): PASS** — real bytecode executes; no execution-bypassing
  extensions; non-vacuity mutation rejected with a satisfiable residual; results
  constrained to intended values (program-pinned).
- **Gate B (adequacy): PASS** — the five proven claims match the requested theorem and
  the approved spec with no proving-time narrowing; the positive-transfer and
  failure/revert spaces are covered; overflow is a faithful B4 discrepancy.
- **Gate C (trust/evidence): PASS** — assumptions named with dependents, evidence and
  task IDs retained, constants verified by exact comparison.

## Trust boundary (conclusions are conditional on these)

1. **keccak collision-resistance.** Claims `transfer-success` and `transfer-overflow`
   assume `#hashedLocation("Solidity",1,MSG_SENDER) =/=Int #hashedLocation("Solidity",1,TO)`
   (distinct storage slots for the distinct addresses `MSG_SENDER =/=Int TO`). KEVM
   treats `keccak` as an uninterpreted total function, so this is supplied as a scoped
   precondition (not a global rewrite; it cannot affect other claims). Standard EVM
   storage-aliasing assumption.
2. **Execution environment.** `<schedule> ISTANBUL`, `<useGas> true` with infinite gas
   (`#gas(_VGAS)`), non-static call. Functional correctness is proved independently of
   gas exhaustion; a finite-gas result is out of scope.

## Empirically supported facts

- `StandardTokenCode` equals the bytecode file (exact byte-for-byte comparison).
- `TransferTopic0` equals the event-signature `PUSH32` constant in the bytecode and the
  known `keccak256("Transfer(address,address,uint256)")`.

## Excluded behaviour (not claimed)

- Other selectors (`approve`, `transferFrom`, `balanceOf`, `allowance`) — not proved.
- Malformed / short calldata.
- The `_value == 0 ∧ balances[sender] ≥ 0` else-trigger (a no-op returning false) — the
  "insufficient balance" claim covers only `balances[sender] < _value`.
- Gas-metering / out-of-gas behaviour (infinite gas assumed).
- Any conclusion depending on two distinct addresses hashing to the same storage slot
  (excluded by the keccak assumption above).
