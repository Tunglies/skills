---
name: dev-handoff
description: Capture, resume, transfer, or close durable development handoffs when a coding task crosses sessions or people, the user requests durable pause/stop state, or work continues from an existing handoff. Revalidates repository drift and enriches an active IRS contract without implementing, reviewing, validating, committing, or pushing. Do not use for ordinary same-turn continuation or a pause with no durable-state need.
---

# Development Handoff

Preserve enough revision-bound state that the next worker can continue at the first stale or incomplete gate without reconstructing the task.

## Rules

- Treat the handoff as coordination state, not authorization to edit, fix, commit, push, publish, or contact external systems.
- Re-read live repository state before trusting a record. Mark drift explicitly; never silently rewrite historical evidence to match current state.
- Keep handoff records outside worktrees by default. Prefer a user path or established convention; otherwise use `${CODEX_HOME:-$HOME/.codex}/handoffs`.
- Read before writing. Update only the record that unambiguously belongs to this task; create a distinct record on collision and never overwrite unrelated state.
- Preserve the user's dirty work. Closing archives or marks a record closed; it does not delete repositories, branches, worktrees, or task artifacts.
- When durable capture is requested or needed, a pause or stop may Capture immediately at any IRS gate. A non-durable pause does not create a handoff.

## Choose One Mode

- **Capture:** Immediately snapshot a durably paused, stopped, or transferred task at its current gate after sampling its state.
- **Resume:** Load a matching durable record, revalidate every repository and external fact that can drift, and continue from the earliest stale or incomplete gate.
- **Close:** Revalidate final state, record the outcome and residual work, then mark the record closed without deleting its history.

Read [references/workflow.md](references/workflow.md) for the record schema, drift procedure, and mode details.

## Companion Routing

One user request is enough; do not require the user to invoke companion skills separately.

- If an IRS workflow is active, its Canonical Contract remains authoritative. If a resumed record contains an active IRS contract or pending IRS gate, resume that workflow with the same IRS-designated sole writer identity; never silently substitute another writer. Add durable record identity, drift, gate/findings, evidence pointers, and the next gate; do not create a parallel plan or review loop.
- If validation evidence is present, preserve the `repo-validate` ledger revision and limits rather than upgrading its claims.
- If multiple repositories or dependency edges are present, preserve the `cross-repo-integrator` graph, order, and temporary wiring state.
- If delivery is requested or completed, preserve the `git-delivery` authorization and local/remote state separately.

Companion activation is conditional description matching, not a guaranteed cascade. When a companion is unavailable, capture its minimal relevant state without claiming that skill ran.

## Completion

Return the record path and identity, sampled revisions, drift, active authorization, completed and stale gates, risks or unknowns, exact next action, next gate, and stop condition. On Resume, distinguish record-derived facts from facts revalidated now.
