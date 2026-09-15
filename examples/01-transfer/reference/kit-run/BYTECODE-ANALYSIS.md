# Bytecode analysis — StandardToken.transfer

Runtime bytecode: `contract/StandardToken.inlined.bytes` (0x-prefixed, 2091 bytes).
Full disassembly: `.disasm.txt`. Solidity `^0.4.2` (no SafeMath).

## Storage layout (Solidity inheritance order)
`StandardToken is TokenInterface`. State variables in declaration order:
- slot 0: `uint totalSupply`  (declared in `TokenInterface`)
- slot 1: `mapping(address=>uint256) balances`
- slot 2: `mapping(address=>mapping(address=>uint256)) allowed`

`balances[k]` is stored at `keccak(#buf(32,k) ++ #buf(32,1))` =
`#hashedLocation("Solidity", 1, k)`. Confirmed in bytecode: the key computation
at pc `0x60f`/`0x666`/`0x6b3` does `mstore(0x00,key); mstore(0x20,0x01); sha3(0,0x40)`
(the `PUSH1 0x01` slot immediately precedes each key hash). `transfer` touches
**only** slot 1 (`balances`).

## Function dispatch
Selector `0xa9059cbb` = keccak256("transfer(address,uint256)") → jump to `0x192`
(confirmed in dispatcher at pc `0x58`).

## transfer(address to, uint256 value) control flow
1. **Non-payable guard** (pc `0x193`): `CALLVALUE; ISZERO; PUSH 0x19d; JUMPI`.
   If `CALLVALUE != 0` → falls to `PUSH 0 DUP1 REVERT` (`0x199`–`0x19c`): **REVERT, empty output.**
2. Decode `to` (calldata[4:], masked to 160 bits) and `value` (calldata[36:]),
   then `JUMP 0x60f` (internal `transfer`), returning to `0x1d2`.
3. **Condition** (pc `0x652`): `cond = (balances[msg.sender] >= value) && (value > 0)`.
   Uses only `SLOAD balances[msg.sender]`; `balances[to]` is not read here.
4. **False branch** (pc `0x76d`): `PUSH 0; ...` → return value `0`. **No state
   change, no log, normal RETURN.** Taken when `balances[msg.sender] < value` OR `value == 0`.
5. **True branch** (`cond` holds):
   - `0x666`–`0x6b1`: `balances[msg.sender] = balances[msg.sender] - value` (`SUB`, no underflow — guard ensures `>=`).
   - `0x6b3`–`0x6fe`: `balances[to] = balances[to] + value` (`ADD`, **wraps mod 2^256 — NO overflow check**).
   - `0x700`–`0x764`: `LOG3` — topic0 = `0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef`
     (keccak256("Transfer(address,address,uint256)"), confirmed `PUSH32` at `0x72e`),
     topic1 = `msg.sender`, topic2 = `to`, data = `#buf(32,value)`.
   - `0x765`: return value `1`.
6. Return path `0x1d2`: ABI-encodes the bool and `RETURN`s 32 bytes → output `#buf(32, retval)`.

## Consequences for the 5 claims
1. **Success (to ≠ sender, no overflow):** bal[sender]-=value, bal[to]+=value, out=`#buf(32,1)`, one Transfer log, SUCCESS.
2. **Self-transfer (to == sender):** write `bal-value` then re-read and add `value` on the SAME slot ⇒ net unchanged; out=`#buf(32,1)`, Transfer(sender,sender,value) log, SUCCESS. No overflow possible.
3. **Insufficient balance (bal[sender] < value):** false branch ⇒ out=`#buf(32,0)`, storage unchanged, no log, **SUCCESS (normal RETURN, NOT revert)**.
4. **Not payable (callvalue > 0):** REVERT, empty output, storage/log unchanged.
5. **Recipient overflow (to ≠ sender, bal[to]+value ≥ 2^256):** bal[to] becomes `chop(bal[to]+value)=bal[to]+value-2^256 < bal[to]`; still returns `#buf(32,1)` + log, SUCCESS. Documents the missing SafeMath.
