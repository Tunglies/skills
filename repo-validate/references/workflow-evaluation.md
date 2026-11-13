# Agent Workflow Evaluation

Use only when comparing skills, instructions or execution workflows is requested.
Ordinary documentation edits need proportionate document checks, not this method.

## Freeze the comparison

Start from current behavior, including improvements already delivered. Compare
that baseline with the smallest change; add a new skill variant only if packaging
or discovery is an unresolved cause. Do not credit an old improvement again.

Choose a few independent tasks adapted from actual work, including success,
failure and no-benefit cases. When skill selection or invocation is part of the
comparison, include natural-language discovery, explicit invocation and tasks
that should not trigger it. Reserve a task that did not guide the change.
Repetitions are not additional independent tasks.

Freeze prompts, allowed actions/files, preserved behavior, checks and scoring
before execution. Give executors raw task evidence, not expected answers. Mark
synthetic defects or reports as fixtures. Score behavior and artifacts, not exact
wording, rule recitation or document length. A read-only TUN question should not
require approval for a TUN mutation; a real mutation still needs its own authority.

Fix model, effort, CLI version, tools, permissions, dependencies and task inputs.
When skill discovery is under comparison, probe the actual catalog: disable
duplicate installed variants for the child process and expose one neutral local copy.
Explicit invocation may inject a body
without a file read, so absence of a `cat` is not proof the skill was unused.

Prepare independent workspaces and dependencies before timing. For repair tasks,
verify that the defective baseline fails and a reference repair passes the frozen checks. Use
already installed executables; an automatic install contaminates task timing.
Freeze and give executors the verified command entrypoints when installation is
forbidden. A working direct executable does not prove that a package-manager
wrapper will avoid dependency preparation.
Keep evaluator checks outside the executor's task, protect their input files,
and do not share mutable build caches between concurrent trials.

## Run and judge

Use a prepared workspace per trial and keep results outside executor workspaces.
Reuse an existing evaluator where possible; place task-specific tooling outside
repositories unless adding a maintained tool is part of the requested change.
Inspect executable commands against existing authorization. Sandbox settings do
not replace transcript review.

Balance paired execution order before freezing it. Record setup/check time
separately from model time, raw traces, file changes, HEAD/index drift and protected
input drift. Treat timeouts, modified checks and scope violations as failures or
invalid trials, never passing samples. Mechanical checks do not replace quality
grading. Missing token usage is unknown, not zero. Inspect traces for installs,
forbidden operations, hidden answer access and unrecorded external changes before
accepting comparisons. Clean up only processes owned by the trial.

For blind grading, prepare anonymous task/output/diff/check bundles without
variant labels, instruction text, timing or token totals. Have an independent
reviewer apply the frozen rubric before revealing identities. Grade routing from
normalized traces separately if skill paths would reveal the variant. Report
what was blinded; this alone is not a double-blind study.

## Decide whether to retain the change

Report each pair's quality, preservation failures, extra work, tool calls, human
interventions, elapsed time and input/cached-input/output tokens. Keep setup cost,
timeouts, excluded contaminated trials and exclusion reasons visible. Do not pool
tasks to hide a regression or equate cached input reduction with monetary savings.

Reject critical behavior or authority regressions regardless of efficiency.
Both versions succeeding can be a no-benefit result. If a shared tool or existing
entry performs equally well, do not add a skill merely to package it. Stop at the
planned sample bound unless a concrete invalid trial or unresolved decision
justifies more work. Archive enough authorized evidence to reproduce the result;
after requested cleanup, report deleted artifacts as unavailable.
