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
