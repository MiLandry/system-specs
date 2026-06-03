# Quickstart: GraphQL + Apollo (spec 010)

## Prerequisites

- `employee-manager-be` running with Postgres (see spec 009 quickstart).
- `employee-manager-fe` dependencies installed (`bun install`).

## Environment

**Backend** — unchanged (`PORT=3000`).

**Frontend** (`.env` or `.env.example`):

| Variable | Default | Purpose |
|----------|---------|---------|
| `VITE_GRAPHQL_URL` | `http://localhost:3000/graphql` | Apollo `HttpLink` endpoint |
| `VITE_MOCK_USER_ID` | `u-dev` | Mock auth header |
| `VITE_MOCK_ROLES` | `admin` | Default mock role |

## Regenerate GraphQL types

From `employee-manager-fe`:

```bash
bun run codegen:api
```

## Live backend

```bash
# terminal 1 — BFF
cd employee-manager-be && bun run dev

# terminal 2 — UI
cd employee-manager-fe && bun run dev
```

Open the app; employee grid and health data load via `POST /graphql`.

Probe health manually:

```bash
curl -s -X POST http://localhost:3000/graphql \
  -H 'Content-Type: application/json' \
  -d '{"query":"{ health { status timestamp message db { status } } }"}'
```

## Mock mode (MSW)

```bash
cd employee-manager-fe && bun run dev:mock
```

MSW intercepts GraphQL at `VITE_GRAPHQL_URL` without a running BFF.

## Tests

```bash
cd employee-manager-be && bun test
cd employee-manager-fe && bun test
```
