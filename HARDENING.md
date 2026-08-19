<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-languagetool/v1.22.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-languagetool/v1.22.0** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### missing-permissions (severity: medium)

None of the workflow files have a top-level `permissions:` key, and no individual jobs define job-level permissions. This means workflows run with the default (potentially broad) token permissions. All five workflow files are affected: depup.yml, dockerimage.yml, release.yml, reviewdog.yml, and test.yml.

Locations:

- `.github/workflows/depup.yml:1`
- `.github/workflows/dockerimage.yml:1`
- `.github/workflows/release.yml:1`
- `.github/workflows/reviewdog.yml:1`
- `.github/workflows/test.yml:1`

### script-injection (severity: high)

Sub-rule (a) violation: `${{ github.repository }}` is directly interpolated inside a `run:` shell command in dockerimage.yml. The offending line is: `run: docker build . --file Dockerfile --tag ${{ github.repository }}:$(date +%s)`. An attacker who can control the repository name (e.g. via a fork with a crafted name) could inject arbitrary shell commands. The value should be passed via an `env:` variable and then referenced as a quoted `"$VAR"` in the shell script.

Locations:

- `.github/workflows/dockerimage.yml:12`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, missing-permissions

**Notes:**

Fixed script-injection in dockerimage.yml by moving ${{ github.repository }} into an env: block (REPOSITORY variable) and referencing it as "$REPOSITORY" in the shell command. Added top-level permissions: blocks to all 5 workflow files: dockerimage.yml gets permissions: {} (no token access needed), depup.yml gets contents:write + pull-requests:write (creates PRs), release.yml gets contents:write (creates releases/tags), reviewdog.yml gets contents:read + checks:write + pull-requests:write (posts review comments), and test.yml gets contents:read + checks:write + pull-requests:write (posts review comments).

