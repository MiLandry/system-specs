# Feature Specification: Frontend CI foundations (spec 004)

**Status**: Draft  
**Scope**: Add a frontend-only CI baseline in `employee-manager-fe` with lint, test, and build checks while preserving OpenAPI codegen from canonical `system-specs`.

## Goals

1. Every frontend pull request gets an automated quality gate.
2. Frontend `main` receives post-merge CI validation.
3. CI preserves the existing build flow (`prebuild:app` -> `codegen:api` -> `build:app`) without changing FE architecture.

## Behavior

### Workflow location and triggers

- FE repo adds `.github/workflows/ci.yml`.
- Workflow runs on `pull_request` and `push` to `main`.
- Concurrency cancels stale runs for the same ref.

### Runtime and command sequence

- Workflow uses pinned Bun runtime.
- Required steps run in order:
  1. `bun install --frozen-lockfile`
  2. `bun run lint`
  3. `bun test`
  4. `bun run build`
- Any step failure marks the workflow failed.

### OpenAPI codegen dependency

- `employee-manager-fe` build depends on `codegen:api` reading `../system-specs/specs/002-backend-connectivity/contracts/openapi.yaml`.
- CI checks out `system-specs` and makes that path available to FE workflow execution (for example by linking to `../system-specs`).
- Canonical contract source remains `system-specs`; generated FE output remains derived artifact.

### Documentation

- `employee-manager-fe/README.md` includes a CI section with trigger behavior and local parity commands.
- README notes fallback behavior if checkout/pathing fails temporarily.

## Acceptance Criteria

- FE PRs trigger CI automatically.
- CI passes on current baseline with lint, test, and build included.
- Build succeeds in CI with OpenAPI path resolved from checked-out `system-specs`.
- README clearly documents CI parity commands for contributors.

## Out of scope (separate features)

- Service containers and DB-backed integration dependencies.
- FE/BE combined workflow orchestration and org-wide required-check policy.
- Migrating to committed generated OpenAPI artifacts.
- Deployment/release automation.
