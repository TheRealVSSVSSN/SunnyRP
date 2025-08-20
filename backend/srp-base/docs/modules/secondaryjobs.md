# Secondary Jobs Module

The **Secondary Jobs** module adds support for assigning additional jobs to a
character beyond their primary role.  In the original Lua resource this
functionality was provided by the `np-secondaryjobs` resource, which
emitted `secondary:NewJobServer` and `secondary:NewJobServerWipe` events to
insert and remove job assignments.  The `srp‑base` backend now exposes a
RESTful API to perform the same operations while persisting data in
MySQL.

## Endpoints

### `GET /v1/secondary-jobs`

List all secondary job assignments for a given character.  The `playerId`
query parameter is required and must be a string.  On success, the
response contains an array of job records:

```
GET /v1/secondary-jobs?playerId=cid123

Response 200 OK
{
  "ok": true,
  "data": [
    {
      "id": 1,
      "playerId": "cid123",
      "job": "burglar",
      "created_at": "2025-08-19T12:00:00Z",
      "updated_at": "2025-08-19T12:00:00Z"
    }
  ],
  "requestId": "...",
  "traceId": "..."
}
```

### `POST /v1/secondary-jobs`

Assign a new secondary job to a character.  The request body must include
`playerId` and `job` strings.  If the assignment is created successfully
the response includes the auto‑incremented record ID:

```
POST /v1/secondary-jobs
{
  "playerId": "cid123",
  "job": "burglar"
}

Response 200 OK
{
  "ok": true,
  "data": { "id": 2 },
  "requestId": "...",
  "traceId": "..."
}
```

### `DELETE /v1/secondary-jobs`

Remove **all** secondary job assignments for the specified character.  The
`playerId` query parameter is required.  The response returns the number of
rows deleted:

```
DELETE /v1/secondary-jobs?playerId=cid123

Response 200 OK
{
  "ok": true,
  "data": { "deleted": 1 },
  "requestId": "...",
  "traceId": "..."
}
```

## Database Schema

Secondary jobs are persisted in the `secondary_jobs` table created by
migration 016.  The table schema is:

| Column     | Type          | Description                                  |
|-----------|---------------|----------------------------------------------|
| `id`      | INT           | Primary key, auto‑incrementing identifier     |
| `player_id` | VARCHAR(64) | Character identifier (CID)                    |
| `job`     | VARCHAR(100)  | Name of the secondary job                    |
| `created_at` | TIMESTAMP  | When the assignment was created               |
| `updated_at` | TIMESTAMP  | When the assignment was last updated          |

An index on `player_id` accelerates lookups by character.

## Notes

* This module is idempotent: deleting secondary jobs multiple times for
  the same character will return `deleted: 0` once no rows remain.
* Authentication, rate limiting and idempotency policies are inherited
  from the global middleware in `src/app.js`.
* If `playerId` or `job` are missing or not strings, the API returns a
  `VALIDATION_ERROR` with a `400` status.