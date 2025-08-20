# Manifest for Secondary Jobs Patch (2025‑08‑19 Part 6)

This manifest summarises the files added or modified in this patch and
provides context for the new **secondary jobs** module.

## Summary of Changes

* Added an Express router (`secondaryJobs.routes.js`) to expose REST
  endpoints for listing, creating and deleting secondary job
  assignments.
* Added a repository (`secondaryJobsRepository.js`) encapsulating data
  access for the `secondary_jobs` table.
* Added a SQL migration (`016_add_secondary_jobs.sql`) to create the
  `secondary_jobs` table and index on `player_id`.
* Added and mounted the secondary jobs router in `app.js`.
* Added module documentation under `docs/modules/secondaryjobs.md`.
* Created new `CHANGELOG.md` and `MANIFEST.md` entries for this sprint.

## File Listing

| Path | Type | Notes |
|---|---|---|
| `src/repositories/secondaryJobsRepository.js` | **A** | New repository exposing `listSecondaryJobs`, `createSecondaryJob`, `deleteSecondaryJobs` functions. |
| `src/routes/secondaryJobs.routes.js` | **A** | New Express router implementing `GET`, `POST` and `DELETE` endpoints for `/v1/secondary-jobs`. |
| `src/migrations/016_add_secondary_jobs.sql` | **A** | New migration creating the `secondary_jobs` table with an index on `player_id`. |
| `src/app.js` | **A/M** | Added import and mount for `secondaryJobsRoutes`; rest of file copied from base to maintain structure. |
| `docs/modules/secondaryjobs.md` | **A** | Documentation describing the new module, endpoints and database schema. |
| `CHANGELOG.md` | **A** | New changelog file capturing this sprint’s additions. |
| `MANIFEST.md` | **A** | This manifest summarising the patch. |

## Startup and Configuration Notes

* No new environment variables are required for the secondary jobs
  module.  Standard authentication (`X‑API‑Token`), idempotency and
  rate‑limiting middleware apply automatically via `app.js`.
* Run migrations via `node src/bootstrap/migrate.js` to apply
  `016_add_secondary_jobs.sql` before starting the service.

## Compatibility

Existing APIs remain unchanged.  The new endpoints follow the same
response envelope (`{ ok, data, requestId, traceId }`) as other
modules.  Clients must include the `X‑API‑Token` header on all
requests.  Idempotency keys may be provided to `POST` and `DELETE`
operations via the `X‑Idempotency-Key` header.