# Zones Module

The **Zones** module stores polygonal or shaped areas used by the PolyZone resource.

## Feature flag

There is no feature flag for this module; it is always enabled.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/zones`** | List defined zones. | n/a | Required | Yes | None | `200 { ok, data: { zones: Zone[] }, requestId, traceId }` |
| **POST `/v1/zones`** | Create a new zone. Broadcasts `zone.created` over WebSocket and webhooks. | n/a | Required | Yes (use `X-Idempotency-Key`) | `ZoneCreateRequest` | `200 { ok, data: { zone: Zone }, requestId, traceId }` |
| **DELETE `/v1/zones/{id}`** | Remove a zone. Broadcasts `zone.deleted` over WebSocket and webhooks. | n/a | Required | Yes | None | `200 { ok, requestId, traceId }` |

### Schemas

* **Zone** –
  ```yaml
  id: integer
  name: string
  type: string
  data: object
  createdBy: integer | null
  createdAt: string(date-time)
  expiresAt: string(date-time) | null
  ```

* **ZoneCreateRequest** –
  ```yaml
  name: string (required)
  type: string (required)
  data: object (required)
  createdBy: integer (optional)
  expiresAt: string(date-time) | null
  ```

## Implementation details

* **Repository:** `src/repositories/zonesRepository.js` provides `listZones`, `createZone`, `deleteZone` and `removeExpiredZones`.
* **Migration:** `src/migrations/025_add_zones.sql` creates the `zones` table; `062_add_zone_expiry.sql` adds `expires_at`.
* **Routes:** `src/routes/zones.routes.js` defines HTTP endpoints and broadcasts.
* **OpenAPI:** `openapi/api.yaml` documents `/v1/zones` paths and schemas.
