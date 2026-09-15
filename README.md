# kit-example

Agentic formal verification, end to end: you hand an AI agent a smart contract
and a property, and KIT writes the K reachability specification, proves it on
our hosted Prover, audits its own proof in a clean room, and leaves you a
machine-checked `PROOF.md`. This repository is the shortest path to seeing that
happen on a contract you already know: the HKG ERC20 token.

Two examples, same contract, increasing scope:

| Example | Scope | Expected wall clock |
|---|---|---|
| `examples/01-transfer` | the `transfer` function only | about an hour |
| `examples/02-erc20-full` | every externally callable function | several hours |

Nothing here teaches K. It assumes you already read KEVM specs fluently and
want to see what an agent does with them.

## Prerequisites

- GitHub access to `nlp-research-rosu/kit` and this repository (you were
  invited to both). Both are private, so authenticate Git before cloning:

  ```bash
  gh auth login
  gh auth setup-git
  ```

- `git`, a Rust toolchain (`curl https://sh.rustup.rs -sSf | sh`), and
  [Claude Code](https://claude.com/claude-code).
- macOS or Linux. This path was verified on Ubuntu 24.04 x64.

No local K installation is needed. All K work runs on Prover.

## Install

```bash
git clone --recurse-submodules https://github.com/nlp-research-rosu/kit-example.git
cd kit-example
cargo install --path third_party/kit/crates/kprover-cli
kprover --version && kprover health && kprover semantics
```

`kprover` is KIT's client for Prover (sessions, uploads, polling, evidence).
It is not K's `kprove`. `kprover semantics` must list `evm`; that is the
semantics both examples use.

## Configure budgets (required)

Write `~/.config/kprover/config.toml`:

```toml
task_timeout_seconds = 3600
max_proof_attempts = 10
max_validation_attempts = 10
max_run_attempts = 5
```

The stock defaults are 600 seconds and 3 attempts per session. They are too
small for EVM: the first submission in a session compiles the verification
extension (roughly 11 minutes) before proving starts, individual ERC20 claims
take 3 to 17 minutes to close, and KIT's audit stage spends at least two more
proof submissions (a clean-room replay and a mutation probe). Without this file
the pipeline times out and burns its budget. Check with `kprover config`.

## Example 1: `transfer`

```bash
cd examples/01-transfer
claude --plugin-dir ../../third_party/kit
```

Paste the contents of `PROMPT.md` as your first message. The prompt already
states the semantics, the automation level, and the timeout, so KIT does not
stop to ask.

What you will see, in order:

1. `using-kit` starts a Prover session for `evm` and pins its revision.
   Working files appear under `.kprover/sessions/<id>/`.
2. `writing-spec` writes `SCOPE.md` (what the theorem covers and what it
   deliberately leaves out), `spec.k` (the claims), and summary definitions
   in `verification.k`.
3. `auditing-spec` reviews the theorem in a fresh context and writes
   `audits/spec-audit-1.md` ending in a `VERDICT:` block.
4. `proving-spec` submits proofs, reads residuals, and extends
   `verification.k` until every claim closes. Each attempt's server response,
   stdout, and stderr land in `.kprover/sessions/<id>/proof-NNN/result.json`.
5. `validating-proof` replays the proof in its own clean-room session, runs a
   deliberate false mutation to show the proof is not vacuous, and writes
   `audits/proof-audit-1.md` and `PROOF.md`.

The first line of `PROOF.md` is the exact status. `VALIDATED` means
soundness, adequacy, and evidence all passed. `SOUND-BUT-LIMITED` means the
proof is sound but the theorem is narrower than the intent; the file says
where. `prove.sh` next to it is the exact `kprover` command that produced the
final run, so you can replay it yourself.

## Example 2: full ERC20

```bash
cd examples/02-erc20-full
claude --plugin-dir ../../third_party/kit
```

Paste `PROMPT.md`. Same pipeline, broader theorem: KIT decides which claims
each external function needs. Our verified reference run reached 18 claims
across `balanceOf`, `allowance`, `approve`, `transfer`, `transferFrom`, and
the dispatcher. Expect several hours; the session keeps running while you do
other things, and every accepted submission is retained under
`.kprover/sessions/<id>/`.

## Compare with the reference run

The `reference` branch carries our own completed runs so you can diff what your
agent produced against what ours did:

```bash
git fetch origin reference
git diff main..reference --stat
git show reference:examples/01-transfer/reference/kit-run/PROOF.md
```

Under `examples/<n>/reference/` you will find `kit-run/` (the agent's `spec.k`,
`verification.k`, `SCOPE.md`, `prove.sh`, `audits/`, `PROOF.md`, and the
`result.json` evidence with Prover task IDs) and, for the full ERC20,
`prover-only/`: an 18-claim solution proved on the same `evm` revision
independently of KIT. `RUN-NOTES.md` records timings and attempts used.

The reference branch is kept out of `main` on purpose: the agent reads the
project directory, and a finished spec sitting next to the contract would turn
a verification into a copy.

## If something goes wrong

- `kprover health` fails: infrastructure, not you. Tell us.
- A command returns `status: exhausted` (exit 20): the session's budget is
  spent. Raise the limit in `config.toml`; a new prompt in a fresh Claude Code
  session starts a new Prover session with fresh budgets.
- An audit ends in `VERDICT: BLOCKED`: KIT's instruments failed rather than the
  proof. Send us the verdict block from `audits/*.md`.
- Anything else: send the `.kprover/sessions/<id>/` directory. It has every
  server response.

Reply in the channel where you received the invite.
