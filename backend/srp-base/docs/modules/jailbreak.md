# Jailbreak Module

## Purpose
Tracks jailbreak attempts and their outcomes for characters.

## Routes
- `POST /v1/jailbreaks` – start a jailbreak attempt.
- `POST /v1/jailbreaks/{id}/complete` – complete an attempt with `success` flag.
- `GET /v1/jailbreaks/active` – list active attempts.

### Realtime
- WebSocket namespace `jailbreaks` emits `attempt`, `completed`, and `expired` events.
- Webhook dispatcher mirrors events as `jailbreak.attempt`, `jailbreak.completed`, and `jailbreak.expired`.

## Repository Contracts
- `createAttempt({ characterId, prison })` → `JailbreakAttempt`.
- `completeAttempt({ id, success })` → `JailbreakAttempt` or `null` if not found.
- `listActiveAttempts()` → Array of `JailbreakAttempt`.
- `expireStale(maxAgeMs)` → Array of expired `JailbreakAttempt`.

## Edge Cases
- Returns 400 if required fields are missing.
- Returns 404 when completing a non-existent attempt.

## Scheduler
- `jailbreak-expire` runs every minute to fail attempts older than `JAILBREAK_MAX_ACTIVE_MS` (default 5 minutes).
