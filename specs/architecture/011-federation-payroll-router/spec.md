# Specification: Federated payroll subgraph + Apollo Router (spec 011)

**Status**: Active  
**Scope**: Split payroll compensation data into a dedicated subgraph; expose a single federated GraphQL API via Apollo Router for the UI.

## Goals

1. **Employees subgraph** (`employee-manager-be`, port 3000) owns `Employee @key(fields: "id")`, health, and employee CRUD.
2. **Payroll subgraph** (`employee-manager-payroll-be`, port 3001) extends `Employee` with read-only compensation fields; separate `employee_payroll` database.
3. **Apollo Router** (`employee-manager-router`, port 4000) composes subgraphs; frontend uses `VITE_GRAPHQL_URL=http://localhost:4000/graphql`.
4. Payroll field auth: only `admin` mock role may read `compensationSummary` and `lastPayStub`.

## Subgraph contracts

- SDL sources of truth for composition: `employee-manager-router/subgraphs/*.graphql`
- Composed supergraph: `employee-manager-router/supergraph.graphql` (regenerate with `bun run compose` in router package)

## Behavior

### Payroll fields on Employee

- `compensationSummary { payGrade, currency, annualBase }`
- `lastPayStub { periodEnd, netPay, currency }`

### Seeding

Employee seed IDs in employees DB must match payroll seed `employee_id` values (`11111111-…`, `22222222-…`, `33333333-…`).

## Out of scope

- Pay run mutations, tax engines, or external payroll providers.
- Migrating `/users` REST to federation.
- GraphOS Studio / managed federation (local Rover compose only).

## Acceptance criteria

- Router serves stitched queries joining `employees` and payroll fields.
- Payroll subgraph tests cover admin vs viewer on `_entities`.
- Frontend codegen uses `supergraph.graphql`; employee grid shows pay columns for admin only.
- `quickstart.md` documents four-process local dev (employees, payroll, router, FE).
