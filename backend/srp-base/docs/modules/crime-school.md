# crime-school module

Tracks character progress through staged crime training.

## Routes

- `GET /v1/crime-school/{characterId}`
- `POST /v1/crime-school/{characterId}`

## Repository Contracts

- `getProgress(characterId)` – fetch progress record or null.
- `updateProgress(characterId, stage)` – insert or update current stage.
- `deleteOlderThan(cutoff)` – purge stale records.

## Realtime & Scheduler

- WebSocket `crime-school.progress.updated` and matching webhooks on progress change.
- Scheduler `crime-school-expiry` removes records older than `CRIME_SCHOOL_RETENTION_DAYS`.

## Edge Cases

- Missing record returns `null`.
- Stage is required; updates overwrite previous stage.
