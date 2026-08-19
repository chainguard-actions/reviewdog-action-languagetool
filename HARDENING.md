<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-languagetool/v1.21.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-languagetool/v1.21.0** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a) violation: The `run:` block in dockerimage.yml directly interpolates `${{ github.repository }}` into a shell command string. Before the shell executes the command, GitHub Actions performs template substitution, meaning a repository name containing shell metacharacters could alter the command. The offending line is: `run: docker build . --file Dockerfile --tag ${{ github.repository }}:$(date +%s)`. This should be replaced with an env var reference (e.g., `env: REPO: ${{ github.repository }}` and then `"$REPO"` in the run block).

Locations:

- `.github/workflows/dockerimage.yml:12`

### missing-permissions (severity: medium)

None of the workflow files define a top-level `permissions:` key, and no job within any of these files defines job-level `permissions:` either. Without explicit permissions, workflows run with the repository's default token permissions, which may be overly broad (e.g., write access to contents, pull-requests, etc.). Each workflow file should declare minimal required permissions.

Locations:

- `.github/workflows/depup.yml:1`
- `.github/workflows/dockerimage.yml:1`
- `.github/workflows/release.yml:1`
- `.github/workflows/reviewdog.yml:1`
- `.github/workflows/test.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, missing-permissions

**Notes:**

Fixed script-injection in dockerimage.yml by moving `${{ github.repository }}` to an env var `REPO` and referencing it as `"$REPO"` in the run block. Added top-level `permissions:` blocks to all 5 workflow files with minimal required permissions: depup.yml (contents:write, pull-requests:write for PR creation), dockerimage.yml (contents:read for Docker build), release.yml (contents:write for release creation), reviewdog.yml (contents:read, checks:write, pull-requests:write for posting reviews/checks), test.yml (contents:read, checks:write, pull-requests:write for the languagetool action that posts reviews/checks).

