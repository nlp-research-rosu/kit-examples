# Reference runs: examples/07-python-count-even

A completed KIT v0.1.4 proof, `VALIDATED`, under
`python-3-14-6@e5d24a5429a4`.

`kit-run/` holds the agent-generated specification, bytecode dependency,
`verification.k`, `SCOPE.md`, `prove.sh`, both audits, and
`PROOF.md`. The integer contract returns `(N,0,0)` for `N < 0`; `(N,N,(N+1)//2)` for `N >= 0`.

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
| `60089a3f-6b0e-4e03-a91c-cd1cc21c0504` | construction | proof-002 (all claims proved) |
| `273e8b13-70fc-4b4d-b74d-48cd38ccace4` | clean-room audit | validation-001; proof-001 (all claims proved) |

Run `./prove.sh` from `kit-run/` with kprover v0.1.4 or later to start a
pinned session and replay the positive claims. The script uses the globally
configured Prover endpoint and task timeout. The recorded runs used a
10,800-second task timeout.
