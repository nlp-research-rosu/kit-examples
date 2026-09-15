#!/usr/bin/env bash
# Executable proof evidence for StandardToken.transfer (5 claims).
# Runs the global kprover CLI against the SAME construction session and the
# SAME sources used for the recorded #Top run (proof-003). No depth bound,
# no claim filtering: the final positive proof is the whole SPEC module.
#
# Session : 16dec4d8-3461-45d9-8112-23f9a0ec6c5b
# Semantics: evm @ 4f4c3843076c (KEVM, K 7.1.337)
# Task timeout: 3600 s (kprover config).
set -euo pipefail

SESSION=16dec4d8-3461-45d9-8112-23f9a0ec6c5b

kprover prove \
  --session "$SESSION" \
  --spec inputs/spec.k --spec-module SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION

# Expected: JSON with task.result.outcome == "proved", residual == null,
# tool exitCode 0, and stdout "PROOF PASSED" for all five claims:
#   SPEC.transfer-success, SPEC.transfer-self, SPEC.transfer-insufficient,
#   SPEC.transfer-not-payable, SPEC.transfer-overflow.
# Recorded evidence: .kprover/sessions/$SESSION/proof-003/result.json
