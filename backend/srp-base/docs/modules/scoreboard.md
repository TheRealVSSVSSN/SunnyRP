# Scoreboard Module

Tracks active players and provides REST/WS interfaces.

## REST Endpoints
- `GET /v1/scoreboard/players` – list active players sorted by `displayName` or `ping`.
- `POST /v1/scoreboard/players` – upsert player entry with job metadata. Requires `scoreboard:write`.
- `DELETE /v1/scoreboard/players/{characterId}` – remove player. Requires `scoreboard:write`.

## WebSocket Events
- `srp.scoreboard.update` – player ping, name, or job update.
- `srp.scoreboard.remove` – player removed/timeout.

## Scheduler
- Purges stale players every `SCOREBOARD_STALE_MS`.
