---
name: irs
description: Coordinate an Implement-Review-Simplify (IRS) coding workflow for coding requests that explicitly name IRS, 3pass, "one implement one review one simplify", "一个编码一个审查一个更简代码", or require a single writer plus independent correctness and simplification reviews. Supports analysis-only, implementation, existing-diff review, and resume/delivery modes. Do not use for tax or regulatory IRS topics, generic planning, or ordinary code review.
---

# IRS

IRS means Implement, Review, Simplify. Use it to keep coding changes scoped, independently reviewed, and convergent.

## Rules

- Preserve behavior outside the request and avoid opportunistic cleanup. Prefer the smallest change satisfying one canonical contract.
- Respect current authorization. Analysis does not authorize edits; commit does not authorize push, tag, release, or PR creation.
- Use one writer for implementation and every accepted correction. Reviewers never edit; the main agent edits only when explicitly designated as the fallback sole writer.
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

- mode, authorization, baseline revision, current diff, and completed gates;
- goal, non-goals, allowed files or modules, and open decisions;
- preserved and requested behavior, including relevant edge and failure paths;
- diff budget, allowed new structures, chosen shape, and why smaller credible shapes fail;
- repository-native validation and required manual or runtime evidence.

Give every role the raw request, contract, repository instructions, and current diff or relevant files. Isolate other agents' conclusions, not requirements or evidence. Update the contract only for new evidence, authorization, or accepted scope.

## Gate Order

1. Inspect repository state and lock the contract.
2. For Implement mode, assign exactly one writer; skip it for Review existing.
3. The main agent integrates the actual diff before review without editing it.
4. A fresh correctness reviewer examines the full diff. An accepted blocker returns to the same writer, then the full updated diff is reviewed again.
5. After correctness passes, a separate fresh simplification reviewer seeks a smaller equally safe shape. Accepted logic changes return to the same writer and then correctness review.
6. Validate and close only when no accepted blocker or required simplification remains.

Do not rerun an unchanged completed gate. Optional, deferred, rejected, or stylistic findings do not trigger edits merely to clear comments.

## Completion

Finish when the contract and preservation boundary hold, review findings are resolved, required validation passes or missing evidence is explicit, the budget is accepted, and no unrelated or unauthorized action is included.

Report mode, material scope decisions, behavior before and after, changed files, validation, finding dispositions, budget, residual risk, and exact local and remote delivery state. For review-only work, lead with findings and state that no files changed.

When changing this skill, evaluate [evals/cases.yaml](evals/cases.yaml) for mode, side effects, agent topology, resume behavior, and delivery authorization, not exact wording. Use isolated forward tests when delegation is authorized.
