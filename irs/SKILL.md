---
name: irs
description: Coordinate an Implement-Review-Simplify (IRS) coding workflow for coding requests that explicitly name IRS, 3pass, "one implement one review one simplify", "一个编码一个审查一个更简代码", require a sole writer plus independent correctness and simplification reviews, or coordinate repository edits that span two or more repositories or cross an explicit dependency edge. Supports analysis-only, implementation, existing-diff review, and resume/delivery modes. Do not use for tax or regulatory IRS topics, read-only multi-repository mapping, generic planning, or ordinary code review.
---

# IRS

IRS means Implement, Review, Simplify. Use it to keep coding changes scoped, independently reviewed, and convergent.

## Rules

- Preserve behavior outside the request and avoid opportunistic cleanup. Prefer the smallest change satisfying one canonical contract.
- Respect current authorization. Analysis does not authorize edits; commit does not authorize push, tag, release, or PR creation.
- Designate one sole writer identity for the whole implementation, including every repository, source/consumer phase, accepted correction, and resume. Reviewers never edit; the main agent edits only when it is that designated fallback writer. Never silently substitute another writer.
- A full implementation uses a fresh read-only correctness reviewer and a separate fresh read-only simplification reviewer.
- Report unavailable delegation or validation; never claim an incomplete gate passed.
- Review passing means technical readiness, not user acceptance.

## Choose One Mode

Classify the whole request. Planning inside an already authorized implementation does not require another authorization.

- **Analyze:** No edits. Read [references/analysis.md](references/analysis.md), return the analysis contract and recommendations, then stop at the implementation gate.
- **Implement:** Edits are requested. Read [references/workflow.md](references/workflow.md) and run every gate.
- **Review existing:** Review without edits. Read [references/workflow.md](references/workflow.md), skip the writer, and run correctness plus simplification unless the user requests a narrower read-only gate. Findings do not authorize fixes.
- **Resume or deliver:** Continue prior work or perform an authorized delivery action. Read [references/workflow.md](references/workflow.md), verify current diff, revision, evidence, and authorization, then resume at the earliest stale or incomplete gate.

Also read [references/performance-startup.md](references/performance-startup.md) only for performance, startup, or render work. Review plus fixes uses Implement mode. Ask for a missing decision only when it changes behavior, public API, ownership, authorized scope, or external side effects.

## Canonical Contract

Record one shared source of truth before dispatching work:

- mode, authorization, baseline revision, current worktree fingerprint and candidate diff, candidate phase (`working` or `staged-delivery`), and completed gates;
- goal, non-goals, allowed files or modules, and open decisions;
- preserved and requested behavior, including relevant edge and failure paths;
- diff budget, allowed new structures, chosen shape, and why smaller credible shapes fail;
- repository-native validation and required manual or runtime evidence.
- when applicable, durable handoff identity and drift, validation ledger revision and gaps, repository/dependency graph and order, and exact requested Git delivery actions and state.

The worktree fingerprint binds HEAD to content digests for staged and unstaged diffs, relevant untracked contents, and relevant dependency, lock, resolution, and generated state. Path names alone are insufficient; incomplete or changed fingerprints stale prior readiness. When commit or amend is authorized, the readiness lock binds a staged-delivery candidate, not an earlier unstaged review. The IRS Canonical Contract remains the core source of truth when companions are active. Reference companion-owned records rather than creating parallel plans or review loops. Give every role the raw request, contract, repository instructions, and current candidate or relevant files. Isolate other agents' conclusions, not requirements or evidence. Update the contract only for new evidence, authorization, or accepted scope.

## Companion Routing

Treat one user request as sufficient; do not ask the user to invoke each companion manually. An explicitly named companion overrides these implicit routing thresholds and must run when available, but never overrides authorization, scope, evidence, or safety gates. Otherwise use only companions whose condition applies:

- `repo-validate` for nontrivial validation involving multiple evidence layers, generated state, cross-module or dependency contracts, native runtime, platform/device evidence, CI conditions, or meaningful failure attribution. Keep simple repository-native checks inside IRS only when `repo-validate` was not explicitly named.
- `cross-repo-integrator` for two or more repositories or an explicit dependency edge. It owns the graph and order; all repository edits remain under this one IRS contract and the same IRS-designated sole writer.
- `git-delivery` for delivery-readiness inspection or audit, or when commit, amend, push, or PR inspection/mutation is requested. It consumes current IRS readiness without repeating review gates.
- `dev-handoff` only when durable state is requested or needed: cross-session capture, transfer, or close, or resume/continue from an existing durable handoff. Ordinary same-turn continuation and a non-durable pause stay inside IRS.

Companions detect and update an active IRS contract but cannot expand its scope or authorization. Companion activation relies on skill description matching, not a hard dependency or guaranteed cascade; do not fan out to all companions by default or claim an unavailable companion ran.

## Execution

Read and follow [references/workflow.md](references/workflow.md) for the canonical gate and checkpoint algorithm in implementation, existing-diff review, resume, and delivery modes. It owns candidate-phase transitions, correction cycles, readiness locks, intermediate source checkpoints, pause/resume, and completion order; do not reconstruct or reorder those rules here.

Keep the Canonical Contract and IRS-designated sole writer stable. Resume at the earliest gate invalidated by a changed candidate, worktree fingerprint, evidence, or authorization; never repeat an unchanged completed gate merely to clear optional comments.

## Completion

Finish when the contract and preservation boundary hold, review findings are resolved, required validation passes or missing evidence is explicit, the budget is accepted, and no unrelated or unauthorized action is included.

Report mode, material scope decisions, behavior before and after, changed files, validation, finding dispositions, budget, residual risk, and exact local and remote delivery state. For review-only work, lead with findings and state that no files changed.

When changing this skill, evaluate [evals/cases.yaml](evals/cases.yaml) for mode, side effects, agent topology, resume behavior, and delivery authorization, not exact wording. Use isolated forward tests when delegation is authorized.
