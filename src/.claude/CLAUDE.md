# Agent Protocol

Christian owns this. Start: say hi + 1 motivating line. Work style: telegraph; noun-phrases ok; drop grammar; min tokens.

- Workspace: `~/Workforge`.
- PRs: use `gh pr view/diff`, not URLs.
- Bugs: add regression test when it makes sense.
- Keep files < ~500 LOC, refactor as needed.
- Commits: [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/).
- Subagents: read `subagents.md`.
- Editor: `code <path>`.
- CI: `gh run list/view` (iterate until green).
- Prefer end-to-end verify; if blocked, say what’s missing.
- New deps: quick health check (recent releases/commits, adoption).
- Web: search early; quote exact errors; prefer sources from within the last year.
- Style: telegraph. Drop filler/grammar. Min tokens (global AGENTS + replies).

## Important Locations

- Repositories: `~/Workforge`.

## PR Feedback

- Active PR: `gh pr view --json number,title,url --jq '"PR #\\(.number): \\(.title)\\n\\(.url)"'`.
- PR comments: `gh pr view …` + `gh api …/comments --paginate`.
- Replies: cite fix + file/line; resolve threads only after fix lands.

## Flow & Runtime

- Use repo’s package manager/runtime; no swaps w/o approval.

## Build / Test
- Before handoff: run full gate (lint/typecheck/tests/docs).
- CI red: `gh run list/view`, rerun, fix, push, repeat until green.
- Keep it observable (logs, panes, tails, MCP/browser tools).

## Git
- Safe by default: `git status/diff/log`. Push only when user asks.
- `git checkout` ok for PR review / explicit request.
- Branch changes require user consent.
- Destructive ops forbidden unless explicit (`reset --hard`, `clean`, `restore`, `rm`, …).
- Don’t delete/rename unexpected stuff; stop + ask.
- No repo-wide S/R scripts; keep edits small/reviewable.
- Avoid manual `git stash`; if Git auto-stashes during pull/rebase, that’s fine (hint, not hard guardrail).
- If user types a command (“pull and push”), that’s consent for that command.
- No amend unless asked.
- Big review: `git --no-pager diff --color=never`.
- Multi-agent: check `git status/diff` before edits; ship small commits.

## Available CLI Tools

The following advanced CLI tools are installed and available:

### File Search & Navigation
- `fd` - faster find alternative
- `fzf` - fuzzy finder
- `tree` - directory visualization

### Code Search & Analysis
- ripgrep (`rg`) - fast code search
- `ast-grep` - structural code search using AST patterns
- `semgrep` - semantic code analysis
- `ctags` - symbol indexing

### Code Understanding
- `tokei` - code statistics
- git-delta (`delta`) - better diff visualization
- difftastic (`difft`) - structural/syntax-aware diffs

### Structured Data
- `jq` - JSON processing
- `yq` - YAML/TOML processing

### Automation & Benchmarking
- `watchexec` - run commands on file changes
- `hyperfine` - command benchmarking

### Network & APIs
- `httpie` - intuitive HTTP client
- `s` - WebSocket debugging

### Service tools
- `gh` - Github client
- `sentry-cli` - Sentry client. Use when being given a https://{subdomain}.sentry.io/issues/{issue-id}/?project={project-id} URL

### Package management
- `uv` - use uv and uvx instead of pip
- `pnpm` - use pnpm instead of npm
- `mise` - use for golang projects
