# Assets Module

The **Assets** module stores arbitrary media or metadata owned by a character.

## Feature flag

There is no feature flag for this module; it is always enabled.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/assets?ownerId={cid}`** | List assets for a character. | 20/min per IP | Required | n/a | None | `200 { ok, data: { assets: Asset[] }, requestId, traceId }` |
| **GET `/v1/assets/{id}`** | Retrieve a single asset by id. | 20/min per IP | Required | n/a | None | `200 { ok, data: { asset: Asset }, requestId, traceId }` |
| **POST `/v1/assets`** | Create an asset record. | 20/min per IP | Required | Yes (use `X-Idempotency-Key`) | `AssetCreateRequest` | `200 { ok, data: { asset: Asset }, requestId, traceId }` *(broadcasts `assets.assetCreated`)* |
| **DELETE `/v1/assets/{id}`** | Delete an asset. | 20/min per IP | Required | n/a | None | `200 { ok, data: { deleted: true }, requestId, traceId }` *(broadcasts `assets.assetDeleted`)* |

### Schemas

* **Asset** –
  ```yaml
  id: integer
  owner_id: integer
  url: string
  type: string
  name: string | null
  created_at: string (date-time)
  ```

* **AssetCreateRequest** –
  ```yaml
  ownerId: integer
  url: string
  type: string
  name: string | null
  ```

## Implementation details

* **Repository:** `src/repositories/assetsRepository.js` provides `createAsset`, `getAsset`, `listByOwner`, `deleteAsset` and `deleteOlderThan`.
* **Migration:** `src/migrations/030_add_assets.sql` creates the `assets` table with an index on `owner_id` and `065_add_assets_created_index.sql` adds an index on `created_at`.
* **Routes:** `src/routes/assets.routes.js` defines the HTTP endpoints, validation and realtime/webhook dispatch.
* **Scheduler:** `src/tasks/assets.js` purges assets older than `ASSET_RETENTION_MS` with hourly jittered runs.
* **OpenAPI:** `openapi/api.yaml` documents the schemas and `/v1/assets` paths.

## Future work

Future iterations may support uploading binary data.
