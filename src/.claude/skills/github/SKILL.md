---
name: github
description: "Interact with GitHub using the `gh` CLI. Use `gh issue`, `gh pr`, `gh run`, `gh release`, `gh search`, and `gh api` for issues, PRs, CI runs, releases, search, and advanced queries."
---

# GitHub Skill

Use the `gh` CLI to interact with GitHub. Always specify `--repo owner/repo` when not in a git directory.

## Issues

```bash
# List open issues
gh issue list --repo owner/repo

# Create an issue
gh issue create --repo owner/repo --title "Bug: ..." --body "Description"

# Create with labels and assignee
gh issue create --repo owner/repo --title "Feature: ..." \
  --label "enhancement" --assignee "@me" --body "Description"

# View issue details
gh issue view 42 --repo owner/repo

# Close an issue
gh issue close 42 --repo owner/repo

# Reopen
gh issue reopen 42 --repo owner/repo

# Add comment
gh issue comment 42 --repo owner/repo --body "Update: ..."

# Edit labels/assignees
gh issue edit 42 --repo owner/repo --add-label "bug" --add-assignee "user"

# Filter by label, author, milestone
gh issue list --repo owner/repo --label "bug" --author "@me" --milestone "v2.0"
```

## Pull Requests

```bash
# Create PR from current branch
gh pr create --title "feat: add widget" --body "Description"

# Create draft PR
gh pr create --title "wip: new feature" --body "Description" --draft

# Create PR targeting specific base branch
gh pr create --base develop --title "fix: typo" --body "Description"

# List open PRs
gh pr list --repo owner/repo

# View PR details
gh pr view 55 --repo owner/repo

# View PR diff
gh pr diff 55 --repo owner/repo

# Review PR
gh pr review 55 --repo owner/repo --approve
gh pr review 55 --repo owner/repo --request-changes --body "Fix X"
gh pr review 55 --repo owner/repo --comment --body "Looks good but..."

# Merge PR
gh pr merge 55 --repo owner/repo --squash --delete-branch

# Check CI status on a PR
gh pr checks 55 --repo owner/repo

# Add labels / reviewers
gh pr edit 55 --repo owner/repo --add-label "ready" --add-reviewer "user"
```

## CI / Workflow Runs

```bash
# List recent workflow runs
gh run list --repo owner/repo --limit 10

# Filter by workflow name or branch
gh run list --repo owner/repo --workflow "CI" --branch main

# View a run and see which steps failed
gh run view <run-id> --repo owner/repo

# View logs for failed steps only
gh run view <run-id> --repo owner/repo --log-failed

# Re-run failed jobs
gh run rerun <run-id> --repo owner/repo --failed

# Watch a run in progress
gh run watch <run-id> --repo owner/repo
```

## Releases

```bash
# List releases
gh release list --repo owner/repo

# Create release from tag
gh release create v1.0.0 --repo owner/repo --title "v1.0.0" --notes "Release notes"

# Create release with auto-generated notes
gh release create v1.0.0 --repo owner/repo --generate-notes

# Create draft release
gh release create v1.0.0 --repo owner/repo --draft --generate-notes

# Upload assets to a release
gh release upload v1.0.0 ./dist/*.tar.gz --repo owner/repo

# View release
gh release view v1.0.0 --repo owner/repo

# Delete release
gh release delete v1.0.0 --repo owner/repo
```

## Search

```bash
# Search issues/PRs across repos
gh search issues "memory leak" --repo owner/repo
gh search prs "refactor" --repo owner/repo --state open

# Search code
gh search code "TODO FIXME" --repo owner/repo

# Search repos
gh search repos "language:rust stars:>100"
```

## Labels & Milestones

```bash
# List labels
gh label list --repo owner/repo

# Create label
gh label create "priority:high" --repo owner/repo --color "FF0000" --description "High priority"

# Edit label
gh label edit "bug" --repo owner/repo --color "CC0000"

# Delete label
gh label delete "stale" --repo owner/repo --yes

# List milestones (via API)
gh api repos/owner/repo/milestones --jq '.[].title'

# Create milestone (via API)
gh api repos/owner/repo/milestones -f title="v2.0" -f due_on="2026-06-01T00:00:00Z"
```

## Repo Management

```bash
# Clone
gh repo clone owner/repo

# Fork
gh repo fork owner/repo --clone

# View repo info
gh repo view owner/repo

# Create repo
gh repo create my-project --public --clone

# Sync fork with upstream
gh repo sync owner/fork
```

## API for Advanced Queries

The `gh api` command covers anything not available through subcommands.

```bash
# Get PR with specific fields
gh api repos/owner/repo/pulls/55 --jq '.title, .state, .user.login'

# List PR review comments
gh api repos/owner/repo/pulls/55/comments --jq '.[].body'

# Paginate results
gh api repos/owner/repo/issues --paginate --jq '.[].title'

# GraphQL query
gh api graphql -f query='{ viewer { login } }'
```

## JSON Output

Most commands support `--json` for structured output. Use `--jq` to filter:

```bash
gh issue list --repo owner/repo --json number,title --jq '.[] | "\(.number): \(.title)"'
gh pr list --repo owner/repo --json number,title,state --jq '.[] | select(.state=="OPEN")'
```
