# Quickstart: Spec 005 — System-specs CI foundations

This spec validates a CI baseline for the `system-specs` repository.

## Step 1 — Verify workflow file

```bash
cd path/to/system-specs
ls .github/workflows/ci.yml
```

Expected: workflow exists and triggers on PRs and pushes to `main`.

## Step 2 — Run local parity commands

```bash
cd path/to/system-specs
bun install --frozen-lockfile
bunx @redocly/cli lint specs/002-backend-connectivity/contracts/openapi.yaml
```

Expected: install succeeds and OpenAPI lint passes.

## Step 3 — Validate PR behavior

1. Create branch in `system-specs`.
2. Open PR to `main`.
3. Confirm CI starts automatically.

Expected: check appears on PR and blocks merge on failures.

## Step 4 — Validate failure behavior (optional)

Temporarily introduce an invalid OpenAPI change in:

`specs/002-backend-connectivity/contracts/openapi.yaml`

Expected: CI fails contract lint with actionable output.

Revert temporary invalid change and confirm CI returns to green.
