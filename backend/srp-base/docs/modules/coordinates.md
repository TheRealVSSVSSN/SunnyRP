# coordinates module

Provides APIs to save and retrieve named world coordinates per character.

## Routes

- `GET /v1/characters/{characterId}/coordinates`
- `POST /v1/characters/{characterId}/coordinates`
- `DELETE /v1/characters/{characterId}/coordinates/{id}`
- Deprecated alias: `/v1/characters/{characterId}/coords`

## Repository Contracts

- `listCoords(characterId)` – list saved coordinates.
- `saveCoord({ characterId, name, x, y, z, heading })` – upsert coordinate.
- `deleteCoord(characterId, id)` – remove coordinate.
- `purgeOldCoords(maxAgeDays)` – remove coordinates older than `maxAgeDays` days.

## Edge Cases

- Duplicate names update existing coordinates.
- Invalid numeric values return 400.
- Coordinate create/delete events broadcast over WebSocket topic `coordinates` and dispatcher events `coordinates.saved`/`coordinates.deleted`.
