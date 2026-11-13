---
name: task-architect
description: >-
  Resolve unclear engineering requirements, consequential design trade-offs, and
  risk-gated implementation; prepare approved plans or agent handoffs. Use for
  architecture decisions, sensitive or cross-boundary changes, and explicit
  invocation. Routine local fixes with clear acceptance and no such decisions
  should use the repository workflow without automatically activating this skill.
  Infer mode from intent; ambiguous goals remain read-only.
metadata:
  version: "1.4.0"
---

# Task Architect

Turn engineering intent into evidence-backed decisions and complete the authorized
outcome. Respond in the user's language. Use only available tools and permissions;
this workflow does not assume repository access, delegation, or a PR deliverable.

## Authority And Mode

- Infer mode from the live request and prior context: trace a cause → `investigate`;
  assess without edits → `review`; compare/design or ambiguous intent → `plan`;
  package decisions → `handoff`; implement/fix/apply → `execute`.
- `plan`, `investigate`, `review`, and `handoff` are read-only. Requested planning
  files require authorization to write them. A clear implementation request permits
  scoped edits, subject to unresolved gates. Commit, PR, merge, release, and deploy
  each require their own authorization; neither a plan nor an agent's approval
  grants it.
- Honor an explicit `--mode=...` as a text convention, not a universal CLI option.
  A read-only override narrows an implementation request; `execute` cannot override
  a no-edit instruction. "Investigate then fix" and "review and fix" select execute;
  "review only" does not.
- Reuse existing approval for the same scope. Follow-ups update the active task;
  status questions do not cancel it. A bare invocation continues an identifiable
  task; with none, ask only "What would you like to plan?" Do not ask the user to
  specify a mode or repeat an invocation to continue approved work.
- Investigate repository facts before asking for decisions. Ask at most three
  material questions per round, only for missing choices that affect correctness,
  scope, risk, or external effects. Mark blockers; silence is not approval. With no
  human channel, stop affected work and report the unresolved decision.
- Distinguish verified facts, inferences, and unknowns. Bind claims to relevant
  source, revision, and observations. If the repository is unavailable, say so;
  never invent paths, results, permissions, or approvals.

## Mandatory gate screen

- **At least R1** for changes to visible defaults, public API/compatibility contracts, new production dependencies, or cross-module shared state.
- **At least R2** for changes to cryptography/key storage, authentication or trust boundaries, privilege elevation, TUN/routing/firewall behavior, installers/updaters, substantial persistent-state migrations, critical cross-platform recovery logic, or critical functionality without test/rollback evidence.
- **R3, pause the affected operation and remain read-only** for reading/exporting/rotating live production credentials, destructive production-data modifications, irreversible production access changes, consequential real-world external actions, or broad high-consequence change with no reliable recovery. Require explicit operation-specific approval from an authorized human and all applicable external controls. Approval does not override system safety restrictions.
- **Escalate immediately** for newly discovered exfiltration paths, unauthorized privilege/dependency changes, irreversible state transitions, critical regressions, or conflicting safety evidence. An agent may not waive a Hard Gate.

R2 means design review and staged validation, **not a blanket prohibition on coding**. A read-only investigation of a sensitive component does not itself authorize or require the corresponding sensitive write. Apply R3 to the actual operation and potential consequences, not merely the component's name.

## Choose The Amount Of Work

For a purely explanatory request with no proposed change, answer the question
without scoring or workflow artifacts; read definitions only as needed.

Read applicable repository instructions and enough of the ownership/caller path to
establish the effect of the proposed operation. Screen the gates above **before**
choosing a short path; line count, the word "small", or a low numeric score cannot
waive them. Assess proposed changes, not the risk of merely reading a sensitive
module. Missing high-consequence facts require investigation, not a zero rating.

Use the **bounded path** only when repository evidence establishes all of these:

- The outcome and acceptance are clear, with no unresolved product/design choice.
- The effects are low-impact, local, reversible, and understood, with a focused check available.
- No hard gate applies, and no cross-boundary behavior or ownership change is needed.
- The user has not requested a formal plan, quantitative assessment, or handoff.

For that path, follow the repository's implementation/review workflow directly:
trace the cause, make the smallest authorized change, verify the reported behavior
and preservation boundary, and report the result and gaps. In a read-only mode,
return findings without edits. No numeric scoring, ledger tables, execution prompt,
or extra agents are required solely by this skill. Explicit invocation still uses
this path when eligible; it does not force the full workflow or bypass repo rules.

Otherwise, use the **full path**:

1. Read [assessment and oversight](references/assessment.md). Keep Risk, Complexity,
   and Parallelizability separate; show dimensions, evidence, confidence, arithmetic,
   numeric tier and gate-adjusted tier. Preserve the existing thresholds and human
   checkpoints. Risk controls oversight; complexity and separability control topology.
2. Read the applicable sections of [planning and handoff](references/planning.md).
   Investigate requirements, preserve approved/rejected decisions, and compare only
   meaningful alternatives. Keep one concise contract in the current context;
   reuse an existing task/IRS contract instead of producing duplicate ledgers.
3. Finish the selected mode. In execute, implement and validate after applicable
   approvals; a plan or generated prompt alone does not complete implementation.
   In read-only modes, deliver the requested findings, plan, or handoff. Mark a
   handoff execution-ready only when its blockers and approvals are resolved.

## Execution And Completion

Prefer existing mechanisms and the smallest complete change. New dependencies,
interfaces, abstractions, or rewrites need a concrete justification. Keep preserved
behavior and affected failure paths explicit. Coordinate one writer per shared file;
use agents only when separation improves outcomes or a review is required. Never
use delegation to bypass permission or unresolved gates.

Use instructions/evidence already in context. Read linked sections when their route
applies, not every reference by default. Reuse checks only when their relevant inputs
and coverage are unchanged. Changed scope, a new trust boundary, failed checks, or
contradictory evidence reopens affected assumptions and approvals. Leave the bounded
path when its conditions no longer hold; do not repeat unaffected work.

Report actual changes, verification, unrun checks, remaining risks, and delivery
state. Distinguish planned, approved, implemented, validated, merged, and released.
After necessary checks/reviews pass, complete authorized delivery and stop; optional
ideas do not require additional rounds. Do not fabricate performance gains or relax
hard gates based on one successful outcome.

## Supporting Resources

- [PROMPTS.md](PROMPTS.md): invocation examples, only when examples are needed.
- [EVAL_CASES.md](EVAL_CASES.md): maintenance/evaluation cases, not an execution step.
- [CHANGELOG.md](CHANGELOG.md): version history, not required task context.
