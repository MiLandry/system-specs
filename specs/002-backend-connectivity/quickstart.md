# Quickstart: Spec 002 — Backend connectivity POC

Manual verification only — **CI pipelines are out of scope** for this spec (see [`spec.md`](spec.md)).

## Step 1 — Contract

Verify OpenAPI locally from the `system-specs` checkout:

```bash
cd path/to/system-specs
bunx @redocly/cli lint specs/002-backend-connectivity/contracts/openapi.yaml
```

Preview (optional):

```bash
cd path/to/system-specs
bunx @redocly/cli preview-docs specs/002-backend-connectivity/contracts/openapi.yaml
```

## Step 2 — Backend (`employee-manager-be`)

```bash
cd path/to/employee-manager-be
bun install
cp .env.example .env
# Configure all POSTGRES_* vars and ensure Postgres is running with that database.
bun run dev   # exits immediately with code 1 if the DB is unreachable
```

(Optional) run backend tests:

```bash
cd path/to/employee-manager-be
bun test
```

Optional: regenerate frontend types whenever the OpenAPI file changes (`employee-manager-fe`):

```bash
cd path/to/employee-manager-fe
bun run codegen:api
```

## Step 3 — Frontend live (`employee-manager-fe`, no MSW)

```bash
cd path/to/employee-manager-fe
bun install
cp .env.example .env   # ensure VITE_API_BASE_URL matches the backend PORT
bun run dev            # plain dev — MSW off
```

Expected: baseline UI shows **Connected** with **`db.status: up`**. Non-healthy backend states return **503** (and the BFF shuts down afterward), which the frontend surfaces as **Connection failed**.

## Step 4 — Mock mode (`employee-manager-fe`)

```bash
cd path/to/employee-manager-fe
bun run dev:mock
```
