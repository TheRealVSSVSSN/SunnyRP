# Furniture Module

The furniture module stores custom furniture placements for player housing. Each record tracks the item model and world coordinates. Endpoints allow listing, placing and removing furniture tied to a specific character.

## Feature flag

There is no feature flag for furniture; the module is always enabled.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/characters/{characterId}/furniture`** | List furniture for the character. | 60/min per IP | Required | Yes | None | `{ ok, data: { furniture: FurnitureItem[] }, requestId, traceId }` |
| **POST `/v1/characters/{characterId}/furniture`** | Place a furniture item. Requires `item`, `x`, `y`, `z` and optional `heading`. | 30/min per IP | Required | Yes | `FurnitureCreateRequest` | `{ ok, data: { furniture: FurnitureItem }, requestId, traceId }` |
| **DELETE `/v1/characters/{characterId}/furniture/{id}`** | Remove a furniture item by id. | 60/min per IP | Required | Yes | None | `{ ok, data: {}, requestId, traceId }` |

### Schemas

* **FurnitureItem** –
  ```yaml
  id: integer
  item: string
  x: number
  y: number
  z: number
  heading: number | null
  createdAt: string (date-time)
  updatedAt: string (date-time)
  ```

* **FurnitureCreateRequest** –
  ```yaml
  item: string (required)
  x: number (required)
  y: number (required)
  z: number (required)
  heading: number (optional)
  ```

## Implementation details

* **Repository:** `src/repositories/furnitureRepository.js` provides query helpers.
* **Migration:** `src/migrations/047_add_furniture.sql` creates the `furniture` table.
* **Routes:** `src/routes/furniture.routes.js` defines the HTTP endpoints.
* **OpenAPI:** `openapi/api.yaml` documents schemas and paths.
* **Realtime:** `furniture.placed` and `furniture.removed` broadcast over WebSocket and webhook dispatcher.
* **Scheduler:** `src/tasks/furniture.js` purges furniture older than `FURNITURE_RETENTION_MS` daily.

## Configuration

| Key | Default | Notes |
|---|---|---|
| `FURNITURE_RETENTION_MS` | `15552000000` | Milliseconds to retain furniture before purge (180 days). |

## Future work

Future enhancements may enforce ownership validation against account sessions and allow batch placement or updating of furniture positions.
