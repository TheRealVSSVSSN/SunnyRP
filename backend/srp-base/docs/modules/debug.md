# Debug Module

Diagnostics and development tools surface for SunnyRP. Extends simple status into structured debug logs and ephemeral markers suitable for client overlays (e.g., lines, text, spheres).

## Routes

- `GET /v1/debug/status` – Returns server uptime, memory usage and load averages.
- `POST /v1/debug/logs` – Create a debug log entry. Broadcasts `debug.log` via WebSocket and webhooks.
- `GET /v1/debug/logs` – List recent logs (filter by level/since/accountId/characterId/limit).
- `POST /v1/debug/markers` – Create an ephemeral marker with optional TTL. Broadcasts `debug.marker.created`.
- `GET /v1/debug/markers` – List active (non-expired) markers.
- `DELETE /v1/debug/markers/{id}` – Remove a marker early. Broadcasts `debug.marker.deleted`.

## Realtime

- WebSocket namespace `debug` emits:
  - `debug.log.created`
  - `debug.marker.created`
  - `debug.marker.deleted`
  - `debug.marker.expired` (scheduler-driven)

## Webhooks

- Events mirror the WebSocket topics: `debug.log`, `debug.marker.created`, `debug.marker.deleted`, `debug.marker.expired`.
- HMAC-signed payloads; retries with exponential backoff.

## Repository

`debugRepository.js` supports:

- `getSystemInfo()` – process and host metrics
- `insertLog()`, `listLogs()` – debug_logs persistence and queries
- `createMarker()`, `listActiveMarkers()`, `deleteMarker()` – marker lifecycle
- `purgeExpiredMarkers()`, `purgeOldLogs()` – maintenance helpers

## Scheduler

- Job `debug-maintenance` runs every `DEBUG_MARKER_CLEANUP_INTERVAL_MS` (default 60s) to:
  - purge expired markers and emit `debug.marker.expired`
  - delete logs older than `DEBUG_RETENTION_MS` (default 7 days)

## Schema

- `debug_logs` – level, message, context (JSON), account_id, character_id, source, created_at (+indexes)
- `debug_markers` – type, data (JSON), created_by, created_at, expires_at (+indexes)

## Edge Cases

- All endpoints require `X-API-Token`; HMAC headers enforced for writes when replay guard is enabled.
- Write endpoints honor idempotency keys.
- Domain-level rate limits mitigate spam (60 RPS window; 120 writes/minute).
