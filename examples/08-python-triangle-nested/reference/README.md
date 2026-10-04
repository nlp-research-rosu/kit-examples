# Reference runs: examples/08-python-triangle-nested

A completed KIT v0.1.4 proof, `VALIDATED`, under
`python-3-14-6@e5d24a5429a4`.

`kit-run/` holds the agent-generated specification, bytecode dependency,
`verification.k`, `SCOPE.md`, `prove.sh`, both audits, and
`PROOF.md`. The integer contract returns `(N,N,J,0)` for `N <= 0`; `(N,0,0,N*(N+1)/2)` for `N > 0`.

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
| `7acfc13d-63ea-4e61-bd7e-ab9df1d57783` | construction | proof-008 (all claims proved) |
| `c81c5d17-66f5-4438-ac21-a719c596d61a` | clean-room audit | validation-001; proof-001 (all claims proved) |

Run `./prove.sh` from `kit-run/` with kprover v0.1.4 or later to start a
pinned session and replay the positive claims. The script uses the globally
configured Prover endpoint and task timeout. The recorded runs used a
10,800-second task timeout.
