#!/usr/bin/env bash
#
# Executable proof evidence — transfer(address,uint256) of StandardToken,
# verified at EVM bytecode level with KEVM through Prover.
#
# Reproduces the final positive proof exactly: all FIVE reachability claims
# proved TOGETHER in one `kprove` invocation, with NO depth bound, under the
# session-pinned `evm` semantics (commit 4f4c3843076c). The last full run was
# recorded under <workspaceDir>/proof-004/ with outcome "proved" (5/5).
#
# Spec/verification paths are resolved by the CLI relative to the session
# workspaceDir (.kprover/sessions/$SESSION), not the shell's cwd.
set -euo pipefail

SESSION=5acb1515-f651-41ff-b351-5d14436376b8

kprover prove \
  --session "$SESSION" \
  --spec inputs/spec.k               --spec-module         TRANSFER-SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION
