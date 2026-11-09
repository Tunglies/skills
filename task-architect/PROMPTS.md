# Task Architect - Short Invocation Examples

These examples are **invocations, not system prompts**. The complete workflow is already in `SKILL.md`. Do not paste a long instructions template for every task.

## Everyday use: one sentence

```text
$task-architect Refactor Mihomo configuration management, preserve IPC compatibility, and avoid overengineering.
```

The agent chooses the mode from your intent and conversation. This explicit refactoring request selects `execute`, with investigation and applicable risk gates before changes. If you only want a plan, say "Plan this refactor; do not edit." No mode flag is needed.

```text
$task-architect Improve the TUN startup sequence.
```

This broad improvement goal selects read-only `plan` until the intended change is clear. Short requests such as "Fix the failing parser test" can select `execute`; clarity of intent, not length, determines the mode.

## Natural-language routing

```text
$task-architect Trace why system proxy settings are sometimes not restored on Windows.
$task-architect Review the current branch for regressions. Do not edit.
$task-architect Package our approved plan for another engineer.
$task-architect Implement option B within the scope I just approved.
$task-architect Investigate the failing test, then fix it and run the focused check.
```

These select `investigate`, `review`, `handoff`, `execute`, and `execute` respectively. Existing approval is reused; unresolved risk gates still apply. A status question or added constraint does not reset an active task.

## Optional explicit overrides

```text
$task-architect --mode=investigate Trace why system proxy settings are sometimes not restored on Windows.
```

```text
$task-architect --mode=handoff
```

`handoff` uses approved decisions from the available conversation. If that context is missing, request only the minimum missing decisions; never invent prior human approval.

```text
$task-architect --mode=review Check the current branch for cross-platform regressions and unnecessary abstractions.
```

```text
$task-architect --mode=execute Implement option B within the scope I just approved.
```

`execute` expresses intent but does not bypass human gates, missing permissions, or blocking decisions.

## Update decisions without re-invocation

After Task Architect has asked you to choose an approach, you can simply reply:

```text
Windows and macOS must work; Linux support can follow later.
```

Or:

```text
Choose B, but do not add dependencies. Produce the final execution prompt.
```

The agent should update the Requirement Brief and Decision Ledger and re-score only if necessary.

## Sensitive task example

```text
$task-architect Design safer Age private-key storage for our Rust desktop proxy client.
A standalone crate is acceptable, but security and recovery matter more than convenience.
Start by investigating the existing implementation. Do not edit code.
```

Expected: an evidence-backed study, at least an R2 floor for planned key-storage changes, a small number of high-value choices, and an approved implementation handoff only after blocking decisions are answered.

## Tool-specific invocation caveat

`$task-architect` is a convenient example for hosts that support dollar-prefixed skill invocation. Other products may use `/task-architect`, a picker, or explicit loading of `SKILL.md`. The skill's instructions remain the same regardless of how it is loaded. The `--mode=...` suffix is a text convention, not a universal command-line flag.
