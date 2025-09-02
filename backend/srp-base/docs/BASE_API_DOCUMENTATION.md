# API Documentation
All endpoints require `Authorization: Bearer <token>` signed with `JWT_SECRET` and `Idempotency-Key` for mutations. Token issuance and refresh endpoints are unauthenticated. `POST /v1/sessions/login` is also unauthenticated.

The full specification is available in [openapi.yaml](openapi.yaml).

## System
- `GET /v1/health`
- `GET /v1/ready`
- `GET /v1/info`
- `GET /v1/time`
- `GET /metrics` – exposes default and per-route HTTP metrics
- Webhook: `srp.system.time`

## Auth
- `POST /v1/auth/token`
- `POST /v1/auth/refresh`

## Accounts
- `GET /v1/accounts/{accountId}/characters`
- `POST /v1/accounts/{accountId}/characters`
- `POST /v1/accounts/{accountId}/characters/{characterId}:select`
- `DELETE /v1/accounts/{accountId}/characters/{characterId}`

## Inventory
- `GET /v1/inventory/{characterId}/items`
- `POST /v1/inventory/{characterId}/items`
- `DELETE /v1/inventory/{characterId}/items/{itemId}`

## Banking
- `GET /v1/banking/{characterId}/account`
- `POST /v1/banking/{characterId}/deposit`
- `POST /v1/banking/{characterId}/withdraw`
- `GET /v1/banking/{characterId}/transactions`

## Scoreboard
- `GET /v1/scoreboard/players` – list active players. Optional query `sort=displayName|ping`.
- `POST /v1/scoreboard/players` – upsert player with `{ characterId, accountId, displayName, job?, ping }`.
- `DELETE /v1/scoreboard/players/{characterId}` – remove player entry.

## Telemetry
- `GET /v1/telemetry/errors` – list recent error logs. Requires `telemetry:read`.
- `POST /v1/telemetry/errors` – log error `{ service, level, message }`. Requires `telemetry:write`.
- `POST /v1/telemetry/rcon` – record RCON command `{ command, args? }`. Requires `telemetry:write`.
- `POST /v1/telemetry/exec` – execute sandboxed code `{ code }`. Requires `telemetry:write`.
- `POST /v1/telemetry/restart` – schedule restart `{ restartAt, reason? }`. Requires `telemetry:write`.
- `GET /v1/telemetry/restart` – fetch scheduled restart. Requires `telemetry:read`.
- `DELETE /v1/telemetry/restart` – cancel scheduled restart. Requires `telemetry:write`.
- `POST /v1/telemetry/debug` – log debug message `{ message }`. Requires `telemetry:write`.

## Scheduler (Admin)
- `GET /v1/scheduler/runs` – list tasks and last run times. Requires `scheduler:read`.
- `POST /v1/scheduler/runs/{taskName}` – record manual run for task. Requires `scheduler:write`.

## Queue
- `GET /v1/queue` – list queued accounts ordered by priority and enqueue time.
- `POST /v1/queue` – enqueue `{ accountId, priority? }`. Requires `queue:write`.
- `DELETE /v1/queue/{accountId}` – remove account from queue. Requires `queue:write`.

## Voice
- `GET /v1/voice/channels/{channelId}` – list characters in a channel.
- `POST /v1/voice/channels/{channelId}/join` – add character to channel. Requires `voice:write`.
- `POST /v1/voice/channels/{channelId}/leave` – remove character from channel. Requires `voice:write`.
- `GET /v1/voice/broadcast` – list active broadcasters.
- `GET /v1/voice/broadcast/{characterId}` – get broadcast state. Requires `voice:read`.
- `POST /v1/voice/broadcast` – set broadcast state `{ characterId, active }`. Requires `voice:write`.

## Sessions
- `POST /v1/sessions/login` – verify server login password. Unauthenticated.
- `PUT /v1/sessions/login` – set server login password `{ password }`. Requires `sessions:write`.
- `GET /v1/sessions/whitelist` – list whitelisted accounts. Requires `sessions:read`.
- `POST /v1/sessions/whitelist` – add account to whitelist `{ accountId, power? }`. Requires `sessions:write`.
- `DELETE /v1/sessions/whitelist/{accountId}` – remove account from whitelist. Requires `sessions:write`.
- `GET /v1/sessions/hardcap` – get current player limit. Requires `sessions:read`.
- `PUT /v1/sessions/hardcap` – update player limit `{ maxPlayers }`. Requires `sessions:write`.
- `GET /v1/sessions/population` – get active player count. Requires `sessions:read`.
- `GET /v1/sessions/characters/{characterId}/cid` – get character CID. Requires `sessions:read`.
- `POST /v1/sessions/characters/{characterId}/cid` – assign CID. Requires `sessions:write`.
- `GET /v1/sessions/characters/{characterId}/hospitalize` – check hospitalization status. Requires `sessions:read`.
- `POST /v1/sessions/characters/{characterId}/hospitalize` – admit character. Requires `sessions:write`.
- `DELETE /v1/sessions/characters/{characterId}/hospitalize` – discharge character. Requires `sessions:write`.
- `POST /v1/sessions/characters/{characterId}/spawn` – log spawn `{ x, y, z, heading }`. Requires `sessions:write`.

## Jobs
- `GET /v1/jobs/characters/{characterId}` – list primary and secondary jobs. Requires `jobs:read`.
- `POST /v1/jobs/characters/{characterId}` – set primary job `{ job, grade }`. Requires `jobs:write`.
- `POST /v1/jobs/characters/{characterId}/secondary` – add secondary job `{ job, grade }`. Requires `jobs:write`.
- `DELETE /v1/jobs/characters/{characterId}/secondary/{job}` – remove secondary job. Requires `jobs:write`.

## World
- `GET /v1/world/weather` – get current weather. Requires `world:read`.
- `PUT /v1/world/weather` – set current weather `{ weather }`. Requires `world:write`.
- `GET /v1/world/coords/{characterId}` – get saved coordinates. Requires `world:read`.
- `POST /v1/world/coords` – save coordinates `{ characterId, x, y, z, heading }`. Requires `world:write`.
- `GET /v1/world/zones` – list world zones. Requires `world:read`.
- `POST /v1/world/zones` – create zone `{ name, data }`. Requires `world:write`.
- `DELETE /v1/world/zones/{id}` – remove zone. Requires `world:write`.
- `GET /v1/world/barriers` – list barriers. Requires `world:read`.
- `POST /v1/world/barriers` – create barrier `{ zoneId, data }`. Requires `world:write`.
- `DELETE /v1/world/barriers/{id}` – remove barrier. Requires `world:write`.
- `GET /v1/world/infinity/entities/{entityId}` – get entity coordinates. Requires `world:read`.
- `POST /v1/world/infinity/entities` – save entity coordinates `{ entityId, x, y, z, heading }`. Requires `world:write`.

## UX
- `GET /v1/ux/chat` – list recent chat messages. Requires `ux:read`.
- `POST /v1/ux/chat` – send chat message `{ characterId, message }`. Requires `ux:write`.
- `POST /v1/ux/votes` – start vote `{ question, options[], endsAt? }`. Requires `ux:write`.
- `POST /v1/ux/votes/{voteId}` – cast vote `{ characterId, optionId }`. Requires `ux:write`.
- `GET /v1/ux/votes/{voteId}` – get vote results. Requires `ux:read`.
- `POST /v1/ux/taskbar` – broadcast task progress `{ characterId, task, progress }`. Requires `ux:write`.
- `POST /v1/ux/broadcast` – broadcast notification `{ message }`. Requires `ux:write`.
- `POST /v1/ux/notify` – send notification `{ message, type?, characterId? }`. Requires `ux:write`.
- `POST /v1/ux/taskbarskill` – update skill meter `{ characterId, skill, progress }`. Requires `ux:write`.
- `POST /v1/ux/taskbarthreat` – update threat meter `{ characterId, threat, level }`. Requires `ux:write`.
- `POST /v1/ux/tasknotify` – task-specific notification `{ characterId, message }`. Requires `ux:write`.

## Hooks (Admin)
- `GET /v1/hooks/endpoints`
- `POST /v1/hooks/endpoints`
- `DELETE /v1/hooks/endpoints/{id}`

## Roles (Admin)
- `GET /v1/roles`
- `POST /v1/roles`
- `POST /v1/roles/{roleId}/permissions`
- `GET /v1/accounts/{accountId}/roles`
- `POST /v1/accounts/{accountId}/roles`
