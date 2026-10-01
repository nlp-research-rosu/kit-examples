#!/usr/bin/env bash
set -euo pipefail

HERE=$(cd -- "$(dirname -- "$0")" && pwd)
SESSION_JSON=$(kprover session start --project "$HERE" --semantics python-3-14-6)
SESSION=$(python3 -c 'import json,sys; print(json.load(sys.stdin)["sessionId"])' <<< "$SESSION_JSON")
WORKSPACE=$(python3 -c 'import json,sys; print(json.load(sys.stdin)["workspaceDir"])' <<< "$SESSION_JSON")
PIN=$(python3 -c 'import json,sys; s=json.load(sys.stdin)["semantics"]; print(s["id"]+"@"+s["commit"])' <<< "$SESSION_JSON")
if [[ "$PIN" != "python-3-14-6@e5d24a5429a4" ]]; then
  echo "Unexpected semantics: $PIN" >&2
  exit 1
fi
mkdir -p "$WORKSPACE/inputs"
cp "$HERE/spec.k" "$HERE/verification.k" "$HERE/program.k" "$WORKSPACE/inputs/"
kprover prove \
  --session "$SESSION" \
  --spec inputs/spec.k --spec-module SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION \
  --source inputs/program.k \
  --task-timeout 3600
