<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-languagetool/v1.20.3

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-languagetool/v1.20.3** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a) violation: `${{ github.repository }}` is interpolated directly inside a `run:` shell command in dockerimage.yml. The expression is substituted by the Actions runner before the shell sees it, allowing a repository name containing shell metacharacters to inject arbitrary commands. The offending line is: `run: docker build . --file Dockerfile --tag ${{ github.repository }}:$(date +%s)`. Fix: move the value into an `env:` variable and reference it as a quoted shell variable, e.g. `env: REPO: ${{ github.repository }}` then `run: docker build . --file Dockerfile --tag "$REPO":$(date +%s)`.

Locations:

- `.github/workflows/dockerimage.yml:13`

### missing-permissions (severity: medium)

None of the workflow files define a top-level `permissions:` key, and no individual job within any of these files defines a `permissions:` key either. Without explicit permissions, workflows inherit the default repository token permissions (which may be broad write-all depending on repository settings). Each workflow should declare minimal required permissions at the top level or per job.

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

Fixed script-injection in dockerimage.yml by moving `${{ github.repository }}` into an env: variable (REPO) and referencing it as a quoted shell variable `"$REPO"` in the run command. Added top-level permissions blocks to all 5 workflow files with minimal required permissions: dockerimage.yml (contents: read), depup.yml (contents: write, pull-requests: write), release.yml (contents: write), reviewdog.yml (contents: read, checks: write, pull-requests: write), test.yml (contents: read, checks: write, pull-requests: write).

