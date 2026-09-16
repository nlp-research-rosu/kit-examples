#!/usr/bin/env bash
# Usage: run-example.sh <example-dir-name>                       fresh run
#        run-example.sh <example-dir-name> --resume <sid> <msg>   continue a print session
# Non-interactive KIT run with an explicit tool allowlist (no permission bypass).
# KIT comes from the installed kit@kit-plugin marketplace plugin (no --plugin-dir).
set -u
ex="$1"; shift
root="$HOME/kit-example"
runs="$HOME/kit-example-runs/$ex"
mkdir -p "$runs"
cd "$root/examples/$ex" || exit 1
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"
# Foreground kprover calls can run for up to task_timeout_seconds (3600).
export BASH_DEFAULT_TIMEOUT_MS=3600000
export BASH_MAX_TIMEOUT_MS=3600000
# In print mode, wait for background tasks (subagents, backgrounded kprover) indefinitely
# instead of terminating the run after the default 600 s ceiling.
export CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS=0
allowed=(
  "Read" "Write" "Edit" "MultiEdit" "Glob" "Grep" "Agent" "TodoWrite" "WebFetch" "WebSearch"
  "Bash(kprover:*)" "Bash(bash:*)" "Bash(sh:*)" "Bash(chmod:*)" "Bash(mkdir:*)" "Bash(cp:*)"
  "Bash(ls:*)" "Bash(cat:*)" "Bash(head:*)" "Bash(tail:*)" "Bash(grep:*)" "Bash(find:*)"
  "Bash(wc:*)" "Bash(sed:*)" "Bash(awk:*)" "Bash(cut:*)" "Bash(sort:*)" "Bash(diff:*)"
  "Bash(command:*)" "Bash(which:*)" "Bash(python3:*)" "Bash(jq:*)" "Bash(date:*)"
  "Bash(echo:*)" "Bash(pwd:*)" "Bash(cd:*)" "Bash(sha256sum:*)" "Bash(xxd:*)" "Bash(tr:*)"
  "Bash(tee:*)" "Bash(true:*)" "Bash(test:*)" "Bash(touch:*)" "Bash(printf:*)"
)
harness="Harness notes for this non-interactive run: (1) Run every kprover command in the FOREGROUND and wait for it to return; kprover polls the server itself and may take up to 3600 seconds. Never end your turn while a prover task is pending. Pass these same notes verbatim to any subagent you dispatch. (2) Shell commands must begin with the executable name; do not prefix commands with VAR=value assignments (use absolute paths instead), or the command is denied. (3) Nobody can answer questions; proceed with maximum automation."
if [ "${1:-}" = "--resume" ]; then
  sid="$2"; msg="$3"; suffix=".resume-$(date -u +%H%M%S)"
  args=(--resume "$sid" "$msg")
else
  suffix=""; args=("$(cat PROMPT.md)")
fi
start=$(date -u +%Y-%m-%dT%H:%M:%SZ); echo "start=$start" > "$runs/timing$suffix.txt"
claude -p "${args[@]}" \
  --append-system-prompt "$harness" \
  --add-dir "$HOME/.config/kprover" \
  --permission-mode acceptEdits \
  --allowedTools "${allowed[@]}" \
  --output-format stream-json --verbose \
  > "$runs/transcript$suffix.jsonl" 2> "$runs/stderr$suffix.log"
rc=$?
end=$(date -u +%Y-%m-%dT%H:%M:%SZ); echo "end=$end" >> "$runs/timing$suffix.txt"; echo "rc=$rc" >> "$runs/timing$suffix.txt"
echo "done rc=$rc start=$start end=$end"
