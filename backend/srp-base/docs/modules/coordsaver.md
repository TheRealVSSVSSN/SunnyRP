# coordsaver module

Provides APIs to save and retrieve named world coordinates per character.

## Routes

- `GET /v1/characters/{characterId}/coords`
- `POST /v1/characters/{characterId}/coords`
- `DELETE /v1/characters/{characterId}/coords/{id}`

## Repository Contracts

- `listCoords(characterId)` – list saved coordinates.
- `saveCoord({ characterId, name, x, y, z, heading })` – upsert coordinate.
- `deleteCoord(characterId, id)` – remove coordinate.

## Edge Cases

- Duplicate names update existing coordinates.
- Invalid numeric values return 400.
