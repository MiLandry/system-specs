# Contract: Health API

**Endpoint**: `GET /health`  
**Content-Type**: `application/json`

## Request

No body. Optional headers:

| Header | Value |
|--------|-------|
| `Accept` | `application/json` |

Canonical machine-readable contract for this endpoint: [Spec 002 OpenAPI](../002-backend-connectivity/contracts/openapi.yaml) (`HealthResponse` schema).

## Response — 200 OK

```json
{
  "status": "ok",
  "timestamp": "2026-05-27T12:00:00.000Z",
  "message": "Service is healthy",
  "db": {
    "status": "up"
  }
}
```

`db` MUST be present on successful (**200**) responses when using the reference BFF. For **200**, `db.status` is **`up`** (Postgres reachable). Database failures after startup yield **503** with an [`ApiError`](../002-backend-connectivity/contracts/openapi.yaml) body, not `HealthResponse`.

## Response — 503 Service Unavailable (live BFF)

When Postgres is unreachable **after** the server has bound, the BFF responds with **503** and a JSON **`ApiError`** (for example `code: DATABASE_UNAVAILABLE`). The reference backend then shuts down shortly after responding.

```json
{
  "error": "Database unavailable: connection refused",
  "code": "DATABASE_UNAVAILABLE"
}
```

## Historical example (spec 001 baseline)

```json
{
  "status": "ok",
  "timestamp": "2026-05-27T12:00:00.000Z",
  "message": "Service is healthy"
}
```

When `db` was not yet in the contract, the frontend only required `status` and `timestamp`.

## Response — Error (non-2xx)

The frontend treats any non-OK HTTP status as a failed health check and surfaces the status, status text, and response body text to the user.

## MSW Mocking

When running `bun run dev:mock`, MSW handlers in `employee-manager-fe/src/mocks/handlers/health.ts` MUST implement this contract for requests to `GET /health`.

Example handler shape (illustrative):

```ts
import { http, HttpResponse } from 'msw'

export const healthHandlers = [
  http.get(({ request }) => new URL(request.url).pathname === '/health', () =>
    HttpResponse.json({
      status: 'ok',
      timestamp: new Date().toISOString(),
      message: 'MSW mock backend connectivity confirmed.',
      db: { status: 'up' },
    }),
  ),
]
```

Handlers SHOULD match requests to `GET /health` reliably across environments (for example by matching request pathname), so the same contract works for both mocked and live flows.

## Client

- Type: `HealthStatus` in `src/services/healthApi.ts`
- Function: `fetchHealthStatus()` — uses `fetch`; no branching on mock vs live beyond MSW interception
