# Weed Plants Module

The **weed plants** module implements backend support for the cannabis
farming system originally defined in the `np‑gangs` resource.  In the
Lua implementation, events like `weed:createplant`, `weed:killplant`
and `weed:UpdateWeedGrowth` inserted, deleted and updated rows in a
MySQL `weed_plants` table and broadcast the current table to
clients【366444498392161†L9-L33】.  This module re‑imagines that behaviour as
a RESTful API within the `srp‑base` service.

## Purpose

Provide endpoints for players (or other services) to create, view,
update and delete weed plants.  The server persists plant data in
MySQL and exposes them via HTTP.  All operations require a valid
API token and are subject to idempotency and rate limits.

## Configuration

No additional configuration is required beyond enabling the feature
via `features.weedPlants` in the service configuration.  The module
uses the existing database connection defined in `src/repositories/db.js`.

## Endpoints

| Method & Path | Description | Auth | Rate Limit |
|---|---|---|---|
| **GET /v1/weed-plants** | List all weed plants.  Returns an array of
  plant objects.  Intended for administrative use or to broadcast to
  clients. | API Token | Default global rate limit |
| **POST /v1/weed-plants** | Create a new plant.  Body must include
  `coords` (object with `x`, `y`, `z`), `seed` (string) and
  `ownerId` (integer).  Returns the created plant. | API Token,
  Idempotent | 10 req/min/IP |
| **PATCH /v1/weed-plants/{id}** | Update the `growth` value of an
  existing plant.  Body must include `growth` (integer). | API Token,
  Idempotent | 10 req/min/IP |
| **DELETE /v1/weed-plants/{id}** | Delete a plant by id. | API Token,
  Idempotent | 10 req/min/IP |

## Database Schema

The `weed_plants` table is created in migration
`010_add_weed_plants.sql` with the following columns:

- `id` (bigint unsigned, primary key)
- `coords` (JSON) – contains `x`, `y`, `z` floats
- `seed` (varchar) – identifier for the plant type
- `owner_id` (bigint unsigned) – character ID who owns the plant
- `growth` (int) – growth percentage or arbitrary unit
- `created_at` (timestamp)
- `updated_at` (timestamp)

An index on `owner_id` improves lookups when listing plants owned by a
specific player.

## Common Issues & Troubleshooting

- **404 / plant not found:** Attempting to update or delete a plant
  that does not exist will return a 404 error.  Ensure you pass the
  correct `id`.
- **Validation errors:** Missing or invalid fields will result in a
  400 error with details in the response body.
- **Rate limiting:** Creating or modifying plants is rate‑limited to
  prevent abuse.  Exceeding the limit returns a 429 status.

## Future Work

This module currently exposes only CRUD operations.  A future sprint
may implement additional features such as batch retrieval by owner,
growth timers, or integration with the jobs system to restrict
planting to certain roles.