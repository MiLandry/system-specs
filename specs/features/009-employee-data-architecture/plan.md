# Implementation Plan: Employee Data Architecture

**Branch**: `009-employee-data-architecture` | **Date**: 2026-05-30 | **Spec**: [`spec.md`](spec.md)  
**Input**: Feature specification from `/specs/features/009-employee-data-architecture/spec.md`

## Summary

Implement PostgreSQL persistence for employee CRUD: shared connection pool, versioned SQL migrations, `employeesRepository`, and dev seed/reset scripts in `employee-manager-be`. Spec 008 routes consume this repository.

## Technical Context

**Language/Version**: TypeScript ~5.9, Bun runtime  
**Primary Dependencies**: `postgres` npm package (existing), Zod (validation at route boundary in spec 008)  
**Storage**: PostgreSQL  
**Testing**: Bun test; repository integration tests against local Postgres; CI mocks until service container  
**Target Platform**: Local dev + future CI Postgres  
**Project Type**: `employee-manager-be` implementation; specs in `system-specs`

## Constitution Check

- **Gate 1 (Test-first)**: Failing repository integration tests before implementation.
- **Gate 2 (Simplicity)**: Plain SQL migrations, single repository module, no ORM.
- **Gate 3 (TypeScript safety)**: Typed row mappers; parameterized queries only.
- **Gate 4 (Documentation)**: `database-management.md`, `quickstart.md`, BE README updates.

## Project Structure

### Documentation (this feature)

```text
specs/features/009-employee-data-architecture/
├── spec.md
├── plan.md
├── research.md
├── data-architecture.md
├── database-management.md
├── data-model.md
├── quickstart.md
└── tasks.md
```

### Source Code (`employee-manager-be`)

```text
employee-manager-be/
├── src/db/
│   ├── connection.ts
│   ├── migrate.ts
│   ├── employeesRepository.ts
│   ├── migrations/
│   │   └── 001_create_employees.sql
│   └── seeds/
│       └── dev-employees.sql
├── scripts/
│   ├── db-migrate.ts
│   ├── db-seed.ts
│   └── db-reset.ts
└── tests/
    └── employeesRepository.test.ts
```

## Implementation Phases

### Phase 1 — Connection and migrations (P1)

1. Add `connection.ts` shared pool (separate from health probe).
2. Implement migration runner + `schema_migrations` table.
3. Add `001_create_employees.sql` per `data-model.md`.
4. Add `bun run db:migrate` script.

### Phase 2 — Repository (P1)

1. Implement `employeesRepository` with CRUD + filtered list.
2. Map snake_case rows ↔ camelCase domain types.
3. Map DB errors to repository result types for route layer.

### Phase 3 — Dev tooling (P2)

1. Dev seed script (3+ departments).
2. Local-only reset script with env guard.
3. Document workflow in `quickstart.md`.

### Phase 4 — Tests (P1)

1. Integration tests against local Postgres.
2. Migration runner unit test (mock or local).
3. Document CI mock strategy until Postgres service container.

## Dependencies

- **Blocks**: Spec 008 employee routes (real persistence).
- **Requires**: Spec 002 Postgres env and health probe baseline.

## Related specs

- Spec 008 — CRUD UI/API consumer
- Spec 007 — Future CI Postgres service container
