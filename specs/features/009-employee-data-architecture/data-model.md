# Data Model: Employee Persistence

Entity field definitions and initial table DDL for spec 009.

For layer boundaries, naming, and repository responsibilities see [`data-architecture.md`](data-architecture.md).  
For migrations, seeds, and operational DB practices see [`database-management.md`](database-management.md).

API field names align with spec 008 OpenAPI contract.

## Employee

Represents a workforce record persisted in PostgreSQL.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` (UUID) | Yes | Stable identifier |
| `fullName` | `string` | Yes | Display name; searchable |
| `email` | `string` (email) | Yes | Unique official email |
| `department` | `string` | Yes | Organizational unit; filterable |
| `jobTitle` | `string` | Yes | Role/title |
| `employmentStatus` | `'active' \| 'inactive' \| 'on_leave'` | Yes | Employment state |
| `managerName` | `string` | Yes | Direct manager display name |
| `startDate` | `string` (date) | Yes | ISO date (`YYYY-MM-DD`) |
| `phone` | `string` | No | Contact phone |
| `location` | `string` | No | Office or region |
| `createdAt` | `string` (date-time) | Yes (system) | Record creation timestamp |
| `updatedAt` | `string` (date-time) | Yes (system) | Last update timestamp |

### Validation rules

- `fullName`, `email`, `department`, `jobTitle`, `employmentStatus`, `managerName`, `startDate` MUST be present on create.
- `email` MUST be valid format and unique across employees.
- `employmentStatus` MUST be one of the enum values.
- Updates MUST re-validate required fields; partial patches are not supported in v1 (full replace on edit).

### Search and filter semantics (repository)

- **Name search**: case-insensitive substring match on `full_name`.
- **Department filter**: exact match on `department` when filter value is provided.
- When both are present, results MUST satisfy both conditions (AND).

## PostgreSQL schema (initial migration)

Migration file: `001_create_employees.sql` (see [`database-management.md`](database-management.md)).

```sql
CREATE TABLE employees (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  full_name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  department TEXT NOT NULL,
  job_title TEXT NOT NULL,
  employment_status TEXT NOT NULL CHECK (employment_status IN ('active', 'inactive', 'on_leave')),
  manager_name TEXT NOT NULL,
  start_date DATE NOT NULL,
  phone TEXT,
  location TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_employees_full_name ON employees (LOWER(full_name));
CREATE INDEX idx_employees_department ON employees (department);
```

## SchemaMigration

| Field | Type | Description |
|-------|------|-------------|
| `id` | `TEXT` | Migration file basename (e.g., `001_create_employees`) |
| `applied_at` | `TIMESTAMPTZ` | When migration was applied |

## Error codes at persistence boundary

| Condition | Suggested HTTP mapping (route layer) |
|-----------|--------------------------------------|
| Unique violation on `email` | `409 DUPLICATE_EMAIL` |
| Row not found | `404 NOT_FOUND` |
| Query/connection failure | `500` (logged) |
