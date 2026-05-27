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

Stop the dev server (process bound to `PORT` in `.env`):

```bash
cd path/to/employee-manager-be
bun run stop
```

(Optional) run backend tests:

```bash
cd path/to/employee-manager-be
bun test
```

### Backend cleanup (`employee-manager-be`)

Remove build artifacts only:

```bash
cd path/to/employee-manager-be
bun run clean
```

Deep reset (removes `node_modules`, reinstalls from `bun.lock`):

```bash
cd path/to/employee-manager-be
bun run nuke
```

| Command | Removes | Keeps |
|---------|---------|-------|
| `bun run clean` | `dist/`, `build/`, `node_modules/.cache/` | `node_modules/`, source, `bun.lock`, `.env` |
| `bun run nuke` | everything `clean` removes, plus `node_modules/` (then `bun install`) | `src/`, `tests/`, `bun.lock`, `.env` |

After `nuke`, run `bun run dev` again once Postgres is configured.

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

### Frontend cleanup (`employee-manager-fe`)

Same pattern as spec 001 — see [`../001-baseline-app-poc/quickstart.md`](../001-baseline-app-poc/quickstart.md#clean-and-nuke):

```bash
cd path/to/employee-manager-fe
bun run clean   # dist/, src/generated/, Vite/TS caches — keeps node_modules
bun run nuke    # clean + node_modules + bun install
```

After `clean` or `nuke`, run `bun run build:app` or `bun run dev` to regenerate `src/generated/openapi.ts`. After `nuke`, run `bun run dev` or `bun run dev:mock` as usual. Re-run `bun run msw:init` only if `public/mockServiceWorker.js` was deleted.
