# Prover-only reference: 18 HKG ERC20 claims

These spec files were not produced by KIT. They come from an earlier, independent
verification of the same runtime bytecode (the fvk-report benchmark run) and were
re-proved on 2026-09-14 by uploading them directly to Prover, semantics
`evm@4f4c3843076c`, K 7.1.337, using `verification.k` as the verification extension.

They exist so you can compare what KIT produces for `examples/02-erc20-full`
against a known-good, independently proved theorem set.

| Spec file | Module | Claims | Prover task | Outcome | Execution |
|---|---|---|---|---|---|
| balanceOf-spec.k | BALANCEOF-SPEC | 2 | 2d9ed069-b306-4f52-8b00-2bb79e2b723f | proved | 168 s |
| allowance-spec.k | ALLOWANCE-SPEC | 2 | 3dca7829-5372-479c-a5a7-98e7dcc17df3 | proved | 662 s |
| approve-spec.k | APPROVE-SPEC | 2 | bc54b448-39b3-4fd8-80aa-7881b60411aa | proved | 684 s |
| dispatch-spec.k | DISPATCH-SPEC | 2 | 9c89a5f0-c34c-4fa1-853d-d1fc7e0a2152 | proved | 998 s |
| transfer-spec.k | TRANSFER-SPEC | 5 | 6aec395a-ec49-4360-9f3c-f8a0623430ad | proved | 465 s |
| transferFrom-spec.k | TRANSFERFROM-SPEC | 5 | 5c402158-2e5e-496d-9b29-82274399ce2b | proved | 683 s |

Claims proved (18):

```
BALANCEOF-SPEC.balanceOf.success            BALANCEOF-SPEC.balanceOf.revert.payable
ALLOWANCE-SPEC.allowance.success            ALLOWANCE-SPEC.allowance.revert.payable
APPROVE-SPEC.approve.success                APPROVE-SPEC.approve.revert.payable
DISPATCH-SPEC.dispatch.revert.short-calldata
DISPATCH-SPEC.dispatch.revert.unknown-selector
TRANSFER-SPEC.transfer.success              TRANSFER-SPEC.transfer.success.overflow
TRANSFER-SPEC.transfer.success.self         TRANSFER-SPEC.transfer.revert.payable
TRANSFER-SPEC.transfer.failure
TRANSFERFROM-SPEC.transferFrom.success      TRANSFERFROM-SPEC.transferFrom.success.overflow
TRANSFERFROM-SPEC.transferFrom.success.self TRANSFERFROM-SPEC.transferFrom.revert.payable
TRANSFERFROM-SPEC.transferFrom.failure
```

Those tasks ran on the shared production Prover instance, not on `rv-prover`.
To replay one here, start an `evm` session with `kprover session start`, copy
`verification.k`, `erc20-lemmas.k`, and one spec file into its `inputs/`, and run
`kprover prove --spec inputs/<file> --spec-module <MODULE> --verification
inputs/verification.k --verification-module VERIFICATION --source inputs/erc20-lemmas.k`.
