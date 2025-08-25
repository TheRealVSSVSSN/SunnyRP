# InteractSound Module

The **InteractSound** module logs sound play requests from the server and broadcasts them to connected clients.

## Feature flag

There is no feature flag for this module; it is always enabled.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/interact-sound/plays/:characterId`** | Retrieve up to 50 recent sound plays for the specified character. | n/a | Required | Yes | None | `200 { ok, data: { plays: InteractSoundPlay[] }, requestId, traceId }` |
| **POST `/v1/interact-sound/plays`** | Record a sound play event and push to clients via WebSocket and webhooks. | n/a | Required | Yes (use `X-Idempotency-Key`) | `InteractSoundPlayCreateRequest` | `200 { ok, data: { play: InteractSoundPlay }, requestId, traceId }` |

### Schemas

* **InteractSoundPlay** –
  ```yaml
  characterId: string
  sound: string
  volume: number
  playedAt: integer (unix ms)
  ```

* **InteractSoundPlayCreateRequest** –
  ```yaml
  characterId: string (required)
  sound: string (required)
  volume: number (required)
  playedAt: integer (optional)
  ```

## Implementation details

* **Repository:** `src/repositories/interactSoundRepository.js` provides `recordPlay`, `listPlaysByCharacter` and `deleteOlderThan`.
* **Tasks:** `src/tasks/interactSound.js` purges stale records based on `INTERACT_SOUND_RETENTION_MS`.
* **Routes:** `src/routes/interactSound.routes.js` defines the HTTP endpoints and pushes events via WebSocket and webhooks.
* **OpenAPI:** `openapi/api.yaml` documents the schemas and `/v1/interact-sound/plays` paths.

## Future work

Secret rotation for webhook endpoints can be automated in a future iteration.
