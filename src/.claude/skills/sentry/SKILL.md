---
name: sentry
description: "Interact with Sentry using `sentry-cli`. Use for releases, source maps, debug symbols, deploys, cron monitors, and event management. Trigger on any Sentry workflow, source map upload, release management, or crash symbolication task."
---

# Sentry CLI Skill

Use `sentry-cli` for Sentry automation. Set `SENTRY_ORG` and `SENTRY_PROJECT` env vars or pass `--org` / `--project` flags.

## Config & Auth

```bash
# Interactive login — opens browser, writes .sentryclirc
sentry-cli login

# Check current config/auth
sentry-cli info

# Key env vars (CI/CD)
# SENTRY_AUTH_TOKEN   — org-scoped auth token (sntrys_...)
# SENTRY_DSN          — only for send-event / send-envelope
# SENTRY_ORG          — default org slug
# SENTRY_PROJECT      — default project slug
# SENTRY_URL          — self-hosted URL (default: https://sentry.io/)
# SENTRY_LOG_LEVEL    — debug, info, warn, error, fatal
# SENTRY_RELEASE      — override release name
```

`.sentryclirc` (INI format, project root or `~/.sentryclirc`):

```ini
[defaults]
url = https://sentry.io/
org = my-org
project = my-project

[auth]
token = sntrys_xxx...
```

Resolution order: `~/.sentryclirc` → `.sentryclirc` → env vars → CLI flags.

## Orgs & Projects

```bash
sentry-cli organizations list
sentry-cli projects list
sentry-cli repos list
```

## Releases

```bash
# Auto-detect version from git
sentry-cli releases propose-version

# Create release
sentry-cli releases new 1.0.0

# Associate commits (auto from git history)
sentry-cli releases set-commits 1.0.0 --auto

# Explicit commit range
sentry-cli releases set-commits 1.0.0 --commit "repo@from..to"

# Finalize (marks as non-draft)
sentry-cli releases finalize 1.0.0

# List / delete
sentry-cli releases list
sentry-cli releases delete 1.0.0

# Release info
sentry-cli releases info 1.0.0
```

## Deploys

```bash
# Record deployment
sentry-cli releases deploys 1.0.0 new -e production

# With timestamps
sentry-cli releases deploys 1.0.0 new -e staging \
  --started 1234567890 --finished 1234567899

# List deploys for a release
sentry-cli releases deploys 1.0.0 list
```

## Source Maps

Modern approach uses **debug IDs** (inject then upload). Avoids `--url-prefix` headaches.

```bash
# Debug ID workflow (recommended)
sentry-cli sourcemaps inject ./dist
sentry-cli sourcemaps upload --release 1.0.0 ./dist

# URL-prefix workflow (legacy)
sentry-cli sourcemaps upload --release 1.0.0 \
  --url-prefix '~/static/js' \
  --strip-prefix './dist' \
  ./dist

# Diagnose source map issues
sentry-cli sourcemaps explain --release 1.0.0
```

Key flags: `--release`, `--dist`, `--url-prefix`, `--strip-prefix`, `--validate`, `--wait`

## Debug Symbols

Upload dSYM, ProGuard, ELF, PDB files for native crash symbolication.

```bash
# Upload dSYMs (iOS/macOS)
sentry-cli debug-files upload --include-sources path/to/dSYMs

# Upload ProGuard mappings (Android)
sentry-cli debug-files upload --type proguard ./mapping.txt

# Check / find / list
sentry-cli debug-files check path/to/file
sentry-cli debug-files find <debug-id>
sentry-cli debug-files list

# Bundle sources into debug files
sentry-cli debug-files bundle-sources path/to/debug/files

# Bundle JVM sources
sentry-cli debug-files bundle-jvm --output ./out --debug-id <uuid> path/to/sources
```

Key flags: `--include-sources`, `--no-reprocessing`, `--type` (dsym/proguard/elf/pe/pdb/sourcebundle/bcsymbolmap), `--wait`

## Cron Monitors

```bash
# Wrap command — auto check-in / check-out
sentry-cli monitors run <monitor-slug> -- <command>

# Example crontab entry
# * * * * * sentry-cli monitors run daily-backup -- ./backup.sh

# Manual check-ins
sentry-cli monitors check-in <monitor-slug> --status in_progress
sentry-cli monitors check-in <monitor-slug> --status ok
sentry-cli monitors check-in <monitor-slug> --status error

# List monitors
sentry-cli monitors list
```

## Send Events

```bash
# Test event
sentry-cli send-event -m "Something happened"

# With tags and extra data
sentry-cli send-event -m "Deploy failed" \
  --tag environment:production \
  --tag service:api \
  --extra build_id:abc123

# With log level
sentry-cli send-event -m "Disk full" --level fatal

# From logfile
sentry-cli send-event -m "Error log" --logfile /var/log/app.log

# Raw envelope (advanced)
sentry-cli send-envelope path/to/envelope

# Bash error hook — auto-reports failing commands
eval "$(sentry-cli bash-hook)"
```

## React Native

```bash
sentry-cli react-native gradle --variant release
sentry-cli react-native xcode
sentry-cli react-native appcenter
```

## Common Workflows

### Full Release Cycle (CI/CD)

```bash
VERSION=$(sentry-cli releases propose-version)
sentry-cli releases new "$VERSION"
sentry-cli releases set-commits "$VERSION" --auto

# Build step
npm run build

# Source maps (debug ID approach)
sentry-cli sourcemaps inject ./dist
sentry-cli sourcemaps upload --release "$VERSION" ./dist

sentry-cli releases finalize "$VERSION"
sentry-cli releases deploys "$VERSION" new -e production
```

### iOS dSYM Upload (post Xcode build)

```bash
sentry-cli debug-files upload --include-sources \
  "build/Build/Products/Release-iphoneos/MyApp.app.dSYM"
```

### Bash Script Error Tracking

```bash
#!/bin/bash
export SENTRY_DSN="https://xxx@sentry.io/123"
eval "$(sentry-cli bash-hook)"
# Any failing command below auto-reports to Sentry
```

## Utilities

```bash
sentry-cli update      # self-update
sentry-cli uninstall   # remove
```
