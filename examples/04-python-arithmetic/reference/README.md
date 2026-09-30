# Reference runs: examples/04-python-arithmetic

A completed KIT v0.1.3 run, `VALIDATED`, under
`python-3-14-6@e5d24a5429a4`.

`kit-run/` holds the agent-generated specification, bytecode dependency,
`verification.k`, `SCOPE.md`, `prove.sh`, both audits, and
`PROOF.md`. The integer contract returns `(A, B, A * B + A - B)`.

`evidence/` holds the original passing construction proofs and clean-room
positive replay results, including stdout, stderr, and task IDs.
The audit reports summarize the original checks and verdicts; this package
contains only successful program proofs and validation logs.
The reports summarize the original run and retain its recorded hashes.
Packaged bytecode normalizes source filenames and line metadata; instructions,
formal claims,
and summary equations are unchanged. Source filenames and local descriptor
paths are normalized in published evidence copies for portability.

| Session | Role | Operations |
|---|---|---|
| `308551e7-85d3-4ceb-8100-62ae50a3b825` | construction | proof-005, proof-006, proof-007, proof-008, proof-009, proof-010, proof-011, proof-012 (proved) |
| `ccf48e89-c2c8-4649-850b-70ed6b91fc91` | clean-room audit | positive replay; see `kit-run/PROOF.md` |

Run `./prove.sh` from `kit-run/` to start a pinned session and replay the
positive claims. The script uses the globally configured Prover endpoint.
