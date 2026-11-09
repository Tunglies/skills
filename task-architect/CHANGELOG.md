# Changelog

## v1.3.0 - Intent-based mode selection

- Infer investigate, plan, review, handoff, or execute from natural-language intent and ongoing task context.
- Keep explicit mode flags optional and use read-only planning for ambiguous goals.
- Preserve scoped authorization, no-edit constraints, and unresolved risk gates; add routing and conflict evaluation cases.

## v1.2.1 - Full English documentation

- Rewrote all four Markdown documents entirely in English, including frontmatter metadata, sample requests, evaluation cases, and supporting text.
- Preserved the zero-boilerplate invocation contract and the tool-agnostic, default read-only behavior.
- Kept separate weighted Risk and Complexity scores, Parallelizability, non-overridable Hard Gates, Human Oversight checkpoints, Decision Ledger, Work Package Contracts, and Outcome Ledger.
- Clarified that the assistant should respond in the user's language unless instructed otherwise, even though the skill documentation is English.
- Added evaluation cases for lack of a live human channel and the half-up rounding boundary.
- No claims of having executed the skill against a live repository or validated scoring thresholds empirically.

## v1.2.0 - Zero-boilerplate invocation

- Made `$task-architect <short request>` sufficient to start the default planning workflow; `--mode=plan` is unnecessary.
- Embedded investigation, risk/complexity scoring, human decisions, prompt compilation, and reporting within `SKILL.md`.
- Clarified continuation from short follow-up messages and that cross-tool/session approval state cannot be assumed.
- Added empty-invocation, mode-selection, compact-response, and escalation guidance.

## v1.1.0 - Risk-adaptive oversight and orchestration

- Added anchored, weighted Risk Score (0-100), confidence, and evidence requirements.
- Added Hard Gates to prevent sensitive or production operations from being hidden by a low average.
- Added independent Complexity Score (0-100) and Parallelizability (`P0-P4`).
- Added `G0-G4` human checkpoints and dynamic re-evaluation when facts change.
- Upgraded decisions to a ledger with scope, approval state, decider, and reopen conditions.
- Added Work Package Contracts, exclusive file ownership, and integration responsibilities.
- Added Outcome Ledger for observed results, rework, human friction, incidents, and proposed calibration.
- Preserved a tool-neutral workflow supporting local commits, optional PRs, and staged deliverables.

## Limitations

Risk and complexity scores are interpretable engineering heuristics, not calibrated incident probabilities. Weights and thresholds should be reviewed against real project cases and can only be adjusted under human-controlled policy governance. Completion of this documentation is not evidence of successful real-world agent execution.
