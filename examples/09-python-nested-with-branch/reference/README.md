# Reference runs: examples/09-python-nested-with-branch

A completed KIT v0.1.4 proof, `VALIDATED`, under
`python-3-14-6@e5d24a5429a4`.

`kit-run/` holds the agent-generated specification, bytecode dependency,
`verification.k`, `SCOPE.md`, `prove.sh`, both audits, and
`PROOF.md`. The integer contract returns `(A,B,min(A,0),J_final,L*(L+1)/2)`, with `L=max(0,min(A,B))` and `J_final=0` only when both inputs are positive.

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
| `b35bf39a-8544-4725-a1ec-29b9ce884e5b` | construction | proof-001 (all claims proved) |
| `03008422-572b-4ea7-bc9c-a37ff47fef2e` | clean-room audit | validation-001; proof-001 (all claims proved) |

Run `./prove.sh` from `kit-run/` with kprover v0.1.4 or later to start a
pinned session and replay the positive claims. The script uses the globally
configured Prover endpoint and task timeout. The recorded runs used a
10,800-second task timeout.
