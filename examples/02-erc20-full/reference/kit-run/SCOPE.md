# SCOPE — StandardToken ERC20, EVM bytecode-level verification

Semantics: bundled `evm` (KEVM), session pin commit `4f4c3843076c`.
Target: runtime bytecode in `contract/StandardToken.inlined.bytes`
(2091 bytes, `0x6060...0029`). Source `contract/StandardToken.inlined.sol`
(Solidity 0.4.2) and `eip-20.md` are the informal specification.

Claims are stated over the KEVM configuration and are proved against the
runtime bytecode loaded into `<program>`/`<code>`. Every claim starts at
`<k> #execute ~> CONT => #halt ~> CONT </k>` with `<pc> 0 </pc>`, empty
stack/memory, so it exercises the real dispatcher and function bodies.

## 1. Program boundary

- Entry computation: one top-level message call into the contract's runtime
  code — dispatcher (`0x00`) through the halting `RETURN`/`REVERT` of the
  selected function. `#execute` runs the whole body to `#halt`.
- Program-defined operations covered: the four-byte selector dispatcher, the
  short-calldata guard, and every externally callable function reachable
  through it: `approve`, `transfer`, `transferFrom`, `balanceOf`, `allowance`.
- Not modeled: contract creation/constructor (runtime code only, as required);
  any re-entrant sub-call (none of these functions issue CALL/DELEGATECALL);
  caller-side rollback of storage on REVERT (out of frame — we observe the
  callee frame's halting configuration, and no storage write precedes any
  REVERT in this contract, so the distinction is immaterial here).

## 2. Input domain

- Address arguments constrained by `#rangeAddress` (0 ≤ a < 2^160); the code
  masks every address argument with `AND 0x00..ff(20 bytes)`, so this is the
  faithful domain. `uint256` arguments constrained by `#rangeUInt(256, ·)`.
- Storage words read by a function are symbolic and constrained by
  `#rangeUInt(256, ·)`.
- `msg.sender` (`CALLER_ID`), the contract account `ACCT_ID` and `ORIGIN_ID`
  are symbolic addresses. `ACCT_ID` is a non-zero, non-precompile address.
- Calldata is exactly the canonical ABI encoding (`#abiCallData`) for the
  functional claims. The two dispatcher claims use raw calldata: length < 4
  (symbolic), and a symbolic 4-byte selector disjoint from all five real
  selectors.
- Gas: `<useGas> false</useGas>` — gas accounting is disabled. This is a
  modeling choice: the theorem is about functional behaviour (storage, output,
  logs, status), not gas. It removes out-of-gas branches; a real caller that
  supplies enough gas observes exactly these behaviours.
- Schedule: `SHANGHAI`. Call context: `<static> false</static>`,
  `<callDepth>` ≤ 1024. The functional claims fix `<callValue> 0</callValue>`
  (the contract is non-payable); the `*-revert-value` claims take
  `<callValue> = VCallValue</callValue>` with `VCallValue > 0`.

## 3. Observable final state

Each claim observes, at `#halt`:
- `<statusCode>`  — `EVMC_SUCCESS` or `EVMC_REVERT`.
- `<output>`      — exact returned bytes (`#buf(32, v)` for the ABI word, or
                    empty on revert).
- `<log>`         — exact log list (one `#abiEventLog(...)` on the event-emitting
                    success paths; unchanged otherwise).
- `<storage>` of `ACCT_ID` — exact final map of the touched slots.

Storage layout (Solidity): `totalSupply` slot 0, `balances` slot 1,
`allowed` slot 2. Thus `balances[a] = #hashedLocation("Solidity", 1, a)` and
`allowed[a][b] = #hashedLocation("Solidity", 2, a b)`.

## 4. Intended property (per eip-20.md)

- `approve(spender,value)`: sets `allowed[caller][spender] = value`, emits
  `Approval(caller,spender,value)`, returns true. Always succeeds (non-payable).
- `transfer(to,value)`: if `balances[caller] >= value && value > 0`, moves
  `value` from `balances[caller]` to `balances[to]`, emits
  `Transfer(caller,to,value)`, returns true; otherwise no state change and
  returns false. Zero-value or insufficient balance ⇒ false (this
  implementation does NOT throw). Reverts only on non-zero call value.
- `transferFrom(from,to,value)`: if `balances[from] >= value &&
  allowed[from][caller] >= value && value > 0`, moves `value` from
  `balances[from]` to `balances[to]`, decrements `allowed[from][caller]` by
  `value`, emits `Transfer(from,to,value)`, returns true; otherwise no change,
  returns false.
- `balanceOf(owner)` returns `balances[owner]`; `allowance(owner,spender)`
  returns `allowed[owner][spender]`. Pure reads, no state change.
- Dispatcher: calldata shorter than 4 bytes, or a selector matching no
  function, reverts.
- Arithmetic edge case: the contract predates SafeMath. `balances[to] += value`
  is an unchecked EVM `ADD`, so for `to != caller` with
  `balances[to] + value >= 2^256` the destination balance wraps
  (`chop(balances[to] + value)`) and the call still returns true. The
  `*-overflow` claims state exactly this actual (buggy) behaviour.

## 5. Chosen contract readings (underdetermined points)

- **"SHOULD throw" on insufficient balance (eip-20 transfer/transferFrom):**
  eip-20 says the function *SHOULD* throw. This implementation instead returns
  `false` with `EVMC_SUCCESS` and no state change. The theorem states the
  actual bytecode behaviour (returns false), and records that it diverges from
  the SHOULD.
- **Zero-value transfers:** eip-20 requires them to be treated as normal
  transfers that fire `Transfer`. This implementation's guard is `value > 0`,
  so a zero-value transfer takes the false branch: NO `Transfer` event, returns
  false. The theorem states this actual behaviour (`transfer-fail` /
  `transferFrom-fail` cover `value == 0`), and records the divergence from
  eip-20's MUST.
- **`sender == to` self-transfer:** modeled as its own claim; net balance
  unchanged because the two sequential SSTOREs to the same slot cancel.
- **Log cell initial value:** taken as `.List` (call begins with no prior
  logs in this frame); each event-emitting success appends exactly one entry.
- **Overflow:** stated as actual wrapping behaviour, not excluded, so the
  domain is complete: `transfer`/`transferFrom` success claims split into a
  no-overflow case and an overflow case that together cover all
  `balances[to]`.

## 6. Assumptions (trust ledger)

- Keccak reasoning lemmas (injectivity; a symbolic keccak differs from any
  concrete constant; disjointness of distinct mapping slots) are added in
  `verification.k`'s `VERIFICATION` module. These encode the standard
  collision-freedom assumption on keccak-256 used by all Solidity storage
  reasoning. They are assumptions, not theorems of the semantics.
