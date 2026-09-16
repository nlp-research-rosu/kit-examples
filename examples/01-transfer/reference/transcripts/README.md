# Transcripts (Claude Code stream-json)

One JSON event per line: the system init (tools, model, loaded skills), every
assistant message, every tool call with its input, every tool result, and a
final `result` event with turn count, duration, and cost. Read with `jq` or
any JSONL viewer.

| File | What it is |
|---|---|
| `attempt1-aborted-sighup.jsonl` | 20 s; the launcher shell closed and took the agent with it. Harness error. |
| `attempt2-orphaned-validation.jsonl` | 18 min; spec written, `kprover validate` backgrounded, run ended at the print-mode wait ceiling. |
| `attempt3-construction.jsonl` | 61 min; the run that produced `kit-run/`: spec, validations, three proofs, `prove.sh`, first audit attempt (interrupted by the Prover storage incident). |
| `attempt3-resumed-audit.jsonl` | 23 min; `claude -p --resume` continuation that redid the audit on rv-prover and wrote `PROOF.md`. |
| `run-example.sh` | The exact non-interactive launcher used (tool allowlist, env, appended harness notes). |

The pasted prompt is `../../PROMPT.md`, unchanged. See `/RUN-NOTES.md` for the timeline.
