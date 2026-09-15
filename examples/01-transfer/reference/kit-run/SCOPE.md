# SCOPE.md — StandardToken.transfer bytecode verification

## Semantics
- Session `16dec4d8-3461-45d9-8112-23f9a0ec6c5b`, pinned `evm` @ `4f4c3843076c`
  (KEVM, K 7.1.337). Claims compile against `edsl.md` + `lemmas/lemmas.k`.

## Program boundary
- Target: the runtime bytecode `contract/StandardToken.inlined.bytes` (2091 bytes),
  entered at `#execute` with `<pc> 0`, empty stack/memory, running to `#halt`.
- Entry computation covered: the full external call to selector
  `0xa9059cbb` = `transfer(address,uint256)` (dispatch at pc `0x58` → body at `0x192`),
  including the internal transfer logic at `0x60f`, the ABI return encoder at `0x1d2`,
  and the `LOG3` event emission. No other function selector is claimed.
- The claims fix `<program>`/`<code>` to this exact bytecode via the
  `StandardTokenCode` macro and `<jumpDests>` via `#computeValidJumpDests`.

## Input domain
- `CALLER` (`msg.sender`), `TO` (the `_to` argument), `VALUE` (`_value`): all
  `#rangeAddress`/`#rangeUInt(256,·)` as appropriate. `<callData>` is the canonical
  `#abiCallData("transfer", #address(TO), #uint256(VALUE))` (well-formed ABI call).
- Contract account: `ACCTID` an address, `ACCTBAL` a uint256, `ACCTNONCE` a nonce,
  `CALLDEPTH` in `[0,1024)`.
- `balances[k]` lives at storage slot 1: `#hashedLocation("Solidity", 1, k)`
  (Solidity inheritance order — totalSupply=0, balances=1, allowed=2; confirmed in
  the bytecode key computation). `BAL_FROM = balances[CALLER]`, `BAL_TO = balances[TO]`.
- The five claims partition the behaviour by guard:
  1. `transfer-success`: `CALLER≠TO`, `VALUE>0`, `BAL_FROM≥VALUE`, `BAL_TO+VALUE<2^256`.
  2. `transfer-self`: `TO==CALLER`, `VALUE>0`, `BAL_FROM≥VALUE`.
  3. `transfer-insufficient`: `BAL_FROM<VALUE` (forces the `else` branch).
  4. `transfer-not-payable`: `CALLVALUE>0` (any calldata).
  5. `transfer-overflow`: `CALLER≠TO`, `VALUE>0`, `BAL_FROM≥VALUE`, `BAL_TO+VALUE≥2^256`.
- Excluded (not the target theorem): calls to other selectors; malformed/short
  calldata; `VALUE==0 ∧ BAL_FROM≥0` boundary of the else-branch is folded into
  claim 3 only via `BAL_FROM<VALUE` (the task's "insufficient balance" reading).

## Observable final state
- `<statusCode>`: `EVMC_SUCCESS` (claims 1,2,3,5) or `EVMC_REVERT` (claim 4).
- `<output>`: `#buf(32,1)` (success/self/overflow), `#buf(32,0)` (insufficient),
  `.Bytes` (not-payable revert).
- `<storage>` of the contract account: the balances-slot entries, shown changing
  (claims 1,5), unchanged (claims 2,3), or fully symbolic-unchanged (claim 4).
- `<log>`: exactly one appended `Transfer` entry
  `{ ACCTID | [topic0, CALLER, TO] | #buf(32,VALUE) }` (claims 1,2,5), where
  `topic0 = TransferTopic0 = keccak256("Transfer(address,address,uint256)")`;
  log unchanged (claims 3,4).

## Intended property
`transfer` moves `VALUE` tokens from `msg.sender` to `_to` and returns `true`
when the sender can cover a positive `VALUE`; returns `false` without side effects
when the sender's balance is insufficient; reverts if ETH is attached; and — because
this 0.4.x contract has no SafeMath — silently wraps the recipient balance on
overflow rather than reverting. Self-transfer is a no-op on balances.

## Chosen contract readings (underdetermined points)
- **Failure = return false, not revert.** The source's `else` returns `false`; the
  bytecode false branch (`0x76d`) does a normal `RETURN` of `#buf(32,0)`. Claim 3
  asserts `EVMC_SUCCESS` + `#buf(32,0)`, not a revert.
- **`value > 0` is required for success.** The source guard is
  `balances[msg.sender] >= value && value > 0`; a zero-value transfer takes the
  else branch. Success claims therefore require `VALUE > 0`.
- **Recipient overflow silently wraps.** No overflow check exists; claim 5 states
  the wrapped result `chop(BAL_TO+VALUE) = BAL_TO+VALUE-2^256` and still `SUCCESS`.
  This is faithful to the bytecode, and documents a real defect vs. the EIP-20 intent.
- **Success claim assumes distinct sender/recipient and no overflow**; self-transfer
  and overflow are stated as separate claims so each net storage effect is exact.

## Trust / modelling assumptions (recorded for the trust ledger)
- **keccak collision-resistance.** Claims 1 and 5 include the precondition
  `#hashedLocation("Solidity",1,CALLER) =/=Int #hashedLocation("Solidity",1,TO)`
  alongside `CALLER =/=Int TO`. Distinct storage slots for distinct addresses is
  implied by injectivity of keccak on the 64-byte pre-images `k ++ slot`; KEVM
  models keccak as an uninterpreted total function, so this fact is supplied as a
  precondition rather than derived. This is the standard, universally-accepted EVM
  storage-aliasing assumption.
- **Environment:** `<schedule> ISTANBUL`, `<useGas> true` with infinite gas
  (`#gas(_VGAS)`), non-static call. All opcodes used by `transfer` (SHA3, SLOAD,
  SSTORE, LOG3, REVERT, RETURN) exist under ISTANBUL. Infinite gas isolates
  functional correctness from gas exhaustion; a finite-gas theorem would be
  strictly about gas and is out of scope.
