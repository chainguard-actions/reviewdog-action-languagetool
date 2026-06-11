<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-languagetool/v1.23.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **reviewdog--action-languagetool/v1.23.0** was hardened automatically. 1 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### unsafe-shell (severity: high)

The Dockerfile (a core supporting build script referenced by action.yml via `image: 'Dockerfile'`) downloads remote install scripts and pipes them directly to the shell interpreter using `wget -O - -q <url> | sh`. This is unsafe because the remote content is executed without any integrity verification. Three of the four URLs fetch from the `master` branch (mutable), meaning the content can change at any time and could be replaced with malicious code:
- `wget -O - -q https://raw.githubusercontent.com/haya14busa/tmpl/master/install.sh | sh`
- `wget -O - -q https://raw.githubusercontent.com/haya14busa/offset/master/install.sh | sh`
- `wget -O - -q https://raw.githubusercontent.com/haya14busa/ghglob/master/install.sh | sh`
- `wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/fd59714416d6d9a1c0692d872e38e7f8448df4fc/install.sh | sh` (pinned commit, but still piped to shell without verification)

Locations:

- `Dockerfile:17`
- `Dockerfile:18`
- `Dockerfile:19`
- `Dockerfile:20`

## Iteration Notes

### Iteration 1

**Fixes applied:** unsafe-shell

**Notes:**

Fixed all four `wget -O - -q <url> | sh` patterns in the Dockerfile by: (1) downloading each install script to a temporary file first (`wget -O /tmp/install-*.sh`), (2) executing the downloaded file separately (`sh /tmp/install-*.sh`), and (3) removing the temporary file afterward. Additionally pinned the three mutable `master` branch URLs to specific commit SHAs: haya14busa/tmpl@0f3ab9222c8445feb80db1783e630a8b2526a285, haya14busa/offset@672ac5ecc5cae667caa8b46cead9ad822a07278b, haya14busa/ghglob@c28f127bd85ea42b4ef62381bd7a9861ffb1b785. The reviewdog install.sh URL was already pinned to commit fd59714416d6d9a1c0692d872e38e7f8448df4fc.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed two unquoted shell variable expansions in entrypoint.sh:
1. Line 18: Changed `git config --global --add safe.directory $GITHUB_WORKSPACE` to `git config --global --add safe.directory "$GITHUB_WORKSPACE"` — prevents word-splitting on paths with spaces or special characters.
2. Line 40: Changed `ghglob ${INPUT_PATTERNS}` to `ghglob "${INPUT_PATTERNS}"` — prevents word-splitting and command injection from attacker-controlled `patterns` input containing shell metacharacters (`;`, `|`, `&`, `$(...)`, etc.).

