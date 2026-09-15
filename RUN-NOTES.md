# kit-example verification run notes (draft)

Environment: WSL Ubuntu 24.04 x64, kit b3dee27 (2026-09-15), kprover 0.1.0 built with cargo 1.89,
Claude Code 2.1.197 (default model claude-opus-4-8), Prover evm@4f4c3843076c, K 7.1.337.
Config: task_timeout_seconds=3600, max_proof_attempts=10, max_validation_attempts=10, max_run_attempts=5.

## Toolchain pass (README install + configure)
- `git clone --recurse-submodules` of a private submodule works once `gh auth setup-git` has run. PASS
- `cargo install --path third_party/kit/crates/kprover-cli` builds in 41 s. PASS
- `kprover config` / `health` / `semantics` / `session start --semantics evm` all as documented. PASS

## Example 1 (transfer) attempts
- Attempt 1 (20:10Z): died 20 s in with SIGHUP. Harness error (launcher shell closed). Not a kit issue.
- Attempt 2 (20:11Z-20:30Z, 18 min, rc=0): agent wrote SCOPE.md, spec.k (5 claims matching the
  5 requested properties), verification.k; submitted `kprover validate` as a BACKGROUND shell task,
  then said "I'll wait for the validation task notification" and ended its turn. In `claude -p` mode
  that exits the process. The validation itself failed on the server: DEFINITION_COMPILATION_FAILED
  (kompile exit 113) — i.e. the first verification.k did not compile; the agent never saw it.
  One permission denial: a command prefixed with `SESS=... ` (env-assignment prefix defeats a
  `Bash(mkdir:*)`-style allowlist).
- Attempt 3 (20:32Z): relaunched with an appended system prompt: run kprover in the foreground,
  no VAR= prefixes, never end the turn with a prover task pending; BASH_MAX_TIMEOUT_MS=3600000.
  Session 16dec4d8. Timeline (UTC): 20:32 start; ~20:40 SCOPE.md/BYTECODE-ANALYSIS.md/spec.k
  (5 claims) via generator scripts at project root; validation-001 kompile OK, kprove 113
  (parse: 'CALLER'); validation-002 kprove 113 (parse: '</block>'); validation-003 valid=true;
  spec-audit-1 PASS (inline); 20:53 proof-001 task df359f8d --claim transfer-not-payable proved
  (74 s exec); proof-002 task a229cfab, 4 claims (insufficient, self, success, overflow) proved
  (657 s exec); proof-003 task ed85c28c full spec, no filter (final positive run) submitted.

## Findings to report to Xiaohong (kit)
1. running-k.md / proving-spec should say explicitly: `kprover validate|prove` block until the task
   finishes; run them in the foreground, never as a background task. Under Claude Code the Bash tool
   default timeout (2 min, max 10 min) is shorter than a typical EVM proof, so either the skill must
   tell the agent to raise BASH_MAX_TIMEOUT_MS or to background-and-wait *inside one turn*.
2. Non-interactive (`claude -p`) runs end when the agent ends its turn; the kit's "wait for the
   notification" pattern silently kills the pipeline there. Interactive use is unaffected.
3. kprover-setup points at kit-plugin release URLs; irrelevant when kprover is already on PATH.

  proof-003 proved all 5 claims (698 s exec); prove.sh written. validating-proof started a
  clean-room session 02ea26ba: validation-001 valid=true; its replay proof submission was refused
  with HTTP 500 STORAGE_EXHAUSTED ("The configured data directory is full"); the auditor retried
  (task 8ffdab7e, stuck in queued). The auditor had backgrounded that proof; Claude Code print
  mode terminated the run at its 600 s background-wait ceiling (21:33Z, rc=0, no PROOF.md).
  Fix for the harness: CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS=0 (documented in the termination
  message). Session will be resumed once the prover has storage again.
- Attempt 3 resumed (21:40Z, `claude -p --resume d41d9959`, client switched to rv-prover):
  auditor opened fresh clean-room session 8c86f354 on rv-prover; validation valid; replay proof
  task a0a462be proved all 5 claims (757 s exec, incl. fresh definition compile on rv-prover);
  mutation (sender post-balance +1) task db9231b4 notProved / PROOF FAILED (232 s) with a
  satisfiable residual; audits/proof-audit-1.md VERDICT PASS, Gates A/B/C PASS;
  PROOF.md first line VALIDATED (assumptions: keccak collision-resistance; ISTANBUL +
  infinite gas). PROOF.md records the audit as same-agent review because the subagent audit
  was interrupted by the server incident. Root-level artifacts the agent left in the example
  dir: SCOPE.md, BYTECODE-ANALYSIS.md, gen_spec.py, gen_verification.py, prove.sh, PROOF.md,
  audits/{spec-audit-1.md, proof-audit-1.md, _disasm.py, audit_disasm.py, _prove_all.*}.
  Notable contract finding reproduced: recipient balance silently wraps on overflow (0.4.x,
  no SafeMath), matching the benchmark's transfer.success.overflow claim.
  EXAMPLE 1 RESULT: VALIDATED. Wall clock: construction 20:32-21:33Z (61 min incl. the
  interrupted audit), resumed audit 21:40Z-~22:05Z.

## Findings to report to Xiaohong (prover)
0. PROVER STORAGE FULL (2026-09-15 ~21:30Z): submissions return 500 STORAGE_EXHAUSTED while
   /healthz still says ok; new tasks (8ffdab7e, ee9d64df) stay queued with startedAt null.
   Blocks every RV user until the data volume is cleaned or enlarged. /healthz should reflect it.
   Cause: PROVER_DATA_MAX_SIZE default 20GiB (volume is 100 GB; disk used 24 GB). Each distinct
   verification.k compiles a multi-GB KEVM definition. Decision (Ovidiu, 2026-09-15): RV uses the
   separate `rv` environment https://rv-prover.intentcomputing.org (README config.toml sets
   server_url); PROVER_DATA_MAX_SIZE raised to 80GiB on `rv` only; production left for Xiaohong.
1. When the verification extension fails to kompile, task 26f7db6b returned
   error {code: DEFINITION_COMPILATION_FAILED, details: {exitCode: 1, reason: exit_error}},
   stdout empty, and stderr containing only the pyk Python traceback ending in
   "kompile ... returned non-zero exit status 113". The K compiler's own [Error] output is not
   surfaced anywhere, so an agent cannot see what to fix. Suggest capturing kompile's stderr into
   the task stderr (or error.details). Contrast: when the *spec* fails in the kprove dry run
   (attempt 3, validation-001: kompile 0, kprove 113, valid=false) the K errors do reach the client
   ("[Error] Inner Parser: Parse error: unexpected token 'CALLER'" x5) and the agent repaired them.
   So the gap is only the definition-compile path.
