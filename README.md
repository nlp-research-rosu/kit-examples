# kit-example

Agentic formal verification, end to end: you hand an AI agent a program or
smart contract and a property, and KIT writes the K reachability specification, proves it on
our hosted Prover, audits its own proof in a clean room, and leaves you a
machine-checked `PROOF.md`. This repository is the shortest path to seeing that
happen with the HKG ERC20 token and nine Python programs.

Two EVM examples, same contract, increasing scope, plus nine Python
examples from KleverBench:

| Example | Scope | Wall clock |
|---|---|---|
| `examples/01-transfer` | the `transfer` function only | about an hour |
| `examples/02-erc20-full` | every externally callable function | several hours |
| `examples/03-python-swap` | integer variable swap and tuple return | 1h34m |
| `examples/04-python-arithmetic` | integer multiplication, addition, and subtraction | 2h45m |
| `examples/05-python-absolute-value` | conditional branching and integer negation | 1h52m |
| `examples/06-python-sum` | decreasing loop and accumulated integer sum | — |
| `examples/07-python-count-even` | loop with parity branch and even-index count | — |
| `examples/08-python-triangle-nested` | nested loops and triangular count | — |
| `examples/09-python-nested-with-branch` | nested loops, conditional execution, and preserved locals | — |
| `examples/10-python-pipeline` | multiplication, absolute value, loop, and final addition | — |
| `examples/11-python-stats-pipeline` | min/max branches, range, loop, and final addition | — |

The times for examples 3–5 are recorded agent runtimes with KIT v0.1.3,
rounded to the nearest minute. Examples 6–11 use KIT v0.1.4.
All nine Python examples have validated proofs on the `reference` branch.

Nothing here teaches K. It assumes you already read K specifications fluently
and want to see what an agent does with them.

## Prerequisites

- GitHub access to this repository (you were invited). It is private, so
  authenticate Git before cloning:

  ```bash
  gh auth login
  gh auth setup-git
  ```

- `git` and [Claude Code](https://claude.com/claude-code).
- macOS or Linux. This path was verified on Ubuntu 24.04 x64 with KIT v0.1.1.

No local K installation is needed. All K work runs on Prover.

## Install

KIT ships as a Claude Code plugin plus a `kprover` command-line client, both
from the public `nlp-research-rosu/kit-plugin` repository.

```bash
git clone https://github.com/nlp-research-rosu/kit-example.git
cd kit-example
claude plugin marketplace add nlp-research-rosu/kit-plugin
claude plugin install kit@kit-plugin
curl --proto '=https' --tlsv1.2 -LsSf \
  https://github.com/nlp-research-rosu/kit-plugin/releases/latest/download/install-kprover.sh | sh
```

The installer puts `kprover` in `~/.local/bin` and adds it to your shell's
PATH, so open a new terminal, then:

```bash
kprover --version && kprover health && kprover semantics
```

`kprover` is KIT's client for Prover (sessions, uploads, polling, evidence).
It is not K's `kprove`. `kprover semantics` must list `evm`; that is the
semantics both examples use.

## Configure the endpoint and budgets (required)

Write `~/.config/kprover/config.toml`:

```toml
server_url = "https://rv-prover.intentcomputing.org"
task_timeout_seconds = 3600
max_proof_attempts = 10
max_validation_attempts = 10
max_run_attempts = 5
```

`server_url` selects the Prover instance reserved for you. The CLI's built-in
default is a different, shared instance; `kprover config` shows which one is in
effect.

The stock budget defaults are 600 seconds and 3 attempts per session. They are too
small for EVM: the first submission in a session compiles the verification
extension (roughly 11 minutes) before proving starts, individual ERC20 claims
take 3 to 17 minutes to close, and KIT's audit stage spends at least two more
proof submissions (a clean-room replay and a mutation probe). Without this file
the pipeline times out and burns its budget. Check with `kprover config`.

## Example 1: `transfer`

```bash
cd examples/01-transfer
claude
```

Paste the contents of `PROMPT.md` as your first message. The prompt already
states the semantics, the automation level, and the timeout, so KIT does not
stop to ask.

What you will see, in order (timings from our reference run):

1. `using-kit` starts a Prover session for `evm` and pins its revision.
   Session inputs and evidence go under `.kprover/sessions/<id>/`; the agent's
   own working notes, scripts, and reports land in the example directory.
2. `writing-spec` disassembles the bytecode, then writes `SCOPE.md` (what the
   theorem covers and what it deliberately leaves out), `spec.k` (five claims,
   one per property in the prompt), and `verification.k`. About 10 minutes.
3. `auditing-spec` reviews the theorem against the source and writes
   `audits/spec-audit-1.md` ending in a `VERDICT:` block.
4. `proving-spec` validates the sources (expect a couple of parse-error
   round trips; each is a short server call), then submits proofs. Ours
   closed one claim in 74 s, the other four in 11 minutes, and finished with a
   full-module run of 12 minutes recorded in `prove.sh`. Every attempt's
   server response, stdout, and stderr are in
   `.kprover/sessions/<id>/proof-NNN/result.json`.
5. `validating-proof` opens a second, clean-room session, replays the whole
   proof there (13 minutes, including a fresh definition compile), proves
   that a deliberately false variant of one claim fails, and writes
   `audits/proof-audit-1.md` and `PROOF.md`. About 25 minutes.

Total: roughly an hour and a half of unattended agent time.

The first line of `PROOF.md` is the exact status. `VALIDATED` means
soundness, adequacy, and evidence all passed. `SOUND-BUT-LIMITED` means the
proof is sound but the theorem is narrower than the intent; the file says
where. `prove.sh` next to it is the exact `kprover` command that produced the
final run, so you can replay it yourself. Our run's `PROOF.md` also records
the one thing about this contract worth knowing: the recipient balance
silently wraps on overflow (Solidity 0.4.x, no SafeMath), proved as a faithful
discrepancy against EIP-20 rather than papered over.

## Example 2: full ERC20

```bash
cd examples/02-erc20-full
claude
```

Paste `PROMPT.md`. Same pipeline, broader theorem: KIT decides which claims
each external function needs. In our reference run it derived 18 claims from
the source and `eip-20.md` alone (five each for `transfer` and
`transferFrom`, two each for `approve`, `balanceOf`, and `allowance`, two for
the dispatcher), the same coverage as the independently written 18-claim
solution on the `reference` branch.

Timings from that run: spec and scope in about 25 minutes; four validation
round trips (the first failed to compile the definition, the next two were
parse errors the server reported precisely); a 4-claim probe in 5 minutes;
then all 18 claims proved in one 27-minute submission recorded in
`prove.sh`; then the clean-room audit replay, another 27 minutes, plus the
mutation probe. About two hours unattended, ending in a `PROOF.md` whose
first line is `VALIDATED`, conditional on one recorded assumption (keccak
collision freedom). The session keeps running while you do other things, and
every accepted submission is retained under `.kprover/sessions/<id>/`.

## Example 3: Python swap

```bash
cd examples/03-python-swap
claude
```

Use KIT v0.1.3 or later and check that `kprover semantics` lists
`python-3-14-6` on your configured Prover. These Python runs use
`https://prover.intentcomputing.org`; set `server_url` to that endpoint in
`~/.config/kprover/config.toml` if your instance does not offer it.
Paste `PROMPT.md`. The example supplies the Python source and its
CPython 3.14.6 `.kpyc` export.

For arbitrary integer inputs `A`, `B`, and `R`, prove that
`run(A, B, R)` returns `(B, A, A)`. The temporary variable is overwritten
and the two original values are swapped.

## Example 4: Python arithmetic

```bash
cd examples/04-python-arithmetic
claude
```

Paste `PROMPT.md` with the same Python semantics and KIT prerequisites.
For arbitrary integer inputs `A`, `B`, and `R`, prove that
`run(A, B, R)` returns `(A, B, A * B + A - B)`.

The reference proof covers both small and heap-allocated integer results.
Its eight claims partition the representations of the three intermediate
arithmetic results and together cover all integer inputs.

## Example 5: Python absolute value

```bash
cd examples/05-python-absolute-value
claude
```

Paste `PROMPT.md` with the same Python semantics and KIT prerequisites.
For arbitrary integer inputs `A` and `R`, prove that `run(A, R)` returns
`(A, abs(A))`. The proof covers the negative and nonnegative branches.

## Example 6: Python sum

```bash
cd examples/06-python-sum
claude
```

Use KIT v0.1.4 or later and paste `PROMPT.md` with the same Python
semantics prerequisites.

For arbitrary integer inputs `N` and `S`, prove partial correctness of `run(N, S)`: a normal return is `(N, S)` when `N <= 0`, and `(0, S + N * (N + 1) // 2)` when `N > 0`.

## Example 7: Python count even

```bash
cd examples/07-python-count-even
claude
```

Use KIT v0.1.4 or later and paste `PROMPT.md` with the same Python
semantics prerequisites.

For arbitrary integer inputs `N`, `I` and `C`, prove partial correctness of `run(N, I, C)`: a normal return is `(N, 0, 0)` when `N < 0`, and `(N, N, (N + 1) // 2)` when `N >= 0`. Initial `I` and `C` are overwritten.

## Example 8: Python nested triangular count

```bash
cd examples/08-python-triangle-nested
claude
```

Use KIT v0.1.4 or later and paste `PROMPT.md` with the same Python
semantics prerequisites.

For arbitrary integer inputs `N`, `I`, `J` and `C`, prove partial correctness of `run(N, I, J, C)`: a normal return is `(N, N, J, 0)` when `N <= 0`, and `(N, 0, 0, N * (N + 1) // 2)` when `N > 0`. Initial `I` and `C` are overwritten.

## Example 9: Python nested loops with a branch

```bash
cd examples/09-python-nested-with-branch
claude
```

Use KIT v0.1.4 or later and paste `PROMPT.md` with the same Python
semantics prerequisites.

For arbitrary integer inputs `A`, `B`, `I`, `J` and `R`, prove partial correctness of `run(A, B, I, J, R)`: a normal return is `(A, B, min(A, 0), J_final, L * (L + 1) // 2)`, where `L = max(0, min(A, B))`. `J_final` is 0 if `A > 0` and `B > 0`, otherwise the incoming `J`. Initial `I` and `R` are overwritten.

## Example 10: Python arithmetic pipeline

```bash
cd examples/10-python-pipeline
claude
```

Use KIT v0.1.4 or later and paste `PROMPT.md` with the same Python
semantics prerequisites.

For arbitrary integer inputs `A`, `B`, `N`, `T`, `I` and `R`, prove partial correctness of `run(A, B, N, T, I, R)`: every normal return is `(A, B, N, abs(A * B), max(N, 0), max(N, 0) * abs(A * B) + A)`. Initial `T`, `I` and `R` are overwritten.

## Example 11: Python statistics pipeline

```bash
cd examples/11-python-stats-pipeline
claude
```

Use KIT v0.1.4 or later and paste `PROMPT.md` with the same Python
semantics prerequisites.

For arbitrary integer inputs `A`, `B`, `N`, `M`, `X`, `T`, `I` and `R`, prove partial correctness of `run(A, B, N, M, X, T, I, R)`: every normal return is `(A, B, N, min(A, B), max(A, B), D, max(N, 0), max(N, 0) * D + min(A, B))`, where `D = max(A, B) - min(A, B)`. Initial `M`, `X`, `T`, `I` and `R` are overwritten.

These six loop examples prove partial correctness of the compiled function
body in a prepared runtime frame. Their reference reports state the frame
conditions; module initialization, argument binding and a separate termination
theorem are outside that scope.

These programs are Python rewrites of KleverBench programs. Their prompts
state the original integer properties directly; KIT writes the formal
specifications itself. The theorems establish partial correctness under
`python-3-14-6`.

## Compare with the reference run

The `reference` branch carries our own completed EVM and Python runs so you
can diff what your agent produced against what ours did:

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
- A submission returns HTTP 500 `STORAGE_EXHAUSTED`: the Prover instance's
  data cap is full (every distinct `verification.k` compiles a multi-gigabyte
  definition). Tell us; it is a one-line fix on our side, and the agent can
  resume the same session afterwards.
- A proof is cancelled at almost exactly 10 minutes: the agent ran `kprover`
  in the foreground and hit Claude Code's shell-command timeout. Start Claude
  Code with `BASH_MAX_TIMEOUT_MS=3600000 claude` so foreground proofs can run
  as long as the Prover task timeout.
- KIT does not show up (no `kit:` skills when you type `/`): run
  `claude plugin marketplace update kit-plugin && claude plugin update kit@kit-plugin`
  and start a new session. The same two commands pick up new KIT releases;
  rerun the installer to update `kprover`.
- Anything else: send the `.kprover/sessions/<id>/` directory. It has every
  server response.

Reply in the channel where you received the invite.
