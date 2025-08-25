# Heli Module

The heli module records helicopter flights for characters.

## Feature flag

No feature flag; module is always enabled.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **POST `/v1/heli/flights`** | Start a helicopter flight. | 30/min per IP | Required | Yes | `HeliFlightCreate` | `{ ok, data: { flight: HeliFlight }, requestId, traceId }` |
| **POST `/v1/heli/flights/{id}/end`** | End an active flight. | 30/min per IP | Required | Yes | none | `{ ok, data: { flight: HeliFlight }, requestId, traceId }` |
| **GET `/v1/characters/{characterId}/heli/flights`** | List flights for a character. | 60/min per IP | Required | Yes | none | `{ ok, data: { flights: HeliFlight[] }, requestId, traceId }` |

### Schemas

* **HeliFlight** –
  ```yaml
  id: integer
  characterId: integer
  purpose: string
  startTime: string (date-time)
  endTime: string (date-time)
  ```
* **HeliFlightCreate** –
  ```yaml
  characterId: integer
  purpose: string
  ```

## Implementation details

* **Repository:** `src/repositories/heliRepository.js` persists flight records.
* **Migration:** `src/migrations/051_add_heli_flights.sql` creates the `heli_flights` table.
* **Routes:** `src/routes/heli.routes.js` defines the REST API.
* **OpenAPI:** `openapi/api.yaml` documents schemas and paths.

## Future work

Add altitude and location tracking.
