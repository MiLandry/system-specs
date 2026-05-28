# Quickstart: Spec 004 — Frontend CI foundations

This spec validates frontend CI in `employee-manager-fe` with the existing OpenAPI codegen dependency on `system-specs`.

## Step 1 — Verify workflow file

```bash
cd path/to/employee-manager-fe
ls .github/workflows/ci.yml
```

Expected: workflow exists with `pull_request` + `push` (`main`) triggers, Bun setup, and lint/test/build steps.

## Step 2 — Verify local parity commands

```bash
cd path/to/employee-manager-fe
bun install --frozen-lockfile
bun run lint
bun test
bun run build
```

Expected: all commands pass on a healthy branch.

## Step 3 — Validate OpenAPI path dependency

`bun run build` should run `codegen:api` and read:

`../system-specs/specs/002-backend-connectivity/contracts/openapi.yaml`

Expected: `src/generated/openapi.ts` is regenerated successfully before TypeScript/Vite build.

## Step 4 — Validate PR behavior

1. Create a feature branch in `employee-manager-fe`.
2. Open a PR to `main`.
3. Confirm workflow runs and reports status.

Expected: CI runs automatically and blocks merge when lint/test/build fails.

## Step 5 — Validate fallback behavior (optional)

If CI pathing to `system-specs` fails:

- Temporarily gate with install/lint/test only.
- Restore build as required check immediately after pathing is corrected.
