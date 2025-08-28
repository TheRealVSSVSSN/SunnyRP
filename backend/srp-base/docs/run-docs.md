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
