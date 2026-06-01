# Data Model: Baseline UI POC

## HealthStatus

Represents the JSON payload returned by `GET /health`.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `status` | `'ok' \| 'error'` | Yes | Overall health indicator |
| `timestamp` | `string` (ISO-8601) | Yes | Time the health check was produced |
| `message` | `string` | No | Human-readable detail for the UI |

### Validation Rules

- `status` and `timestamp` MUST be present and non-empty strings.
- Invalid payloads MUST cause `fetchHealthStatus` to throw so the UI can show an error state.

### MSW Handler Defaults (development)

When MSW is enabled and no backend is running, the default success handler SHOULD return:

```json
{
  "status": "ok",
  "timestamp": "<ISO-8601>",
  "message": "MSW mock backend connectivity confirmed."
}
```

## Other Entities

No persistent storage or additional domain entities are required for this POC.
