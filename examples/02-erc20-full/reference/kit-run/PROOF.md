VALIDATED

# Proof — StandardToken ERC20, EVM bytecode level (KEVM)

Status: **VALIDATED**, conditional on the single named keccak collision-freedom
assumption in the trust ledger below. All 18 reachability claims were re-proved
in an independent clean-room session at the matching semantics pin; Gates A, B,
and C pass.

## What is proven

Machine-checked, at EVM runtime-bytecode level under KEVM (SHANGHAI), that the
runtime bytecode in `contract/StandardToken.inlined.bytes` — byte-identical to
the `#StandardTokenCode` constant used by the proof — implements exactly the
following behaviour for every externally callable function and the dispatcher,
starting from `<k> #execute </k>` at `<pc> 0 </pc>` (real dispatcher + real
function body run to `#halt`):

- `approve(spender,value)`: sets `allowed[caller][spender] = value`, emits
  `Approval(caller,spender,value)`, returns `1`, status SUCCESS. Reverts iff
  the call carries non-zero value.
- `transfer(to,value)`: on `balances[caller] >= value && value > 0`
  (callValue 0), moves `value` caller→to (with the unchecked-ADD overflow wrap
  when `balances[to]+value >= 2^256` for `to != caller`; self-transfer nets
  zero), emits `Transfer`, returns `1`; otherwise no state change, returns `0`,
  status SUCCESS. Reverts iff non-zero call value.
- `transferFrom(from,to,value)`: on `balances[from] >= value &&
  allowed[from][caller] >= value && value > 0`, moves `value` from→to,
  decrements the allowance, emits `Transfer`, returns `1` (same overflow wrap);
  otherwise no change, returns `0`. Reverts iff non-zero call value.
- `balanceOf(owner)` returns `balances[owner]`; `allowance(owner,spender)`
  returns `allowed[owner][spender]`; both pure reads. Revert iff non-zero value.
- Dispatcher: calldata shorter than 4 bytes, or a 4-byte selector distinct from
  the five real selectors (0x095ea7b3, 0x23b872dd, 0x70a08231, 0xa9059cbb,
  0xdd62ed3e), reverts.

Each claim observes the callee frame's exact halting `<statusCode>`, `<output>`,
`<log>`, and `<storage>` of the touched slots.

## Formal claim

18 KEVM reachability claims in `SPEC` (module `SPEC`, file
`inputs/spec.k`) over module `VERIFICATION` (`inputs/verification.k`):
approve-{success,revert-value}; transfer-{success,success-self,overflow,fail,
revert-value}; transferFrom-{success,success-self,overflow,fail,revert-value};
balanceOf-{success,revert-value}; allowance-{success,revert-value};
dispatch-{short-calldata,unknown-selector}.

## Proof-extension inventory

1. `#StandardTokenCode` — definitional constant = target runtime bytecode
   (byte-identical, verified). Supplies `<program>`/`<code>`; executed by fixed
   semantics, not an operational bridge.
2. `#bal(A) => #hashedLocation("Solidity",1,A)`,
   `#alw(A,B) => #hashedLocation("Solidity",2,A B)` — definitional storage-slot
   aliases; `#hashedLocation` is defined by the fixed semantics. Used only in
   `<storage>` cells.
3. `ERC20-KECCAK-LEMMAS [symbolic]` — keccak collision-freedom assumptions
   (injectivity; symbolic-keccak ≠ concrete word). Trusted primitive; the model
   leaves symbolic `keccak` opaque and provides no injectivity. These speak only
   about `keccak` terms (storage-key identity/disjointness), never about the
   ERC20 result, so they do not encode the conclusion.

No operational bridges. No program-derived opaque result symbols.

## Commands and actual outputs (clean room)

Audit session `ec1b5850-5f8b-477d-885d-9f7eafb6de99`, pin commit
`4f4c3843076c` (matches construction session `787a58a8-…`), compiled
definitionId `7_1_337-haskell-evm-4f4c3843076c-bedddccf…adfb`.

- `kprover validate … --spec inputs/spec.k --spec-module SPEC --verification
  inputs/verification.k --verification-module VERIFICATION` → `valid: true`,
  exit 0.
- `kprover prove … --spec inputs/spec.k --spec-module SPEC --verification
  inputs/verification.k --verification-module VERIFICATION` (no depth bound) →
  `outcome: proved`, `residual: null`, exit 0, task
  `46f4cc81-940d-4b4d-9110-46e9271b1816`; stdout: 18× `PROOF PASSED`
  (all expected labels, none missing/extra).
- Non-vacuity mutant (audit-authored, `inputs/spec_mut.k`, module `SPEC_MUT`):
  `approve-success` storage RHS `|-> VALUE` → `|-> (VALUE +Int 1)`. →
  `outcome: notProved`, exit 1, task `0234c459-1519-4d44-884a-c900feb28827`,
  `PROOF FAILED: SPEC_MUT.approve-success-mut`. Residual stuck node storage cell:
  `keccak(#buf(32,SPENDER) +Bytes keccak(#buf(32,CALLER_ID) +Bytes …\x02)) |->
  VALUE:Int #Implies VALUE:Int +Int 1`, path condition `#Top` — a genuine
  off-by-one falsification over the satisfiable domain.

Recorded construction evidence (untrusted, cross-checked): `proof-002/result.json`
= 18-claim `proved`; `proof-001` = 4-claim subset `proved`.

## Per-gate results

- Gate A (real-program soundness): PASS. Program pinned to actual bytecode;
  body sensitivity shown by the mutant; postconditions are concrete constraints;
  extensions carry no false-conclusion witness.
- Gate B (intent adequacy): PASS. Domain complete over the actual bytecode
  (case partitions verified; dispatcher selectors independently recomputed).
- Gate C (evidence): PASS. Sole assumption ledgered with dependents; all
  artifacts reproducible.

## Trust boundary (conditional facts)

The functional claims are conditional on the standard keccak-256
collision-freedom / injectivity assumption (`ERC20-KECCAK-LEMMAS`), used to keep
distinct mapping slots distinct and a symbolic slot ≠ concrete slot 0. This is a
cryptographic idealization, not a theorem of the EVM semantics. All storage-slot
reasoning depends on it.

## Empirically supported facts

None relied upon: no differential-testing bridge is claimed. The five function
selectors were independently recomputed (keccak-256 of the signatures) and match
the dispatcher table and the unknown-selector exclusion set.

## Excluded behaviour

Contract creation/constructor (runtime code only); re-entrancy (contract issues
no CALL/DELEGATECALL); caller-side storage rollback on REVERT (out of frame; no
storage write precedes any REVERT here); gas accounting (`useGas false`).
EIP-20 divergences are stated as the actual bytecode behaviour, not as EIP-20
idealizations: insufficient balance returns `false`+SUCCESS (EIP "SHOULD throw")
and zero-value transfer returns `false` with no `Transfer` event (EIP MUST-fire)
— faithfully-reported implementation/specification discrepancies.
