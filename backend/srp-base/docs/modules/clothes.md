# Clothes Module

The **Clothes** module stores character outfit data for quick swapping.

## Feature flag

There is no feature flag for this module; it is always enabled.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/clothes?characterId={cid}`** | List saved outfits for a character. | 20/min per IP | Required | n/a | None | `200 { ok, data: { clothes: Clothing[] }, requestId, traceId }` |
| **POST `/v1/clothes`** | Save an outfit. | 20/min per IP | Required | Yes (use `X-Idempotency-Key`) | `ClothingCreateRequest` | `200 { ok, data: { clothing: Clothing }, requestId, traceId }` |
| **DELETE `/v1/clothes/{id}`** | Delete an outfit. | 20/min per IP | Required | n/a | None | `200 { ok, data: { deleted: true }, requestId, traceId }` |

### Schemas

* **Clothing** –
  ```yaml
  id: integer
  characterId: integer
  slot: string
  name: string | null
  data: object
  createdAt: string (date-time)
  ```

* **ClothingCreateRequest** –
  ```yaml
  characterId: integer
  slot: string
  data: object
  name: string | null
  ```

## Implementation details

* **Repository:** `src/repositories/clothesRepository.js` provides `create`, `listByCharacter` and `delete`.
* **Migration:** `src/migrations/031_add_clothes.sql` creates the `clothes` table with an index on `character_id`.
* **Routes:** `src/routes/clothes.routes.js` defines the HTTP endpoints and validation.
* **OpenAPI:** `openapi/api.yaml` documents the schemas and `/v1/clothes` paths.

## Future work

Future iterations may support editing outfits and slot naming conventions.
