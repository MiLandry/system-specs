# Research: Employee Data Architecture

## Decision 1: Repository-only SQL access

All SQL lives in `employeesRepository`; route handlers call repository functions only.

### Rationale

- Clear boundary for testing and review.
- Prevents authorization bypass via ad-hoc queries in routes.
- Aligns with constitution simplicity and layered architecture.

## Decision 2: camelCase API / snake_case DB mapping in repository

Single mapping layer converts between OpenAPI field names (spec 008) and PostgreSQL columns.

### Rationale

- Matches JavaScript/TypeScript conventions at API boundary.
- Matches PostgreSQL naming conventions in schema.
- Avoids ORM magic while keeping mapping explicit and testable.

## Decision 3: Shared connection pool separate from health probe

Health probe keeps short-lived `SELECT 1`; repository uses pooled connections.

### Rationale

- Spec 002 probe is intentionally lightweight.
- CRUD workloads benefit from connection reuse without conflating health semantics.

## Decision 4: Versioned SQL migrations with lightweight runner

Use ordered SQL files + `schema_migrations` table tracked by a Bun migration script (no ORM framework in v1).

### Rationale

- Aligns with simplicity-first constitution and existing `postgres` driver usage.
- Keeps schema changes reviewable as plain SQL in PRs.
- Forward-only migration policy is sufficient for early feature velocity.

See [`database-management.md`](database-management.md) for full operational rules.

### Alternatives considered

- **Prisma/Drizzle migrations**: Deferred — adds tooling surface area before team needs it.
- **Manual psql only**: Rejected — not repeatable across dev/CI environments.

## Decision 5: CI mocks repository until Postgres service container

Route tests in CI use mocked repository; SQL integration tests run locally.

### Rationale

- Current CI (spec 003) has no Postgres service container.
- Roadmap spec 007 covers adding ephemeral Postgres in CI later.

## Open questions (non-blocking)

- **Soft delete**: Deferred; v1 uses hard delete.
- **Separate migration DB role**: Deferred to production hardening.
