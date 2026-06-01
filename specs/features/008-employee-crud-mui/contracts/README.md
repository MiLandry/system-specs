# Spec 008 — Employee CRUD API contracts

Canonical OpenAPI for employee view-centric BFF endpoints introduced in spec 008.

## Files

| File | Purpose |
|------|---------|
| `openapi.yaml` | Employee list/create/update/delete contract |

## Validate locally

From `system-specs`:

```bash
bunx @redocly/cli lint specs/features/008-employee-crud-mui/contracts/openapi.yaml --skip-rule security-defined
```

## Codegen (per repo)

**Frontend** (`employee-manager-fe`) — extend or add codegen target:

```bash
bunx openapi-typescript ../system-specs/specs/features/008-employee-crud-mui/contracts/openapi.yaml -o src/generated/employees.openapi.ts
```

Adjust path if sibling checkout layout differs.

**Backend** (`employee-manager-be`) — handlers SHOULD mirror this contract; optional Zod generation deferred.

## View-centric paths

| UI widget | Endpoint |
|-----------|----------|
| Root Data Grid | `GET /employees/list` |
| Create dialog | `POST /employees/list` (or `/employees/list/create`) |
| Edit dialog | `PUT /employees/{id}/edit` |
| Delete confirmation | `DELETE /employees/{id}` |

## Auth headers (phase 1 mock)

Until real auth lands, local/testing requests use mock principal headers from spec 006:

- `x-mock-user-id`
- `x-mock-roles` (comma-separated: `admin`, `manager`, `viewer`)

## Related specs

- [`../spec.md`](../spec.md) — feature requirements
- [`../../architecture/006-auth-phase1-simple/spec.md`](../../architecture/006-auth-phase1-simple/spec.md) — mock auth baseline
- [`../../architecture/002-backend-connectivity/contracts/openapi.yaml`](../../architecture/002-backend-connectivity/contracts/openapi.yaml) — health contract (separate)
