# Quickstart: Spec 008 — Employee CRUD with Material UI Data Grid

Manual verification guide for employee CRUD after implementation.

## Prerequisites

- Postgres running and employee schema applied (see spec 009 quickstart)
- Backend and frontend dev servers available
- Mock auth headers available (spec 006)

## Step 1 — Validate contract

```bash
cd path/to/system-specs
bunx @redocly/cli lint specs/features/008-employee-crud-mui/contracts/openapi.yaml --skip-rule security-defined
```

## Step 2 — Start backend

```bash
cd path/to/employee-manager-be
bun run dev
```

## Step 3 — List and mutate employees via API (admin)

```bash
curl -s \
  -H "x-mock-user-id: u-admin" \
  -H "x-mock-roles: admin" \
  "http://localhost:3000/employees/list"
```

## Step 4 — Verify search, filter, and role enforcement

See examples in spec 008 acceptance scenarios; viewer delete MUST return `403`.

## Step 5 — Frontend root page

```bash
cd path/to/employee-manager-fe
bun run dev
```

Expected on `/`: Material UI Data Grid, search/filter controls, role-gated CRUD actions.

## Step 6 — Automated tests

```bash
cd path/to/employee-manager-be && bun test
cd path/to/employee-manager-fe && bun test
```
