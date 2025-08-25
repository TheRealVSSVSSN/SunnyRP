# Jobs Module

The Jobs module provides REST endpoints for defining jobs and assigning them to characters.
It mirrors the responsibilities of the original `jobsystem` resource while enforcing
character-based ownership and optional grade tracking.

## Endpoints

### `GET /v1/jobs`
List all job definitions.

### `POST /v1/jobs`
Create a job with `name`, optional `label` and `description`.

### `GET /v1/jobs/{id}`
Retrieve a job by its identifier.

### `POST /v1/jobs/assign`
Assign a job to a character.
Body:
```
{
  "characterId": 123,
  "jobId": 1,
  "grade": 0
}
```
Returns the stored assignment.

### `POST /v1/jobs/duty`
Toggle duty status for a character and job.
Body:
```
{
  "characterId": 123,
  "jobId": 1,
  "onDuty": true
}
```

### `GET /v1/jobs/{characterId}/assignments`
List all job assignments for a character.

## Database Schema

Jobs are stored in the `jobs` table and character assignments in `character_jobs`:

| Table | Purpose |
|---|---|
| `jobs` | Job definitions with `name`, `label`, `description` |
| `character_jobs` | Character job assignments with `grade`, `on_duty` and `hired_at` |

## Notes

* Assignments are scoped by `character_id`; `grade` defaults to `0`.
* All endpoints require an `X-API-Token` header. Mutating requests honor idempotency and rate limits.
