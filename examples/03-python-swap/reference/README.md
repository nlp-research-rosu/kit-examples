# Reference runs: examples/03-python-swap

A completed KIT v0.1.3 run, `VALIDATED`, under
`python-3-14-6@e5d24a5429a4`.

`kit-run/` holds the agent-generated specification, bytecode dependency,
`verification.k`, `SCOPE.md`, `prove.sh`, both audits, and
`PROOF.md`. The integer contract returns `(B, A, A)`.

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
| `2f8278f9-afcf-4fe6-b17b-882f0db1524d` | construction | proof-003 (proved) |
| `6b19174d-608c-484c-b547-0670ba36728d` | clean-room audit | positive replay; see `kit-run/PROOF.md` |

Run `./prove.sh` from `kit-run/` to start a pinned session and replay the
positive claims. The script uses the globally configured Prover endpoint.
