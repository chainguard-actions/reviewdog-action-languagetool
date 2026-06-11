<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-languagetool/v1.21.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **reviewdog--action-languagetool/v1.21.0** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unsafe-shell (severity: high)

The Dockerfile pipes remote install scripts directly to `sh` using `wget ... | sh` four times. This pattern executes remotely-fetched content without any integrity verification, allowing a compromised or man-in-the-middle'd script to run arbitrary code during the Docker image build. The scripts are fetched from mutable URLs (including `master` branches): `https://raw.githubusercontent.com/haya14busa/tmpl/master/install.sh`, `https://raw.githubusercontent.com/haya14busa/offset/master/install.sh`, and `https://raw.githubusercontent.com/haya14busa/ghglob/master/install.sh`.

Locations:

- `Dockerfile:17`
- `Dockerfile:18`
- `Dockerfile:19`
- `Dockerfile:20`

### script-injection (severity: high)

Rule (b) violation: In entrypoint.sh line 37, the shell variable `${INPUT_PATTERNS}` (sourced from the action input `inputs.patterns`, which is workflow-controllable) is expanded **unquoted** inside a command substitution: `FILES="$(git ls-files | ghglob ${INPUT_PATTERNS})"`. An unquoted expansion allows the shell to parse metacharacters (`;`, `|`, `&`, `$(...)`, whitespace, glob chars) from the value, enabling command injection. It should be quoted: `ghglob "${INPUT_PATTERNS}"`.

Locations:

- `entrypoint.sh:37`

## Iteration Notes

### Iteration 1

**Fixes applied:** unsafe-shell, script-injection

**Notes:**

Dockerfile: Replaced all four `wget ... | sh` pipe patterns with download-to-file-then-execute approach. The three mutable `master` branch URLs were also pinned to specific commit SHAs (tmpl: 0f3ab9222c8445feb80db1783e630a8b2526a285, offset: 672ac5ecc5cae667caa8b46cead9ad822a07278b, ghglob: c28f127bd85ea42b4ef62381bd7a9861ffb1b785). entrypoint.sh: Quoted `${INPUT_PATTERNS}` in the `ghglob` call to prevent shell metacharacter injection from the workflow-controllable `patterns` input.

