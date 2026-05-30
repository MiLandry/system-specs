# Tasks: Employee Data Architecture (spec 009)

**Input**: Design documents from `/specs/features/009-employee-data-architecture/`  
**Prerequisites**: `spec.md`, `plan.md`, `data-architecture.md`, `database-management.md`, `data-model.md` (required)

**Implementation repo**: `employee-manager-be`  
**Spec repo**: `system-specs`

**Tests**: Required per constitution (test-first) and spec FR-010. Repository integration tests run locally against Postgres; CI continues to skip DB-backed tests until spec 007 service container.

**Organization**: Tasks grouped by user story (`US1`–`US3`) for independent delivery and validation.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no direct dependency)
- **[Story]**: User story label from `spec.md`
- Include exact file paths in each task description

---

## Phase 1: Setup (Shared Foundations)

**Purpose**: Confirm scope, baseline paths, and local Postgres readiness.

- [ ] T001 Review spec 009 scope and out-of-scope items in `system-specs/specs/features/009-employee-data-architecture/spec.md` (no route handlers, no FE work)
- [ ] T002 Review existing health probe pattern in `employee-manager-be/src/db/probe.ts` and env loading in `employee-manager-be/src/env.ts`
- [ ] T003 Verify local Postgres via `system-specs/.specify/scripts/setup-postgres.sh` and `employee-manager-be/.env` (`POSTGRES_*`)

**Checkpoint**: Persistence work is scoped to `employee-manager-be`; local DB is reachable.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Shared DB config, connection pool, migration runner, and initial schema. **Blocks all user stories.**

**⚠️ CRITICAL**: No repository or seed work until this phase completes.

- [ ] T004 [P] Add shared Postgres config helper in `employee-manager-be/src/db/config.ts` (host/port/user/password/database from `AppEnv`)
- [ ] T005 Refactor `employee-manager-be/src/db/probe.ts` to use `config.ts` (preserve short-lived probe behavior)
- [ ] T006 Add shared connection pool factory in `employee-manager-be/src/db/connection.ts` (`max: 10`, separate from probe)
- [ ] T007 [P] Add migration SQL `001_create_employees.sql` in `employee-manager-be/src/db/migrations/001_create_employees.sql` per `data-model.md` DDL and indexes
- [ ] T008 [P] Add migrations README in `employee-manager-be/src/db/migrations/README.md` (naming, forward-only policy)
- [ ] T009 Implement migration runner in `employee-manager-be/src/db/migrate.ts` (`schema_migrations` table, ordered apply, fail-fast, no partial record on error)
- [ ] T010 Add CLI entry `employee-manager-be/scripts/db-migrate.ts` and wire `db:migrate` in `employee-manager-be/package.json`
- [ ] T011 Write migration runner tests in `employee-manager-be/tests/db/migrate.test.ts` (RED then GREEN: idempotent re-run, ordered apply)
- [ ] T012 Manual verify: `bun run db:migrate` creates `employees` + `schema_migrations` on fresh local DB

**Checkpoint**: Migrations apply cleanly; pool exists; probe unchanged in behavior.

---

## Phase 3: User Story 1 — Persist employee records reliably (Priority: P1) 🎯 MVP

**Goal**: Repository CRUD with camelCase ↔ snake_case mapping and typed error signals.

**Independent Test**: After migrate, call repository create/get/update/delete against real Postgres; duplicate email surfaces repository error for route mapping.

### Tests for User Story 1 (write first — RED)

- [ ] T013 [P] [US1] Add domain types in `employee-manager-be/src/db/employees/types.ts` (`Employee`, `CreateEmployeeInput`, `UpdateEmployeeInput`, filter types)
- [ ] T014 [P] [US1] Add repository error types in `employee-manager-be/src/db/employees/errors.ts` (`DuplicateEmailError`, `NotFoundError`, generic `RepositoryError`)
- [ ] T015 [US1] Write integration tests in `employee-manager-be/tests/db/employeesRepository.crud.test.ts` (RED: create, getById, update refreshes `updatedAt`, delete, duplicate email, not-found update/delete)
- [ ] T016 [US1] Gate integration tests on local Postgres env (skip or `describe.skip` when `POSTGRES_*` unavailable so CI stays green)

### Implementation for User Story 1

- [ ] T017 [US1] Add row mapper helpers in `employee-manager-be/src/db/employees/mapRow.ts` (snake_case DB row → camelCase `Employee`)
- [ ] T018 [US1] Implement `createEmployee`, `getEmployeeById`, `updateEmployee`, `deleteEmployee` in `employee-manager-be/src/db/employeesRepository.ts` (parameterized SQL only)
- [ ] T019 [US1] Map Postgres unique violation on `email` to `DuplicateEmailError` in `employeesRepository.ts`
- [ ] T020 [US1] Map zero-row update/delete to `NotFoundError` in `employeesRepository.ts`
- [ ] T021 [US1] Ensure `updateEmployee` sets `updated_at = NOW()` on successful update (GREEN tests)

**Checkpoint**: US1 repository CRUD passes local integration tests after `bun run db:migrate`.

---

## Phase 4: User Story 2 — Search and filter at the data layer (Priority: P2)

**Goal**: `listEmployees` supports name substring and department filter with AND semantics.

**Independent Test**: Seed or insert rows across departments; verify filter combinations without route layer.

### Tests for User Story 2 (write first — RED)

- [ ] T022 [US2] Extend `employee-manager-be/tests/db/employeesRepository.list.test.ts` (RED: name case-insensitive match, department exact match, combined AND, default sort `fullName ASC`)

### Implementation for User Story 2

- [ ] T023 [US2] Implement `listEmployees(filters?)` in `employee-manager-be/src/db/employeesRepository.ts` with parameterized `LOWER(full_name) LIKE` and `department = $n`
- [ ] T024 [US2] Export list filter type from `employee-manager-be/src/db/employees/types.ts` aligned with spec 008 query param names (`name`, `department`)
- [ ] T025 [US2] GREEN list/filter integration tests in `employeesRepository.list.test.ts`

**Checkpoint**: List queries pass; indexes from `001_create_employees.sql` support search/filter paths.

---

## Phase 5: User Story 3 — Operate database changes safely (Priority: P3)

**Goal**: Dev seed/reset scripts with guards; idempotent migration and seed behavior documented.

**Independent Test**: Run migrate twice (no dup apply); run seed twice (no dup emails); reset refuses non-local without override.

### Tests for User Story 3 (write first — RED)

- [ ] T026 [P] [US3] Add dev seed data SQL in `employee-manager-be/src/db/seeds/dev-employees.sql` (≥3 departments, `ON CONFLICT DO NOTHING` on email)
- [ ] T027 [US3] Write seed idempotency test in `employee-manager-be/tests/db/db-seed.test.ts` (RED: two runs, stable row count)
- [ ] T028 [US3] Write reset guard test in `employee-manager-be/tests/db/db-reset.test.ts` (RED: refuses without local override flag)

### Implementation for User Story 3

- [ ] T029 [US3] Implement `employee-manager-be/scripts/db-seed.ts` and wire `db:seed` in `employee-manager-be/package.json`
- [ ] T030 [US3] Implement `employee-manager-be/scripts/db-reset.ts` (truncate `employees` only) with local-env guard; wire `db:reset` in `package.json`
- [ ] T031 [US3] GREEN seed and reset tests; manual verify per `system-specs/specs/features/009-employee-data-architecture/quickstart.md`

**Checkpoint**: Local dev workflow migrate → seed → reset is repeatable and safe.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Documentation, export surface for spec 008, and handoff.

- [ ] T032 [P] Add public repository barrel export in `employee-manager-be/src/db/index.ts` (pool factory, repository functions, error types)
- [ ] T033 [P] Update `employee-manager-be/README.md` with `db:migrate`, `db:seed`, `db:reset` scripts and local Postgres prerequisites
- [ ] T034 [P] Document CI strategy (mock repository in route tests until Postgres service container) in `employee-manager-be/README.md`
- [ ] T035 Run full local suite: `bun run typecheck`, `bun test`, `bun run build` in `employee-manager-be`
- [ ] T036 Run quickstart validation steps in `system-specs/specs/features/009-employee-data-architecture/quickstart.md`
- [ ] T037 Confirm no SQL strings added to `employee-manager-be/src/app.ts` or future route modules (FR-003 static review)

**Checkpoint**: Spec 008 can consume `employeesRepository` from a stable export; docs match behavior.

---

## Dependencies & Execution Order

### Phase Dependencies

| Phase | Depends on | Delivers |
|-------|------------|----------|
| 1 Setup | — | Scope + local DB |
| 2 Foundational | Phase 1 | Pool, migrations, `db:migrate` |
| 3 US1 (P1) | Phase 2 | CRUD repository (MVP) |
| 4 US2 (P2) | Phase 3 | List search/filter |
| 5 US3 (P3) | Phase 2 (Phase 3 for seed data) | Seed/reset tooling |
| 6 Polish | Phases 3–5 | README, exports, validation |

### User Story Dependencies

- **US1 (P1)**: Requires Phase 2 only — **MVP stop point**.
- **US2 (P2)**: Requires US1 repository module (extends same file).
- **US3 (P3)**: Requires migrations (Phase 2); seed content assumes `employees` table from US1 path.

### Parallel Opportunities

- T004, T007, T008 can run in parallel after T002–T003.
- T013, T014 parallel before T015.
- T026 parallel with T027–T028 prep while US1 completes.
- T032–T034 parallel during polish.

---

## MVP Recommendation

Deliver **Phase 2 + Phase 3 (US1)** first:

1. Migrations + pool + `db:migrate`
2. Repository CRUD + integration tests

This unblocks spec 008 route implementation (with real persistence locally, mocked repository in CI).

Add **US2** before spec 008 grid search/filter endpoints. Add **US3** when local dev ergonomics matter for the team.

---

## Acceptance Criteria Mapping

| Spec criterion | Validated by |
|----------------|--------------|
| SC-001 Migrations on fresh DB | T011, T012 |
| SC-002 Repository CRUD + filters | T015–T025 |
| SC-003 No SQL in route handlers | T037 (FR-003; routes come in spec 008) |
| SC-004 Index-backed search/filter | T007, T023, T025 |
| FR-008 Duplicate email → route `409` | T019 (repository error); route mapping in spec 008 |
| FR-010 Local SQL integration path | T015–T016, T022, T027 |

---

## Notes

- Do **not** add employee HTTP routes in this spec — that is spec 008 scope.
- Reuse `postgres` package; do not introduce an ORM (see `research.md`).
- Integration tests MUST NOT break CI: skip when Postgres is unavailable.
- Commit in `employee-manager-be` on branch `feature/009-employee-data-architecture-be` (suggested); commit this `tasks.md` in `system-specs` on `009-employee-data-architecture` or follow-on docs branch.
