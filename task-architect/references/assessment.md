# Risk, Complexity, And Oversight

Read when the entrypoint requires full assessment or the user requests scores.
The mandatory gate screen remains in [SKILL.md](../SKILL.md#mandatory-gate-screen).
These scores are engineering heuristics, not incident probabilities.

### 3.1 Risk Score (0-100)

| Factor | Weight | Score anchors, from 0 to 4 |
| --- | ---: | --- |
| `I` - Impact of failure | 30% | 0: No behavioral impact; 1: Minor local issue; 2: Recoverable feature outage; 3: Serious critical-function, security, or privacy impact; 4: Widespread or irreversible harm |
| `B` - Blast radius | 20% | 0: Non-runtime; 1: One local component; 2: One module/few users; 3: Multiple modules or platforms; 4: System-wide or many production users |
| `V` - Irreversibility | 20% | 0: Stateless, trivial reversal; 1: Straightforward revert; 2: Migration/recovery required; 3: Expensive or incomplete rollback; 4: No reliable recovery path |
| `U` - Uncertainty | 15% | 0: Behavior and tests verified; 1: Few bounded unknowns; 2: Key paths need investigation; 3: Major behavior/test uncertainty; 4: High-consequence critical facts cannot be verified |
| `S` - Sensitivity | 15% | 0: No sensitive boundary; 1: Ordinary application state; 2: Persistence/system integration boundary; 3: Secrets, crypto, privileges, routes, installers, or trust boundary; 4: Live credentials, production privilege, destructive production operation |

```text
Risk Score = round_half_up((30*I + 20*B + 20*V + 15*U + 15*S) / 4)
```

The numerator already includes weights expressed as percentages. Scores run from `0` to `100`; round `.5` upward. Preserve the five-factor vector and its evidence.

Numeric tiers:

- `R0`: 0-24, minimal risk.
- `R1`: 25-49, moderate risk.
- `R2`: 50-74, high risk.
- `R3`: 75-100, critical risk.

**Final tier = the higher of the numeric tier and every applicable Hard Gate minimum.** When a potentially high-consequence fact cannot be checked, mark the rating `Provisional / Pending investigation`, use conservative assumptions, and never give missing information a score of zero by default.

### 3.3 Complexity Score (0-100)

| Factor | Weight | Score anchors: 0 / 2 / 4 (1 and 3 are intermediate) |
| --- | ---: | --- |
| `M` - Modification scope | 25% | One local point / One module / Multiple subsystems or large refactor |
| `C` - Coupling | 25% | Independent / Clear interface dependencies / Tight coupling and shared mutable state |
| `X` - Cross-platform divergence | 15% | One consistent behavior / Some platform-specific paths / OS-level multi-platform matrix |
| `T` - Verification effort | 20% | Unit checks / Integration suite / Multi-platform end-to-end and failure injection |
| `D` - Coordination burden | 15% | Independent owner / Interface coordination / Multiple owners or critical dependency chain |

```text
Complexity Score = round_half_up((25*M + 25*C + 15*X + 20*T + 15*D) / 4)
```

Complexity tiers: `0-24` simple; `25-49` moderate; `50-74` complex; `75-100` large.

Assess `P` - **Parallelizability** independently:

- `P0`: Cannot meaningfully split.
- `P1`: Work must remain sequential.
- `P2`: Independent read-only investigation or verification can run in parallel; implementation remains coupled.
- `P3`: Two or more implementation packages with clear interfaces and ownership.
- `P4`: Several independent packages, disjoint file ownership, stable interfaces, and straightforward integration.

High complexity **does not imply** that multiple agents will help.

### 3.4 Choose the execution topology

| Condition | Default topology | Rationale |
| --- | --- | --- |
| Low complexity or inseparable shared state | Single agent, small local change, or one review artifact | Avoid coordination overhead |
| High complexity and `P <= 2` | Sequential/staged work | Stabilize interfaces before implementation |
| `Complexity >= 50`, `P >= 3`, at least two independent packages | Multiple agents/worktrees with planned integration | Inputs, outputs, ownership, and integration responsibility can be explicit |

The deliverable may be a local commit, a single PR, several PRs, a patch, or a document according to user preference and available tooling. **Do not require a PR for every task.** Risk determines approval density, not the number of agents or a mandatory platform.

## 4. Phase C - Risk-Adaptive Human Oversight

| Final tier | Allowed autonomy, if `execute` is authorized | Human checkpoints | Minimum review evidence |
| --- | --- | --- | --- |
| `R0` | Implement and validate within scope | Delivery review; any commit/merge per repo rules | Diff, basic checks, unverified claims |
| `R1` | Present design first; implement after approval | `G1` design approval and `G3` pre-merge review when applicable | Interface and compatibility impact, tests |
| `R2` | Investigate/compare; implement in approved stages | `G1` design/failure-model approval, `G2` critical-stage review, `G3` integration/release review when applicable | Failure/threat model, platform matrix, rollback, negative tests |
| `R3` | Read-only until operation-specific permission | Separate authorized approval for each sensitive or production operation; additional independent controls when required | Explicit operation scope, recovery, authority, auditability, post-action validation |

Checkpoint meanings:

- `G0`: Establish task and tool-permission boundaries; do not create avoidable human friction.
- `G1`: Human approves objectives, constraints, and chosen design.
- `G2`: Human approves a critical implementation phase or newly discovered high-risk step.
- `G3`: Human reviews integration, merge, or release **if that action is in scope**. Review is not automatic merge authority.
- `G4`: Examine results and calibration after execution.

**Escalation protocol:** `Pause affected writes -> capture evidence -> re-score -> reopen only affected decisions -> resume after scoped approval`.

Unrelated, authorized read-only work can continue. If the human cannot be reached, report `Blocked` and stop affected writes. Never equate an AI reviewer's "LGTM" with human approval.
