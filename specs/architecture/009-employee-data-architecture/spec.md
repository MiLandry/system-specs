# Feature Specification: Employee Data Architecture

**Feature Branch**: `[009-employee-data-architecture]`  
**Created**: 2026-05-30  
**Status**: Draft  
**Input**: Split from spec 008 design — persistence layer, migrations, and repository strategy for employee CRUD.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Persist employee records reliably (Priority: P1)

Developers can apply versioned migrations and use a repository layer so employee CRUD routes persist data in PostgreSQL with consistent field mapping.

**Why this priority**: Spec 008 CRUD UI/API depends on a defined persistence foundation.

**Independent Test**: Run migrations, seed dev data, and verify repository CRUD operations against a real Postgres instance.

**Acceptance Scenarios**:

1. **Given** a fresh local database, **When** `bun run db:migrate` runs, **Then** the `employees` table and indexes exist and migration is recorded in `schema_migrations`.
2. **Given** migrated schema, **When** repository `createEmployee` is called with valid input, **Then** a row is inserted with snake_case columns and returned as camelCase domain shape.
3. **Given** an existing employee, **When** repository `updateEmployee` runs, **Then** `updated_at` is refreshed and values persist.
4. **Given** duplicate email on create, **When** repository insert runs, **Then** unique constraint violation maps to `DUPLICATE_EMAIL` at route boundary.

---

### User Story 2 - Search and filter at the data layer (Priority: P2)

List queries support name search and department filter using parameterized SQL and supporting indexes.

**Why this priority**: Spec 008 grid search/filter depends on efficient, correct repository queries.

**Independent Test**: Seed employees across departments; verify `listEmployees` filter combinations without route-layer logic.

**Acceptance Scenarios**:

1. **Given** seeded employees, **When** `listEmployees({ name: 'ann' })` runs, **Then** case-insensitive substring matches on `full_name` are returned.
2. **Given** seeded employees, **When** `listEmployees({ department: 'Engineering' })` runs, **Then** only matching department rows are returned.
3. **Given** both filters, **When** list runs, **Then** results satisfy AND semantics.

---

### User Story 3 - Operate database changes safely (Priority: P3)

Teams apply schema changes through forward-only migrations with documented local seed/reset workflows.

**Why this priority**: Prevents ad-hoc schema drift and supports repeatable dev/CI environments.

**Independent Test**: Add a second migration in a test branch; verify runner applies only pending files in order.

**Acceptance Scenarios**:

1. **Given** applied migration `001`, **When** migrate runs again, **Then** no duplicate apply occurs.
2. **Given** a new migration file `002_*`, **When** migrate runs, **Then** only `002` is applied after `001`.
3. **Given** dev seed script, **When** `bun run db:seed` runs twice, **Then** seed is idempotent (no duplicate emails).

---

### Edge Cases

- Migration SQL failure mid-run: no partial record for failed file; operator fixes SQL and re-runs.
- Connection pool exhaustion: errors logged; health probe may still pass if probe uses separate short connection.
- Row not found on update/delete: repository signals not-found for route to map to `404`.
- Reset script against non-local env: MUST refuse unless explicit override flag is set.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: PostgreSQL MUST be the system of record for employee entities.
- **FR-002**: API field names use camelCase; database columns use snake_case; mapping MUST occur only in the repository layer (see [`data-architecture.md`](data-architecture.md)).
- **FR-003**: Route handlers MUST NOT embed SQL; they call repository functions only.
- **FR-004**: Schema changes MUST be applied via versioned SQL migrations tracked in `schema_migrations` (see [`database-management.md`](database-management.md)).
- **FR-005**: Initial migration MUST create `employees` table with unique `email`, required columns, and indexes for name search and department filter (see [`data-model.md`](data-model.md)).
- **FR-006**: Repository MUST expose: `listEmployees`, `getEmployeeById`, `createEmployee`, `updateEmployee`, `deleteEmployee`.
- **FR-007**: Application queries MUST use a shared connection pool separate from the health probe connection.
- **FR-008**: Duplicate email violations MUST map to HTTP `409` with code `DUPLICATE_EMAIL` at the route boundary.
- **FR-009**: Dev-only seed and reset scripts MUST be documented and guarded against non-local misuse.
- **FR-010**: CI MAY mock repository until Postgres service container is available; at least one local integration test path MUST exercise real SQL.

### Key Entities *(include if feature involves data)*

- **Employee (persistence)**: Row in `employees` table; see [`data-model.md`](data-model.md).
- **SchemaMigration**: Record in `schema_migrations` tracking applied migration IDs.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Migrations apply cleanly on fresh DB in 100% of documented setup runs.
- **SC-002**: Repository CRUD + list filter scenarios pass in local integration tests.
- **SC-003**: No SQL strings appear in route handler modules (static review or lint rule).
- **SC-004**: Name search and department filter queries use indexes as defined in initial migration.

## Assumptions

- Spec 008 defines API contract and UI; this spec owns BE persistence only.
- Existing `POSTGRES_*` env vars from spec 002 remain sufficient for v1.
- Forward-only migrations are acceptable for early feature velocity.
- Hard delete (no soft-delete column) is sufficient for v1.

## Dependencies

- Spec 002 — Postgres connectivity baseline and health probe.
- Spec 008 — Employee API shapes and CRUD routes (consumer of this repository).

## Related documents

- [`data-architecture.md`](data-architecture.md) — layer boundaries, mapping, query strategy
- [`database-management.md`](database-management.md) — migrations, seeds, operational practices
- [`data-model.md`](data-model.md) — table DDL and field definitions
- [`../008-employee-crud-mui/contracts/openapi.yaml`](../008-employee-crud-mui/contracts/openapi.yaml) — API contract (spec 008)
