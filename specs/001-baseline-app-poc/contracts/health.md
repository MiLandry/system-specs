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

The frontend treats any non-OK HTTP status as a failed health check and surfaces the status text to the user.

## MSW Mocking

When `VITE_ENABLE_MSW=true`, MSW handlers in `employee-manager-fe/src/mocks/handlers/health.ts` MUST implement this contract for the configured base URL.

Example handler shape (illustrative):

```ts
import { http, HttpResponse } from 'msw'

export const healthHandlers = [
  http.get('http://localhost:3000/health', () =>
    HttpResponse.json({
      status: 'ok',
      timestamp: new Date().toISOString(),
      message: 'MSW mock backend connectivity confirmed.',
    }),
  ),
]
```

Handlers SHOULD be parameterized to match `VITE_API_BASE_URL` so the same contract works across environments.

## Client

- Type: `HealthStatus` in `src/services/healthApi.ts`
- Function: `fetchHealthStatus()` — uses `fetch`; no branching on mock vs live beyond MSW interception
