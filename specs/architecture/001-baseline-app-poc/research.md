# Research: Baseline UI POC — API Mocking

## Decision

Use **Mock Service Worker (MSW)** as the sole API mocking layer for the baseline health contract in development and automated tests.

## Rationale

- **Realistic network path**: MSW intercepts `fetch` at the HTTP layer, so `fetchHealthStatus` stays unchanged between mocked and live modes.
- **Dev and test parity**: The same handlers run in the browser (service worker) and in Bun tests (`setupServer`), reducing drift between local UI work and CI.
- **Contract fidelity**: Handlers return JSON bodies that match `HealthStatus`, making contract violations visible in tests.
- **Ecosystem fit**: MSW is widely used with Vite + React and documents first-class browser and Node test setups.

## Alternatives Considered

- **In-memory mock factory** (`createMockHealthApi`): Rejected because it bypasses `fetch`, hides URL/header bugs, and duplicates the contract outside HTTP semantics.
- **Vite dev-server proxy only**: Rejected because it does not help unit/integration tests and still requires custom stub logic per endpoint.
- **Manual `global.fetch` stubs in tests**: Rejected as brittle and harder to share with development mocking.

## MSW Configuration Notes

- Run `msw init public` once to add `mockServiceWorker.js` under `public/`.
- Use `bun run dev:mock` (`vite --mode mock`) to start the browser worker; do not use a separate MSW env flag.
- Prefer `onUnhandledRequest: 'bypass'` so non-health assets and HMR are not blocked.
- Match handler URLs to `buildHealthUrl()` (respect `VITE_API_BASE_URL` and `/health` path).
