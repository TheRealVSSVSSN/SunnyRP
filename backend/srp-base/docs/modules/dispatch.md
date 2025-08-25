# dispatch module

Provides storage and real-time distribution of police dispatch alerts and codes.

## Routes
| Method & Path | Description | Auth | Idempotent | Rate Limited | Request | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/dispatch/alerts`** | List recent alerts. | Required | No | No | None | `200 { ok, data: { alerts: DispatchAlert[] }, requestId, traceId }` |
| **POST `/v1/dispatch/alerts`** | Create an alert. | Required | Yes (`X-Idempotency-Key`) | No | `DispatchAlertCreateRequest` | `200 { ok, data: { alert: DispatchAlert }, requestId, traceId }` |
| **PATCH `/v1/dispatch/alerts/{id}/ack`** | Acknowledge alert. | Required | Yes (`X-Idempotency-Key`) | No | None | `200 { ok, data: { acknowledged: true }, requestId, traceId }` |
| **GET `/v1/dispatch/codes`** | List dispatch codes. | Required | No | No | None | `200 { ok, data: { codes: DispatchCode[] }, requestId, traceId }` |

## Repository Contracts
- `getAlerts()` → `DispatchAlert[]`
- `createAlert(payload)` → `DispatchAlert`
- `acknowledgeAlert(id)` → boolean
- `deleteOlderThan(timestamp)` → void
- `getCodes()` → `DispatchCode[]`

## Edge Cases
- Creating alerts without `code` or `title` returns `VALIDATION_ERROR`.
- Acknowledging non-existent alerts returns `NOT_FOUND`.
- Purge task removes alerts older than `DISPATCH_ALERT_RETENTION_MS`.
