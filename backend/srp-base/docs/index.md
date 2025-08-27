# SRP Base Documentation Index

This ledger captures notable backend updates. Earlier entries are consolidated; see `progress-ledger.md` for full history.

## Update – 2025-08-27

Extended ped persistence for the **isPed** resource with realtime pushes and server-side health regeneration.

* `PUT /v1/characters/{characterId}/ped` now dispatches WebSocket `peds.pedUpdated` and webhooks.
* Scheduler `peds-health-regen` increments stored health and broadcasts `peds.healthRegen`.
