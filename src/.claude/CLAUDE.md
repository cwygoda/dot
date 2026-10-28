# Agent Protocol

Christian owns this. Start: say hi + 1 motivating line. Work style: telegraph; noun-phrases ok; drop grammar; min tokens.

- Workspace: `~/Workforge`.
- PRs: use `gh pr view/diff`, not URLs.
- Bugs: add regression test when it makes sense.
- Keep files < ~500 LOC, refactor as needed.
- Commits: [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/).
- Editor: `code <path>`.
- CI: `gh run list/view` (iterate until green).
- Prefer end-to-end verify; if blocked, say what’s missing.
- New deps: quick health check (using the current release? adoption?).
- Web: search early; quote exact errors; prefer sources from within the last year.
- Style: telegraph. Drop filler/grammar. Min tokens (global AGENTS + replies).

# Workflow Orchestration

1. Plan mode by default
   - plan mode for ANY non-trivial task (3+ steps or architectural decisions)
   - if something goes sideways, STOP and re-plan immediately
   - use plan mode for verification steps, not just building
   - write detailed specs upfront to reduce ambiguity
   - use the /interview command to scrutinise the spec details
   - Break down SPEC into tasks in ".tasks/todo.md"
2. Subagent Strategy
   - use subagents liberally to keep main context window clean
   - offload research, exploration, and parallel analysis to subagents
   - for complex problems, throw more compute at it via subagents
   - one task per subagent for focused execution
3. Self-Improvement Loop
   - after ANY correction from the user: update '.tasks/lessons.md' with the pattern
   - write rules for yourself that prevent the same mistake
   - ruthlessly iterate on these lessons until mistake rate drops
   - review lessons at session start for relevant project
4. Verification Before Done
   - never mark a task complete without proving it works
   - use the Always Works™ skill
5. Demand Elegance (Balanced)
   - for non-trivial changes: pause and ask "is there a more elegant way?"
   - ff a fix feels hacky: "Knowing everything I know now, implement the elegant solution"
   - skip this for simple, obvious fixes - don't over-engineer
   - challenge your own work before presenting it
6. Autonomous Bug Fixing
   - when given a bug report: just fix it. Don't ask for hand-holding
   - point at logs, errors, failing tests - then resolve them
   - zero context switching required from the user
   - go fix failing CI tests without being told how

# Task Management

1. ﻿**Plan First**: Write plan to ".tasks/todo.md" with checkable items
2. ﻿**Verify Plan**: Check in before starting implementation
3. ﻿**Track Progress**: Mark items complete as you go
4. ﻿**Explain Changes**: High-level summary at each step
5. ﻿**Document Results**: Add review section to ".tasks/todo.md*
6. ﻿**Capture Lessons**: Update ".tasks/lessons.md' after corrections

## Core Principles

- **Simplicity First**: Make every change as simple as possible. Impact minimal code.
- **No Laziness**: Find root causes. No temporary fixes. Senior developer standards.
- **Minimal Impact**: Changes should only touch what's necessary. Avoid introducing bugs.

# Code Quality Standards

## LOC
- File: < 500; split at natural seams
- Function: < 30; if scrolling, extract
- PR: < 400 changed lines

## Naming
- Variables: noun phrases describing *what it holds* (`usersByEmail`, not `map`)
- Booleans: `is/has/can/should` prefix (`isLoading`, `hasPermission`)
- Functions: verb phrases describing effect/return (`fetchUser`, `isExpired`)
- No abbreviations unless universal (`id`, `url`, `ctx`, `err`); no single letters except loop indices
- Length proportional to scope
- No Hungarian notation / type suffixes

## Complexity
- Cyclomatic complexity ≤ 10; > 15 = refactor required
- Nesting depth: max 3; use early returns / guard clauses
- Ternaries: single condition only; nested → extract
- Boolean expressions: max 3 operands; extract named variable for compound conditions

## Function Design
- One level of abstraction per function
- Max 3–4 parameters; beyond that → struct/object
- No boolean flag parameters → two functions
- Command–Query Separation: do OR return, not both
- No side effects in query-named functions

## Structure
- Co-locate by feature, not by type
- Dependency direction: high-level → low-level only
- Magic numbers/strings: always named constants
- Delete dead code; git history exists

## Readability
- Positive conditions first (`if isValid` not `if !isInvalid`)
- Fail fast: validate early, happy path runs straight through
- Comments explain *why*, not *what*; good names beat comments
- Consistent abstraction level within a file

## Maintainability
- Explicit > implicit
- Parse don't validate: transform to rich types at boundary
- Error messages: actionable with context (`"failed to fetch user id=42: ..."`)
- No stringly-typed state; enums/sum types over strings
- Dependency injection over global state

## Observability

### Logging
- Structured always: key-value pairs, never interpolated strings (`log.info("user created", user_id=42)`)
- One logger per module/component; injected, not global
- Levels: `DEBUG` local dev only; `INFO` lifecycle events; `WARN` recoverable anomalies; `ERROR` actionable failures
- Every log line: `service`, `trace_id`, `span_id` — correlate across systems
- Log at boundaries: entry/exit of external calls, not internal hops
- No secrets, PII, or tokens in logs — ever
- Errors: log once at the handler; don't re-log as you propagate up the stack

### Tracing
- Instrument at I/O boundaries: HTTP, DB, queue, cache, external APIs
- Span names: `verb.noun` (`db.query`, `http.post`, `queue.publish`)
- Span attributes: request params, resource IDs, outcome — enough to reproduce the call
- Propagate context (W3C `traceparent`) across service boundaries; never start a new root span mid-flow
- Mark span status explicitly: OK / ERROR; attach error message on failure
- Avoid high-cardinality span names (no user IDs in the name itself → put them in attributes)

### Metrics
- Three golden signals minimum per service: latency (p50/p95/p99), error rate, throughput
- Naming: `namespace_subsystem_unit_suffix` (`http_server_request_duration_seconds`)
- Labels/tags: low cardinality only (status code, method, endpoint pattern — not user IDs); each unique combo = a new time series in Prometheus-style backends
- Histograms over averages for latency; averages lie
- Counters: always monotonic; use rates in dashboards
- Emit business metrics alongside infra metrics (`orders_placed_total`, `payments_failed_total`)
- SLO-aligned alerts only; avoid alert fatigue from non-actionable thresholds
- Exemplars: attach `trace_id` to histogram samples — bridges low-cardinality metrics to high-cardinality traces

### High Cardinality (traces + logs)
- Traces and logs *should* be high cardinality — `user_id`, `order_id`, `session_id` in span attributes and log fields is how you answer "why is this one customer broken"
- Mental model: metrics = *what* is broken at scale; traces/logs = *why*, *where*, *who*
- Modern backends (Honeycomb, Grafana Tempo, Loki, ClickHouse) handle high-cardinality fields natively — don't artificially limit them
- Rule of thumb: if you'd want to filter by it in an incident, it belongs in traces/logs as a field
