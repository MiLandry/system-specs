# Quickstart: Spec 002 — Backend connectivity POC

## Step 1 — Contract only (this step)

Verify the OpenAPI contract:

```bash
cd system-specs
bunx @redocly/cli lint specs/002-backend-connectivity/contracts/openapi.yaml
```

Optional: inspect the spec in a browser:

```bash
bunx @redocly/cli preview-docs specs/002-backend-connectivity/contracts/openapi.yaml
```

## Step 2 — Backend (next)

Scaffold `employee-manager-be` with Bun + Hono and implement `GET /health` per `contracts/openapi.yaml`.

## Step 3 — Frontend live mode

```bash
# Terminal 1 — backend (after step 2)
cd employee-manager-be
bun install
cp .env.example .env
bun run dev

# Terminal 2 — frontend (no MSW)
cd employee-manager-fe
bun run dev
```

Expected: baseline UI shows Connected with `status`, `timestamp`, and DB status when backend is up.

## Step 4 — Mock mode (unchanged)

```bash
cd employee-manager-fe
bun run dev:mock
```

MSW mocks must return a payload matching `HealthResponse` (including `db` after step 3).
