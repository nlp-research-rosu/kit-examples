# Reference runs: examples/11-python-stats-pipeline

A completed KIT v0.1.4 proof, `VALIDATED`, under
`python-3-14-6@e5d24a5429a4`.

`kit-run/` holds the agent-generated specification, bytecode dependency,
`verification.k`, `SCOPE.md`, `prove.sh`, both audits, and
`PROOF.md`. The integer contract returns `(A,B,N,min(A,B),max(A,B),D,max(N,0),max(N,0)*D+min(A,B))`, with `D=max(A,B)-min(A,B)`.

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
| `6f0062ae-d9cd-4767-82dc-b42374c4c45a` | construction | proof-002 (all claims proved) |
| `e92e3059-5fc0-417b-aba2-93dc39b5a2b6` | clean-room audit | validation-002; proof-001 (all claims proved) |

Run `./prove.sh` from `kit-run/` with kprover v0.1.4 or later to start a
pinned session and replay the positive claims. The script uses the globally
configured Prover endpoint and task timeout. The recorded runs used a
10,800-second task timeout.
