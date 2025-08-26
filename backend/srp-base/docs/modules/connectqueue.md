# Connect Queue Module

Manages account-based queue priorities for server connections.

## Feature flag

There is no feature flag for connectqueue; the module is always enabled.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/connectqueue/priorities`** | List queue priorities optionally filtered by `accountId`. | 30/min per IP | Required | Yes | None | `{ ok, data: { priorities: QueuePriority[] }, requestId, traceId }` |
| **POST `/v1/connectqueue/priorities`** | Upsert a priority for an account. Requires `accountId` and `priority`. | 30/min per IP | Required | Yes | `QueuePriorityUpsertRequest` | `{ ok, data: { priority: QueuePriority }, requestId, traceId }` |
| **DELETE `/v1/connectqueue/priorities/{accountId}`** | Remove an account's priority entry. | 30/min per IP | Required | Yes | None | `{ ok, data: { deleted: boolean }, requestId, traceId }` |

### Schemas

* **QueuePriority** –
  ```yaml
  accountId: integer
  priority: integer
  reason: string | null
  expiresAt: string (date-time) | null
  createdAt: string (date-time)
  updatedAt: string (date-time)
  ```
* **QueuePriorityUpsertRequest** –
  ```yaml
  accountId: integer (required)
  priority: integer (required)
  reason: string | null
  expiresAt: string (date-time) | null
  ```

## Implementation details

* **Repository:** `src/repositories/connectqueueRepository.js` stores priority entries.
* **Migration:** `src/migrations/040_add_queue_priorities.sql` creates the `queue_priorities` table.
* **Routes:** `src/routes/connectqueue.routes.js` defines the REST API and emits WebSocket and webhook events `priority.upserted` and `priority.removed`.
* **Scheduler:** `src/tasks/connectqueue.js` purges expired priorities every minute and broadcasts `priority.expired` events.
* **OpenAPI:** `openapi/api.yaml` documents schemas and paths.

## Future work

Consider exposing administrative endpoints for bulk priority adjustments and analytics.
