# Git Delivery Workflow

## Readiness Intake

Resolve repository roots and read applicable instructions. Sample branch, HEAD, upstream, divergence, remotes, status, staged and unstaged diffs, untracked paths, and relevant worktrees or submodules.

When IRS is active, consume its candidate phase and readiness lock; it owns review and validation gates. An unstaged review is not final commit readiness. Prepare the staged-delivery candidate when requested, then return control to IRS without reconstructing its gates. Verify any validation ledger revision, worktree fingerprint, and stale conditions. The standalone readiness path is defined below and never invents IRS reviews or approval.

Parse a per-repository action set: inspect readiness, inspect PR, commit, amend, push, create PR, or update PR. Record explicit exclusions. Read-only PR inspection does not authorize push or PR mutation; treat creation, each update, force/rewrite operations, and every network mutation as distinct authorization.

## Index Isolation And Candidate Construction

Before any index mutation, record the original index tree, staged patch, staged paths, and the worktree fingerprint. Derive the authorized candidate as exact patches or hunks relative to its reviewed baseline, including authorized new and generated files. Path names alone are not an exact candidate.

If the original index contains unrelated staged content or a path mixes authorized and unrelated hunks, establish exact isolation before mutation. A temporary-index or exact-patch procedure may be used when its candidate, isolation, restoration, and compatibility with hooks can be verified; prior repository use is not required. If ownership or isolation cannot be established, stop before changing the index. Report the procedure and all index/worktree effects. Never invent broad staging or silently reset, stash, unstage, or absorb user work.

After staging, require the complete index patch/tree to equal the reviewed authorized candidate exactly. Check it against its baseline with `git diff --cached --check` or an equivalent candidate-tree/patch check; plain `git diff --check` cannot validate it. A staged-only failure blocks readiness even when the unstaged diff is clean. Record the candidate phase, tree identity, and worktree fingerprint. If equality or hygiene cannot be proven, restore only through a verified established procedure when authorized; otherwise stop and report the changed state.

With active IRS, return the candidate for its final gates and consume only the resulting readiness lock. Standalone, run proportionate repository-native readiness intake, hygiene, and available evidence checks without claiming IRS review. If required evidence is missing or the state is unsafe, stop. Otherwise establish a local delivery readiness lock over the exact index tree, candidate patch, worktree fingerprint, resolved authorization, evidence, and explicit gaps. Any later change to those fields stales the local lock.

## Exact Local Commit

Commit or amend only the locked staged-delivery candidate under either an IRS readiness lock or a standalone local delivery readiness lock. Immediately before mutation, recheck its index tree, patch, worktree fingerprint, authorization, and evidence against that lock. Later staging, index-tree, hook, generated/dependency, candidate, authorization, or evidence changes stale readiness. Inspect configured hooks and run applicable preparation checks before locking when feasible. The mere possibility of hook mutation is not a blocker to an authorized commit. Do not bypass hooks without authorization. If hooks change the candidate before a failed commit, inspect their effects and rebuild readiness before retrying. After a successful commit, verify its tree against the locked candidate; if it differs, report the mismatch and review the actual result before further delivery. Do not silently amend, reset, or push an unreviewed result. Stop repeated retries when the same unexplained mutation recurs. The expected HEAD advance is the delivery transition, not a different candidate.

For Amend, require explicit rewrite authorization and resolve the exact old commit, normally current HEAD; stop if another target is unsupported. Record its parent, publication state, and complete replacement tree. Apply the same original-index capture, exact isolation, candidate equality, and readiness-lock requirements as Commit. Under active IRS, consume its lock without reconstructing gates. Never absorb unrelated staged work. Report old and new SHA plus consequences for every remote ref.

After any commit operation, verify the resulting commit, tree, parent, included paths, status, branch, and upstream/divergence. A successful local commit is not a push.

## PR Inspection

For Inspect PR, resolve the provider, repository, and exact existing PR. Read its head/base identities, current commits, checks, reviews, conflicts or mergeability when available, and relationship to current IRS/validation readiness. Label provider facts that were not checked or cannot be fetched. Do not push, edit fields, add reviewers, change labels, close, merge, or otherwise mutate the PR or its branches.

## Remote Mutation

For Push, resolve the exact remote and refspec, check divergence and expected remote identity, and use only the authorized update kind. A force update requires explicit force authorization and a lease or equivalent remote-state guard when supported. Verify the remote ref after pushing; report verification failure separately from local state.

At an intermediate source checkpoint, accept only a locked staged-delivery candidate from active IRS or the standalone readiness procedure, perform the recorded separately authorized actions, and verify the resulting source identity is reachable. Report the identity and new worktree fingerprint to `cross-repo-integrator`. Candidate drift returns to the applicable readiness owner for affected gates; missing authorization or reachability blocks this delivery transition. Return control for any independent authorized local work.

For Create PR, resolve repository/provider, head and base, title/body intent, and confirm the head is already reachable without an implicit push. For Update PR, resolve the existing PR and the exact fields authorized to change. Do not alter reviewers, labels, title/body, close state, base, or head unless that specific update was requested. Neither mode authorizes push, merge, checks, review submission, or release. Report inspection, creation, and update separately.

## Delivery Report

For every repository report:

- requested, authorized, completed, failed, and intentionally unperformed actions;
- branch, pre/post HEAD, original index state, exact authorized candidate and staged/committed tree, and hook/generated effects;
- upstream, ahead/behind or unknown divergence, resolved remote/refspec, and verified remote SHA or `not checked`;
- PR identity, inspection result, and separately authorized create/update state when applicable;
- readiness source, stale evidence, blockers, and residual user-owned changes.

Tags, release artifacts, registries, deployments, and publication are outside this skill.
