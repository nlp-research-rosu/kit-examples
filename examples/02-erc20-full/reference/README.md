# Reference run: examples/02-erc20-full

`kit-run/` is what KIT left behind after the run described in `/RUN-NOTES.md`:
`SCOPE.md`, the generator script, `spec.k` (18 claims) and `verification.k`
from the construction session's `inputs/`, `prove.sh`, the proof audit, the
auditor's mutation spec (`audits/spec_mut.k`), and `PROOF.md` (first line:
`VALIDATED`).

`evidence/` holds every `result.json` the `kprover` CLI retained, keyed by
session and operation, plus the global `session.json` descriptors.

| Session | Role | Operations |
|---|---|---|
| `787a58a8` | construction | validation-001..004, proof-001 (4-claim probe), proof-002 (all 18, proved) |
| `ec1b5850` | clean-room audit | validation-001, proof-001 (replay, 18/18 proved), proof-002 (mutation, notProved) |

`prover-only/` is an independently written 18-claim solution for the same
bytecode, proved directly on Prover without KIT. Use it to compare theorem
coverage and phrasing against what KIT derived.
