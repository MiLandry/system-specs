# Spec 002 — API contracts

Canonical OpenAPI source of truth for the Employee Manager BFF. Frontend and backend repos generate types/clients from this spec (no shared package repo).

## Files

| File | Purpose |
|------|---------|
| `openapi.yaml` | OpenAPI 3.1 contract for spec 002 |

## Validate locally (not CI)

Run this on your machine when changing the contract. **Automated lint in CI is out of scope** for spec 002.

From `system-specs`:

```bash
bunx @redocly/cli lint specs/architecture/002-backend-connectivity/contracts/openapi.yaml
```

## Codegen (per repo, step 3+)

**Frontend** (`employee-manager-fe`) — fetch client:

```bash
bun add -d openapi-typescript
bunx openapi-typescript ../system-specs/specs/architecture/002-backend-connectivity/contracts/openapi.yaml -o src/generated/openapi.ts
```

Or `bun run codegen:api` from `employee-manager-fe` (same output path). Output is gitignored under `src/generated/`; `prebuild:app` runs before `build:app`, and `bun run clean` removes it.

**Backend** (`employee-manager-be`) — optional Zod from OpenAPI (handlers currently mirror this spec manually).

Paths assume sibling checkouts:

```text
employee-manager-spec-kit/
  system-specs/
  employee-manager-fe/
  employee-manager-be/
```

Adjust paths if your layout differs.

## `GET /health` contract summary

| Status | Body |
|--------|------|
| **200** | `HealthResponse` — `status`, `timestamp`, optional `message`, `db.status` **`up`** when healthy |
| **503** | `ApiError` — database unavailable (`code: DATABASE_UNAVAILABLE` when produced by reference BFF); server process terminates shortly after |
| **500** | `ApiError` — unexpected handler error |

The reference BFF exits before bind if Postgres is unreachable **at startup**; runtime probe failures yield **503** then **process exit**.

Backward compatibility with spec 001 UI baseline: callers still distinguish success via **HTTP 200** vs failure via **non-2xx**.
