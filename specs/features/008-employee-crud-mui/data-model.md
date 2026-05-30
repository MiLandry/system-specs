# Data Model: Employee CRUD (application layer)

Application-level entity and UI state definitions for spec 008. Persistence schema and migration strategy are defined in spec 009.

## Employee

Represents a workforce record displayed in the root-page Data Grid and edited via create/update dialogs.

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

### Search and filter semantics

- **Name search**: case-insensitive substring match on `fullName`.
- **Department filter**: exact match on `department` when filter value is provided.
- When both are present, results MUST satisfy both conditions (AND).

## EmployeeGridView (frontend state)

| State | Type | Description |
|-------|------|-------------|
| `rows` | `Employee[]` | Current grid data |
| `searchQuery` | `string` | Name search input |
| `departmentFilter` | `string \| ''` | Selected department or empty for all |
| `loading` | `boolean` | Fetch in progress |
| `error` | `string \| null` | Last fetch/mutation error |
| `dialogMode` | `'create' \| 'edit' \| 'delete' \| null` | Active dialog |
| `selectedEmployee` | `Employee \| null` | Row targeted for edit/delete |

## EmployeeRolePermission

Maps auth roles to allowed employee actions (mirrors BE policy).

| Role | read | create | update | delete |
|------|------|--------|--------|--------|
| admin | yes | yes | yes | yes |
| manager | yes | no | yes | no |
| viewer | yes | no | no | no |

## ApiError (reuse)

Employee endpoints reuse spec 002 `ApiError` shape for failures:

- `401` / `403` authorization failures (`UNAUTHENTICATED`, `FORBIDDEN`)
- `400` validation failures (`VALIDATION_ERROR`)
- `409` duplicate email (`DUPLICATE_EMAIL`)
