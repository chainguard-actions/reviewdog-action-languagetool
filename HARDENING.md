<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-languagetool/v1.20.4

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **reviewdog--action-languagetool/v1.20.4** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unsafe-shell (severity: high)

The Dockerfile (a supporting script that is part of the distributed action) downloads four remote shell scripts and pipes them directly to `sh` without first saving to a file and verifying integrity. Three of the four URLs reference the mutable `master` branch, meaning the content can change at any time. Patterns:
- `wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/fd59714416d6d9a1c0692d872e38e7f8448df4fc/install.sh| sh`
- `wget -O - -q https://raw.githubusercontent.com/haya14busa/tmpl/master/install.sh| sh`
- `wget -O - -q https://raw.githubusercontent.com/haya14busa/offset/master/install.sh| sh`
- `wget -O - -q https://raw.githubusercontent.com/haya14busa/ghglob/master/install.sh| sh`
An attacker who compromises any of those repositories (or performs a MITM attack) can execute arbitrary code during the Docker image build.

Locations:

- `Dockerfile:17`

## Iteration Notes

### Iteration 1

**Fixes applied:** unsafe-shell

**Notes:**

Fixed the Dockerfile to eliminate pipe-to-shell patterns. Each of the four install scripts is now downloaded to a temporary file (e.g., /tmp/reviewdog-install.sh) and then executed separately with 'sh', followed by removal of the temp file. Additionally, the three mutable 'master' branch URLs were replaced with pinned commit SHAs: haya14busa/tmpl pinned to 0f3ab9222c8445feb80db1783e630a8b2526a285, haya14busa/offset pinned to 672ac5ecc5cae667caa8b46cead9ad822a07278b, and haya14busa/ghglob pinned to c28f127bd85ea42b4ef62381bd7a9861ffb1b785. The reviewdog URL was already pinned to fd59714416d6d9a1c0692d872e38e7f8448df4fc.

