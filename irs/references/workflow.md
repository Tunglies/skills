# Implementation And Review Workflow

## Handoffs

- **Writer:** Gets shape, scope, non-goals, behavior boundary, budget, and validation. It alone edits and never commits.
- **Correctness reviewer:** Gets acceptance conditions, behavior boundary, scope, full diff, and validation. Withhold writer rationale unless factually necessary.
- **Simplification reviewer:** Gets behavior boundary, non-goals, budget, full diff, and only the fact that correctness passed.
- **Main agent:** Records state and findings, reads the diff, dispatches gates, validates, and performs authorized delivery. It is not a second writer.

Use distinct fresh reviewers. If delegation is unavailable, the main agent may write but must identify missing independent gates.

## Execution

1. Read repository instructions and relevant code. Record baseline and pre-existing dirty paths; search callers and indirect contracts.
2. The writer returns changed files, budget variance, and exact validation. On resume, reuse the writer when available and preserve accepted work.
3. Before review, inspect the actual diff against goal, non-goals, behavior, budget, edge/failure paths, new structures or ownership, validation, and unrelated artifacts. Return blockers to the same writer.
4. Correctness review covers requested behavior, drift, edge/error paths, cross-module contracts, tests, and validation gaps.
5. Only after correctness passes, simplification review checks unnecessary files, state, APIs, abstractions, helpers, duplication, budget overruns, and complexity required for safety.

Record findings as ID, `blocking` or `optional`, evidence, `accepted`/`deferred`/`rejected`, reason, and owner. Only accepted blockers or behavior-preserving simplifications trigger edits.

After a blocker, the same writer fixes it, affected validation reruns, and the full diff receives full correctness review. After simplification, repeat correctness when logic changed; otherwise validate proportionally and record why rereview is unnecessary.

If scope exceeds budget, update and continue only inside the request with no new behavior, public contract, ownership, or external side effect; otherwise stop for a decision.

Use repository-native validation and run `git diff --check` when available. Static checks do not prove runtime, device, production, or performance behavior.

Commit, push, tag, release, and PR creation require separate authorization. Before commit, inspect status and diff, stage exact paths including required generated files, exclude unrelated artifacts, and inspect hook changes. Report commit and remote state separately.

Resume at the first gate whose diff or evidence changed; do not repeat unchanged gates.
