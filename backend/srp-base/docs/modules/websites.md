# Websites Module

The **websites** module implements backend support for the Gurgle
phone application as seen in the `np‑gurgle` resource.  In the
original Lua code the `website:new` event charged the player $500,
inserted a new row into a `websites` table and broadcast the updated
list to all clients【73746484563419†L0-L48】.  This module provides a
RESTful interface to those operations.

## Purpose

Allow players to purchase personal websites and view existing sites via
HTTP endpoints.  The server persists website data and enforces a fixed
purchase price, withdrawing funds from the player's cash balance via
the existing economy subsystem.  Optionally, the list endpoint can
filter by owner.

## Configuration

No additional configuration is required.  The purchase cost is fixed
at $500 and is not currently configurable via environment variables.

## Endpoints

| Method & Path | Description | Auth | Rate Limit |
|---|---|---|---|
| **GET /v1/websites** | List all websites.  Accepts optional
  `ownerId` query parameter to filter by character.  Returns an
  array of website objects. | API Token | Default global rate limit |
| **POST /v1/websites** | Purchase a new website.  Body must include
  `ownerId` (character ID) and `name` (title).  `keywords` and
  `description` are optional.  Deducts $500 from the player’s cash
  balance.  Returns the created website. | API Token, Idempotent |
  5 req/min/IP |

## Database Schema

The `websites` table is created in migration `011_add_websites.sql`
with the following columns:

- `id` (bigint unsigned, primary key)
- `owner_id` (bigint unsigned) – character ID who owns the site
- `name` (varchar) – website title
- `keywords` (varchar, nullable) – space separated keywords
- `description` (text, nullable) – longer description
- `created_at`, `updated_at` (timestamps)

An index on `owner_id` supports efficient filtering by owner.

## Example Usage

To purchase a website:

```http
POST /v1/websites
Content-Type: application/json
X-API-Token: secret-token

{
  "ownerId": 123,
  "name": "MyAwesomeSite",
  "keywords": "cars racing",
  "description": "A blog about street racing."
}
```

Response:

```json
{
  "ok": true,
  "data": {
    "website": {
      "id": 1,
      "owner_id": 123,
      "name": "MyAwesomeSite",
      "keywords": "cars racing",
      "description": "A blog about street racing.",
      "created_at": "2025-08-19T17:22:33Z",
      "updated_at": "2025-08-19T17:22:33Z"
    }
  },
  "requestId": "abcd1234",
  "traceId": "abcd1234"
}
```

## Common Issues & Troubleshooting

- **Insufficient funds** – If the player’s cash balance is less
  than $500 the API responds with a 400 status and an
  `INSUFFICIENT_FUNDS` error.
- **Validation errors** – Missing `ownerId` or `name` results in a
  400 error with an `INVALID_ARGUMENT` code.
- **Rate limiting** – Creating more than 5 websites per minute
  returns a 429 status code.

## Future Work

Future sprints may add website editing, deletion and search
capabilities, as well as configuration to make the purchase price and
maximum websites per player adjustable.  An administration endpoint
could also be added to manage all websites or moderate content.