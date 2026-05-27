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

Optional: override the mocked base URL if handlers use absolute URLs:

```bash
VITE_API_BASE_URL=http://localhost:3000 bun run dev:mock
```

## Mode B — Live backend health check

1. Start the backend (BFF) on the expected port (default `http://localhost:3000`).
2. Run the frontend **without** MSW:

```bash
bun run dev
```

Expected behavior:

- The baseline page calls `GET {VITE_API_BASE_URL}/health`.
- A healthy backend returns `status: "ok"` and the UI shows success.

## Clean and nuke

Remove build artifacts only (fast):

```bash
bun run clean
```

Deep reset (removes `node_modules`, reinstalls from `bun.lock`):

```bash
bun run nuke
```

Expected behavior:

- `clean` deletes `dist/`, `dist-ssr/`, `node_modules/.tmp/`, and `node_modules/.vite/`; source and `node_modules` packages remain.
- `nuke` runs `clean`, deletes `node_modules/`, then runs `bun install`. Keeps `bun.lock`, `.env`, and `public/mockServiceWorker.js`.

## Run Tests

```bash
bun test
```

Tests SHOULD use MSW `setupServer` with the same handlers as development so `fetchHealthStatus` is exercised over HTTP.

## Verification Checklist

- [ ] Baseline page loads at the Vite dev URL.
- [ ] With `bun run dev:mock`, health status renders without a backend.
- [ ] With MSW disabled and backend running, health status reflects the live BFF response.
- [ ] With MSW disabled and backend stopped, the UI surfaces a fetch or HTTP error clearly.
- [ ] `bun run build:app` and `bun run lint` succeed.
- [ ] `bun run clean` removes `dist/`; `bun test` still passes without reinstall.
- [ ] `bun run nuke` reinstalls dependencies; `bun test` and `bun run build:app` succeed afterward.
