---
name: irs
description: Use when the user says "irs", "IRS workflow", "3pass", "one implement one review one simplify", "一个编码一个审查一个更简代码", asks for IRS analysis or a plan without landing changes, asks to loop until the smallest behavior-preserving fix, or asks for a guarded coding workflow with one implementation pass, one independent correctness review, one code-simplification review, and convergence toward minimal change. Applies to behavior-preserving bug fixes, refactors, performance work, startup work, and minimal-scope changes where no behavior drift, no opportunistic cleanup, repository-specific validation, explicit acceptance, and controlled commits matter.
---

# IRS

IRS means Implement, Review, Simplify. Use it as a guarded coding workflow for changes where correctness, small scope, and review discipline matter.

## Core Contract

- Preserve behavior unless the user explicitly requests behavior change.
- Make the smallest scoped change that satisfies the request.
- Do not make opportunistic cleanup.
- If the user asks for analysis, a scheme, a plan, or says not to land changes, stay in analysis-only mode until they explicitly authorize implementation.
- Do not commit unless the user explicitly asks.
- Use one implementation pass, one independent correctness review, and one simplification review.
- Iterate only to improve correctness, preserve behavior, or reduce unnecessary code; do not churn.
- Keep agent roles isolated and pass each agent only the minimum context needed for its responsibility.
- Treat review passing as technical readiness, not user acceptance.

## Analysis-Only Mode

Use this mode when the user asks for IRS analysis, a scheme, a plan, comparison of approaches, or explicitly says not to land changes.

In analysis-only mode:

- Do not edit files, create commits, or start implementation agents.
- Read the repository enough to ground the analysis in actual files and local patterns.
- Identify whether the request is a behavior change, behavior-preserving fix, refactor, performance change, startup change, or review-only task.
- Produce an IRS Analysis Contract before any implementation plan is accepted.
- If a requested implementation would exceed the proposed diff budget, call that out as a pending decision rather than silently widening scope.
- Ask the user for implementation authorization before leaving analysis-only mode.

## IRS Analysis Contract

For analysis-only requests, or before high-risk/minimal-change implementation, produce this concise contract:

```markdown
## IRS Analysis Contract

### Request Interpretation
- Goal:
- Non-goals:
- Behavior change allowed: yes/no
- Analysis-only: yes/no

### Repository Evidence
- Relevant files/modules:
- Existing patterns:
- Unknowns:

### Behavior Boundary
- Existing behavior to preserve:
- New or fixed behavior:
- Edge paths:
- Failure and fallback paths:

### Option Matrix
| Option | Scope | New state/API | Behavior risk | Diff size | Verdict |
|--------|-------|---------------|---------------|-----------|---------|

### Proposed Diff Budget
- Expected files:
- Expected kind of change:
- New structures allowed:
- Explicit exclusions:

### Verification Plan
- Targeted checks:
- Broader checks if scope expands:
- Manual checks:

### Review Routing
- Implementation agent scope:
- Correctness reviewer focus:
- Simplification reviewer focus:

### Pending Decisions
- DEC-1:
```

Keep empty sections short. Mark unknowns explicitly instead of inventing facts. If no implementation is authorized, stop after the contract and recommendations.

## Scope Lock

Before implementation, identify:

- Goal: the concrete bug, performance issue, or refactor target.
- Non-goals: things that look related but should not be changed.
- Allowed area: files/modules expected to change.
- Behavior boundary: user-visible behavior that must remain unchanged.
- Verification: how success will be checked.

If the expected diff is not small, say why before editing. When possible, name what will not be changed.

## Diff Budget

Before editing, set a lightweight diff budget when the task is narrow or the user cares about minimality:

- Expected files or modules to change.
- Expected kind of change: local logic, call site, config, tests, docs.
- Expected new structures: helpers, state, types, public API, generated files.
- Explicit exclusions: files/modules that should not change.

If the actual diff exceeds the budget, pause and explain why before continuing or before final acceptance. After implementation, compare actual diff against the budget.

## Pre-Implementation Option Gate

For narrow or minimal-change tasks, especially performance and startup work, compare implementation shapes before editing:

- Smallest local change.
- Explicit data-flow or call-site change.
- Cache, state, singleton seeding, or cross-module API change if applicable.

Choose the smallest behavior-preserving shape. Do not implement a shape that initializes unrelated modules earlier, widens lifecycle ownership, adds cross-module seeding APIs, or moves work into another startup/render path unless the smaller local shape is proven behaviorally unsafe.

When an option exceeds the diff budget, the implementation agent must report:

- why the smaller option is invalid,
- which files/modules become newly involved,
- whether any lazy/deferred work becomes eager,
- what new state/API is introduced,
- and why the scope expansion is necessary.

If this explanation is missing or weak, the main agent must not accept the implementation as final.

## Behavior Matrix

For behavior-preserving or high-risk changes, write a short behavior matrix before finalizing:

- Existing behavior that must remain unchanged.
- New or fixed behavior.
- Direct-entry or deep-link behavior.
- State-transition behavior such as toggles, language/theme changes, cache refreshes, retries, and already-mounted views.
- Error, fallback, empty, permission, and disabled-state behavior.

Use the matrix to guide review and manual verification. Keep it concise; focus on paths that can regress.

## Agent Isolation

Keep agent responsibilities separate to reduce context pollution:

- Implementation agent: receives the goal, allowed scope, behavior boundary, and validation expectations. Do not include expected review findings or simplification conclusions.
- Correctness review agent: receives the goal and current diff or file paths. Do not include the implementer's rationale except when necessary to understand the intended behavior.
- Simplification agent: receives the goal and current diff. Do not include correctness review conclusions unless a blocking correctness issue affects simplification.
- Main agent: integrates results, resolves conflicts, validates, and decides whether another loop is required.

Prefer fresh agents for distinct roles. Do not ask one agent to both implement and approve its own work. When re-reviewing after a fix, provide the updated diff and the narrow prior blocking issue, not the full implementation narrative.

## Implementation Pass

Use one worker agent only when the user requested agent-based handling or this workflow requires delegation.

Instruct the worker to:

- Own a narrow file/module scope.
- Compare plausible implementation shapes before editing when the change must be minimal.
- Edit directly in its workspace.
- Avoid unrelated cleanup.
- Preserve behavior.
- Stay within the diff budget or report why it cannot, including why smaller approaches are unsafe.
- Treat new singleton seeding, cross-module initialization entry points, broad caches, public or crate-wide APIs, and lifecycle ownership changes as suspicious by default.
- List changed files and validation results.
- Not commit.

After the worker returns, inspect the actual diff yourself before accepting it.

## Main-Agent Integration

Review the diff locally before sending it to reviewers:

- Check `git diff --stat`.
- Compare the actual diff with the diff budget.
- Check the behavior matrix against changed code.
- Read changed files, not only summaries.
- Search call sites and indirect reuse paths with `rg`.
- Check deep links, fallback paths, state transitions, and language/theme/cache changes when relevant.
- Treat new state, new helpers, new abstractions, and public API changes as suspicious until justified.
- For performance/startup/render fixes, run a reverse-performance check: confirm the fix does not make unrelated I/O, parsing, module initialization, subscriptions, timers, rendering, or singleton construction happen earlier.
- Treat moving work from one startup/render path into another as a possible non-fix until the new timing and ownership are clear.
- Confirm no unrelated files or generated artifacts were changed.

If a blocking issue is found, fix only that issue and repeat the relevant review.

## Convergence Loop

After the first technically working fix, loop toward the smallest behavior-preserving diff.

Use this loop:

1. Establish behavior correctness: the requested behavior works and no known behavior drift remains.
2. Establish a baseline diff: changed files, insertion/deletion count, new helpers, new state, and new public API surface.
3. Ask whether each new moving part is required:
   - Can existing source of truth replace new state?
   - Can an existing helper or local pattern replace a new helper?
   - Can a new abstraction become a local inline block?
   - Can a changed public API stay compatible or remain private?
   - Can a route/component/file avoid being touched?
   - Can a cross-module seed/cache become a local one-time handoff?
   - Does the diff initialize any unrelated module earlier than before?
4. Apply only simplifications that preserve the established behavior.
5. Re-run the relevant validation and review after any simplification that changes logic.
6. Stop when further simplification would:
   - reintroduce a reviewed bug,
   - weaken an edge case,
   - hide behavior behind clever code,
   - remove useful validation/guards,
   - or save only line count without reducing complexity.

Report the final diff size if the user questioned size or minimality. Explain why remaining code is necessary.

## Independent Review

Send a read-only review task to an independent agent. Ask it to find:

- Blocking bugs.
- Behavior drift.
- Behavior matrix gaps.
- Edge cases and direct-entry paths.
- Error/fallback regressions.
- Missing tests or insufficient validation.
- Cross-module contract risks.

Do not ask the review agent to modify files. If it finds a blocking issue, fix the narrow issue and re-run review on the updated diff.

## Simplification Review

Send a read-only Code-Simplifier-style task. Ask it to find:

- Unnecessary abstraction.
- Helpers or types with too little payoff.
- Duplicated state or duplicated source of truth.
- Diff budget overruns.
- Scope expansion beyond the request.
- Code that can be removed without behavior change.
- Places where further simplification would risk behavior drift.

Do not reduce code solely to reduce line count. Prefer simpler behavior-preserving structure over smaller but riskier code.

For tasks where the user explicitly emphasizes minimality, consider a read-only simplification/option review before implementation. Ask for the smallest safe implementation shape and known traps, then give the implementation agent only the chosen boundary, not the simplifier's conclusions.

## Validation

Use the repository's own validation conventions.

- Discover validation commands from local project files before choosing commands:
  - `package.json`
  - lockfiles such as `pnpm-lock.yaml`, `yarn.lock`, `package-lock.json`, `bun.lockb`
  - `Cargo.toml`
  - `Makefile`, `justfile`, `Taskfile.yml`
  - CI configs such as `.github/workflows/*`
  - lint/type/test configs near touched files
- Prefer existing repo scripts or tasks over raw tool commands.
- Match validation scope to change risk:
  - narrow source edits: lint/type/format or targeted tests
  - shared contracts, routing, startup, generated types, bundling, or runtime initialization: broader test/build checks
- Run `git diff --check` when git is available.
- Report exactly which commands ran and whether they passed.
- If validation cannot be run, say why and state residual risk.

Do not assume a package manager, language, framework, or test runner unless the repository shows it.

## Acceptance And Session Notes

If the task uses a session-local notes file:

- Keep it local-only.
- Exclude it via `.git/info/exclude`, not project `.gitignore`, unless the user asks otherwise.
- Update it with status, changed files, validation, review results, residual risk, and manual acceptance.
- Mark accepted only when the user confirms acceptance or asks to mark it accepted.

## Commit Rules

Commit only after explicit user instruction.

Before committing:

- Re-check `git status --short`.
- Stage only files relevant to the fix.
- Exclude session notes, caches, build output, local generated artifacts, and unrelated dirty files.
- If hooks or formatters modify files, re-check the diff before finalizing.

Use a commit title that names the actual mechanism or behavior changed.

## Reporting

When reporting back, include:

- What changed.
- What benefit it gives.
- Why behavior is preserved.
- Whether the change is minimal.
- What validation passed.
- What review and simplification found.
- How the user can manually verify it.
