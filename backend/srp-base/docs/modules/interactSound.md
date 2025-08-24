# InteractSound Module

The **InteractSound** module logs sound play requests from the server.

## Feature flag

There is no feature flag for this module; it is always enabled.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/interact-sound/plays/:characterId`** | Retrieve up to 50 recent sound plays for the specified character. | n/a | Required | Yes | None | `200 { ok, data: { plays: InteractSoundPlay[] }, requestId, traceId }` |
| **POST `/v1/interact-sound/plays`** | Record a sound play event. | n/a | Required | Yes (use `X-Idempotency-Key`) | `InteractSoundPlayCreateRequest` | `200 { ok, data: { play: InteractSoundPlay }, requestId, traceId }` |

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

* **Repository:** `src/repositories/interactSoundRepository.js` provides `recordPlay` and `listPlaysByCharacter`.
* **Migration:** `src/migrations/022_add_interact_sound.sql` creates the `interact_sound_plays` table.
* **Routes:** `src/routes/interactSound.routes.js` defines the HTTP endpoints and validation.
* **OpenAPI:** `openapi/api.yaml` documents the schemas and `/v1/interact-sound/plays` paths.

## Future work

Future iterations may trigger sounds directly via websocket or queue for in-game broadcast.
