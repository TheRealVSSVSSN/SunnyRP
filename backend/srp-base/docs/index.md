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

## Update – 2025-08-28 (koil-debug)

Debug domain extended with structured logs and ephemeral markers.

* `POST /v1/debug/logs` and `GET /v1/debug/logs` store and retrieve logs.
* `POST /v1/debug/markers`, `GET /v1/debug/markers`, `DELETE /v1/debug/markers/{id}` manage markers.
* WebSocket `debug.*` and webhook events mirror lifecycle; scheduler purges expired markers and old logs.
## Update – 2025-08-28 (k9)

Active K9 roster push model.

* `GET /v1/k9s/active` lists active units.
* `POST /v1/characters/{characterId}/k9s`, `PATCH /v1/characters/{characterId}/k9s/{k9Id}/active`, and `DELETE /v1/characters/{characterId}/k9s/{k9Id}` emit `k9.*` events via WebSocket and webhooks.

* Scheduler `k9-active-broadcast` broadcasts active units periodically.
* Scheduler `k9-active-broadcast` broadcasts active units periodically.

## Update – 2025-08-28 (weathersync)

Weather.gov integration with forecast proxy and scheduler.

* `GET/POST /v1/weathersync/forecast` manage forecasts.
* `GET /v1/weathersync/weather.gov` proxies api.weather.gov.
* Scheduler `weathersync-forecast` pulls forecasts and broadcasts `world.forecast.updated`.

## Update – 2025-08-28 (climate-overrides realtime)

Timecycle overrides now broadcast set/clear events and expire automatically.

* `POST /v1/world/timecycle` and `DELETE /v1/world/timecycle` emit `world.timecycle.*` over WebSocket and webhooks.
* Scheduler `timecycle-expiry` clears overrides past `expiresAt`.

## Update – 2025-08-29 (recycling)

Tracked recycling job deliveries with realtime pushes.

* `POST /v1/recycling/deliveries` logs a delivery and emits `recycling.delivery.created` via WebSocket and webhooks.
* 
* Scheduler `recycling-purge` removes deliveries older than `RECYCLING_RETENTION_MS`.

## Update – 2025-08-29 (vehicle control)

Persist and broadcast vehicle siren/indicator state.

* `GET/POST /v1/vehicles/{plate}/control` manage siren and indicator state.
* Scheduler `vehicle-control-prune` removes stale control records.
* Scheduler `recycling-purge` removes deliveries older than `RECYCLING_RETENTION_MS`.

## Update – 2025-08-29 (mapmanager)

Webhooks added for interior proxy updates.

* `POST /v1/world/ipls` and `DELETE /v1/world/ipls/{name}` now emit `world.ipl.updated` and `world.ipl.removed` via WebSocket and webhooks.

## Update – 2025-08-29 (mhacking)

Logged hacking attempts with realtime pushes and scheduled cleanup.

* `POST /v1/hacking/attempts` records an attempt and emits `hacking.attempt.created` via WebSocket and webhooks.
* Scheduler `hacking-purge` removes attempts older than `HACKING_RETENTION_MS`.

## Update – 2025-02-14 (ems vehicles)

Logged EMS vehicle spawns with realtime push and retention purge.

* `POST /v1/ems/vehicles` records spawns and emits `ems.vehicle.spawn`.
* Scheduler `ems-vehicle-spawn-purge` removes old spawn logs.

## Update – 2025-08-29 (minimap)

Dynamic minimap blip service.

* `GET /v1/minimap/blips`, `POST /v1/minimap/blips`, and `DELETE /v1/minimap/blips/{id}` manage blips.
* Scheduler `minimap-blips-broadcast` pushes `world.minimap.blips` events over WebSocket.

## Update – 2025-08-29 (noclip)

Admin noclip control with permission enforcement and realtime signal.

* `POST /v1/admin/noclip` emits `admin.noclip` to the targeted player's namespace.

## Update – 2025-08-30 (action bar)

Persisted per-character quick action slots with realtime push.

* `GET /v1/characters/{characterId}/action-bar`, `PUT /v1/characters/{characterId}/action-bar` manage slots and emit `hud.actionBar.updated`.

## Update – 2025-08-30 (admin unban)

Logged unban actions with audit trail and WebSocket push.

* `POST /v1/admin/unban` logs and broadcasts ban removals.
* `GET /v1/admin/bans/{playerId}` exposes ban status.
## Update – 2025-08-30 (barriers)

Persistent world barriers with realtime sync.

* `GET /v1/barriers`, `POST /v1/barriers`, `PATCH /v1/barriers/{barrierId}/state` manage barrier definitions and state.
* Scheduler `barriers-reset` closes expired barriers and broadcasts `barriers.state`.

## Update – 2025-08-30 (np-base)

Base event logs now support filtering by type for targeted retrieval.

* `GET /v1/base-events?eventType=` returns only matching events using new `(event_type, created_at)` index.

## Update – 2025-08-30 (mechanic)

Mechanic orders API with realtime completion events.

* `POST /v1/mechanic/orders` creates work orders.
* `GET /v1/mechanic/orders/{id}` retrieves status.
* Scheduler `mechanic-process` marks orders complete and broadcasts `mechanic.orders.completed`.

## Update – 2025-08-30 (broadcast)

Broadcast messages API with realtime push and hourly retention purge.

* `POST /v1/broadcast/attempt` assigns broadcaster job.
* `GET /v1/broadcast/messages` lists recent messages.
* `POST /v1/broadcast/messages` creates a message and emits `broadcast.message` via WebSocket and webhooks.

## Update – 2025-08-30 (camera metadata)

Photo descriptions can now be updated with realtime notifications.

* `PATCH /v1/camera/photos/{id}` updates description and emits `camera.photo.updated` via WebSocket and webhooks.

## Update – 2025-08-30 (commands)

Managed server command definitions with realtime push.

* `GET /v1/commands`, `POST /v1/commands`, `DELETE /v1/commands/{id}` emit `commands.*` over WebSocket and webhooks.
