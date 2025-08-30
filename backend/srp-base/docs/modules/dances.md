# dances module

## Purpose
Store and manage server-defined dance animations available to clients. Supports realtime sync and retention cleanup.

## Routes
- `GET /v1/dances/animations` — list available animations.
- `POST /v1/dances/animations` — add animation. Requires `X-Idempotency-Key`.
- `DELETE /v1/dances/animations/{id}` — disable animation. Requires `X-Idempotency-Key`.

## Repository Contract
- `listAnimations()` → array of animations.
- `createAnimation({ name, dict, animation })` → persisted record.
- `disableAnimation(id)` → marks animation disabled.
- `purgeOldDisabled(cutoffMs)` → returns rows purged by scheduler.

## Scheduler
- `dances-purge` runs hourly removing disabled animations older than `DANCE_RETENTION_MS`.

## WebSocket / Webhook Events
- `dances.animationAdded`
- `dances.animationRemoved`
- `dances.animationExpired`

## Edge Cases
- Duplicate `(name, dict, animation)` combinations are ignored via unique key.
