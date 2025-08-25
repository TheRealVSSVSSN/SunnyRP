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
