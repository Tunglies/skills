# Planning And Handoff

Read only the sections needed for the selected mode: requirement/evidence for investigation or planning; decisions for unresolved choices; work packages for coordinated work; handoff for a requested execution prompt; outcomes after full-workflow execution. This reference does not authorize new artifacts or operations.

## 2. Phase A - Requirement brief and repository investigation

Create or update a compact **Requirement Brief** containing:

- Objective and motivation; observed current behavior and desired behavior.
- In scope, out of scope, affected users/platforms, and invariants.
- Acceptance criteria; performance, security, privacy, compatibility, and operational constraints.
- Verified facts, assumptions, missing repository evidence, and human decisions still needed.

Prefer investigating, in order: repository instructions and architecture; entry points and call/data/state/error flow; existing tests; platform differences; trust and privilege boundaries; performance baselines; migrations and recovery paths. Check authoritative external references only when relevant and available, including the applicable version/date.

Maintain a concise **Evidence Ledger**:

| ID | Claim | Status | Evidence (path/symbol/test/source) | Version/time | Gap |
| --- | --- | --- | --- | --- | --- |
| E1 | Example claim | Verified / Inferred / Unknown | Exact evidence or `Unavailable` | If known | What remains unverified |

If the repository is unavailable, label the situation `Repo unavailable`, offer a provisional plan or investigation-only prompt, and state what a later executor must verify. Never fabricate paths, metrics, code behavior, or completed tests.

Evidence that could change a decision must be refreshed if stale or contradicted.

## 5. Phase D - Decision interview and ledger

Ask at most **three high-value questions per round**, typically fewer. Prioritize choices that materially change behavior or architecture. Do not ask humans for repository facts that an available tool can verify.

Each consequential question includes:

- The specific decision and why it matters.
- Options A/B (or C) with concrete trade-offs.
- A conditional recommendation, not a silently selected answer.
- Whether the question is `Blocking`.
- A conservative default only when non-blocking, low-risk, and reversible.

Maintain a **Decision Ledger**:

| ID | Decision | State | Choice and rationale | Decider and evidence | Scope/stage | Reopen trigger |
| --- | --- | --- | --- | --- | --- | --- |
| D1 | Example trade-off | Proposed / Pending / Approved / Rejected / Superseded | Decision or unknown | Explicit human statement when approved | Applicable change and phase | Changed facts or scope |

Rules:

- `Proposed` is not `Approved`. Inferred preferences and decisions from unrelated past tasks are not current authorization.
- When `Blocking` decisions remain unresolved, you may provide investigation prompts and conditional plans, but not a falsely authorized implementation-ready prompt.
- Reversible, non-blocking defaults must be labeled as assumptions and must not silently alter product semantics.
- Respect rejected alternatives. Do not reintroduce them through a subagent or a different work package.
- Preserve ledger context within the available conversation. Across sessions or tools, explicitly include necessary approved decisions; do not claim durable memory if none exists.

## 6. Phase E - Architecture choice and work package contracts

Compare only meaningful candidates, usually along this progression:

`Minimal fix -> Reuse existing module -> Limited refactor -> Boundary/module refactor`

Evaluate correctness, security, performance, compatibility, maintenance cost, reversibility, and testability. Do not manufacture performance improvements, benchmark numbers, or unsupported trade-offs.

A recommendation must state:

1. Preferred approach and assumptions.
2. Why a smaller approach is insufficient, if applicable.
3. Why alternatives were not selected.
4. Evidence that could falsify or change the recommendation.
5. The minimum viable validation and rollback path.

For each implementation or investigation task, create a **Work Package Contract**:

| Field | Required contents |
| --- | --- |
| `ID / Owner` | Unique package ID, responsible role/agent, integration owner |
| `Goal / Inputs` | Deliverable, verified prerequisites, evidence/decision references |
| `Dependencies` | Prior packages and required human approvals |
| `File ownership` | Allowed paths/modules and a single writer for shared files |
| `Outputs / Acceptance` | Interface/patch/test/docs plus checkable acceptance criteria |
| `Risk / Gates / Stop` | Current tier, approval points, pause conditions |
| `Verification` | Tests/measurements and evidence when they cannot be run |

One assistant may play several roles: read-only investigator, designer, implementer, independent reviewer, and integrator. The **human owner alone provides human approval**. Avoid subagents unless they improve outcomes. Do not let independent writers edit the same working tree/file concurrently; stabilize shared interfaces before parallel implementation.

## 7. Phase F - Compile a portable handoff prompt

Only mark a handoff **`Execution-ready`** when all blocking decisions relevant to that implementation phase are resolved and the required design approvals are explicit. Otherwise mark it **`Draft`** or **`Investigation-only`**.

Generate one self-contained, tool-agnostic handoff prompt with these sections:

```text
# Task
[Desired behavior, problem, and reason]

## Status and authorization
[Draft / Ready for implementation / Execute authorized;
 what exact actions have or have not been approved]

## Verified context and evidence
[Repository paths, symbols, tests, external specifications;
 clearly separate Verified, Inferred, and Unknown]

## Objectives and measurable acceptance criteria
[Observable outcomes, reproducible problem, specific assertions]

## In scope / Out of scope
[Allowed changes and explicit non-goals]

## Invariants and constraints
[APIs, performance, security, compatibility, platforms,
 migrations, state recovery, rollback]

## Decision Ledger
[Human-approved decisions, approver, evidence, scope;
 list unresolved questions separately as blockers]

## Risk / Complexity / Parallelizability
[Raw factor vectors, scores, numeric and final risk tiers,
 Hard Gates, confidence, parallelizability]

## Design and rejected alternatives
[Smallest sufficient approach, rationale, invalidation conditions]

## Work packages and execution topology
[Owners, dependencies, file boundaries, integration responsibility]

## Validation and reporting
[Relevant tests, failure scenarios, platform matrix,
 performance baselines if actually known, remaining risk]

## Human checkpoints / Pause conditions
[Exact stop triggers, decisions to request, scope of approval]

## Deliverables
[Code/docs/patches/evidence; label unrun tests Not run]
```

**Compilation constraints:** Specify outcomes and boundaries without micromanaging every line. Do not invent paths, benchmarks, approvals, test results, or tool capabilities. Do not delegate gated changes to another agent to bypass oversight. If blockers remain, only authorize independent read-only investigation, not the blocked implementation.

## 8. Phase G - Outcome Ledger and calibration

When real execution results are available, record an **Outcome Ledger**. If execution did not occur, mark outcomes `Not observed`.

| Field | Record |
| --- | --- |
| `Predicted` | Prior Risk/Complexity/P, Hard Gates, confidence, approved design |
| `Actual changes` | Changed files/APIs/dependencies, scope drift, newly triggered gates |
| `Validation` | Commands actually run, results, unrun checks, platform coverage, measured performance deltas |
| `Review rework` | Number/type of review-driven revisions |
| `Human friction` | Decision questions, duplicates, interruptions |
| `Incidents / deviations` | Regressions, missed tests, unauthorized actions, planning errors, risk under/overestimation |
| `Calibration proposal` | Evidence/scoring/question improvements for later human review |

Evaluate both under-escalation and excessive approval friction. Do not optimize only for fewer questions. A single success or failure does not justify changing thresholds. **Never auto-relax Hard Gates or retroactively grant approval.** If durable storage is unavailable, include the observations in the current output instead of claiming persistence.
