# Run notes: verifying kit-example before handoff

Date: 2026-09-15/16 (UTC). Operator: Ovidiu, with Claude Code driving the runs.

## Environment

| Item | Value |
|---|---|
| Host | WSL Ubuntu 24.04, x86_64 |
| kit | `nlp-research-rosu/kit` @ `b3dee27` (2026-09-15), loaded with `claude --plugin-dir` |
| kprover | 0.1.0, built with `cargo install --path third_party/kit/crates/kprover-cli` (cargo 1.89, 41 s) |
| Claude Code | 2.1.197, default model `claude-opus-4-8` |
| Prover | `https://rv-prover.intentcomputing.org`, `evm@4f4c3843076c`, K 7.1.337 |
| config.toml | `server_url` as above, `task_timeout_seconds=3600`, `max_proof_attempts=10`, `max_validation_attempts=10`, `max_run_attempts=5` |

Runs were non-interactive (`claude -p`) with an explicit tool allowlist, no
permission bypass, and these two harness settings that interactive users do
not need: `CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS=0` and
`BASH_MAX_TIMEOUT_MS=3600000`. An appended system prompt told the agent to run
`kprover` in the foreground. The pasted prompt was `PROMPT.md`, unchanged.

## Install path (README steps 1 to 4)

- Clone with `--recurse-submodules` fetches the private kit submodule once
  `gh auth setup-git` has run. PASS
- `cargo install` of the CLI, `kprover config`, `health`, `semantics`,
  `session start --semantics evm`: all as documented. PASS
- Final check after publishing: a fresh clone from GitHub into a clean
  directory reproduced the above. PASS

## Example 1: `transfer` (5 claims), status VALIDATED

Construction session `16dec4d8`, audit session `8c86f354`, all on `rv-prover`
except where noted.

| Step | Result |
|---|---|
| spec + scope | `SCOPE.md`, `BYTECODE-ANALYSIS.md`, `spec.k` (5 claims), `verification.k`, ~10 min |
| validation 1 | definition compiled; spec parse errors (`unexpected token 'CALLER'` x5) |
| validation 2 | parse error (`</block>`) |
| validation 3 | valid |
| spec audit | `audits/spec-audit-1.md`, VERDICT PASS (inline review) |
| proof 1 | `--claim transfer-not-payable`, proved, 74 s |
| proof 2 | insufficient, self, success, overflow, proved, 657 s |
| proof 3 | full module, no filter, proved, 698 s, recorded in `prove.sh` |
| audit replay | fresh session, all 5 proved, 757 s (includes a definition compile) |
| mutation | sender post-balance off by one, `notProved`, 232 s, satisfiable residual |
| proof audit | `audits/proof-audit-1.md`, VERDICT PASS, Gates A/B/C PASS |
| PROOF.md | `VALIDATED`; assumptions: keccak collision resistance, ISTANBUL + infinite gas |

Wall clock: construction 61 min (20:32 to 21:33), audit 25 min (21:40 to
22:04). The construction ran on the shared production instance; the audit
was interrupted by that instance's storage incident (below) and resumed
against `rv-prover`, which is why `PROOF.md` records the audit as same-agent
review. The audit's replay is therefore the theorem's proof on `rv-prover`.

Notable contract fact the run surfaced: the recipient balance silently wraps
on overflow (Solidity 0.4.x, no SafeMath), proved as a faithful discrepancy
against EIP-20.

## Example 2: full ERC20 (18 claims), status VALIDATED

Construction session `787a58a8`, audit session `ec1b5850`, both on `rv-prover`.

| Step | Result |
|---|---|
| spec + scope | 18 claims derived from source + `eip-20.md`, same coverage as the prover-only reference, ~25 min |
| validation 1 | `DEFINITION_COMPILATION_FAILED`, no diagnostics; agent guessed a `[symbolic]` attribute issue and restructured (correctly) |
| validation 2 | 18 parse errors: variable `LOG` collides with the `LOG(N)` opcode |
| validation 3 | one structural error (unused-variable annotation) |
| validation 4 | valid |
| spec audit | not run (see kit findings) |
| proof 1 | 4-claim probe, one per family, proved, 305 s |
| proof 2 | all 18 claims, one submission, proved, 1649 s, recorded in `prove.sh` |
| audit replay | fresh session, 18/18 proved, 1635 s |
| mutation | `approve-success` with false postcondition, `notProved`, 99 s |
| proof audit | VERDICT PASS, Gates A/B/C PASS |
| PROOF.md | `VALIDATED`; single assumption: keccak collision freedom; schedule SHANGHAI |

Wall clock: 1 h 42 min (22:04 to 23:46), unattended.

## Example 1 re-run through kit-plugin v0.1.1 (2026-09-16)

Plugin `kit@kit-plugin` 0.1.1 installed from the marketplace (private repo, gh
credentials), `kprover` 0.1.1 from the release tarball via `gh release download`
(the curl installer 404s while kit-plugin is private). v0.1.1 is kit `b3dee27`
plus version bumps. Session `5acb1515` on `rv-prover`, started 09:15Z.

| Step | Result |
|---|---|
| validation 1 | `DEFINITION_COMPILATION_FAILED`, no diagnostics; agent repaired blind |
| validation 2 | parse errors (`CALLER`) |
| validation 3 | valid |
| proof 1 | all 5 claims: 4 proved, `transfer-overflow` residual (`chop(...)` vs `- pow256`), 551 s |
| validation 4 | valid after the fix |
| proof 2 | `--claim transfer-overflow`, proved, 157 s |
| proof 3 | full module, task `e710295f`; client received HTTP 502 from rv-prover while polling (~09:47Z) and gave up ("Log unavailable: Prover returned HTTP 502 Bad Gateway"); task kept running server-side |
| proof 4 | agent resubmitted the full module, task `a6092bbb`, proved, 547 s, recorded in `prove.sh` (the orphaned proof 3 also completed as proved) |
| spec audit | `audits/spec-audit-1.md`, VERDICT PASS, written after the proofs rather than before |
| audit replay | clean-room session `65dd4426` (under the example directory this time), 5/5 proved, 548 s |
| mutation | recipient post-balance plus one, `notProved`, 198 s |
| proof audit | VERDICT PASS, Gates A/B/C PASS, fresh-subagent review |
| PROOF.md | `VALIDATED`; single ledgered keccak-distinctness assumption |

Wall clock: 64 min (09:15 to 10:19), unattended, no interruptions. This is
the run under `examples/01-transfer/reference/kit-run/`; the earlier
`b3dee27` run is kept under `kit-run-b3dee27/` and `evidence-b3dee27/`.

The 502 was transient (health 200 within two minutes, no redeploy, memory
peak 5.5 of 24 GB). Two findings: the `kprover` poll loop treats one 5xx as
terminal instead of retrying, and the kit then spends a fresh attempt on a
duplicate task.

Version map: kit-plugin `v0.1.0` = kit `7c03c20` (no EVM hints);
kit-plugin `v0.1.1` = kit `fe465af` = `b3dee27` + version bumps.

## Findings for the kit (nlp-research-rosu/kit)

1. `running-k.md` / `proving-spec` should state that `kprover validate|prove`
   block until the task finishes and must run in the foreground. Under Claude
   Code, the Bash tool's default timeout (2 min, max 10 min) is shorter than
   an EVM proof, so the skill should also tell the agent to raise
   `BASH_MAX_TIMEOUT_MS`. Interactive sessions survive the current behaviour
   because backgrounded tasks notify on completion; `claude -p` runs do not.
2. In `claude -p` mode the run terminates 600 s after the agent backgrounds a
   task and ends its turn ("Background tasks still running after 600s").
   `CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS=0` fixes it; worth documenting for
   anyone scripting the kit.
3. `kprover-setup` points at kit-plugin release URLs. Harmless when `kprover`
   is already on `PATH`, misleading otherwise.
4. Example 2's orchestrator skipped the `auditing-spec` stage entirely
   (validation, probe, full proof, proof audit). Example 1 did run it.
5. The `validating-proof` subagent started its clean-room session with the
   project root inside the shared fetched-sources tree
   (`~/.config/kprover/semantics/.../evm-semantics`), which the CLI says not
   to edit. It should pass `--project` explicitly.
6. A `Bash(mkdir:*)`-style allowlist denies commands prefixed with
   `VAR=value`; the agent produced one such command. Only matters for
   scripted runs.

## Findings for Prover

1. Storage: the shared production instance returned HTTP 500
   `STORAGE_EXHAUSTED` ("The configured data directory is full") at ~21:30Z
   while `/healthz` kept reporting `ok`, and new tasks sat in `queued`. Cause:
   `PROVER_DATA_MAX_SIZE` default 20 GiB on a 100 GB volume (24 GB used);
   every distinct `verification.k` compiles a multi-gigabyte KEVM definition.
   Decision: RV uses the separate `rv` environment; `PROVER_DATA_MAX_SIZE`
   raised to 80 GiB there only (redeployed 21:40Z). Production is untouched
   and still needs the same change. `/healthz` should reflect storage
   pressure.
2. When the verification extension fails to kompile, the task returns
   `DEFINITION_COMPILATION_FAILED` with an exit code, empty stdout, and a
   stderr holding only the pyk Python traceback. K's own `[Error]` output is
   not surfaced, so the agent cannot see what to fix (it had to guess in
   example 2). Spec-level errors from the `kprove` dry run do come through.
3. The `rv` environment has no `PROVER_PROOF_TIMEOUT` set (default 30 min).
   The 18-claim single submission finished in 27.5 min; larger specs will hit
   it. Production sets the variable explicitly.

## Evidence

`examples/<n>/reference/evidence/` on this branch holds every `result.json`
the CLI retained (task IDs, status, outcome, timing, inline stdout/stderr)
plus the global `session.json` descriptors. Prover task IDs:

| Example | Task | Kind |
|---|---|---|
| 1 | `df359f8d`, `a229cfab`, `ed85c28c` | construction proofs 1 to 3 |
| 1 | `a0a462be` | audit replay |
| 1 | `db9231b4` | mutation |
| 2 | `5887760b`, `5dc0cde0` | probe, full proof |
| 2 | `46f4cc81` | audit replay |
| 2 | `0234c459` | mutation |
