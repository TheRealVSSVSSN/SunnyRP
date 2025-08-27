# Emotes Module

The emotes module stores per-character favorite emote commands for quick access in game.

## Feature flag

There is no feature flag for emotes; the module is always enabled.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/characters/{characterId}/emotes`** | List favorite emotes for a character. | 60/min per IP | Required | Yes | None | `{ ok, data: { emotes: CharacterEmote[] }, requestId, traceId }` |
| **POST `/v1/characters/{characterId}/emotes`** | Add a favorite emote for a character. Requires `emote`. Broadcasts `emotes.favoriteAdded` via WebSocket and webhooks. | 30/min per IP | Required | Yes | `CharacterEmoteCreateRequest` | `{ ok, data: { emote: CharacterEmote }, requestId, traceId }` |
| **DELETE `/v1/characters/{characterId}/emotes/{emote}`** | Remove a favorite emote for a character. Broadcasts `emotes.favoriteRemoved` via WebSocket and webhooks. | 30/min per IP | Required | Yes | None | `{ ok, data: {}, requestId, traceId }` |

### Schemas

* **CharacterEmote** –
  ```yaml
  id: integer
  characterId: integer
  emote: string
  createdAt: string (date-time)
  ```
* **CharacterEmoteCreateRequest** –
  ```yaml
  emote: string (required)
  ```

## Implementation details

* **Repository:** `src/repositories/emotesRepository.js` stores and retrieves favorite emotes.
* **Migration:** `src/migrations/044_add_character_emotes.sql` creates the `character_emotes` table.
* **Routes:** `src/routes/emotes.routes.js` defines the REST API and emits realtime events.
* **Scheduler:** `src/tasks/emotes.js` purges favorites older than `EMOTE_RETENTION_MS` (default 180 days) and emits `emotes.favoriteExpired`.
* **Config:** `EMOTE_RETENTION_MS` controls how long favorites are kept.
* **OpenAPI:** `openapi/api.yaml` documents schemas and paths.

## Future work

* Allow labeling or ordering of favorites.
* Bulk sync of favorites to clients.
