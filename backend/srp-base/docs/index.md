# SRP Base Documentation Index

This ledger captures notable backend updates. Earlier entries are consolidated; see `progress-ledger.md` for full history.

## Update – 2025-08-27

Extended ped persistence for the **isPed** resource with realtime pushes and server-side health regeneration.

* `PUT /v1/characters/{characterId}/ped` now dispatches WebSocket `peds.pedUpdated` and webhooks.
* Scheduler `peds-health-regen` increments stored health and broadcasts `peds.healthRegen`.

## Update – 2025-08-27 (jailbreak)

Auto-expiring jailbreak attempts with realtime notifications.

* `POST /v1/jailbreaks` and `POST /v1/jailbreaks/{id}/complete` emit WebSocket `jailbreaks.*` and webhooks.
* Scheduler `jailbreak-expire` marks stale attempts failed after `JAILBREAK_MAX_ACTIVE_MS`.

## Update – 2025-08-28

Realtime job assignments and roster broadcast.

* `POST /v1/jobs/assign` and `POST /v1/jobs/duty` emit `jobs.*` events over WebSocket and webhooks.
* Scheduler `jobs-roster-sync` broadcasts on-duty rosters every minute.

## Update – 2025-08-28 (k9)

Active K9 roster push model.

* `GET /v1/k9s/active` lists active units.
* `POST /v1/characters/{characterId}/k9s`, `PATCH /v1/characters/{characterId}/k9s/{k9Id}/active`, and `DELETE /v1/characters/{characterId}/k9s/{k9Id}` emit `k9.*` events via WebSocket and webhooks.
* Scheduler `k9-active-broadcast` broadcasts active units periodically.
