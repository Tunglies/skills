# Performance Experiments

Use for performance comparisons and measurement causality, not every runtime check.
Reuse the measurement tool and authorized environment identified by project
guidance, including a separate tool checkout. Follow the documented ownership
of operation, cleanup and measurement adapters.

## Establish the claim

Name the decision the experiment must inform: locate a mechanism, quantify a
candidate's benefit, or decide whether the benefit justifies the change. A useful
diagnostic result need not demonstrate a product improvement.

Bind the baseline and candidate to actual source, resolved dependencies, build
settings, artifacts and runtime. A copied label or matching HEAD is insufficient
when compiled inputs differ. Use [runtime identity](runtime-identity.md) if the
loaded version is in question. Historical summaries locate evidence; deleted raw
reports cannot be reanalysed, and old results are not current measurements.

State the preserved behavior and the smallest observable check that would detect
doing less required work. Keep inputs, retained state, visible workload, warmup,
measurement windows and observation settings comparable. Different inputs on the
same implementation are a workload contrast, not an optimization A/B.

## Choose the next discriminating check

List only plausible alternative explanations that could change the decision.
Choose the cheapest representative check separating them. Examples include a
frozen display with live input, bounded versus distinct text, or a no-op probe.
Do not systematically run every example or every available profiler.

Validate the smallest path before expanding a matrix: required initialization,
data delivery, attribution, representative output, and owned shutdown. Follow
project rules for native visibility, focus, process ownership and isolation.
A read-only investigation of TUN code is not a live TUN operation.

Treat observation as part of the workload. Keep probe frequency, script and
transport stable between comparable runs. If the observer is a plausible cause,
vary its dose or disable it while retaining an independent observation. Profilers,
debug allocators and instrumentation may explain a mechanism without measuring
ordinary-build benefit. Changing several observation mechanisms together cannot
identify which one caused the difference.

## Compare and stop

Use independent runs as the comparison unit; adjacent samples within one process
are not independent repetitions. Calibrate noise with A/A when needed, balance
execution order and separate setup from measurement. Serialize trials that share
CPU, GPU, caches or native state. Concurrent diagnosis is not a controlled A/B.

Before an expensive run, choose a bounded duration or decision condition and the
result that would refute the hypothesis. Extend only to resolve a named remaining
question. A finite plateau or observed release cycle supports that window and
runtime; it does not prove universal boundedness. An unresolved or no-benefit
result is a valid stopping point.

Reject runs whose identity, workload, observer, visibility or isolation contract
failed. Retain the failure reason; do not loosen acceptance to obtain a result.
If relevant inputs change, rerun the affected comparison, not unrelated checks.

Report absolute baseline/candidate values, independent-run ranges, per-case
paired differences, and flat or negative cases. Do not replace these with a win
percentage or pool unrelated configurations. Distinguish RSS, physical footprint,
retained allocations, CPU time and wall time; reduced counters alone do not prove
faster interactions or a fixed leak. State the strongest supported claim, gaps,
and why further work would or would not change the decision.
