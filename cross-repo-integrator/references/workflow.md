# Cross-Repository Workflow

## Repository And Edge Inventory

For each repository record its root, role, applicable instructions, branch, HEAD, upstream and divergence, dirty paths, allowed files, authorization, and relevant remote identities. Preserve unrelated changes and stop if repository identity or ownership is ambiguous.

For each directed dependency edge record:

- source repository/package/component and consumer;
- changed API, behavior, artifact, schema, or version contract;
- consumer's current source identity and required target identity;
- mechanism: registry version, Git revision/tag, path, link, workspace, patch/replace, generated artifact, vendored copy, or runtime endpoint;
- state: existing deliverable, temporary development wiring, or intended deliverable;
- lockfile, manifest, generated metadata, artifact, and validation proof required.

## Order And Implementation

Build a directed graph and identify cycles or independently deliverable components. Prefer this order when the contract does not require another:

1. Establish source behavior and its stable identity.
2. Validate the source at that identity.
3. Move consumers from temporary wiring to the intended reachable source.
4. Resolve manifests and locks through native tooling, then verify the resolved revision or version.
5. Build or test consumers against that exact state.
6. Deliver source before consumer when consumers depend on a newly reachable commit, tag, version, or artifact.

All repository edits require one active IRS workflow and the same IRS-designated sole writer identity across every repository, sequential source/consumer phase, correction, and resume. This includes manifest, lockfile, generated metadata, config, docs, and wiring edits. If IRS is unavailable or the designated writer cannot continue, complete only the read-only repository and edge map, report the missing gate, and stop before editing. Update the shared contract before changing repository scope or edge behavior.

## Temporary Wiring

Search manifests, locks, workspace configuration, package manager state, and build output for local paths, links, patches, replaces, unpublished versions, or manually copied artifacts. Label them; do not assume a clean diff means installed or resolved dependencies are deliverable.

Before final delivery, replace temporary wiring with the intended reachable identity and prove the consumer actually resolves it. If the source is not yet reachable or authorization does not allow making it reachable, stop at that dependency gate. Do not disguise temporary state with hand-edited lockfiles.

## Proof And Delivery

Proof should bind source commit/version/artifact to the consumer manifest, lock/resolution output, and consumer validation. Record unavailable registry, remote, platform, or build evidence explicitly.

When a consumer needs a newly reachable source identity, record the intermediate checkpoint and target identity in the graph. The IRS workflow owns candidate phase, gates, and the readiness lock; `git-delivery` consumes the locked staged-delivery candidate for separately authorized actions and verifies reachability. After verification, refresh the graph and worktree fingerprint, then continue the consumer with the same IRS-designated sole writer without closing the workflow or repeating unchanged source gates. Stop at the dependency gate when delivery is unauthorized, the candidate changes, or reachability remains unverified.

Commit, amend, push, PR, tag, version bump, publication, and release are distinct actions. Route only explicitly requested Git actions through `git-delivery`; tags, registries, artifacts, and releases remain out of scope until separately authorized.
