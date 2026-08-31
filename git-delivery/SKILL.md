---
name: git-delivery
description: Prepare or perform exact Git delivery when the user asks to commit, amend, push, create or update a PR, inspect an existing PR for delivery readiness, or audit readiness for one of those actions. Consumes IRS and validation state without rerunning reviews. Do not implicitly activate for ordinary status, log, branch, ahead/behind, or local-versus-remote queries; tags, publication, and releases are out of scope.
---

# Git Delivery

Turn a ready change into only the Git state transition the user actually authorized.

## Rules

- Parse authorization per action and repository. Commit does not imply push; push does not imply PR; none imply tag, publication, merge, deployment, or release.
- Inspect repository identity, instructions, branch, HEAD, upstream, divergence, remotes, worktrees, submodules if relevant, staged and unstaged paths, and user-owned changes before mutation.
- Before index mutation, record the original index/staged state and derive the exact authorized patch and hunks. Never commit unrelated pre-staged content.
- Construct a staged-delivery candidate only when its complete index patch can equal the reviewed authorized candidate. Do not use broad staging that can absorb unrelated work.
- Inspect the candidate, hook effects, generated changes, and final commit identity. Never report an attempted action as completed.
- Without IRS, establish a local delivery readiness lock only after proportionate repository-native hygiene and evidence checks. Never invent IRS reviews; unsafe state or missing required evidence blocks delivery.
- Amend, history rewrite, branch replacement, force update, remote deletion, and other destructive or network mutations require explicit authorization and a resolved exact target.
- Do not publish releases or tags. Route those to separately authorized release work.

## Choose One Mode

- **Inspect readiness:** Report whether a reviewed change is ready for a specific delivery action and what remains; make no mutations.
- **Inspect PR:** Read one resolved existing PR and report its delivery state without pushing or mutating the PR, branch, reviews, checks, or merge state.
- **Commit:** Prepare the exact candidate and commit only the locked staged-delivery candidate.
- **Amend:** With explicit rewrite authorization, resolve the old commit and parent, prepare its complete replacement candidate, and consume only the applicable readiness lock.
- **Push:** Push only the resolved branch/refspec to the resolved remote under explicit authorization; verify the resulting remote state.
- **Create PR:** Create one resolved PR only with explicit creation authorization; do not push a missing branch or merge it.
- **Update PR:** Mutate only explicitly authorized fields of one resolved existing PR; inspection alone never authorizes an update.

Read [references/workflow.md](references/workflow.md) for readiness intake, per-mode checks, exact staging, and reporting.

## Companion Routing

- IRS owns its gates and readiness lock; this skill prepares the exact candidate and consumes that lock without reconstructing IRS reviews. Standalone, this skill owns a local delivery readiness lock over the exact candidate and evidence. Later candidate or worktree-fingerprint drift stales either lock.
- Consume the current `repo-validate` ledger and its evidence limits. Missing required evidence blocks readiness but does not authorize a fix or weaker check.
- With `cross-repo-integrator`, follow its repository order, perform only recorded authorized actions, and report the verified reachable identity.
- With `dev-handoff`, record each completed and unperformed action plus exact local and remote state.

Companion activation is conditional description matching, not a guaranteed cascade. Work standalone by establishing readiness directly when no companion record exists.

## Completion

Report requested and authorized actions, repository and branch, exact staged paths, commit SHA, hook or generated-file effects, upstream and divergence, local state, verified remote state or that it was not checked, PR state, unperformed actions, and residual blockers. Never collapse local commit, pushed ref, PR, merge, tag, and release into one status.
