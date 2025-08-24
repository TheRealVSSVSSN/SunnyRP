# Emotes Module

The emotes module stores per-character favorite emote commands for quick access in game.

## Feature flag

There is no feature flag for emotes; the module is always enabled.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/characters/{characterId}/emotes`** | List favorite emotes for a character. | 60/min per IP | Required | Yes | None | `{ ok, data: { emotes: CharacterEmote[] }, requestId, traceId }` |
| **POST `/v1/characters/{characterId}/emotes`** | Add a favorite emote for a character. Requires `emote`. | 30/min per IP | Required | Yes | `CharacterEmoteCreateRequest` | `{ ok, data: { emote: CharacterEmote }, requestId, traceId }` |
| **DELETE `/v1/characters/{characterId}/emotes/{emote}`** | Remove a favorite emote for a character. | 30/min per IP | Required | Yes | None | `{ ok, data: {}, requestId, traceId }` |

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
* **Routes:** `src/routes/emotes.routes.js` defines the REST API.
* **OpenAPI:** `openapi/api.yaml` documents schemas and paths.

## Future work

* Allow labeling or ordering of favorites.
