# Contract: Health API

**Endpoint**: `GET /health`  
**Content-Type**: `application/json`

## Request

No body. Optional headers:

| Header | Value |
|--------|-------|
| `Accept` | `application/json` |

## Response — 200 OK

```json
{
  "status": "ok",
  "timestamp": "2026-05-27T12:00:00.000Z",
  "message": "Service is healthy"
}
```

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
    }),
  ),
]
```

Handlers SHOULD match requests to `GET /health` reliably across environments (for example by matching request pathname), so the same contract works for both mocked and live flows.

## Client

- Type: `HealthStatus` in `src/services/healthApi.ts`
- Function: `fetchHealthStatus()` — uses `fetch`; no branching on mock vs live beyond MSW interception
