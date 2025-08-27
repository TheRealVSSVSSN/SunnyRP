# Cron Module

The cron module stores scheduled tasks that external resources can use to trigger timed events. Jobs may be global or scoped to an account or character and support priorities for ordering.

## Feature flag

There is no feature flag for cron; the module is always enabled.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/cron/jobs`** | List registered cron jobs. | 60/min per IP | Required | Yes | None | `{ ok, data: { jobs: CronJob[] }, requestId, traceId }` |
| **POST `/v1/cron/jobs`** | Create or replace a cron job. Requires `name`, `schedule` and `nextRun`. | 30/min per IP | Required | Yes | `CronJobCreateRequest` | `{ ok, data: { job: CronJob }, requestId, traceId }` |

### Schemas

* **CronJob** –
  ```yaml
  id: integer
  name: string
  schedule: string
  payload: object | null
  accountId: integer | null
  characterId: integer | null
  priority: integer
  nextRun: string (date-time)
  lastRun: string (date-time) | null
  createdAt: string (date-time)
  updatedAt: string (date-time)
  ```
* **CronJobCreateRequest** –
  ```yaml
  name: string
  schedule: string
  payload: object | null
  accountId: integer | null
  characterId: integer | null
  priority: integer (default 0)
  nextRun: string (date-time)
  ```

## Implementation details

* **Repository:** `src/repositories/cronRepository.js` manages job persistence and rescheduling.
* **Migration:** `src/migrations/042_add_cron_jobs.sql` creates the `cron_jobs` table.
* **Routes:** `src/routes/cron.routes.js` exposes REST endpoints.
* **Scheduler:** `src/tasks/cron.js` polls due jobs, broadcasts `cron.execute` over WebSocket and dispatches webhooks.
* **OpenAPI:** `openapi/api.yaml` documents schemas and paths.

## Future work

Additional job types and administrative endpoints could further expand scheduling capabilities.
