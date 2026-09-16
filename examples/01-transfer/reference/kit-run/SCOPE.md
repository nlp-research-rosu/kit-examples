# SCOPE — `transfer(address,uint256)` of StandardToken (EVM bytecode)

- **Semantics:** `evm` (KEVM), server ID `evm`, commit `4f4c3843076c`.
- **Session:** `5acb1515-f651-41ff-b351-5d14436376b8`.
- **Code under proof:** the runtime bytecode in
  `contract/StandardToken.inlined.bytes`, embedded verbatim as
  `StandardTokenRuntime` in `inputs/verification.k` and executed from
  `<program>`/`<code>` at `<pc> 0` with `#execute`. Claims are therefore against
  the deployed bytecode, not the source.
- **Source of record:** `contract/StandardToken.inlined.sol`, function
  `transfer` (selector `a9059cbb`).

## Program boundary

Each claim starts a fresh call frame at `#execute` with the full runtime
bytecode and `<callData> = #abiCallData("transfer", #address(TO), #uint256(VALUE))`.
Execution runs the real function dispatcher (including the non-payable
`CALLVALUE ISZERO` guard) through to `#halt`. No external call, `transferFrom`,
`approve`, or constructor code is exercised.

## Storage layout (read from source + bytecode)

- `balances` is state-variable slot **1** (`totalSupply` is slot 0, `allowed`
  slot 2). Confirmed by the bytecode's `600160..SLOAD` mapping accesses.
- `balances[A]` lives at `#hashedLocation("Solidity", 1, A)` = `keccak(A ‖ 1)`.

## Input domain

- `#rangeAddress(ACCTID/CALLER/TO)`, `#rangeUInt(256, VALUE)`; `CALLER` is
  `msg.sender` (the `<caller>` cell), `ACCTID` is the executing token contract.
- Symbolic storage map `ACCT_STORAGE`; balances read with `#lookup`.
- Success/self/overflow: `VALUE > 0` and `balances[CALLER] >= VALUE` (the exact
  guard `balances[msg.sender] >= value && value > 0`).
- Distinct-account cases additionally require `CALLER =/= TO` **and** the two
  storage slots distinct — see *Trust assumption* below.

## Observable final state (per claim)

`<statusCode>`, `<output>`, the token account's `<storage>`, and `<log>`. Frame
cells outside the property (`<wordStack>`, `<localMem>`, `<pc>`, `<gas>`,
`<memoryUsed>`, `<refund>`, `<origStorage>`, touched/accessed sets) are left
unconstrained on the RHS (`?_`); they are execution scratch, not part of the
ERC20 behaviour being asserted.

## Intended property and chosen contract readings

The five claims (labels in `spec.k`):

1. **`transfer-success`** (`CALLER =/= TO`): balances[CALLER] −= VALUE,
   balances[TO] += VALUE, output ABI-`true` (`#buf(32,1)`), status
   `EVMC_SUCCESS`, one `Transfer(CALLER,TO,VALUE)` log appended. Requires no
   recipient overflow (`balances[TO] + VALUE < 2^256`).
2. **`transfer-self`** (`CALLER == TO`): net storage unchanged
   (`balances[CALLER]` stays its original value), output `true`, `Transfer`
   emitted. Captures the read-modify-write ordering (`-= VALUE` then `+= VALUE`
   on the same slot).
3. **`transfer-insufficient`** (`balances[CALLER] < VALUE`): the source's `else`
   branch. **Reading:** the contract **returns `false`, it does not revert** —
   status `EVMC_SUCCESS`, output `#buf(32,0)`, storage and log unchanged. (This
   deviates from EIP-20's SHOULD-`throw`; we prove what the code does.)
4. **`transfer-not-payable`** (`CALLVALUE > 0`): the per-function
   `CALLVALUE ISZERO … REVERT` guard fires — status `EVMC_REVERT`, empty output,
   storage and log unchanged.
5. **`transfer-overflow`** (`CALLER =/= TO`, `balances[TO] + VALUE >= 2^256`):
   0.4.x has no SafeMath; `balances[TO]` wraps to `chop(balances[TO] + VALUE)`
   (i.e. `balances[TO] + VALUE − 2^256` under the precondition, since both
   summands are `< 2^256`) and the call still **succeeds** (output `true`,
   `Transfer` emitted, balances[CALLER] −= VALUE). `chop` is KEVM's mod-2^256
   reduction — the exact effect of the unchecked `ADD`. Documents the
   unchecked-arithmetic edge case.

Other contract readings resolved:
- `value == 0` returns `false` (guard is `value > 0`); not a required claim, but
  note it means `transfer-insufficient`'s `balances[CALLER] < VALUE` already
  implies `VALUE > 0`, so that branch is reached cleanly.
- Return type is `bool`; ABI-encoded in a full 32-byte word.

## Trust assumption (recorded for the proof audit)

The distinct-account claims (`transfer-success`, `transfer-overflow`) include
the precondition
`#hashedLocation("Solidity",1,CALLER) =/=Int #hashedLocation("Solidity",1,TO)`.
KEVM models `keccak` as an uninterpreted SMT function with no injectivity
axiom, so `CALLER =/= TO` alone does not entail slot distinctness. This
precondition is the standard **keccak collision-resistance** assumption for
storage-mapping reasoning; it restricts the theorem to non-colliding slots and
is listed as an assumption, not proved. The self-transfer and failure claims do
not depend on it.
