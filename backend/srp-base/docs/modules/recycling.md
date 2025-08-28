# recycling module

Tracks recycling job deliveries and rewards.

## Routes

- `GET /v1/recycling/deliveries/{characterId}`
- `POST /v1/recycling/deliveries`

## Repository Contracts

- `createRun({ characterId, materials })` – store delivery record.
- `listRunsByCharacter(characterId)` – list deliveries for a character.
- `deleteOlderThan(cutoff)` – purge stale records.

## Realtime & Scheduler

- WebSocket `recycling.delivery.created` and matching webhooks on delivery creation.
- Scheduler `recycling-purge` removes records older than `RECYCLING_RETENTION_MS`.

## Edge Cases

- Listing returns an empty array when no deliveries exist.
- Materials must be a positive integer.
