# Wise Audio Module

The **Wise Audio** module stores custom audio tracks for characters.

## Feature flag

There is no feature flag for this module; it is always enabled.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/wise-audio/tracks/:characterId`** | Retrieve up to 50 audio tracks for the specified character. | n/a | Required | Yes | None | `200 { ok, data: { tracks: WiseAudioTrack[] }, requestId, traceId }` |
| **POST `/v1/wise-audio/tracks`** | Store a new audio track and broadcast `wise-audio.track.created` via WebSocket and webhook. | n/a | Required | Yes (use `X-Idempotency-Key`) | `WiseAudioTrackCreateRequest` | `200 { ok, data: { track: WiseAudioTrack }, requestId, traceId }` |

### Schemas

* **WiseAudioTrack** –
  ```yaml
  id: integer
  characterId: string
  label: string
  url: string
  createdAt: integer (unix ms)
  ```

* **WiseAudioTrackCreateRequest** –
  ```yaml
  characterId: string (required)
  label: string (required)
  url: string (required)
  ```

## Implementation details

* **Repository:** `src/repositories/wiseAudioRepository.js` provides `createTrack` and `listTracksByCharacter`.
* **Migration:** `src/migrations/026_add_wise_audio.sql` creates the `wise_audio_tracks` table.
* **Routes:** `src/routes/wiseAudio.routes.js` defines the HTTP endpoints, pushes WebSocket events and dispatches webhooks.
* **OpenAPI:** `openapi/api.yaml` documents the schemas and `/v1/wise-audio/tracks` paths.

## Future work

Future iterations may support deleting tracks or streaming audio directly from the service.
