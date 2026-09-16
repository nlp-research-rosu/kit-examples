# Reference runs: examples/01-transfer

Two complete KIT runs of this example, both `VALIDATED`.

`kit-run/` and `evidence/` are the run RV will reproduce: KIT installed as
`kit@kit-plugin` v0.1.1 from the marketplace, `kprover` 0.1.1 from the
release, everything on `rv-prover`, one uninterrupted 64-minute run
(2026-09-16). `kit-run/` holds the agent's `SCOPE.md`, `spec.k` and
`verification.k` (from the construction session's `inputs/`), `prove.sh`,
both audits, the auditor's `spec_mut.k`, and `PROOF.md`. `evidence/` holds
every `result.json` the CLI retained, keyed by session and operation, plus
the `session.json` descriptors.

| Session | Role | Operations |
|---|---|---|
| `5acb1515` | construction | validation-001..004, proof-001 (4/5, overflow residual), proof-002 (overflow fixed), proof-003 (orphaned by a transient 502, completed server-side), proof-004 (full module, proved) |
| `65dd4426` | clean-room audit | validation-001, proof-001 (replay, proved), proof-002 (mutation, notProved) |

`kit-run-b3dee27/` and `evidence-b3dee27/` are the earlier run on kit commit
`b3dee27` loaded with `claude --plugin-dir` (2026-09-15), kept because its
audit was interrupted by a Prover storage incident and resumed, which
`RUN-NOTES.md` describes. Same theorem, same outcome.

| Session | Role | Operations |
|---|---|---|
| `16dec4d8` | construction | validation-001..003, proof-001..003 |
| `02ea26ba` | first audit attempt, interrupted | validation-001, proof-001 (orphaned) |
| `8c86f354` | clean-room audit | proof-001 (replay), proof-002 (mutation) |

`transcripts/` has the Claude Code stream-json traces for every attempt.
