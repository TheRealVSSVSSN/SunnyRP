# Ammo Module

## Purpose

The **ammo** module manages per‑player ammunition counts in the SRP API.  In the
original Lua implementation (`np‑weapons`), ammunition counts were stored in
the `characters_weapons` table and updated via events such as
`np-weapons:getAmmo` and `np-weapons:updateAmmo`【735206341651753†L6-L44】.
To replicate this behaviour in a persistent and RESTful manner, the ammo
module introduces a dedicated table and API endpoints for querying and
updating ammo.  This allows ammunition counts to survive server restarts
and be manipulated via standard HTTP requests.

## Endpoints

### `GET /v1/players/{playerId}/ammo`

Returns a mapping of weapon types to ammunition counts for the specified
player.  If the player has no ammo records, the map will be empty.  The
response envelope includes `ok`, `data.ammo`, `requestId` and `traceId`.

### `PATCH /v1/players/{playerId}/ammo`

Updates the ammunition count for a specific weapon type.  The request body
must include:

```json
{
  "weaponType": "WEAPON_PISTOL",
  "ammo": 42
}
```

If the player/weapon combination does not exist, a new row is inserted.
If it does exist, the ammo count is updated.  The response returns the
updated map of ammo counts for the player.

## Repository

`ammoRepository.js` defines two functions:

- **getPlayerAmmo(playerId)** – Queries the `player_ammo` table and
  assembles an object mapping `weapon_type` to `ammo` for the player.
- **updatePlayerAmmo(playerId, weaponType, ammoCount)** – Performs an
  `INSERT ... ON DUPLICATE KEY UPDATE` to insert or update the ammo
  count, then returns the full ammo map.

Both functions use parameterised queries to prevent SQL injection and
return JavaScript objects rather than raw database rows.

## Database Migration

The migration `015_add_player_ammo.sql` creates the `player_ammo` table
with columns:

- **player_id** (`VARCHAR(64)`) – Identifier for the player (primary key part).
- **weapon_type** (`VARCHAR(100)`) – Identifier for the weapon (primary key part).
- **ammo** (`INT`) – Number of rounds remaining (non‑negative).
- **created_at**, **updated_at** – Timestamps with automatic updates.

The primary key on (`player_id`, `weapon_type`) ensures that each
player/weapon pair is unique.  An additional index on `player_id` speeds
retrieval of a player's ammo map.

## Notes

* Ammo counts must be non‑negative integers; the API validates this and
  rejects negative values.
* All new endpoints require standard authentication and idempotency
  headers as documented in `BASE_API_DOCUMENTATION.md`.
* Future improvements could include batch updates for multiple
  weapon types and integration with inventory or weapons ownership data.
