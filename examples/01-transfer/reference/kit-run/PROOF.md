VALIDATED

# PROOF — `transfer(address,uint256)` of StandardToken (EVM bytecode)

Status decided by independent clean-room proof audit
(`audits/proof-audit-1.md`). Gates A (real-program soundness), B (intent
adequacy), and C (trust/evidence) all PASS.

## What is proven

For the deployed runtime bytecode of `StandardToken`
(`contract/StandardToken.inlined.bytes`, embedded verbatim as
`StandardTokenRuntime`), executed from a fresh call frame at `<pc> 0` with
`#execute` under KEVM ISTANBUL (`useGas=true`, symbolic gas) and
`<callData> = #abiCallData("transfer", #address(TO), #uint256(VALUE))`, the
function `transfer` behaves as follows across its five reachable cases:

1. **transfer-success** (`CALLER≠TO`, slots distinct, `VALUE>0`,
   `bal[CALLER]≥VALUE`, `bal[TO]+VALUE<2^256`): `bal[CALLER] -= VALUE`,
   `bal[TO] += VALUE`, output `#buf(32,1)` (ABI `true`), status `EVMC_SUCCESS`,
   one `Transfer(CALLER,TO,VALUE)` log appended.
2. **transfer-self** (`CALLER=TO`, `VALUE>0`, `bal[CALLER]≥VALUE`): net storage
   unchanged (`-=VALUE` then `+=VALUE` on the same slot), output `true`,
   status `EVMC_SUCCESS`, `Transfer` emitted.
3. **transfer-insufficient** (`bal[CALLER]<VALUE`): returns `false`
   (output `#buf(32,0)`), status `EVMC_SUCCESS`, storage and log unchanged
   (the code returns false; it does NOT revert).
4. **transfer-not-payable** (`CALLVALUE>0`): the per-function
   `CALLVALUE ISZERO … REVERT` guard fires — status `EVMC_REVERT`, empty output
   (`.Bytes`), storage and log unchanged.
5. **transfer-overflow** (`CALLER≠TO`, slots distinct, `VALUE>0`,
   `bal[CALLER]≥VALUE`, `bal[TO]+VALUE≥2^256`): unchecked 0.4.x arithmetic wraps
   — `bal[TO] := chop(bal[TO]+VALUE)`, `bal[CALLER] -= VALUE`, output `true`,
   status `EVMC_SUCCESS`, `Transfer` emitted (call still succeeds).

## Formal claim

Each item is a KEVM reachability claim in module `TRANSFER-SPEC` proved to
`#Top` (partial correctness) under the pinned semantics. Preconditions are the
`requires` clauses of each claim in `spec.k` (`#rangeAddress`/`#rangeUInt`
bounds, the balance/value guards above, and — for cases 1 and 5 — the
keccak slot-distinctness assumption listed under Trust boundary).

## Proof-extension inventory

Rebuilt from `spec.k` and `verification.k` (not from any construction record):

- **`StandardTokenRuntime => #parseByteStack("0x6060…0029")`** — a definitional
  nullary-constant `Bytes` function (module `VERIFICATION-SUMMARIES`,
  `imports EVM`). Verified **byte-for-byte equal** to
  `contract/StandardToken.inlined.bytes` (2091 bytes / 4184 hex chars,
  `0x`-prefixed). Supplies the code under proof; rewrites no program term.
- **`imports EDSL`** and **`imports LEMMAS`** (module `VERIFICATION`) — generic
  modules from the pinned semantics (`edsl.md`, `lemmas/lemmas.k`); ABI/storage
  helpers and byte/integer/storage simplifications. Not proof-local.

No operational bridge, no summary function, and no opaque result-bearing
abstraction exist. `transfer` is loop-free, so the theorem needs no
invariant/summary; postconditions are stated directly over configuration cells.
`VERIFICATION-SUMMARIES` is unedited from the spec-audit-approved form (contains
only the bytecode constant). The proof imports generic `EDSL`, not the
semantics' `EDSL-SUMMARY`/`EDSL-SUM` bridge modules.

## Semantics

- `evm` (KEVM), repo `https://github.com/nlp-research-rosu/semantics-evm`,
  commit `4f4c3843076c`; kVersion `7.1.337`. Independently confirmed against the
  server `kprover semantics` listing and SCOPE.md.
- Definition id: `7_1_337-haskell-evm-4f4c3843076c-…`.

## Exact commands and actual outputs (audit session)

Audit session: `65dd4426-936e-4f21-adc2-4680c4b98d2f` (a fresh session; the
construction session `5acb1515-…` and its task IDs were not reused).

**Validation** — task `9ef4b97b-ab29-42c9-8a8e-fb37cfcb12c1`, exit 0:
```
kprover validate --session 65dd4426-936e-4f21-adc2-4680c4b98d2f \
  --spec inputs/spec.k --spec-module TRANSFER-SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION
# → { "result": { "valid": true } }   (validation-001)
```

**Positive proof (all five, no depth bound — matches `prove.sh`)** — task
`976eaa90-cdd6-43f3-84ef-a3694a8f05dd`, kprove exit 0,
`outcome: proved`, `residual: null` (proof-001/result.json stdout):
```
kprover prove --session 65dd4426-936e-4f21-adc2-4680c4b98d2f \
  --spec inputs/spec.k --spec-module TRANSFER-SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION
# stdout:
PROOF PASSED: TRANSFER-SPEC.transfer-overflow
PROOF PASSED: TRANSFER-SPEC.transfer-self
PROOF PASSED: TRANSFER-SPEC.transfer-success
PROOF PASSED: TRANSFER-SPEC.transfer-not-payable
PROOF PASSED: TRANSFER-SPEC.transfer-insufficient
```

**A5 non-vacuity mutation** (auditor-authored; `inputs/spec_mut.k`, module
`MUTANT`, claim `transfer-success-mut` = `transfer-success` with recipient RHS
`BAL_TO +Int VALUE +Int 1`) — task `830f41d8-6b96-456c-9248-b274327f7c36`,
kprove exit **1**, `outcome: notProved` (proof-002/result.json):
```
kprover prove --session 65dd4426-936e-4f21-adc2-4680c4b98d2f \
  --spec inputs/spec_mut.k --spec-module MUTANT \
  --verification inputs/verification.k --verification-module VERIFICATION
# stdout:
PROOF FAILED: MUTANT.transfer-success-mut
1 Failure nodes. (0 pending and 1 failing)
# residual: <storage> match fails — real execution writes
#   #lookup(ACCT_STORAGE, keccak(#buf(32,TO)+Bytes …01)) +Int VALUE
# to the recipient slot, mutant demands  … +Int VALUE +Int VALUE +Int 1;
# path condition #Top. Satisfiable witness: CALLER_ID=1, TO=2, VALUE=1,
# BAL_FROM=1, BAL_TO=0.
```
A false postcondition is rejected exactly at the recipient balance update, so
the success claim non-vacuously constrains that value.

## Per-gate results

- **Gate A (real-program soundness): PASS.** Real bytecode executes via
  `#execute`→`#halt` at `<pc> 0` with the transfer callData; the only extension
  is a byte-faithful code constant plus stock imports (no bridge, no opaque
  abstraction); results are non-vacuously constrained (A5 mutation rejected).
- **Gate B (intent adequacy): PASS.** The five claims partition the `transfer`
  selector's reachable behaviour with no gap; `chop` models unchecked wrap
  faithfully; deviations from EIP-20 SHOULDs and the `value==0` case are
  disclosed as implementation/spec discrepancies, not asserted as compliance.
- **Gate C (trust/evidence): PASS.** One ledgered assumption (below); all runs
  reproducible with retained task evidence.

## Trust boundary (assumption-conditional facts)

- **keccak collision-resistance / storage-slot distinctness.** Claims
  `transfer-success` and `transfer-overflow` assume
  `#hashedLocation("Solidity",1,CALLER_ID) =/=Int
  #hashedLocation("Solidity",1,TO)`. KEVM models `keccak` as an uninterpreted
  SMT function with no injectivity axiom, so `CALLER_ID≠TO` alone does not
  entail slot distinctness. This is the standard keccak assumption for
  storage-mapping reasoning; it is NOT proved. **Conclusions 1 and 5 above are
  conditional on this assumption.** Claims `transfer-self`,
  `transfer-insufficient`, and `transfer-not-payable` do NOT depend on it and
  are unconditional (under their stated `requires`).

## Empirically supported facts

None beyond the machine-checked proofs. No summary/abstraction is used, so no
differential-testing evidence is claimed or required. The bytecode-equality
check against `contract/StandardToken.inlined.bytes` is an exact byte
comparison, not sampling.

## Excluded behaviour

- Other selectors (`transferFrom`, `approve`, `balanceOf`, `allowance`),
  constructor code, and cross-contract effects — out of scope (task is
  `transfer` only).
- `value == 0`: the guard is `value > 0`, so a zero-value call takes the else
  branch and returns `false` without emitting `Transfer` — a deliberate,
  disclosed deviation from EIP-20's "transfers of 0 MUST be treated as normal
  transfers"; not among the five proved claims.
- Frame scratch cells (`<wordStack>`, `<localMem>`, `<pc>`, `<gas>`,
  `<memoryUsed>`, `<refund>`, `<origStorage>`) are left unconstrained (`?_`);
  they are execution scratch, not part of the asserted ERC20 behaviour.
- Gas quantities are not asserted (symbolic `#gas`); this is partial
  correctness, not a gas-cost theorem.
