<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-languagetool/v1.22.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **reviewdog--action-languagetool/v1.22.0** was hardened automatically. 1 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### unsafe-shell (severity: high)

The Dockerfile pipes remote install scripts directly to `sh` without first downloading them to a file. Four `wget ... | sh` invocations are present:
1. `wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/fd59714416d6d9a1c0692d872e38e7f8448df4fc/install.sh | sh` — pinned by commit SHA in URL but still piped directly to sh.
2. `wget -O - -q https://raw.githubusercontent.com/haya14busa/tmpl/master/install.sh | sh` — fetches from mutable `master` branch.
3. `wget -O - -q https://raw.githubusercontent.com/haya14busa/offset/master/install.sh | sh` — fetches from mutable `master` branch.
4. `wget -O - -q https://raw.githubusercontent.com/haya14busa/ghglob/master/install.sh | sh` — fetches from mutable `master` branch.
All four pipe remote content directly to a shell interpreter without integrity verification. The three `master`-branch fetches are especially dangerous as the content can change at any time.

Locations:

- `Dockerfile:16`

## Iteration Notes

### Iteration 1

**Fixes applied:** unsafe-shell

**Notes:**

Fixed all four `wget ... | sh` pipe-to-shell invocations in the Dockerfile by downloading each install script to a temporary file first, then executing it separately, then removing it. This eliminates the unsafe pipe-to-shell pattern. Additionally, the three mutable `master` branch URLs were pinned to specific commit SHAs: haya14busa/tmpl → 0f3ab9222c8445feb80db1783e630a8b2526a285, haya14busa/offset → 672ac5ecc5cae667caa8b46cead9ad822a07278b, haya14busa/ghglob → c28f127bd85ea42b4ef62381bd7a9861ffb1b785. The reviewdog install script URL was already pinned to a commit SHA (fd59714416d6d9a1c0692d872e38e7f8448df4fc).

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed script injection vulnerability in entrypoint.sh line 38: changed `ghglob ${INPUT_PATTERNS}` to `ghglob "${INPUT_PATTERNS}"`. The unquoted expansion allowed shell metacharacters (`;`, `|`, `&`, `$(...)`, etc.) in the workflow-controllable `inputs.patterns` value to be interpreted by the shell before `noglob` could suppress glob expansion, enabling command injection. Adding double quotes prevents this by ensuring the value is treated as a single argument to ghglob.

