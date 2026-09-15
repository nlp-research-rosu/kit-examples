# Reference run: examples/01-transfer

`kit-run/` is exactly what KIT left behind after the run described in
`/RUN-NOTES.md`: the agent's `SCOPE.md`, `BYTECODE-ANALYSIS.md`, generator
scripts, `spec.k` and `verification.k` (from the construction session's
`inputs/`), `prove.sh`, both audits, the auditor's `mutation-spec.k`, and
`PROOF.md` (first line: `VALIDATED`).

`evidence/` holds every `result.json` the `kprover` CLI retained, keyed by
session and operation, plus the two global `session.json` descriptors. Each
carries the Prover task ID, status, outcome, timing, and inline stdout/stderr.

| Session | Role | Operations |
|---|---|---|
| `16dec4d8` | construction | validation-001..003, proof-001..003 (proof-003 = full module, proved) |
| `02ea26ba` | first audit attempt, interrupted by a server storage incident | validation-001, proof-001 (orphaned) |
| `8c86f354` | clean-room audit | proof-001 (replay, proved), proof-002 (mutation, notProved) |
