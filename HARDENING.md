<!-- markdownlint-disable -->

# Hardening Report: veracode--veracode-uploadandscan-action/0.2.11

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **veracode--veracode-uploadandscan-action/0.2.11** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

Workflow files reference actions using mutable tags or branch names instead of full 40-character commit SHAs. This exposes the workflow to supply-chain attacks if the referenced tag or branch is moved to a malicious commit.

.github/workflows/main.yml:
  - uses: actions/checkout@v3  (tag, not SHA)
  - uses: actions/setup-java@v2  (tag, not SHA)
  - uses: actions/upload-artifact@v4.6.2  (tag, not SHA)

.github/workflows/policyscan.yml:
  - uses: actions/checkout@v4  (tag, not SHA)
  - uses: veracode/veracode-uploadandscan-action@master  (branch, not SHA)

Locations:

- `.github/workflows/main.yml:24`
- `.github/workflows/main.yml:25`
- `.github/workflows/main.yml:27`
- `.github/workflows/policyscan.yml:20`
- `.github/workflows/policyscan.yml:22`

### missing-permissions (severity: medium)

Neither workflow file defines a top-level `permissions:` block, and no job within either file defines its own `permissions:` block. Without explicit permissions, workflows run with the default (potentially broad) token permissions, violating the principle of least privilege.

Locations:

- `.github/workflows/main.yml:1`
- `.github/workflows/policyscan.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, missing-permissions

**Notes:**

Fixed both workflow files: (1) Pinned all 5 unpinned action references to full 40-character commit SHAs with original tag/branch preserved as inline comments. (2) Added `permissions: {}` top-level block to both .github/workflows/main.yml and .github/workflows/policyscan.yml to enforce least-privilege token access.

