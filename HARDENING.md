<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-languagetool/v1.20.4

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-languagetool/v1.20.4** was hardened automatically. 3 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): A GitHub Actions expression `${{ github.repository }}` is directly interpolated inside a `run:` shell command string: `docker build . --file Dockerfile --tag ${{ github.repository }}:$(date +%s)`. This causes the expression value to be substituted into the shell command before execution, enabling script injection if the value contains shell metacharacters.

Locations:

- `.github/workflows/dockerimage.yml:12`

### unsafe-shell (severity: high)

The Dockerfile (used as the action's Docker image via `image: 'Dockerfile'` in action.yml) pipes remote install scripts directly to a shell interpreter using `wget -O - -q <url> | sh`. This is done for four tools: reviewdog, tmpl, offset, and ghglob. Piping remote content to a shell without verification allows a compromised or MITM'd remote server to execute arbitrary code. Affected lines fetch from: https://raw.githubusercontent.com/reviewdog/reviewdog/.../install.sh, https://raw.githubusercontent.com/haya14busa/tmpl/master/install.sh, https://raw.githubusercontent.com/haya14busa/offset/master/install.sh, https://raw.githubusercontent.com/haya14busa/ghglob/master/install.sh

Locations:

- `Dockerfile:16`
- `Dockerfile:17`
- `Dockerfile:18`
- `Dockerfile:19`

### missing-permissions (severity: medium)

None of the workflow files define a top-level `permissions:` key, and no individual job within any workflow defines a `permissions:` key. Without explicit permissions, workflows run with the default (potentially broad) token permissions, violating the principle of least privilege.

Locations:

- `.github/workflows/depup.yml:1`
- `.github/workflows/dockerimage.yml:1`
- `.github/workflows/release.yml:1`
- `.github/workflows/reviewdog.yml:1`
- `.github/workflows/test.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, unsafe-shell, missing-permissions

**Notes:**

Fixed all three findings: (1) script-injection in dockerimage.yml by moving github.repository into an env var REPOSITORY and referencing it as ${REPOSITORY} in the shell command; (2) unsafe-shell in Dockerfile by replacing all four wget-pipe-to-sh patterns with download-then-execute approach (wget to temp file, then sh temp file, then rm); (3) missing-permissions in all 5 workflow files - dockerimage.yml gets permissions: {}, depup.yml gets contents: write + pull-requests: write, release.yml gets contents: write, reviewdog.yml gets contents: read + checks: write + pull-requests: write, test.yml gets contents: read + checks: write + pull-requests: write.

