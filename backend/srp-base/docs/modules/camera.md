# Camera Module

The **camera** module persists photos captured in game. Each photo is
associated with a character and stores an image URL plus optional
description.

## Feature flag

There is no feature flag for camera; the module is always enabled.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/camera/photos/{characterId}`** | List photos for a character. | 60/min per IP | Required | Yes | None | `{ ok, data: { photos: CameraPhoto[] }, requestId, traceId }` |
| **POST `/v1/camera/photos`** | Create a new photo. Requires `characterId` and `imageUrl`. | 30/min per IP | Required | Yes | `CameraPhotoCreateRequest` | `{ ok, data: { photo: CameraPhoto }, requestId, traceId }` |
| **DELETE `/v1/camera/photos/{id}`** | Delete a photo by ID. | 30/min per IP | Required | Yes | None | `{ ok, data: {}, requestId, traceId }` |
| **PATCH `/v1/camera/photos/{id}`** | Update photo description. | 30/min per IP | Required | Yes | `CameraPhotoUpdateRequest` | `{ ok, data: { photo: CameraPhoto }, requestId, traceId }` |

### Real-time events

| Channel | Event | Payload |
|---|---|---|
| `camera` | `photo.created` | `{ photo }` |
| `camera` | `photo.deleted` | `{ id }` |
| `camera` | `photo.updated` | `{ photo }` |

All events are also dispatched through the webhook dispatcher using event types `camera.photo.created`, `camera.photo.deleted` and `camera.photo.updated`.

### Schemas

* **CameraPhoto** –
  ```yaml
  id: integer
  characterId: integer
  imageUrl: string
  description: string (nullable)
  createdAt: string (date-time)
  updatedAt: string (date-time)
  ```
* **CameraPhotoCreateRequest** –
  ```yaml
  characterId: integer (required)
  imageUrl: string (required)
  description: string (nullable)
  ```

## Implementation details

* **Repository:** `src/repositories/cameraRepository.js` stores and
  retrieves photos using parameterised queries.
* **Migration:** `src/migrations/036_add_camera_photos.sql` creates the
  `camera_photos` table with foreign key to characters.
* **Routes:** `src/routes/camera.routes.js` defines the REST API.
  Photo creation and deletion broadcast over WebSocket and webhook dispatcher.
* **OpenAPI:** `openapi/api.yaml` documents schemas and paths.
* **Scheduler:** `src/tasks/camera.js` purges photos older than `CAMERA_RETENTION_MS` at `CAMERA_CLEANUP_INTERVAL_MS`.
* **Config:** Set `CAMERA_RETENTION_MS` and `CAMERA_CLEANUP_INTERVAL_MS` in environment variables to adjust retention and purge interval.

## Future work

Photo storage could integrate with evidence tracking or support media
expiration policies.
