# Database Management Strategy: Employee Persistence

Defines how schema changes, local development, and operational database practices are managed for spec 009.

## Strategy summary

| Area | v1 decision |
|------|-------------|
| Database engine | PostgreSQL (already required by spec 002 BFF) |
| Schema evolution | Versioned SQL migration files, applied in order |
| Migration tooling | Lightweight Bun/TS runner (no ORM migration framework in v1) |
| Connection library | `postgres` npm package (same as health probe) |
| Local provisioning | Existing `.specify/scripts/setup-postgres.sh` + new migrate/seed scripts |
| CI database | Deferred — unit tests mock repository until Postgres service container is adopted |
| Production deploy | Manual/automated migration run before app start (documented, not automated in this spec) |

## Migration management

### File layout (`employee-manager-be`)

```text
employee-manager-be/
├── src/db/
│   ├── connection.ts          # Shared pool factory
│   ├── migrate.ts             # Applies pending migrations
│   └── migrations/
│       ├── 001_create_employees.sql
│       └── README.md
└── scripts/
    ├── db-migrate.ts          # bun run db:migrate
    └── db-seed.ts             # bun run db:seed (dev only)
```

### Naming convention

- `{sequence}_{description}.sql` (e.g., `001_create_employees.sql`)
- Sequences are zero-padded 3 digits
- One logical change per file; never edit applied migrations — add a new file instead

### Migration tracking table

Runner creates and maintains:

```sql
CREATE TABLE IF NOT EXISTS schema_migrations (
  id TEXT PRIMARY KEY,
  applied_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

Each migration file basename (e.g., `001_create_employees`) is recorded after successful apply.

### Apply workflow

```bash
cd employee-manager-be
bun run db:migrate
```

Behavior:

1. Connect using `POSTGRES_*` from `.env`
2. Ensure `schema_migrations` exists
3. Apply any migration IDs not yet recorded, in filename order
4. Fail fast on first SQL error (no partial record for failed file)

### Rollback policy (v1)

- **Forward-only migrations** in v1 (no automatic down migrations)
- Rollback = new forward migration that reverses change (e.g., `002_drop_employees.sql`) applied only in controlled environments
- Production rollback procedures documented in runbook, not automated here

## Local development workflow

### First-time setup

```bash
# From system-specs (creates role/database if needed)
.specify/scripts/setup-postgres.sh

cd employee-manager-be
cp .env.example .env
bun run db:migrate
bun run db:seed        # optional dev sample rows
bun run dev
```

### Reset local data (dev)

Preferred order:

1. `bun run db:reset` (future script: drop employee rows or truncate `employees`)
2. Re-run `bun run db:seed` if sample data is needed

Destructive reset scripts MUST NOT run against non-local environments unless explicitly forced via env flag.

## Seeding strategy

- Seeds live in `src/db/seeds/dev-employees.sql` or TS seed script
- **Dev-only** — never run automatically in production
- Idempotent where possible (`INSERT ... ON CONFLICT DO NOTHING` on email)
- Seed data covers at least 3 departments for filter testing

## Environment configuration

Reuse existing variables (no new secrets in v1):

| Variable | Purpose |
|----------|---------|
| `POSTGRES_HOST` | DB host |
| `POSTGRES_PORT` | DB port |
| `POSTGRES_USER` | App user |
| `POSTGRES_PASSWORD` | App password |
| `POSTGRES_DB` | Database name |

Optional future vars (not required v1):

- `DATABASE_URL` — single connection string override
- `DB_MIGRATE_ON_START` — opt-in auto-migrate for local only (default false)

## Operational practices

### Before deployment

1. Review pending migration files in PR
2. Run migrations against staging DB
3. Verify app startup + smoke CRUD
4. Apply migrations to production before rolling out app version that depends on them

### Backup and recovery

- v1 assumes managed Postgres or local dev; backup policy is environment-specific
- Minimum: document that employee data loss risk exists if migrations run without backup in shared environments

### Observability

- Log migration apply success/failure with migration ID
- Log repository errors with sanitized messages (no password/connection string leakage)
- Health probe (`GET /health`) continues to reflect DB connectivity; does not validate schema version

## CI and testing implications

Current CI (spec 003/005) does not provision Postgres for BE tests.

Until service-container Postgres is added:

- Route tests use mocked repository
- Repository SQL tests run locally as part of developer workflow
- Migration runner tested via unit test with mocked SQL executor OR local integration test

When CI Postgres is available (roadmap):

- CI job runs `bun run db:migrate` then repository integration tests against ephemeral DB

## Security considerations

- App DB user should have DML + DDL only where needed; prefer separate migration role in production later
- Parameterized queries only — no string-concatenated user input in SQL
- Least privilege: BFF DB user does not require superuser

## Package scripts (to add in implementation)

| Script | Purpose |
|--------|---------|
| `bun run db:migrate` | Apply pending migrations |
| `bun run db:seed` | Load dev seed data |
| `bun run db:reset` | Truncate employee tables (local dev guard) |

## Related documents

- [`spec.md`](spec.md) — feature requirements
- [`data-architecture.md`](data-architecture.md) — layer boundaries and mapping
- [`data-model.md`](data-model.md) — table definition
- [`quickstart.md`](quickstart.md) — verification steps
