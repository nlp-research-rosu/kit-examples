# Transcripts (Claude Code stream-json)

One JSON event per line: the system init (tools, model, loaded skills), every
assistant message, every tool call with its input, every tool result, and a
final `result` event with turn count, duration, and cost. Read with `jq` or
any JSONL viewer. The pasted prompt is `../../PROMPT.md`, unchanged.

| File | What it is |
|---|---|
| `v0.1.1-run.jsonl` | The reference run: KIT from `kit@kit-plugin` v0.1.1, 64 min, produced `../kit-run/`. |
| `run-example.sh` | The non-interactive launcher used for it (tool allowlist, env, appended harness notes; no `--plugin-dir`). |
| `attempt3-construction.jsonl` | Earlier `b3dee27` run, 61 min: spec, validations, three proofs, first audit attempt (interrupted). Produced `../kit-run-b3dee27/`. |
| `attempt3-resumed-audit.jsonl` | `claude -p --resume` continuation that redid that audit on rv-prover. |
| `attempt2-orphaned-validation.jsonl` | 18 min; `kprover validate` backgrounded, run ended at the print-mode wait ceiling. |
| `attempt1-aborted-sighup.jsonl` | 20 s; launcher shell closed. Harness error. |

See `/RUN-NOTES.md` for the timelines.
