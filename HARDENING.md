<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-languagetool/v1.20.3

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **reviewdog--action-languagetool/v1.20.3** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unsafe-shell (severity: high)

The Dockerfile fetches four remote install scripts from raw.githubusercontent.com (on the mutable `master` branch) and pipes them directly to `sh` without first saving to a file and verifying integrity. This allows a compromised or tampered remote script to execute arbitrary code during the Docker image build. Affected lines:
- `wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}`
- `wget -O - -q https://raw.githubusercontent.com/haya14busa/tmpl/master/install.sh| sh -s -- -b /usr/local/bin/ ${TMPL_VERSION}`
- `wget -O - -q https://raw.githubusercontent.com/haya14busa/offset/master/install.sh| sh -s -- -b /usr/local/bin/ ${OFFSET_VERSION}`
- `wget -O - -q https://raw.githubusercontent.com/haya14busa/ghglob/master/install.sh| sh -s -- -b /usr/local/bin/ ${GHGLOB_VERSION}`

Locations:

- `Dockerfile:16`
- `Dockerfile:17`
- `Dockerfile:18`
- `Dockerfile:19`

## Iteration Notes

### Iteration 1

**Fixes applied:** unsafe-shell

**Notes:**

Fixed all four unsafe shell patterns in the Dockerfile (lines 16-19). Each `wget -O - -q <url> | sh` pipe was replaced with a two-step approach: (1) download the install script to a named temporary file with `wget -O /tmp/install-<name>.sh`, (2) execute it with `sh /tmp/install-<name>.sh`, and (3) remove the temporary file with `rm`. This eliminates the pipe-from-internet-to-shell anti-pattern for reviewdog, tmpl, offset, and ghglob install scripts.

