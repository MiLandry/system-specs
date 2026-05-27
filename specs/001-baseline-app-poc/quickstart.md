# Quickstart: Baseline UI POC

Target repository: `employee-manager-fe`

## Install Dependencies

```bash
cd employee-manager-fe
bun install
cp .env.example .env
```

## Initialize MSW (first-time setup)

```bash
bun run msw:init
```

This creates `public/mockServiceWorker.js`, required for browser interception during development.

## Mode A — UI development with MSW (no backend)

```bash
bun run dev:mock
```

Expected behavior:

- Vite serves the baseline app.
- MSW intercepts `GET /health` and returns the mocked `HealthStatus` payload.
- The baseline page shows a successful connectivity message without a running BFF.

Optional: override API base URL (the current MSW handler matches `GET /health` by pathname, so this is typically not required for mocking):

```bash
VITE_API_BASE_URL=http://localhost:3000 bun run dev:mock
```

## Mode B — Live backend health check

1. Start the backend per [spec 002 quickstart](../002-backend-connectivity/quickstart.md) (Postgres + `employee-manager-be` on port `3000`).
2. Run the frontend **without** MSW:

```bash
bun run dev
```

Expected behavior:

- The baseline page calls `GET {VITE_API_BASE_URL}/health`.
- A healthy backend returns `status: "ok"` with `db.status: "up"` (spec 002 contract) and the UI shows success.

## Clean and nuke

Target repository: `employee-manager-fe`. Scripts live under `scripts/` (`clean.ts`, `nuke.ts`, `paths.ts`).

Remove build artifacts only (fast):

```bash
cd employee-manager-fe
bun run clean
```

Deep reset (removes `node_modules`, reinstalls from `bun.lock`):

```bash
cd employee-manager-fe
bun run nuke
```

| Command | Removes | Keeps |
|---------|---------|-------|
| `bun run clean` | `dist/`, `dist-ssr/`, `src/generated/` (OpenAPI client from spec 002), `node_modules/.tmp/`, `node_modules/.vite/` | `node_modules/`, hand-written `src/`, `bun.lock`, `.env` |
| `bun run nuke` | everything `clean` removes, plus `node_modules/` (then `bun install`) | hand-written `src/`, `tests/`, `public/`, `bun.lock`, `.env` |

After `clean` or `nuke`, run `bun run build:app` or `bun run dev` to regenerate `src/generated/openapi.ts` (`prebuild:app`). After `nuke`, run `bun run dev` or `bun run dev:mock` as usual. You do not need `msw:init` again unless you deleted `public/mockServiceWorker.js`.

## Run Tests

```bash
bun test
```

Tests SHOULD use MSW `setupServer` with the same handlers as development so `fetchHealthStatus` is exercised over HTTP.

## Verification Checklist

- [x] Baseline page loads at the Vite dev URL.
- [x] With `bun run dev:mock`, health status renders without a backend.
- [x] With MSW disabled and backend running, health status reflects the live BFF response.
- [x] With MSW disabled and backend stopped, the UI surfaces a fetch or HTTP error clearly.
- [x] `bun run build:app` and `bun run lint` succeed.
- [x] `bun run clean` removes `dist/` and `src/generated/`; `bun run build:app` regenerates the client; `bun test` still passes without reinstall.
- [x] `bun run nuke` reinstalls dependencies; `bun test` and `bun run build:app` succeed afterward.
