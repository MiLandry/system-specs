# Specification: Backend connectivity POC (spec 002)

**Status**: Active  
**Scope**: Minimal BFF exposes `GET /health`, requires local PostgreSQL before listening, verifies DB on health checks.

## Goals

1. Frontend can verify connectivity to a real backend (no mocks in live mode).
2. Backend fails fast when Postgres env is invalid or unreachable at startup.
3. Canonical API surface is documented in [`contracts/openapi.yaml`](contracts/openapi.yaml).

## Behavior

### Startup

- All Postgres variables documented in `employee-manager-be` **`.env.example`** are **required**.
- Startup runs `SELECT 1` once; on failure → log and **`process.exit(1)`**. No HTTP listener starts.

### `GET /health`

- **200** + [`HealthResponse`](contracts/openapi.yaml) (`db.status === "up"` when healthy).
- If the probe fails after startup → **503** + [`ApiError`](contracts/openapi.yaml) (`code: DATABASE_UNAVAILABLE`), then production servers **terminate the process**.

### Frontend

- OpenAPI-derived types (`employee-manager-fe` `bun run codegen:api`) and the `/health` client treat non-2xx as failures.
- Mock mode keeps MSW for offline UI work.
- Cleanup scripts match spec 001: `bun run clean` and `bun run nuke` in `employee-manager-fe` (see [`../001-baseline-app-poc/quickstart.md`](../001-baseline-app-poc/quickstart.md)).

### Developer tooling (`employee-manager-be`)

The backend repo MUST expose Bun cleanup scripts aligned with the frontend pattern:

- **`bun run clean`** — removes `dist/`, `build/`, and `node_modules/.cache/`; keeps `node_modules/`, source, `bun.lock`, and `.env`.
- **`bun run nuke`** — runs `clean`, removes `node_modules/`, then `bun install` (keeps `bun.lock` and `.env`).
- **`bun run stop`** — sends `SIGTERM` to any process listening on `PORT` (from `.env`, default `3000`).

Implementation: `scripts/clean.ts`, `scripts/nuke.ts`, `scripts/stop.ts`, and `scripts/paths.ts` in `employee-manager-be` (see repo `README.md`).

See [`quickstart.md`](quickstart.md) for verification steps.

## Out of scope (separate features)

- **CI/CD** — GitHub Actions (or other pipelines), automated OpenAPI lint on push, and repo-wide quality gates are **not** part of spec 002. Validate contracts and apps **locally** (see `quickstart.md` and per-repo READMEs).
- **Docker Compose** — optional local orchestration for Postgres/services is deferred.
- **ORM, auth, and domain APIs** beyond `/health` — deferred to later specs.
