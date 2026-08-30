---
name: irs
description: Coordinate an Implement-Review-Simplify (IRS) coding workflow for coding requests that explicitly name IRS, 3pass, "one implement one review one simplify", "一个编码一个审查一个更简代码", or require a single writer plus independent correctness and simplification reviews. Supports analysis-only, implementation, existing-diff review, and resume/delivery modes. Do not use for tax or regulatory IRS topics, generic planning, or ordinary code review.
---

# IRS

IRS means Implement, Review, Simplify. Use it to keep coding changes scoped, independently reviewed, and convergent.

## Core Contract

- Preserve behavior outside the requested change.
- Make the smallest change that satisfies the request; do not perform opportunistic cleanup.
- Respect the user's current authorization. Analysis does not authorize edits, and a commit does not authorize push, tag, release, or PR creation.
- Use one writer for all implementation and correction work.
- Use a fresh read-only correctness reviewer and a separate fresh read-only simplification reviewer for a full IRS implementation.
- Treat review passing as technical readiness, not user acceptance.
- Do not claim a full IRS pass when required delegation or validation was unavailable; report the degraded gate explicitly.

## Select The Mode

Classify the whole request before starting. A word such as "plan" does not force analysis-only mode when the same request already authorizes implementation.

- **Analyze:** The user asks for IRS analysis, options, or a plan and does not authorize edits. Inspect the repository, produce the contract and recommendations, then stop at the implementation-authorization gate.
- **Implement:** The user explicitly asks to edit, fix, refactor, optimize, or land a change. Planning within that request does not require a second authorization prompt.
- **Review existing:** The user asks to review an existing diff, branch, or implementation without edits. Skip the writer and run the requested read-only correctness and simplification gates. Findings do not authorize fixes.
- **Resume or deliver:** The user asks to continue an existing IRS task or perform an authorized delivery action. Inspect the current diff, revision, prior evidence, and authorization; resume at the earliest incomplete or stale gate instead of restarting completed work.

When a request combines review and fixes, use Implement mode. When a missing choice would materially change behavior, public API, ownership, or authorized scope, stop for that decision rather than guessing.

## Canonical IRS Contract

Create one concise contract and use it as the source of truth for the main agent and every delegated role:

- mode and current authorization,
- goal and non-goals,
- allowed files or modules,
- existing behavior to preserve and requested behavior to add or fix,
- edge, failure, fallback, and state-transition paths that matter,
- diff budget and allowed new state, helpers, types, APIs, or generated files,
- chosen implementation shape and why smaller credible alternatives are unsafe or insufficient,
- repository-native validation and manual checks,
- baseline revision, current diff, completed gates, and open decisions.

For analysis-only work, present these fields as an `IRS Analysis Contract`. Keep empty sections out. Add an option matrix only when two or more credible implementation shapes need comparison.

Do not recreate the contract independently in each agent prompt. Update it only when repository evidence, authorization, or the accepted scope changes. If implementation exceeds the budget:

- update and continue when the expansion remains inside the explicit request and introduces no new behavior, public contract, ownership, or external side effect;
- otherwise stop at a pending decision and explain why the smaller boundary is invalid.

## Roles And Handoffs

Every role receives the raw user request, the canonical contract, the baseline, the current diff or relevant files, and applicable repository instructions. Isolation means withholding other agents' conclusions, not withholding requirements or evidence.

- **Writer:** Receives the selected shape, scope, non-goals, behavior boundary, diff budget, and validation expectations. It is the only role allowed to edit and handles all accepted corrections. It does not commit.
- **Correctness reviewer:** Receives the behavior boundary, acceptance conditions, scope, full current diff, and validation evidence. It does not receive the writer's rationale unless a factual constraint cannot otherwise be understood.
- **Simplification reviewer:** Receives the behavior boundary, non-goals, diff budget, full current diff, and the fact that correctness passed. It does not receive detailed correctness conclusions.
- **Main agent:** Establishes the contract, inspects actual repository state and diffs, dispatches gates, records finding dispositions, validates, and performs only explicitly authorized delivery actions. It does not become a second writer.

Use distinct fresh agents for the two review roles. If delegation is unavailable, the main agent may be the sole writer, but it must not present its own review as independent.

## Deterministic Workflow

### 1. Establish State

- Read repository instructions and relevant code before choosing the shape.
- Record the baseline revision and pre-existing dirty files.
- Search callers and indirect reuse paths where contracts can propagate.
- Lock the canonical contract before editing.

### 2. Implement With One Writer

In Implement mode, assign exactly one writer. The writer changes only the allowed scope, validates proportionally, and returns changed files, diff-budget variance, and command results.

In Review-existing mode, skip this step. In Resume mode, reuse the original writer when available and do not discard accepted work merely to recreate the workflow.

### 3. Main-Agent Integration

Before review, the main agent reads the changed files and actual diff, then checks:

- the diff against the goal, non-goals, behavior boundary, and budget,
- callers, edge paths, failures, fallbacks, and state transitions relevant to the task,
- new state, helpers, abstractions, APIs, ownership, or generated files for necessity,
- unrelated dirty files or artifacts for accidental inclusion,
- validation evidence against repository conventions.

Return integration blockers to the same writer. Do not start independent reviews on a diff known to be invalid.

### 4. Correctness Gate

Send the full integrated diff to the independent correctness reviewer. Ask for evidence-backed findings covering requested behavior, unintended behavior drift, edge and error paths, cross-module contracts, tests, and validation gaps.

Record each finding with an ID, severity (`blocking` or `optional`), evidence, disposition (`accepted`, `deferred`, or `rejected`), reason, and owner. Only an accepted blocking finding automatically triggers edits.

For an accepted blocker:

1. Send the narrow issue to the same writer.
2. Re-run affected validation.
3. Send the full updated diff back through a full correctness review, highlighting the prior blocker without limiting review to it.

Do not start the simplification gate until correctness has no unresolved blocking findings.

### 5. Simplification Gate

Send the correctness-passing diff to the separate simplification reviewer. Ask it to identify unnecessary files, state, APIs, abstractions, helpers, duplication, and budget overruns, while naming guards or complexity that must remain for behavior.

Optional suggestions do not expand scope automatically. Apply only accepted simplifications that reduce meaningful complexity without weakening the contract.

If an accepted simplification changes logic, the same writer applies it, affected validation runs again, and the full diff returns to the correctness gate. If it changes no behavior-bearing logic, validate proportionally and record why a repeated correctness pass is unnecessary.

### 6. Close The Workflow

Stop when all are true:

- the requested behavior and preservation boundary are satisfied,
- no accepted blocking finding remains,
- no smaller equally safe implementation remains from the simplification gate,
- required validation passes or unavailable evidence is stated,
- the diff fits the budget or an authorized expansion is recorded,
- no unauthorized delivery action or unrelated change is included.

Do not rerun a completed gate when the reviewed diff and relevant evidence are unchanged. Do not implement deferred, rejected, or purely stylistic suggestions merely to make every reviewer comment disappear.

## Risk-Specific Checks

Apply only checks relevant to the task rather than treating one past failure mode as universal:

- For performance, startup, or render work, confirm that work was removed or delayed rather than shifted earlier or into another critical path.
- For concurrency, persistence, lifecycle, protocol, or public-contract changes, identify the exact invariants and failure evidence needed before implementation.
- For generated sources or lockfiles, distinguish repository-required deliverables from disposable local output.

## Validation

Discover and use repository-native checks. Match validation scope to risk, run `git diff --check` when Git is available, and report commands and results exactly. Static checks do not prove runtime, device, production, or performance behavior.

If a review or validation gate cannot run, state the missing evidence and residual risk instead of silently treating the gate as passed.

## Delivery

Commit, push, tag, release, and PR creation are separate authorization boundaries.

Before an authorized commit, re-check status and the full diff, stage exact relevant paths, include repository-required generated files, exclude unrelated dirty files and disposable artifacts, and re-check any hook changes. Report the commit and remote state separately.

## Reporting

Report the selected mode, contract or material scope decisions, changed files, behavior before and after, validation, correctness and simplification dispositions, diff-budget result, residual risk, and exact delivery state. For review-only work, lead with findings and state clearly that no files were changed.

## Skill Evals

When changing this skill, use the positive and negative prompt cases in [evals/cases.yaml](evals/cases.yaml). Evaluate mode, side effects, agent topology, resume behavior, and delivery authorization, not exact wording. Run realistic forward tests in an isolated temporary workspace when delegation is authorized.
