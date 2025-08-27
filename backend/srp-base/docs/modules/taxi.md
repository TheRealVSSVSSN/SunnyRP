# Taxi Module

The taxi module records passenger requests and driver completions for taxi rides.

## Feature flag

No feature flag; module is always enabled.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/taxi/requests`** | List taxi requests by status. | 60/min per IP | Required | Yes | Query `status` | `{ ok, data: { requests: TaxiRequest[] }, requestId, traceId }` |
| **POST `/v1/taxi/requests`** | Create a new taxi request. | 30/min per IP | Required | Yes | `TaxiRequestCreate` | `{ ok, data: { request: TaxiRequest }, requestId, traceId }` |
| **POST `/v1/taxi/requests/{id}/accept`** | Driver accepts a request. | 30/min per IP | Required | Yes | `{ driverCharacterId }` | `{ ok, data: { request: TaxiRequest }, requestId, traceId }` |
| **POST `/v1/taxi/requests/{id}/complete`** | Driver completes a ride. | 30/min per IP | Required | Yes | `{ driverCharacterId, dropoffX, dropoffY, dropoffZ, fare }` | `{ ok, data: { request: TaxiRequest }, requestId, traceId }` |
| **GET `/v1/characters/{characterId}/taxi/rides`** | List completed rides for a character. | 60/min per IP | Required | Yes | Query `role` | `{ ok, data: { rides: TaxiRequest[] }, requestId, traceId }` |

### Schemas

* **TaxiRequest** –
  ```yaml
  id: integer
  passengerCharacterId: integer
  driverCharacterId: integer
  pickupX: number
  pickupY: number
  pickupZ: number
  dropoffX: number
  dropoffY: number
  dropoffZ: number
  fare: integer
  status: string
  createdAt: string (date-time)
  acceptedAt: string (date-time)
  completedAt: string (date-time)
  ```
* **TaxiRequestCreate** –
  ```yaml
  passengerCharacterId: integer
  pickupX: number
  pickupY: number
  pickupZ: number
  ```

## Implementation details

* **Repository:** `src/repositories/taxiRepository.js` persists requests and rides.
* **Migration:** `src/migrations/046_add_taxi_rides.sql` creates the `taxi_rides` table.
* **Migration:** `src/migrations/074_add_taxi_rides_status_created_index.sql` adds `(status, created_at)` index for expiry checks.
* **Routes:** `src/routes/taxi.routes.js` defines the REST API.
* **OpenAPI:** `openapi/api.yaml` documents schemas and paths.
* **Scheduler:** `src/tasks/taxi.js` cancels stale requests based on `TAXI_REQUEST_TTL_MS`.
* **Realtime:** `taxi.request.created`, `taxi.request.accepted`, `taxi.request.completed`, `taxi.request.expired` via WebSocket and webhooks.

## Future work

Add manual ride cancellation and pricing configuration.
