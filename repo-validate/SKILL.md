---
name: repo-validate
description: Build or audit revision-bound validation evidence. Activate implicitly for nontrivial changes involving multiple evidence layers, generated state, cross-module or dependency contracts, native runtime, platform or device behavior, CI conditions, or substantive failure attribution. Explicit $repo-validate invocation also supports focused validation standalone or alongside IRS; do not implicitly activate for ordinary focused tests, simple checks, or generic verification.
---

# Repository Validation

Select and report the smallest credible validation set for the actual change and its risk.

## Rules

- Discover repository instructions, manifests, native scripts, workflow conditions, the current diff, and affected contracts before choosing checks.
- Bind every result to the tested revision, candidate tree, worktree fingerprint, and relevant environment. A result becomes stale when one changes, and an incomplete fingerprint cannot support current confidence. The sole exception is rebinding a locked staged-delivery candidate to its authorized commit when the resulting commit tree is exactly identical.
- Classify evidence as static, unit, integration, runtime, platform, device, or production. Never promote one class into another.
- Classify failures as introduced, pre-existing, environment, or unknown only when evidence supports the label.
- Validation findings do not authorize fixes. Do not edit source, delete artifacts, change dependencies, or weaken checks to obtain a pass.
- Report skipped, unavailable, flaky, and unperformed checks as gaps rather than passes.
- Keep the ledger in the response or active IRS contract by default. Do not create or modify a ledger file unless the user explicitly authorizes a durable path.

## Choose One Mode

- **Plan:** Discover the change surface and produce a proportionate command/evidence matrix without running checks.
- **Run:** Plan as needed, execute authorized repository-native checks, inspect their side effects, and record the validation ledger in the response or active contract.
- **Audit:** Evaluate existing evidence for revision match, command fidelity, coverage, classification, and unsupported claims; rerun only when requested or already authorized.

Read [references/workflow.md](references/workflow.md) for selection, failure classification, and the ledger schema.

## Companion Routing

- When IRS is active, its Canonical Contract is authoritative. Explicit `$repo-validate` invocation runs this companion even for a focused or simple check; the nontrivial threshold applies only to implicit selection. Add the validation plan, ledger revision, failures, gaps, and stale conditions; return accepted code blockers to the IRS-designated sole writer rather than editing. Explicit invocation does not expand authorization or weaken safety gates.
- Use this companion from IRS when validation is nontrivial: multiple layers, generated artifacts, cross-module contracts, native runtime, platform/device evidence, CI condition interpretation, or meaningful failure attribution. Keep simple checks inside IRS to avoid fan-out.
- With `cross-repo-integrator`, create a ledger entry per repository and bind dependency/version proof to the graph edge it validates.
- With `git-delivery`, expose readiness and gaps but do not authorize commit, push, PR, tag, or release actions.
- With `dev-handoff`, preserve the ledger revision and exact stale conditions for resume.

Companion activation is conditional description matching, not a guaranteed cascade. Work standalone when no IRS contract exists.

## Completion

Report tested repository state, selected and omitted checks with reasons, commands and outcomes, evidence classes, failure attribution, side effects, stale conditions, residual gaps, and the strongest claim the evidence actually supports.
