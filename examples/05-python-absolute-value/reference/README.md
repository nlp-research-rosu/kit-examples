# Reference runs: examples/05-python-absolute-value

A completed KIT v0.1.3 run, `VALIDATED`, under
`python-3-14-6@e5d24a5429a4`.

`kit-run/` holds the agent-generated specification, bytecode dependency,
`verification.k`, `SCOPE.md`, `prove.sh`, both audits, and
`PROOF.md`. The integer contract returns `(A, abs(A))`.

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
| `35db469f-c5f8-4f79-8efd-b94e254c92fe` | construction | proof-007 (proved) |
| `a4284896-cf66-424f-9b7b-660707e9d5fa` | clean-room audit | positive replay; see `kit-run/PROOF.md` |

Run `./prove.sh` from `kit-run/` to start a pinned session and replay the
positive claims. The script uses the globally configured Prover endpoint.
