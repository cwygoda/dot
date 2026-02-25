---
name: code-reviewer
description: >
  Conduct thorough code reviews. Use when asked to review code, audit code quality,
  provide code feedback, critique code, or analyze code for issues. Outputs structured
  feedback to .claude/feedback/ with descriptive filenames.
---

# Code Reviewer

Perform thorough, structured code reviews with actionable feedback.

## When to Use

- Code review / code feedback
- Code audit or quality check
- PR review or diff analysis
- "Check my code" / "critique this"

## Filename Generation

Create descriptive filename: `{context}-review-{YYYY-MM-DD}.md`

Derive context from (priority order):

1. Primary function/class name being reviewed
2. File name (without extension)
3. Feature/module name
4. PR/branch reference if provided
5. Fallback: "code-review"

Use kebab-case. Add suffix (-01, -02) if file exists.

## Review Criteria

Evaluate against these dimensions, noting specific locations:

- **Correctness:** Logic errors, edge cases, null handling, off-by-one
- **Security:** Injection, auth issues, data exposure, input validation
- **Performance:** Complexity, unnecessary ops, memory leaks, N+1 queries
- **Maintainability:** Naming, function size, coupling, duplication
- **Error Handling:** Exception coverage, messages, recovery
- **Testing:** Coverage gaps, edge cases, mock usage
- **Style:** Consistency, idiomatic patterns

## Output Format

Write to `.claude/feedback/{filename}.md`:

````markdown
# Code Review: {Descriptive Title}

**Reviewed:** {YYYY-MM-DD}
**Files:** {file list}
**Scope:** {what was reviewed}

## Summary
{2-3 sentences: overall quality assessment and key findings}

## Critical Issues
{Must fix: bugs, security vulnerabilities, data loss risks}

### {Issue Title}
**Location:** `{file:line}` or `{function}`
**Problem:** {description}
**Fix:**
```{lang}
{suggested code}
```

## Improvements

{Should fix: performance, maintainability, best practices}

### {Issue Title}

**Location:** `{file:line}`
**Current:**

```{lang}
{existing}
```

**Suggested:**

```{lang}
{improved}
```

**Why:** {rationale}

## Minor/Style

{Nice to have: formatting, naming, minor polish}

- {location}: {suggestion}

## Positive Notes

{Acknowledge good patterns, clever solutions, clean code}

- {observation}

## Action Items

- [ ] {prioritized fix list}

````

## Guidelines

- Be specific with locations and code snippets
- Pair every criticism with a solution
- Prioritize: critical > improvements > style
- Stay objective - critique code, not coder
- Acknowledge what's done well
- Omit sections with no findings (except Summary)

## PR Diff Review Mode

When reviewing a PR or branch diff (not full files), focus only on changed lines:

1. Get the diff:

   ```bash
   # PR diff
   gh pr diff <number> --repo owner/repo
   # Branch diff against base
   git diff main...HEAD
   ```

2. Review only added/modified lines — don't critique unchanged surrounding code
3. Check that removed code doesn't leave dangling references or broken imports
4. Verify new code integrates correctly with unchanged context (read surrounding lines if needed)
5. Use filename format: `pr-{number}-review-{YYYY-MM-DD}.md` or `{branch}-review-{YYYY-MM-DD}.md`
6. Add a **Changes Reviewed** section listing files and hunks covered

Diff-specific review criteria (in addition to standard criteria):

- **Completeness:** Are all necessary files changed? Missing migrations, tests, docs?
- **Atomicity:** Does the diff represent a single logical change?
- **Revert safety:** Could this be cleanly reverted if needed?

## Steps

1. Ensure `.claude/feedback/` exists (create if needed)
2. Determine review mode: full file review or diff-based (PR/branch)
3. Read and understand the code to review
4. Analyze against review criteria
5. Write structured feedback to file
6. Report: filename created, issue counts by severity, top 3 priorities
7. Offer to discuss findings or help implement fixes
