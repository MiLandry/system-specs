# Research: Employee CRUD — UI and API

## Decision 1: Material UI + MUI X Data Grid for root page

Use **Material UI (MUI)** as the component library and **MUI X Data Grid** for the employee list.

### Rationale

- Spec explicitly requires Material Design principles and Material UI.
- Data Grid provides sortable columns, toolbar slots, and row actions suitable for admin CRUD.
- Aligns with constitution architecture constraint (Material UI on UI layer).

### Alternatives considered

- **Plain MUI Table**: Rejected — more manual work for sorting, toolbar, and row actions at scale.
- **TanStack Table + custom styling**: Rejected — diverges from spec-mandated MUI component library.
- **AG Grid**: Rejected — additional licensing/complexity not required for first release.

## Decision 2: Extend auth phase-1 policy (not parallel auth system)

Add `employees` resource and `update`/`delete` actions to existing `authorize()` policy.

### Rationale

- Reuses mock principal resolver and guard middleware from spec 006.
- Keeps deny-by-default semantics consistent.
- Role matrix from spec maps cleanly to policy table.

## Decision 3: View-centric BFF paths

Use paths aligned to frontend widgets (`/employees/list`, `/employees/{id}/edit`).

### Rationale

- Matches constitution view-centric API guidance.
- Makes FE service methods map 1:1 with UI components.

## Decision 4: OpenAPI contract in feature folder

Canonical employee API contract lives under this feature's `contracts/openapi.yaml`; FE codegen references sibling `system-specs` path (same pattern as spec 002 health).

## Decision 5: MSW handlers for employee API in tests

Extend MSW setup for employee list/mutation endpoints in FE tests (same pattern as health).

## Decision 6: Persistence delegated to spec 009

Employee data architecture, migrations, and repository implementation are specified in [`../009-employee-data-architecture/spec.md`](../009-employee-data-architecture/spec.md) to keep CRUD feature scope focused on UI/API behavior.

## Open questions (non-blocking)

- **Pagination**: Defer server-side pagination until row counts exceed ~200.
- **Manager scope**: v1 uses global role permissions only; department-scoped manager access is a future ABAC enhancement.
