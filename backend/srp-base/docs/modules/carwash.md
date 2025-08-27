# Carwash Module

The **carwash** module logs vehicle washes and tracks dirt levels so cars stay clean across server restarts.

## Feature flag

There is no feature flag for the carwash module; it is always enabled.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **POST `/v1/carwash`** | Record a car wash for a vehicle and reset its dirt level. | 30/min per IP | Required | Yes | `CarwashCreateRequest` | `200 { ok, data: { id }, requestId, traceId }` `400 INVALID_INPUT` |
| **GET `/v1/carwash/history/{characterId}`** | List recent car washes for a character. | 60/min per IP | Required | Yes | None | `200 { ok, data: { history: CarwashTransaction[] }, requestId, traceId }` |
| **GET `/v1/vehicles/{plate}/dirt`** | Retrieve current dirt level for a vehicle plate. | 60/min per IP | Required | Yes | None | `200 { ok, data: { dirt }, requestId, traceId }` |
| **PATCH `/v1/vehicles/{plate}/dirt`** | Update dirt level for a vehicle. | 30/min per IP | Required | Yes | `{ dirt: number }` | `200 { ok, data: { updated }, requestId, traceId }` `400 INVALID_INPUT` |

### Schemas

* **CarwashTransaction** –
  ```yaml
  id: integer
  characterId: integer
  plate: string
  location: string
  cost: integer
  washedAt: string (date-time)
  ```
* **CarwashCreateRequest** –
  ```yaml
  characterId: integer
  plate: string
  location: string
  cost: integer
  ```
* **VehicleDirt** –
  ```yaml
  dirt: integer
  ```

## Implementation details

* **Repository:** `src/repositories/carwashRepository.js`
* **Routes:** `src/routes/carwash.routes.js`
* **Migrations:** `src/migrations/038_add_carwash.sql`, `src/migrations/071_add_vehicle_cleanliness_dirt_index.sql`
* **Task:** `src/tasks/carwash.js` – increments dirt levels every 15 minutes
* **Realtime:** WebSocket topic `vehicles` with event `dirt.update`; webhook events `carwash.wash` and `carwash.dirt.set`
* **OpenAPI:** `openapi/api.yaml`

## Future work

Future updates may integrate automatic billing with the economy and configurable carwash locations.
