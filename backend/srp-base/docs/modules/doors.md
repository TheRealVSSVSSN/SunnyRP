# Doors Module

The **Doors** module persists world door definitions and their locked state.

## Feature flag

There is no feature flag for this module; it is always enabled.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/doors`** | List all registered doors with their current state. | n/a | Required | Yes | None | `200 { ok, data: { doors: Door[] }, requestId, traceId }` |
| **POST `/v1/doors`** | Create or update a door definition. | n/a | Required | Yes (use `X-Idempotency-Key`) | `DoorUpsertRequest` | `200 { ok, data: { door: Door }, requestId, traceId }` |
| **PATCH `/v1/doors/:doorId/state`** | Update a door's locked state. | n/a | Required | Yes (use `X-Idempotency-Key`) | `DoorStateUpdateRequest` | `200 { ok, data: { door: Door }, requestId, traceId }` |

### Schemas

* **Door** –
  ```yaml
  doorId: string
  name: string | null
  locked: boolean
  position: object | null
  heading: number | null
  createdAt: string (ISO date)
  updatedAt: string (ISO date)
  ```

* **DoorUpsertRequest** –
  ```yaml
  doorId: string (required)
  name: string (optional)
  locked: boolean (optional)
  position: object (optional)
  heading: number (optional)
  ```

* **DoorStateUpdateRequest** –
  ```yaml
  locked: boolean (required)
  ```

## Implementation details

* **Repository:** `src/repositories/doorsRepository.js` manages door persistence.
* **Migration:** `src/migrations/004_add_doors_error_weapons_shops.sql` creates the `doors` table.
* **Routes:** `src/routes/doors.routes.js` exposes the HTTP endpoints.
* **OpenAPI:** `openapi/api.yaml` documents the schemas and `/v1/doors` paths.

## Future work

Future enhancements may include access control lists for doors and batch updates.
