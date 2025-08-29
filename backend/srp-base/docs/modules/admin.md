# Admin Module

## Purpose

The **admin** module provides basic moderation capabilities for the SunnyRP platform. It exposes an API for banning players with an optional expiration time so that bans persist across server restarts.

## Endpoint

### `POST /v1/admin/ban`

Bans a player. The request body must include a `playerId` and `reason` and may optionally include `until` as an ISO 8601 timestamp. When `until` is omitted the ban is permanent.

Example request body:

```json
{
  "playerId": "steam:110000100000001",
  "reason": "Exploiting",
  "until": "2025-12-31T23:59:59Z"
}
```

Successful responses use the standard envelope and return the ban details:

```json
{
  "ok": true,
  "data": {
    "banned": true,
    "reason": "Exploiting",
    "until": "2025-12-31T23:59:59.000Z"
  },
  "requestId": "uuid",
  "traceId": "trace"
}
```


### `POST /v1/admin/noclip`

Enables or disables noclip for a player. Body must include `playerId`, `actorId`, and `enabled` boolean. Only players with the `admin` or `dev` scope may receive noclip.

Example request body:

```json
{
  "playerId": "steam:110000100000001",
  "actorId": "steam:110000100000002",
  "enabled": true
}
```

On success the service records the action and emits a WebSocket event:

```json
{
  "ok": true,
  "data": { "playerId": "steam:110000100000001", "enabled": true },
  "requestId": "uuid",
  "traceId": "trace"
}
```

## Repository

`adminRepository.js` exposes helper functions:

- **banPlayer(playerId, reason, until)** – Insert a ban record; `until` may be `null`.
- **setNoclip(playerId, actorId, enabled)** – Log a noclip toggle event.

## Database Migration

`020_add_bans.sql` creates the `bans` table.

`086_add_noclip_events.sql` creates the `noclip_events` table with indexes on `player_id` and `created_at`.

## Notes

* Endpoint requires the standard authentication and idempotency headers.
* `until` must be a valid ISO 8601 timestamp when provided.
* Additional administrative actions (kicks, audit logs) remain out of scope for now.
