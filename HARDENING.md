<!-- markdownlint-disable -->

# Hardening Report: veracode--veracode-uploadandscan-action/0.2.10

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **veracode--veracode-uploadandscan-action/0.2.10** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

Both workflow files reference actions using mutable tags or branch names instead of full 40-character commit SHAs, making them vulnerable to supply-chain attacks if the referenced tag or branch is moved.

.github/workflows/main.yml:
  - uses: actions/checkout@v3
  - uses: actions/setup-java@v2
  - uses: actions/upload-artifact@v4.6.2

.github/workflows/policyscan.yml:
  - uses: actions/checkout@v4
  - uses: veracode/veracode-uploadandscan-action@master  (branch ref — especially dangerous)

Locations:

- `.github/workflows/main.yml:24`
- `.github/workflows/main.yml:25`
- `.github/workflows/main.yml:27`
- `.github/workflows/policyscan.yml:20`
- `.github/workflows/policyscan.yml:22`

### missing-permissions (severity: medium)

Neither .github/workflows/main.yml nor .github/workflows/policyscan.yml defines a top-level `permissions:` key, and no job-level `permissions:` keys are present in any job. Without explicit permissions, the GITHUB_TOKEN is granted its default (potentially broad) permissions, violating the principle of least privilege.

Locations:

- `.github/workflows/main.yml:1`
- `.github/workflows/policyscan.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, missing-permissions

**Notes:**

Fixed both workflow files: (1) Pinned all 5 unpinned action references to full 40-character commit SHAs with original tag/branch preserved as comments. (2) Added `permissions: {}` top-level block to both main.yml and policyscan.yml to enforce least-privilege GITHUB_TOKEN access.

