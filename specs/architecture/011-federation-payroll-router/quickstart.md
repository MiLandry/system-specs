# Quickstart: Federated payroll (spec 011)

## Prerequisites

- PostgreSQL with databases `employee_management` and `employee_payroll`
- Docker (for Apollo Router)
- Bun in `employee-manager-router` (`bun run compose` uses `npx @apollo/rover`; no global `rover` required)

### Create `employee_payroll` (if needed)

`createdb` is not required. Use whichever matches how you run Postgres:

```bash
# psql (Postgres.app, Homebrew server, or remote)
psql -U postgres -h localhost -c "CREATE DATABASE employee_payroll;"

# Docker (replace container name)
docker exec -it postgres psql -U postgres -c "CREATE DATABASE employee_payroll;"

# Homebrew libpq only (adds createdb to PATH)
brew install libpq
export PATH="$(brew --prefix libpq)/bin:$PATH"
createdb -h localhost -U postgres employee_payroll
```

## 1. Employees subgraph

```bash
cd employee-manager-be
cp .env.example .env
bun install
bun run db:migrate
bun run db:seed    # uses stable employee UUIDs for federation
bun run dev        # http://localhost:3000/graphql
```

## 2. Payroll subgraph

```bash
cd employee-manager-payroll-be
cp .env.example .env
bun install
bun run db:migrate
bun run db:seed
bun run dev        # http://localhost:3001/graphql
```

## 3. Apollo Router

```bash
cd employee-manager-router
bun run compose    # optional if supergraph.graphql unchanged; first run downloads Rover via npx
bun run dev        # http://localhost:4000/graphql
```

## 4. Frontend

```bash
cd employee-manager-fe
cp .env.example .env   # VITE_GRAPHQL_URL=http://localhost:4000/graphql
bun install
bun run codegen:graphql
bun run dev
```

Use mock role **admin** to see Pay grade and Annual base columns (payroll subgraph policy).

## Verify federation

```bash
curl -s http://localhost:4000/graphql \
  -H 'Content-Type: application/json' \
  -H 'x-mock-user-id: u-admin' \
  -H 'x-mock-roles: admin' \
  -d '{"query":"{ employees { id fullName compensationSummary { payGrade annualBase } } }"}'
```

## Mock mode (MSW)

`bun run dev:mock` does not run the router; MSW returns payroll fields on the employee list for local UI work without subgraphs.
