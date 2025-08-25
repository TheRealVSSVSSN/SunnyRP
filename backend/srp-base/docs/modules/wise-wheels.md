# Wise Wheels Module

The **Wise Wheels** module stores wheel spin results for characters and removes records older than 30 days.

## Feature flag

There is no feature flag for this module; it is always enabled.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/wise-wheels/spins/:characterId`** | Retrieve up to 50 wheel spins for the specified character. | n/a | Required | Yes | None | `200 { ok, data: { spins: WiseWheelsSpin[] }, requestId, traceId }` |
| **POST `/v1/wise-wheels/spins`** | Record a wheel spin result and broadcast `wise-wheels.spin.created` via WebSocket and webhook. | n/a | Required | Yes (use `X-Idempotency-Key`) | `WiseWheelsSpinCreateRequest` | `200 { ok, data: { spin: WiseWheelsSpin }, requestId, traceId }` |

### Schemas

* **WiseWheelsSpin** –
  ```yaml
  id: integer
  characterId: string
  prize: string
  createdAt: integer (unix ms)
  ```

* **WiseWheelsSpinCreateRequest** –
  ```yaml
  characterId: string (required)
  prize: string (required)
  ```

## Implementation details

* Spins older than 30 days are purged hourly, broadcasting `wise-wheels.spin.expired` via WebSocket and webhooks.
* **Repository:** `src/repositories/wiseWheelsRepository.js` provides `createSpin`, `listSpinsByCharacter` and `purgeOldSpins`.
* **Migration:** `src/migrations/029_add_wise_wheels.sql` creates the `wise_wheels_spins` table, and `064_add_wise_wheels_created_index.sql` indexes `created_at` for efficient purging.
* **Routes:** `src/routes/wiseWheels.routes.js` defines the HTTP endpoints, pushes WebSocket events and dispatches webhooks.
* **Scheduler:** `src/tasks/wiseWheels.js` removes expired spins hourly.
* **OpenAPI:** `openapi/api.yaml` documents the schemas and `/v1/wise-wheels/spins` paths.

## Future work

Future iterations may include prize metadata or spin limits per character.
