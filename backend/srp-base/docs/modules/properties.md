# Properties Module

The **Properties** module unifies housing-related storage for apartments, garages and hotel rentals. It tracks ownership at the character level and supports lease expiration.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/properties?type=&ownerCharacterId=`** | List properties filtered by type or owner. | 30/min per IP | Required | n/a | None | `200 { ok, data: { properties: Property[] }, requestId, traceId }` |
| **POST `/v1/properties`** | Create a property record. | 30/min per IP | Required | Yes (`X-Idempotency-Key`) | `PropertyCreateRequest` | `200 { ok, data: { property: Property }, requestId, traceId }` *(broadcasts `properties.propertyCreated`)* |
| **GET `/v1/properties/{propertyId}`** | Retrieve a property. | 30/min per IP | Required | n/a | None | `200 { ok, data: { property: Property }, requestId, traceId }` |
| **PATCH `/v1/properties/{propertyId}`** | Update property fields. | 30/min per IP | Required | Yes (`X-Idempotency-Key`) | `PropertyCreateRequest` | `200 { ok, data: { property: Property }, requestId, traceId }` *(broadcasts `properties.propertyUpdated`)* |
| **DELETE `/v1/properties/{propertyId}`** | Delete a property. | 30/min per IP | Required | n/a | None | `200 { ok, data: { deleted: true }, requestId, traceId }` *(broadcasts `properties.propertyDeleted`)* |

### Schemas

* **Property**
  ```yaml
  id: integer
  type: string
  name: string
  location: object | null
  price: number
  ownerCharacterId: integer | null
  expiresAt: string(date-time) | null
  createdAt: string(date-time)
  updatedAt: string(date-time) | null
  ```

* **PropertyCreateRequest**
  ```yaml
  type: string
  name: string
  location: object | null
  price: number
  ownerCharacterId: integer | null
  expiresAt: string(date-time) | null
  ```

## Implementation details

* **Repository:** `src/repositories/propertiesRepository.js`
* **Migration:** `src/migrations/066_add_properties.sql`
* **Routes:** `src/routes/properties.routes.js`
* **Scheduler:** `src/tasks/properties.js` releases expired leases hourly.
* **OpenAPI:** `openapi/api.yaml` documents the schemas and endpoints.

## Future work

* Migrate legacy apartment and garage endpoints to this module.
* Add interior and garage capacity metadata.
