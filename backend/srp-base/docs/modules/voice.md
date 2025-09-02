# Voice Module

Manages voice channel membership with REST APIs, WebSocket events, and scheduled purging.

## REST Endpoints
- `GET /v1/voice/channels/{channelId}` – list characters in a channel. Requires `voice:read`.
- `POST /v1/voice/channels/{channelId}/join` – add character to channel. Requires `voice:write`.
- `POST /v1/voice/channels/{channelId}/leave` – remove character from channel. Requires `voice:write`.
- `GET /v1/voice/broadcast` – list active broadcasters. Requires `voice:read`.
- `GET /v1/voice/broadcast/{characterId}` – get broadcast state. Requires `voice:read`.
- `POST /v1/voice/broadcast` – toggle broadcast state `{ characterId, active }`. Requires `voice:write` and enforces `VOICE_BROADCAST_LIMIT`.

## WebSocket Events
- `srp.voice.join` – character joined a channel.
- `srp.voice.leave` – character left a channel.
- `srp.voice.broadcast` – broadcast state changed.

## Scheduler
- Purges stale channel memberships every `VOICE_STALE_MS`.
