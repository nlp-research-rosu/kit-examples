Use KIT to formally verify the `transfer` function of the ERC20 token contract in `contract/` at the EVM bytecode level, using the K framework through Prover.

Settings (use these; do not stop to ask):
- Semantics: `evm`
- Automation level: maximum. Reroll and try alternative angles on every defect; only stop when the budget is exhausted or the proof is validated.
- Prover task timeout: 3600 seconds.

Inputs (everything you need is in this directory):
- `contract/StandardToken.inlined.sol` — the token's source.
- `contract/StandardToken.inlined.bytes` — its runtime bytecode (hex). Claims are against this bytecode.
- `eip-20.md` — the ERC20 standard (the informal specification).

What to prove, for `transfer(address _to, uint256 _value)` only:
1. Success: when the caller's balance covers `_value`, the call succeeds, the caller's balance decreases by `_value`, the recipient's balance increases by `_value`, and the return value is what the source promises.
2. Self-transfer: `_to` equal to the caller leaves balances unchanged.
3. Failure: when the caller's balance is insufficient, the call fails exactly as the contract implements it (read the source: revert versus return false).
4. Not payable: the call reverts when value is sent.
5. Arithmetic edge case: recipient balance overflow.

Claims must be at bytecode level (storage, calldata, output, logs).

Rules:
- Work only inside this directory.
- Do NOT search the web for, or otherwise consult, existing formal specifications of ERC20 — in particular Runtime Verification's verified-smart-contracts specs or any ERC20 specs distributed with KEVM. Writing the specification yourself IS the task.
- General documentation of K, KEVM, EVM opcodes, and Solidity is allowed.
- You are done when `PROOF.md` exists with the proof's exact status on its first line, or you have documented precisely which claims do not pass and why.
