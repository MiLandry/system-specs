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

See [`quickstart.md`](quickstart.md) for verification steps.

## Out of scope (separate features)

- **CI/CD** — GitHub Actions (or other pipelines), automated OpenAPI lint on push, and repo-wide quality gates are **not** part of spec 002. Validate contracts and apps **locally** (see `quickstart.md` and per-repo READMEs).
- **Docker Compose** — optional local orchestration for Postgres/services is deferred.
- **ORM, auth, and domain APIs** beyond `/health` — deferred to later specs.
