# Run Summary — 2025-08-29 (mapmanager)

- Added webhook dispatch for interior proxy (IPL) updates and removals.

## API Changes

- None.

## Realtime & Webhooks

- `world.ipl.updated` and `world.ipl.removed` broadcast via WebSocket and webhooks.

## Migrations

- None.

# Run Summary — 2025-08-29 (vehicle control)

- Persist and broadcast vehicle siren/indicator state with cleanup scheduler.

## API Changes

- `GET /v1/vehicles/{plate}/control`
- `POST /v1/vehicles/{plate}/control`

## Realtime & Webhooks

- WebSocket namespace `vehicles` emits `control.update` and webhook mirror.

## Migrations

- `082_add_vehicle_control_states.sql` — creates `vehicle_control_states` table.

# Run Summary — 2025-08-29 (recycling)

- Added recycling deliveries logging with purge scheduler.

## API Changes

- `POST /v1/recycling/deliveries`
- `GET /v1/recycling/deliveries/{characterId}`

## Realtime & Webhooks

- WebSocket namespace `recycling` broadcasts `delivery.created` on delivery creation.

## Migrations

- `081_add_recycling_runs.sql` — creates `recycling_runs` table.

# Run Summary — 2025-08-28 (weathersync)

- Added weather.gov proxy and forecast scheduler.

## API Changes

- `GET/POST /v1/weathersync/forecast` — manage weather forecast.
- `GET /v1/weathersync/weather.gov` — proxy to api.weather.gov.

## Realtime & Webhooks

- WebSocket topic `world` broadcasts `forecast.updated` on changes.

## Migrations

- None.
- 
# Run Summary — 2025-08-28 (koil-debug)

- Extended Debug domain to support structured logs and ephemeral markers.
- Added WebSocket and webhook broadcasts for debug events.
- Introduced a scheduler job to purge expired markers and old logs.

## API Changes

- `POST /v1/debug/logs` — create a log entry (level, message, context, source, account/character scope).
- `GET /v1/debug/logs` — list logs with filters (level, since, limit, accountId, characterId).
- `POST /v1/debug/markers` — create marker (type, data, ttlMs, createdBy) with realtime push.
- `GET /v1/debug/markers` — list active markers.
- `DELETE /v1/debug/markers/{id}` — remove marker and broadcast deletion.

## Realtime & Webhooks

- WebSocket namespace `debug` events: `log.created`, `marker.created`, `marker.deleted`, `marker.expired`.
- Webhook events mirror WS topics with HMAC-signed payloads and retry.

## Migrations

- `080_add_debug.sql` — tables `debug_logs` and `debug_markers` with indexes.

## Configuration

- `DEBUG_RETENTION_MS` — defaults to 7 days.
- `DEBUG_MARKER_CLEANUP_INTERVAL_MS` — defaults to 60s.

## Outstanding TODO/Gaps

- Add role-based admin gating for debug endpoints beyond token auth.
- Consider pagination for `/v1/debug/logs` beyond `limit` cap.
- Optional: query endpoints for expired markers/logs for audit purposes.
- Optional: Redis-backed idempotency and rate limiting for high-volume debug sessions.

# Run Summary — 2025-08-28 (climate-overrides realtime)

- Broadcast timecycle override set/clear events and clear expired overrides.

## API Changes

- None.
# Run Summary — 2025-08-29 (mhacking)

- Logged hacking attempts with realtime push and purge scheduler.

## API Changes

- `GET /v1/hacking/attempts`
- `POST /v1/hacking/attempts`

## Realtime & Webhooks

- WebSocket namespace `hacking` emits `attempt.created` and `attempts.purged` with webhook mirror.

## Migrations

- `083_add_hacking_attempts.sql` — creates `hacking_attempts` table.

## Outstanding

- Document hacking endpoints in BASE_API_DOCUMENTATION and events-and-rpcs.
- Add db-schema entry for hacking_attempts table.
- Record mhacking research sources in research-log.md.
## Realtime & Webhooks

- WebSocket `world.timecycle.set` and `world.timecycle.clear` with matching webhooks.
- Scheduler `timecycle-expiry` removes expired overrides.

## Migrations

- None.

# Run Documentation – 2025-08-28

## Changed Docs
- docs/events-and-rpcs.md
- docs/framework-compliance.md
- docs/index.md
- docs/modules/k9.md
- docs/modules/world.md
- docs/naming-map.md
- docs/progress-ledger.md
- docs/research-log.md
- docs/todo-gaps.md

## Run – 2025-08-28

### Docs Touched
- events-and-rpcs
- framework-compliance
- index
- modules/k9
- modules/world
- naming-map
- progress-ledger
- research-log
- todo-gaps

## Outstanding TODO/Gaps
| Item | Owner | Priority | Blockers |
|---|---|---|---|
| Migrate existing apartment and garage consumers to new properties API | backend | high | client updates |
| Link interior templates and garage capacity to properties | backend | medium | design of interior data |
| Dispatch property events to external webhooks | backend | medium | webhook endpoint adoption |
| Paginate and search property listings | backend | low | none |
| Document world event endpoints in OpenAPI | backend | medium | spec alignment |
| Integrate player vitals (hunger, thirst, stress) into HUD module | backend | medium | gameplay design |
| Add admin bulk adjustment endpoints for queue priorities | backend | low | none |
| Add admin endpoints for cron job management | backend | low | none |
| Bulk sync endpoint for favorite emotes | backend | low | design |
| Allow labeling/ordering of favorite emotes | backend | low | design |
| Implement call-sign management for police officers | backend | medium | design |
| Add altitude and location tracking for helicopter flights | backend | low | design |
| Support editing existing import pack orders | backend | low | design |
| Persist additional ped attributes such as position and appearance | backend | low | none |
| Implement paycheck and grade progression logic for jobs | backend | medium | design |
| Allow assigning handlers via K9 API | backend | low | design |