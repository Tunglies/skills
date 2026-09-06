---
name: cross-repo-integrator
description: Map or coordinate changes across repositories or an explicit source/consumer dependency edge when revisions, wiring, manifests, locks, or delivery order must stay aligned. Route edits through one IRS workflow. Do not use for ordinary single-repository helper changes, merely reading an external repository, or independent skill folders in one repository; do not infer Git or release authorization.
---

# Cross-Repository Integrator

Keep a multi-repository change coherent from source contract through consumer proof and delivery order.

## Rules

- Record every in-scope repository independently: root, instructions, branch, HEAD, upstream/divergence, dirty paths, allowed scope, and user-owned work.
- Model each dependency edge with source, consumer, contract, current and target identity, wiring type, and required proof.
- Distinguish temporary development wiring from deliverable dependency state. Remove temporary path, link, patch, replace, or local checkout wiring before final delivery unless the user explicitly makes it the deliverable.
- Use a topological implementation and delivery order. Land source before consumer when the changed contract or reachable revision requires it.
- Do not silently bump versions, regenerate locks, rewrite history, commit, push, create PRs, tag, publish, or release.
- Never infer whole-workspace authorization from permission to change one repository.
- Never perform cross-repository edits without an active IRS Canonical Contract, including manifests, lockfiles, generated metadata, config, docs, and wiring. If IRS is unavailable, remain in Map mode and stop at the missing IRS gate.
- Record an intermediate source checkpoint when a consumer requires a newly reachable source identity. Block only the dependent resolution or delivery when authorization or reachability is missing; continue independent authorized local work.

## Choose One Mode

- **Map:** Discover repositories and dependency edges; produce the graph, mismatch findings, order, and stop conditions without editing.
- **Implement:** Coordinate authorized repository, edge, order, and wiring state for the IRS implementation.
- **Resume or deliver:** Revalidate every repository, graph edge, temporary wiring, lock/version mapping, evidence, and authorization before continuing or handing actions to delivery.

Read [references/workflow.md](references/workflow.md) for graph fields, ordering, wiring transitions, and proof requirements.

## Companion Routing

- IRS owns scope, the sole writer, correctness, and simplification. This skill owns repository states, dependency edges, order, and wiring transitions.
- Use `repo-validate` for nontrivial per-repository checks and dependency-edge proof. A passing source test does not prove the consumer resolved or exercised that source.
- Use `git-delivery` only for explicitly requested Git actions. Refresh the graph after it verifies the delivered source identity is reachable.
- Use `dev-handoff` only for durable pause or transfer capture, or resume from an existing durable handoff, so every repository and edge is revalidated.

Companion activation is conditional description matching, not a guaranteed cascade. Do not require the user to manually restate the same goal to each skill.

## Completion

Report the repository table, dependency graph, implementation and delivery order, temporary versus deliverable wiring, source/consumer revision and lock proof, validation per edge, authorization per repository, completed and unperformed delivery actions, and residual mismatches.
