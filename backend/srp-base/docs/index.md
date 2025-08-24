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
