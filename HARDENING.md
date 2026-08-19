<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-languagetool/v1.23.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-languagetool/v1.23.0** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): A GitHub Actions expression is directly interpolated inside a `run:` shell command. In `.github/workflows/dockerimage.yml`, the `run:` step contains `${{ github.repository }}` embedded directly in the shell string: `docker build . --file Dockerfile --tag ${{ github.repository }}:$(date +%s)`. This allows the value to be injected into the shell command before the shell ever sees it, enabling script injection if the value contains shell metacharacters.

Locations:

- `.github/workflows/dockerimage.yml:11`

### permissions (severity: medium)

missing-permissions: None of the workflow files have a top-level `permissions:` key, and none of the individual jobs define job-level `permissions:` blocks. Without explicit permissions, workflows run with the default (potentially broad) token permissions. All five workflow files are affected: depup.yml, dockerimage.yml, release.yml, reviewdog.yml, and test.yml.

Locations:

- `.github/workflows/depup.yml:1`
- `.github/workflows/dockerimage.yml:1`
- `.github/workflows/release.yml:1`
- `.github/workflows/reviewdog.yml:1`
- `.github/workflows/test.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, permissions

**Notes:**

Fixed script injection in dockerimage.yml by moving ${{ github.repository }} to an env block (REPOSITORY variable) and referencing it as "$REPOSITORY" in the shell command. Added permissions blocks to all 5 workflow files: dockerimage.yml gets permissions: {} (no token access needed for local Docker build); depup.yml gets contents:write + pull-requests:write (for creating PRs); release.yml gets contents:write (for creating releases/tags); reviewdog.yml gets contents:read + checks:write + pull-requests:write (for posting reviewdog results); test.yml gets contents:read + checks:write + pull-requests:write (for the languagetool action to post results).

