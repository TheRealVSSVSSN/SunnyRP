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
* **OpenAPI:** `openapi/api.yaml` documents schemas and paths.

## Future work

Photo storage could integrate with evidence tracking or support media
expiration policies.
