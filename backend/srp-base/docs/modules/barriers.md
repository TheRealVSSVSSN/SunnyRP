# Barriers Module

The **Barriers** module persists world road barrier placements and their open/closed state.

## Feature flag

There is no feature flag; barriers are always enabled.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/barriers`** | List all barriers with their current state. | n/a | Required | Yes | None | `200 { ok, data: { barriers: Barrier[] }, requestId, traceId }` |
| **POST `/v1/barriers`** | Create a new barrier definition. | n/a | Required | Yes (use `X-Idempotency-Key`) | `BarrierCreateRequest` | `200 { ok, data: { barrier: Barrier }, requestId, traceId }` |
| **PATCH `/v1/barriers/{barrierId}/state`** | Update a barrier's open/closed state. | n/a | Required | Yes (use `X-Idempotency-Key`) | `BarrierStateUpdateRequest` | `200 { ok, data: { barrier: Barrier }, requestId, traceId }` |

### Schemas

* **Barrier** –
  ```yaml
  id: number
  model: string
  position: object
  heading: number
  state: boolean
  expiresAt: string | null
  placedBy: number | null
  createdAt: string (ISO date)
  updatedAt: string (ISO date)
  ```

* **BarrierCreateRequest** –
  ```yaml
  model: string
  position: object
  heading: number (optional)
  ```

* **BarrierStateUpdateRequest** –
  ```yaml
  state: boolean
  ttl: number (optional, seconds until auto-close)
  ```

## Implementation details

* **Repository:** `src/repositories/barriersRepository.js`
* **Migration:** `src/migrations/089_add_barriers.sql`
* **Routes:** `src/routes/barriers.routes.js`
* **OpenAPI:** `openapi/api.yaml` schemas and `/v1/barriers` paths

## Future work

- Permission checks for barrier placement.
- Bulk barrier state updates.
