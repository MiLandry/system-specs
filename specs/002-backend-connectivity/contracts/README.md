# Spec 002 — API contracts

Canonical OpenAPI source of truth for the Employee Manager BFF. Frontend and backend repos generate types/clients from this spec (no shared package repo).

## Files

| File | Purpose |
|------|---------|
| `openapi.yaml` | OpenAPI 3.1 contract for spec 002 |

## Validate locally

From `system-specs`:

```bash
bunx @redocly/cli lint specs/002-backend-connectivity/contracts/openapi.yaml
```

## Codegen (per repo, step 3+)

**Frontend** (`employee-manager-fe`) — fetch client:

```bash
bun add -d openapi-typescript
bunx openapi-typescript ../system-specs/specs/002-backend-connectivity/contracts/openapi.yaml -o src/generated/api.ts
```

**Backend** (`employee-manager-be`) — optional Zod from OpenAPI (step 2 may use hand-written Zod mirroring this spec until codegen is wired).

Paths assume sibling checkouts:

```text
employee-manager-spec-kit/
  system-specs/
  employee-manager-fe/
  employee-manager-be/
```

Adjust paths if your layout differs.

## `GET /health` contract summary

- **200** — `HealthResponse`: `status`, `timestamp`, optional `message`, required `db.status` (`up` | `down`), optional `db.error`
- **500** — `ApiError`

Backward compatibility with spec 001 UI: `status` and `timestamp` remain required; `db` is additive.
