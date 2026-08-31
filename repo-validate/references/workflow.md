# Validation Workflow

## Discovery

Read applicable repository instructions and inspect the current revision, dirty paths, diff, manifests, test configuration, package or build scripts, generated-file rules, and relevant CI workflow conditions. Search callers and cross-module contracts when the diff alone understates impact.

Use **worktree fingerprint** to mean HEAD plus content digests for the staged diff, unstaged diff, relevant untracked contents, and relevant dependency, lock, resolution, and generated state. Path names alone are insufficient. If relevant content cannot be read or fingerprinted, mark the fingerprint incomplete; it cannot support an unchanged or current-evidence claim. The same HEAD and path set with different content is a different fingerprint and stales evidence bound to the prior fingerprint.

Do not treat a CI job name as evidence that its commands ran. Account for path filters, matrices, feature flags, platform guards, skipped tests, caches, and conditional steps.

## Proportionate Selection

Choose checks based on changed behavior and blast radius:

- **Static:** formatting, parsing, lint, type checking, compile-only checks, schema validation, and diff hygiene.
- **Unit:** isolated behavior at a function, module, or package boundary.
- **Integration:** interactions across modules, processes, services, packages, or dependency edges.
- **Runtime:** an executing application or service exercising the changed path.
- **Platform:** the relevant native OS, architecture, packaging, lifecycle, or system integration.
- **Device:** real hardware, simulator, browser engine, network, or other target-specific execution when it is part of the claim.
- **Production:** observation from the actual deployed environment under an authorized procedure.

Run narrow checks first when they give fast diagnostic value, then broader checks needed by the contract. Repository-native commands and established fixtures take precedence over invented harnesses. Performance claims require controlled measurements against a relevant baseline, not code shape alone.

Diff hygiene follows the candidate phase. For a staged-delivery candidate, check the exact staged patch against its recorded baseline with `git diff --cached --check` or an equivalent locked candidate-tree/patch check. Plain `git diff --check` covers unstaged changes and cannot prove staged-candidate hygiene. For a working candidate, check each applicable component separately: staged changes, unstaged changes, and relevant untracked contents. Do not let unrelated unstaged work substitute for the candidate or report unchecked components as clean.

Before commands likely to generate files or alter an installation, record the worktree fingerprint. Fingerprint again afterward and report side effects; do not clean or revert user files without authorization.

When final commit readiness is requested, bind validation to the staged-delivery candidate tree produced before final IRS gates. Record whether each command actually exercised that candidate. If unstaged or external state can affect the result but is outside the candidate, the evidence is not final delivery proof. After an authorized commit, rebind that evidence to the new commit without rerunning only when the commit tree exactly equals the locked staged-delivery candidate tree and relevant environment is unchanged; this expected transition is not a general revision-drift exception.

## Failure Classification

- **Introduced:** Reproduces on the current change and credible baseline or isolation evidence shows the change causes it.
- **Pre-existing:** Reproduces on an appropriate unchanged baseline under comparable conditions.
- **Environment:** Evidence identifies a missing tool, permission, service, credential, platform, network, capacity, or other external prerequisite.
- **Unknown:** Available evidence cannot distinguish the above.

Do not switch baselines, patch code, install unrequested dependencies, or relax checks merely to classify a failure. Under an active IRS implementation, submit the finding for disposition; only its already-authorized IRS-designated sole writer may apply an accepted in-scope fix.

## Revision-Bound Ledger

The ledger is an in-response or active-contract record by default. A request to run, validate, or audit does not authorize creating a ledger file. Persist it only when the user explicitly requests or authorizes a resolved durable path; never choose a worktree path implicitly.

For each repository record:

- root, branch, HEAD, candidate tree identity, worktree fingerprint and completeness, dirty paths, and relevant environment;
- contract behavior or risk addressed;
- exact command or manual procedure, start/end state, result, and exit status when applicable;
- evidence class and the strongest supported claim;
- failure class with supporting comparison, or `unknown`;
- skipped or unavailable checks and why;
- artifacts or side effects created;
- stale conditions and required rerun scope.

Audit existing evidence against these fields. Except for an exact locked-candidate-to-commit-tree rebind, a green command on another revision, a different fingerprint, or an incomplete fingerprint is historical context, not current proof.
