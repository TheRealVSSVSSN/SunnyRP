# Sprint Overview – 2025-08-23

This sprint resets the documentation ledger and introduces foundational support for the **DiamondBlackjack** resource. A new REST API records blackjack hands for each character, enabling future casino analytics while respecting multi-character ownership.

### Highlights

* Added Diamond Blackjack module with `GET` and `POST /v1/diamond-blackjack/hands` endpoints, repository, migration and OpenAPI documentation.
* Added Interact Sound module with `GET` and `POST /v1/interact-sound/plays` endpoints for sound playback history.
* Reset the progress ledger to begin a new parity run.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/diamondBlackjack.md`.

## Update – 2025-08-24

Extended parity for the **LockDoors** resource by documenting existing door management endpoints and aligning the OpenAPI specification.

* Added Interact Sound module with `GET` and `POST /v1/interact-sound/plays` endpoints for sound playback history.

* Reset the progress ledger to begin a new parity run.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/diamondBlackjack.md`.

## Update – 2025-08-24

Extended parity for the **PolicePack** resource by introducing evidence chain-of-custody tracking and account-based character selection APIs.

## Update – 2025-08-24

Introduced basic zone management to support the **PolyZone** resource.

* Added zones module with `GET /v1/zones`, `POST /v1/zones` and `DELETE /v1/zones/{id}` endpoints.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/zones.md`.

## Update – 2025-08-25

Extended parity for the **Wise Wheels** resource by introducing spin retention and expiry events.

* Spins older than 30 days are purged hourly, broadcasting `wise-wheels.spin.expired` via WebSocket and webhooks.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/wise-wheels.md`.

## Update – 2025-08-24

Introduced audio track storage to support the **Wise Audio** resource.

* Added Wise Audio module with `GET /v1/wise-audio/tracks/{characterId}` and `POST /v1/wise-audio/tracks` endpoints.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/wise-audio.md`.

## Update – 2025-08-24

Introduced import order tracking to support the **Wise Imports** resource.

* Added Wise Imports module with `GET /v1/wise-imports/orders/{characterId}` and `POST /v1/wise-imports/orders` endpoints.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/wise-imports.md`.

## Update – 2025-08-24

Introduced undercover profile storage to support the **Wise-UC** resource.

* Added Wise UC module with `GET /v1/wise-uc/profiles/{characterId}` and `POST /v1/wise-uc/profiles` endpoints.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/wise-uc.md`.
## Update – 2025-08-24

Retired legacy unscoped character endpoints to consolidate account-scoped character management.

* Removed `/v1/characters` and `/v1/characters/{id}` routes and OpenAPI paths.

For resource decisions see `progress-ledger.md`.

## Update – 2025-08-24

Introduced wheel spin tracking to support the **Wise Wheels** resource.

* Added Wise Wheels module with `GET /v1/wise-wheels/spins/{characterId}` and `POST /v1/wise-wheels/spins` endpoints.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/wise-wheels.md`.

## Update – 2025-08-24

Introduced asset metadata storage to support the **assets** resource.

* Added Assets module with `GET /v1/assets`, `GET /v1/assets/{id}`, `POST /v1/assets` and `DELETE /v1/assets/{id}` endpoints.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/assets.md`.

## Update – 2025-08-24

Introduced character outfit storage to support the **assets_clothes** resource.

* Added Clothes module with `GET /v1/clothes`, `POST /v1/clothes` and `DELETE /v1/clothes/{id}` endpoints.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/clothes.md`.

## Update – 2025-08-24

Reviewed asset-only resources **maps**, **furnished-shells**, **hair-pack**, **mh65c**, **motel**, **shoes-pack** and **yuzler**. No server-side responsibilities were identified; no API changes required.

For resource decisions see `progress-ledger.md`.

## Update – 2025-08-24

Extended parity for the **apartments** resource by enforcing character-scoped residency.

* Added optional `characterId` filter to `GET /v1/apartments`.
* Updated resident assignment to use character identifiers and added migration for `character_id` column.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/apartments.md`.

## Update – 2025-08-24

Introduced character-scoped banking to support the **banking** resource.

* Added economy module with account retrieval, deposit, withdrawal and transaction endpoints plus migration and OpenAPI documentation.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/economy.md`.

## Update – 2025-08-24

Introduced base event logging to support the **baseevents** resource.

* Added Base Events module with `GET /v1/base-events` and `POST /v1/base-events` endpoints.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/baseevents.md`.

## Update – 2025-08-25

Extended parity for the **boatshop** resource with realtime catalog and purchase events.

* Scheduler broadcasts `boatshop.catalog` every five minutes.
* Successful purchases emit `boatshop.purchase` via WebSocket and webhooks.

Reference resources unavailable; proceeding with internal consistency only.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/boatshop.md`.

## Update – 2025-08-25

Extended parity for the **boatshop** resource with realtime catalog and purchase events.

* Scheduler broadcasts `boatshop.catalog` every five minutes.
* Successful purchases emit `boatshop.purchase` via WebSocket and webhooks.

Reference resources unavailable; proceeding with internal consistency only.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/boatshop.md`.

## Update – 2025-03-15

Enhanced the Wise Imports module with scheduler-driven order readiness and delivery confirmation.

* Added background task promoting pending orders to ready status with real-time pushes.
* Added `POST /v1/wise-imports/orders/{id}/deliver` endpoint to finalize deliveries.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/wise-imports.md`.

## Update – 2025-08-24

Introduced boat catalog and purchase endpoints to support the **boatshop** resource.

* Added Boatshop module with `GET /v1/boatshop` and `POST /v1/boatshop/purchase` endpoints.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/boatshop.md`.


## Update – 2025-08-24

Reviewed map streaming resource **bob74_ipl**; no server-side responsibilities identified; no API changes required.

For resource decisions see `progress-ledger.md`.

## Update – 2025-08-24

Introduced photo storage to support the **camera** resource.

* Added Camera module with `GET /v1/camera/photos/{characterId}`, `POST /v1/camera/photos` and `DELETE /v1/camera/photos/{id}` endpoints.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/camera.md`.

## Update – 2025-08-24

Introduced HUD preference storage to support the **carandplayerhud** resource.

* Added HUD module with `GET /v1/characters/{characterId}/hud` and `PUT /v1/characters/{characterId}/hud` endpoints.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/hud.md`.

## Update – 2025-08-24

Introduced vehicle cleaning logs to support the **carwash** resource.

* Added Carwash module with `POST /v1/carwash`, `GET /v1/carwash/history/{characterId}` and vehicle dirt endpoints.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/carwash.md`.

## Update – 2025-08-24

Introduced chat message logging to support the **chat** resource.

* Added Chat module with `GET /v1/chat/messages/{characterId}` and `POST /v1/chat/messages` endpoints.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/chat.md`.

## Update – 2025-08-24

Introduced account queue priority management to support the **connectqueue** resource.

* Added Connect Queue module with `GET /v1/connectqueue/priorities`, `POST /v1/connectqueue/priorities` and `DELETE /v1/connectqueue/priorities/{accountId}` endpoints.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/connectqueue.md`.

## Update – 2025-08-24

Introduced cron job scheduling to support the **Cron** resource.

* Added Cron module with `GET /v1/cron/jobs` and `POST /v1/cron/jobs` endpoints.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/cron.md`.

## Update – 2025-08-25

Extended realtime support for the **assets** resource.

* Asset creation and deletion broadcast `assets.assetCreated` and `assets.assetDeleted` over WebSockets and webhooks.
* Hourly `assets-prune` scheduler removes entries older than `ASSET_RETENTION_MS` (default 30 days).

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/assets.md`.

Introduced coordinate saving to support the **coordsaver** resource.

* Added Coordsaver module with `GET /v1/characters/{characterId}/coords`, `POST /v1/characters/{characterId}/coords` and `DELETE /v1/characters/{characterId}/coords/{id}` endpoints.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/coordsaver.md`.

## Update – 2025-08-24

Introduced interior layout persistence to support the **drz_interiors** resource.

* Added Interiors module with `GET /v1/apartments/{apartmentId}/interior` and `POST /v1/apartments/{apartmentId}/interior` endpoints.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/interiors.md`.
## Update – 2025-08-24

Introduced favorite emote persistence to support the **emotes** resource.

* Added Emotes module with `GET /v1/characters/{characterId}/emotes`, `POST /v1/characters/{characterId}/emotes` and `DELETE /v1/characters/{characterId}/emotes/{emote}` endpoints.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/emotes.md`.

## Update – 2025-08-25

Introduced duty shift logging and documented medical record endpoints to support the **emspack** resource.

* Added EMS module with `/v1/ems/records` and `/v1/ems/shifts` endpoints.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/ems.md`.

## Update – 2025-08-25

Introduced taxi dispatch backend to support the **es_taxi** resource.

* Added Taxi module with `/v1/taxi/requests` and ride completion endpoints.
* Migration `046_add_taxi_rides.sql` creates the `taxi_rides` table.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/taxi.md`.

## Update – 2025-08-25

Introduced furniture placement storage to support the **furniture** resource.

* Added Furniture module with `/v1/characters/{characterId}/furniture` endpoints.
* Migration `047_add_furniture.sql` creates the `furniture` table.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/furniture.md`.

## Update – 2025-08-25

Reviewed **gabz_mrpd** mapping resource; no server responsibilities identified. Added `GET /v1/accounts/{accountId}/characters/selected` to retrieve the currently active character, strengthening multi-character session handling.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/characters.md`.

## Update – 2025-08-25

Introduced patient admission tracking to support the **gabz_pillbox_hospital** resource.

* Added Hospital module with `/v1/hospital/admissions` endpoints and migration.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/hospital.md`.

## Update – 2025-08-25

Extended parity for the **garages** resource by scoping stored vehicles to characters.

* Added Garage module with `/v1/garages` CRUD and character vehicle endpoints.
* Migration `049_add_garage_vehicle_character.sql` adds `character_id` to `garage_vehicles`.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/garages.md`.

## Update – 2025-08-25

Enhanced core database utilities to align with the **ghmattimysql** resource.

* Added named parameter handling, scalar queries and transaction helper functions in `src/repositories/db.js`.


## Update – 2025-08-25

Introduced server capacity tracking to support the **hardcap** resource.

* Added Hardcap module with `/v1/hardcap/status`, `/v1/hardcap/config` and `/v1/hardcap/sessions` endpoints.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/hardcap.md`.

## Update – 2025-08-25

Introduced helicopter flight logging to support the **heli** resource.

* Added Heli module with `/v1/heli/flights`, `/v1/heli/flights/{id}/end` and `/v1/characters/{characterId}/heli/flights` endpoints.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/heli.md`.

## Update – 2025-08-25

Introduced import package tracking to support the **import-Pack** resource.

* Added Import Pack module with `/v1/import-pack/orders/{characterId}`, `/v1/import-pack/orders` and `/v1/import-pack/orders/{id}/deliver` endpoints.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/import-pack.md`.

## Update – 2025-08-25

Extended import package tracking to support the **import-Pack2** resource.

* Added order retrieval and cancellation with pricing via `/v1/import-pack/orders`, `/v1/import-pack/orders/{id}`, `/v1/import-pack/orders/{id}/cancel`, `/v1/import-pack/orders/{id}/deliver` and `/v1/import-pack/orders/character/{characterId}` endpoints.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/import-pack.md`.

## Update – 2025-08-25

Introduced ped state persistence to support the **isPed** resource.

* Added Peds module with `GET /v1/characters/{characterId}/ped` and `PUT /v1/characters/{characterId}/ped` endpoints.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/peds.md`.
## Update – 2025-08-25

Introduced jailbreak attempt tracking to support the **jailbreak** resource.

* Added Jailbreak module with `/v1/jailbreaks`, `/v1/jailbreaks/active` and `/v1/jailbreaks/{id}/complete` endpoints.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/jailbreak.md`.

## Update – 2025-08-25

Introduced police K9 unit tracking to support the **k9** resource.

* Added K9 module with `GET /v1/characters/{characterId}/k9s`, `POST /v1/characters/{characterId}/k9s`, `PATCH /v1/characters/{characterId}/k9s/{k9Id}/active` and `DELETE /v1/characters/{characterId}/k9s/{k9Id}` endpoints.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/k9.md`.
Introduced character-scoped job assignments to support the **jobsystem** resource.

* Added Jobs module with `/v1/jobs` CRUD and assignment endpoints plus migration and OpenAPI documentation.
* Updated Broadcaster module to use character identifiers for role attempts.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/jobs.md`.

## Update – 2025-08-25

Resolved duplicate migration numbering and added debug diagnostics endpoint supporting the **srp-debug** resource.

* Renamed K9 migration to `057_add_k9_units.sql`.
* Added Debug module with `GET /v1/debug/status` endpoint.
* Reference resources unavailable; proceeding with internal consistency only.

## Update – 2025-08-25

Introduced world weather forecast tracking to support the **srp-weathersync** resource.

* Added world forecast endpoints and migration `058_add_world_forecast.sql`.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/world.md`.

## Update – 2025-03-02

Replaced the standalone DiamondBlackjack module with a unified **Diamond Casino** backend and introduced core realtime infrastructure.

* Added Diamond Casino module with `/v1/diamond-casino/games` and `/v1/diamond-casino/games/{gameId}/bets` endpoints.
* Added WebSocket gateway with heartbeat and authenticated connections.
* Added webhook dispatcher scaffolding with HMAC signatures and retry.
* Added drift-aware scheduler to resolve casino games server-side.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/diamondCasino.md`.

## Update – 2025-08-25

Extended world module with timecycle override support for the **climate-overrides** resource (formerly koillove).

* Added world timecycle endpoints and repository functions.
* Migration `059_add_world_timecycle.sql` creates `world_timecycle` table.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/world.md`.

## Update – 2025-08-25

Expanded parity for the **InteractSound** cluster by pushing sound play events over WebSockets and webhooks while purging stale logs.

* Broadcast `interactSound.play` events to connected clients.
* Added admin webhook endpoint management at `/v1/hooks/endpoints`.
* Scheduler task removes plays older than `INTERACT_SOUND_RETENTION_MS`.

## Update – 2025-08-25

Consolidated police dispatch responsibilities with real-time push and retention.

* Broadcast and webhook `dispatchAlert` and `dispatchAck` events.
* Scheduler purges `dispatch_alerts` older than `DISPATCH_ALERT_RETENTION_MS`.
* Documented dispatch APIs in OpenAPI and module docs.

## Update – 2025-02-14

Extended parity for the **PolyZone** resource with expiration and real-time pushes.

* Zones may specify `expiresAt`; a scheduler purges expired entries hourly.
* Zone creation and deletion events broadcast via WebSocket and webhook dispatcher.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/zones.md`.

## Update – 2025-08-25

Introduced unified properties backend to consolidate apartments, garages and hotel rentals.

* Added `/v1/properties` CRUD endpoints with WebSocket and webhook events.
* Hourly `properties-expire` scheduler releases leases past `expires_at`.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/properties.md`.

## Update – 2025-08-25

Extended parity for the **banking** resource with invoice support and real-time notifications.

* Added invoice endpoints with WebSocket and webhook events.
* Hourly scheduler purges settled invoices.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/economy.md`.

## Update – 2025-08-25

Enhanced base event logging with WebSocket pushes and retention.

* `POST /v1/base-events` now broadcasts `base-events.logged` via WebSocket.
* Hourly `base-events-purge` scheduler removes logs older than `BASE_EVENT_RETENTION_MS`.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/baseevents.md`.

## Update – 2025-08-25

Introduced interior proxy state management to support the **bob74_ipl** resource.

* Added world IPL endpoints `/v1/world/ipls` and `/v1/world/ipls/{name}` with WebSocket broadcasts and scheduled sync.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/world.md`.
