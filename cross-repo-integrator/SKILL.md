---
name: cross-repo-integrator
description: Coordinate source and consumer revisions, dependency wiring, validation, and delivery order across repositories or a dependency edge. Excludes independent folders in one repository and merely reading external code.
---

# Cross-Repository Integrator

Keep a multi-repository change coherent from source contract through consumer proof and delivery order.

## Authority and scope

Follow the current user request over this skill’s workflow defaults, within system, developer, and tool constraints. Reuse established authorization; ask only for a material unresolved decision. If a skill instruction actually blocks progress, cite that instruction and explain the concrete missing prerequisite while continuing independent authorized work.

## Rules

- Record every in-scope repository independently: root, instructions, branch, HEAD, upstream/divergence, dirty paths, allowed scope, and user-owned work.
- Model each dependency edge with source, consumer, contract, current and target identity, wiring type, and required proof.
- Distinguish temporary development wiring from deliverable dependency state. Remove temporary path, link, patch, replace, or local checkout wiring before final delivery unless the user explicitly makes it the deliverable.
- Use a topological implementation and delivery order. Land source before consumer when the changed contract or reachable revision requires it.
- Regenerate manifests and locks when necessary for the authorized dependency update, inspect the result, and explain version changes. Do not infer authorization for history rewrites, commits, pushes, PRs, tags, publication, or release.
- Never infer whole-workspace authorization from permission to change one repository.
- Use one coordinated contract and designated writer for dependent edits. Use IRS when available for its independent review workflow. If unavailable, retain scope, ownership, graph, and evidence directly; continue authorized implementation and disclose missing reviews. If the user explicitly requires IRS gates, do not claim readiness until those gates are satisfied.
- Record an intermediate source checkpoint when a consumer requires a newly reachable source identity. Block only the dependent resolution or delivery when authorization or reachability is missing; continue independent authorized local work.

## Choose One Mode

- **Map:** Discover repositories and dependency edges; produce the graph, mismatch findings, order, and stop conditions without editing.
- **Implement:** Coordinate authorized repository, edge, order, and wiring state for the designated implementation owner.
- **Resume or deliver:** Revalidate every repository, graph edge, temporary wiring, lock/version mapping, evidence, and authorization before continuing or handing actions to delivery.

Read [references/workflow.md](references/workflow.md) for graph fields, ordering, wiring transitions, and proof requirements.

## Companion Routing

- When active, IRS owns scope, the sole writer, correctness, and simplification. Otherwise retain those coordination fields directly, disclosing missing independent review. This skill owns repository states, dependency edges, order, and wiring transitions.
- Use `repo-validate` for nontrivial per-repository checks and dependency-edge proof. A passing source test does not prove the consumer resolved or exercised that source.
- Use `git-delivery` only for explicitly requested Git actions. Refresh the graph after it verifies the delivered source identity is reachable.
- Use `dev-handoff` only for durable pause or transfer capture, or resume from an existing durable handoff, so every repository and edge is revalidated.

Companion activation is conditional description matching, not a guaranteed cascade. Do not require the user to manually restate the same goal to each skill.

## Completion

Report the repository table, dependency graph, implementation and delivery order, temporary versus deliverable wiring, source/consumer revision and lock proof, validation per edge, authorization per repository, completed and unperformed delivery actions, and residual mismatches.
