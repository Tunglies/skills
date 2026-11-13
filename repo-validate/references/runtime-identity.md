# Source, Artifact, And Runtime Identity

Use when the question is whether a particular implementation reached a consumer,
package or running instance. Read-only inspection does not authorize a rebuild,
installation, service restart, system update or credential access.

Follow the actual relationship, checking only edges needed for the claim:

| Boundary | Useful evidence | What it does not establish |
| --- | --- | --- |
| Source | Exact commit/tag and implementation; upstream default branch or recent fix when relevant | Consumer uses it |
| Resolution | Manifest plus lock, resolved graph and active path/patch/replace wiring | It was compiled into this artifact |
| Build | Actual compiler inputs, features, target, toolchain and dependency artifacts | Package contains that output |
| Package | Final executable/resource hashes matched to build output; embedded metadata or symbols as corroboration | Signature, launch or behavior passed |
| Runtime | Process executable and start identity, loaded module paths/version/build IDs, or trustworthy runtime version endpoint | Every relevant path exercised the fix |
| Behavior | Target instance exercises the affected path under recorded conditions | Other platforms or instances passed |

Build an evidence graph, not an assumed universal chain. A system framework can
be supplied by the OS independently of the application's dependency lock or SDK.
A separately installed runtime or sibling checkout need not affect the active
process. Inspect loaded identity before attributing behavior to a new version.

Use mutually supporting evidence appropriate to the artifact. Source strings in
a binary can corroborate a build, but their absence is not proof of exclusion
after stripping or optimization. A branch label, configured path, successful
download or build exit code alone does not prove loaded identity. Record partial
success explicitly, such as a built app whose signing step failed.

Check the consumer's pinned version and relevant upstream current implementation
before proposing a duplicate fix. If access or version mapping is unavailable,
leave that edge unknown; do not substitute the local checkout or latest upstream.

Return the shortest supported chain, mismatches, unknown edges and the next
authorized observation. Use `cross-repo-integrator` only when aligned repository
changes or dependency wiring/order are actually needed. Keep its graph and this
validation record linked rather than maintaining competing inventories.
