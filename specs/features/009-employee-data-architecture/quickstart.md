# Quickstart: Spec 009 — Employee Data Architecture

Manual verification guide for persistence layer after implementation.

## Prerequisites

- PostgreSQL available locally
- `.specify/scripts/setup-postgres.sh` run once
- `employee-manager-be` `.env` configured with `POSTGRES_*`

## Step 1 — Provision database

```bash
cd path/to/system-specs
.specify/scripts/setup-postgres.sh
```

## Step 2 — Apply migrations

```bash
cd path/to/employee-manager-be
cp .env.example .env   # if needed
bun run db:migrate
```

Expected: `employees` table and indexes exist; `schema_migrations` records `001_create_employees`.

## Step 3 — Seed dev data (optional)

```bash
bun run db:seed
```

Expected: sample employees across at least 3 departments; re-run is idempotent.

## Step 4 — Verify repository integration tests

```bash
bun test tests/employeesRepository.test.ts
```

Requires local Postgres with migrated schema.

## Step 5 — Smoke via spec 008 routes (after both specs implemented)

With backend running and mock auth headers, list employees via `GET /employees/list` (see spec 008 quickstart).

## Reset local data

```bash
bun run db:reset   # local guard only
bun run db:seed
```

## Related documents

- [`database-management.md`](database-management.md) — full migration and operational strategy
- [`data-architecture.md`](data-architecture.md) — layer boundaries
- [`../008-employee-crud-mui/quickstart.md`](../008-employee-crud-mui/quickstart.md) — CRUD UI/API verification
