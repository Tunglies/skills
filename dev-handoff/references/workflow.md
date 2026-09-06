# Handoff Workflow

## Record Identity And Location

Prefer a user-provided path or an existing repository-independent convention. Otherwise place a stable task-named record under `${CODEX_HOME:-$HOME/.codex}/handoffs`; do not add a handoff file to a worktree unless the user asks for a repository artifact.

Before writing, inspect the candidate record. Reuse it only when repository roots, task identity, and goal match. If identity is ambiguous or the path belongs to another task, create a distinct name. Preserve prior observations with timestamps or a short history instead of replacing unrelated content.

Use **worktree fingerprint** to mean HEAD plus content digests for the staged diff, unstaged diff, relevant untracked contents, and relevant dependency, lock, resolution, and generated state. Path names alone are insufficient. If relevant content cannot be read or fingerprinted, mark the fingerprint incomplete; it cannot support an unchanged or current-state claim. The same HEAD and path set with different content is a different fingerprint and stales a handoff bound to the prior fingerprint.

## Canonical Record

Record only applicable fields:

- identity, status (`active` or `closed`), capture time, owner or intended recipient if known;
- every repository root, branch, HEAD, worktree fingerprint and completeness, dirty paths, upstream, ahead/behind or unknown divergence, and remotes relevant to delivery;
- active authorization and explicit exclusions;
- goal, non-goals, allowed scope, behavior boundary, open decisions, and user-owned changes;
- active IRS contract identity, mode, gate, completed gates, findings and dispositions, writer continuity, and diff budget;
- validation ledger revision, commands, results, evidence class, gaps, and stale conditions;
- repository/dependency graph, delivery order, version or revision mapping, locks, and temporary wiring;
- delivery requests and results, including original index state, candidate phase, staged-delivery candidate tree identity, readiness lock, worktree fingerprint, commit SHA, upstream, local/remote state, and unperformed actions;
- risks, unknowns, blockers, exact next action, next gate, and stop condition.

Do not duplicate large diffs or logs when a stable path and revision-bound digest is enough. Never store secrets or tokens.

## Capture

When durable capture is requested or needed, a pause or stop is an interrupt path: capture immediately after the current atomic action or safe observation at any gate. Do not wait for technical close or Git delivery, and record partially completed gates as partial rather than passed. Ordinary same-turn continuation and non-durable pauses do not create or update a handoff.

1. Discover all in-scope repositories and read their instructions.
2. Sample Git state and the worktree fingerprint; label incomplete fingerprints and unavailable remote or external facts as unknown.
3. Merge current IRS and companion records by reference, preserving their ownership and evidence limits.
4. Write the matching handoff record atomically when practical, then read it back and report its path.

## Resume

1. Resolve the record by explicit path or task/repository identity. Do not guess between multiple plausible records.
2. Re-sample repository roots, branches, HEADs, worktree fingerprints, upstreams, divergence, dirty paths, dependencies, validation evidence, and delivery state.
3. Compare record versus live state field by field. Classify differences as expected progress, stale evidence, conflicting work, unavailable fact, or harmless metadata drift.
4. Update the active IRS Canonical Contract when present. Resume at the earliest gate invalidated by diff, revision, evidence, or authorization drift; do not repeat unchanged gates.
5. Reconcile drift with the live request and existing authorization. Continue expected in-scope progress; ask only when conflicting work, ambiguous task identity, or a change outside the authorized outcome prevents a safe next action. Explain the missing fact and impact, and continue independent authorized work.

Preserve the original goal and unfinished actions when incorporating a new constraint or status question. A request to resume authorized work continues beyond this record update; a request only to inspect drift remains read-only.

## Close

Re-sample final state, record delivered and undelivered outcomes separately, retain residual risks and follow-ups, and mark the record closed. Closing never implies that a local commit was pushed, a PR was merged, or a release was published.
