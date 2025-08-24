# Base Events Module

The **baseevents** module logs fundamental player events such as joining, disconnecting and player kills. It exposes REST endpoints so other resources can persist these events for analytics and auditing.

## Feature flag

There is no feature flag; the module is always enabled.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/base-events?limit=n`** | List recent base events. | 60/min per IP | Required | Yes | None | `{ ok, data: { events: BaseEventLog[] }, requestId, traceId }` |
| **POST `/v1/base-events`** | Record an event. Requires `accountId`, `characterId`, `eventType`; optional `metadata`. | 60/min per IP | Required | Yes | `BaseEventLogCreateRequest` | `{ ok, data: { event: BaseEventLog }, requestId, traceId }` |

### Schemas

* **BaseEventLog** –
  ```yaml
  id: integer
  accountId: string
  characterId: integer
  eventType: string
  metadata: object (nullable)
  createdAt: integer
  ```

* **BaseEventLogCreateRequest** –
  ```yaml
  accountId: string (required)
  characterId: integer (required)
  eventType: string (required)
  metadata: object (nullable)
  ```

## Implementation details

* **Repository:** `src/repositories/baseEventsRepository.js`
* **Migration:** `src/migrations/034_add_base_event_logs.sql`
* **Routes:** `src/routes/baseEvents.routes.js`
* **OpenAPI:** `openapi/api.yaml` includes schemas and `/v1/base-events` paths.

## Future work

Future iterations may categorise additional event types and correlate logs with session metrics.
