# Reference runs: examples/06-python-sum

A completed KIT v0.1.4 proof, `VALIDATED`, under
`python-3-14-6@e5d24a5429a4`.

`kit-run/` holds the agent-generated specification, bytecode dependency,
`verification.k`, `SCOPE.md`, `prove.sh`, both audits, and
`PROOF.md`. The integer contract returns `(N,S)` for `N <= 0`; `(0,S+N*(N+1)/2)` for `N > 0`.

`evidence/` holds the passing full construction proof and clean-room
positive replay results, including stdout, stderr, and task IDs.
The audit reports summarize the original checks and verdicts; this package
contains only successful program proofs and validation logs.
The proof sources and their recorded hashes are unchanged. Packaged bytecode
normalizes the source filename to `program/program.py`; instructions, code
metadata, formal claims and summary equations are unchanged. Original
bytecode hashes in the recorded audits refer to the pre-normalized image.

| Session | Role | Operations |
|---|---|---|
| `fe6fa19a-e342-450d-a190-afa9f9cedf0b` | construction | proof-004 (all claims proved) |
| `4f14b139-8202-4fa2-bc9d-1e97c1a638f3` | clean-room audit | validation-001; proof-001 (all claims proved) |

Run `./prove.sh` from `kit-run/` with kprover v0.1.4 or later to start a
pinned session and replay the positive claims. The script uses the globally
configured Prover endpoint and task timeout. The recorded runs used a
10,800-second task timeout.
