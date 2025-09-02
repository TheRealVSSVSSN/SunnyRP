# Queue Module

Manages connection order for accounts awaiting server access.

## REST Endpoints
- `GET /v1/queue` – list queued accounts ordered by priority and enqueue time. Requires `queue:read`.
- `POST /v1/queue` – enqueue `{ accountId, priority? }`. Requires `queue:write` and `Idempotency-Key`.
- `DELETE /v1/queue/{accountId}` – remove account. Requires `queue:write` and `Idempotency-Key`.

## WebSocket Events
- `srp.queue.update` – queue membership changed.

## Scheduler
- Purges entries older than `QUEUE_STALE_MS` every minute.
