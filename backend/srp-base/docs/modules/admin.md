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

## Repository

`adminRepository.js` provides the `banPlayer` function which inserts a row into the `bans` table using parameterised queries:

- **banPlayer(playerId, reason, until)** – Persists a ban for the specified player. `until` may be `null` for permanent bans.

## Database Migration

`020_add_bans.sql` creates the `bans` table with columns:

- **player_id** (`VARCHAR(64)`) – Identifier for the banned player.
- **reason** (`VARCHAR(255)`) – Reason for the ban.
- **until** (`DATETIME`, nullable) – When present, the ban expires at this time.
- **created_at** (`TIMESTAMP`) – Creation timestamp.

An index on `player_id` accelerates lookups.

## Notes

* Endpoint requires the standard authentication and idempotency headers.
* `until` must be a valid ISO 8601 timestamp when provided.
* Additional administrative actions (kicks, audit logs) remain out of scope for now.
