# Quickstart: Baseline UI POC

Target repository: `employee-manager-fe`

## Install Dependencies

```bash
cd employee-manager-fe
yarn install
```

## Initialize MSW (first-time setup)

```bash
yarn msw init public
```

This creates `public/mockServiceWorker.js`, required for browser interception during development.

## Mode A — UI development with MSW (no backend)

```bash
VITE_ENABLE_MSW=true yarn dev
```

Expected behavior:

- Vite serves the baseline app.
- MSW intercepts `GET /health` and returns the mocked `HealthStatus` payload.
- The baseline page shows a successful connectivity message without a running BFF.

Optional: override the mocked base URL if handlers use absolute URLs:

```bash
VITE_ENABLE_MSW=true VITE_API_BASE_URL=http://localhost:3000 yarn dev
```

## Mode B — Live backend health check

1. Start the backend (BFF) on the expected port (default `http://localhost:3000`).
2. Run the frontend **without** MSW:

```bash
yarn dev
```

Expected behavior:

- The baseline page calls `GET {VITE_API_BASE_URL}/health`.
- A healthy backend returns `status: "ok"` and the UI shows success.

## Run Tests

```bash
yarn test
```

Tests SHOULD use MSW `setupServer` with the same handlers as development so `fetchHealthStatus` is exercised over HTTP.

## Verification Checklist

- [ ] Baseline page loads at the Vite dev URL.
- [ ] With `VITE_ENABLE_MSW=true`, health status renders without a backend.
- [ ] With MSW disabled and backend running, health status reflects the live BFF response.
- [ ] With MSW disabled and backend stopped, the UI surfaces a fetch or HTTP error clearly.
- [ ] `yarn build` and `yarn lint` succeed.
