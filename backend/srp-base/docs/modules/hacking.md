# Hacking Module

## Purpose
Records character hacking attempts for analytics and gameplay consequences.

## Routes
- `GET /v1/hacking/attempts` — list recent attempts for a character.
- `POST /v1/hacking/attempts` — log new hacking attempt.

## Repository Contracts
- `createAttempt({ characterId, target, success })`
- `listRecent(characterId, limit)`
- `deleteOldAttempts(ttlMs)`

## Edge Cases
- `X-Idempotency-Key` required on `POST /v1/hacking/attempts`.
- Validation errors return code `VALIDATION_ERROR`.
