Use KIT to formally specify and machine-check the ERC20 token contract in `contract/` at the EVM bytecode level, using the K framework through Prover.

Settings (use these; do not stop to ask):
- Semantics: `evm`
- Automation level: maximum. Reroll and try alternative angles on every defect; only stop when the budget is exhausted or the proof is validated.
- Prover task timeout: 3600 seconds.

Inputs (everything you need is in this directory):
- `contract/StandardToken.inlined.sol` — the token's source.
- `contract/StandardToken.inlined.bytes` — its runtime bytecode (hex). Claims are against this bytecode.
- `eip-20.md` — the ERC20 standard (the informal specification).

What to prove: K reachability claims covering EVERY externally callable function of the contract, per `eip-20.md`. For each function: its success behavior(s), its failure or revert behavior(s), and arithmetic edge cases (for example balance overflow). Also cover the dispatcher: calls with short calldata and calls with an unknown selector. Claims must be at bytecode level (storage, calldata, output, logs).

Rules:
- Work only inside this directory.
- Do NOT search the web for, or otherwise consult, existing formal specifications of ERC20 — in particular Runtime Verification's verified-smart-contracts specs or any ERC20 specs distributed with KEVM. Writing the specification yourself IS the task.
- General documentation of K, KEVM, EVM opcodes, and Solidity is allowed.
- You are done when `PROOF.md` exists with the proof's exact status on its first line, or you have documented precisely which claims do not pass and why.
