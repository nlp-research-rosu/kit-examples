Use KIT to formally verify `program/program.py` at the Python bytecode
level through Prover.

Settings (use these; do not stop to ask):
- Semantics: `python-3-14-6`
- Automation level: maximum. Continue until the proof is validated or the
  session budget is exhausted.
- Prover task timeout: 10800 seconds.

Inputs (everything you need is in this directory):
- `program/program.py` — the Python source.
- `program/program.kpyc` — its CPython 3.14.6 bytecode export. Claims are
  against this bytecode.

What to prove:
For arbitrary integer inputs `A`, `B`, `N`, `T`, `I` and `R`, prove partial correctness of `run(A, B, N, T, I, R)`: every normal return is `(A, B, N, abs(A * B), max(N, 0), max(N, 0) * abs(A * B) + A)`. Initial `T`, `I` and `R` are overwritten.

Rules:
- Work only inside this directory.
- Write the specification yourself; do not consult existing formal specs
  for this program.
- Prove the claims and audit the proof.
- You are done when `PROOF.md` exists with the proof's exact status on its
  first line, or you have documented which claims do not pass and why.
