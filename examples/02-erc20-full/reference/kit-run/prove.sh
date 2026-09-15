#!/usr/bin/env bash
# Executable proof evidence for the StandardToken ERC20 bytecode verification.
# Proves all 18 reachability claims in one kprove invocation, in the original
# construction session, against the pinned bundled `evm` semantics
# (commit 4f4c3843076c). No depth bound. Task timeout 3600s (config default).
#
# Regenerate the K sources first with:  python3 gen_spec.py
# Files live under the session workspace: inputs/spec.k, inputs/verification.k.
set -euo pipefail

SESSION=787a58a8-8dc5-4b9e-93ed-40e49f22bedf

kprover prove \
  --session "$SESSION" \
  --spec inputs/spec.k --spec-module SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION
