# Events and RPCs Mapping

| Resource | In-Game Events/RPCs | SRP Base API Mapping |
|---|---|---|
| DiamondCasino | Resource emits events for casino games such as blackjack, slots and horse racing | `POST /v1/diamond-casino/games` creates a game; bets via `POST /v1/diamond-casino/games/{gameId}/bets` and history via `GET /v1/diamond-casino/games/{gameId}` |
| PolicePack | Resource emits events for evidence custody updates and character selections | Custody via `GET/POST /v1/evidence/items/{id}/custody`; selection via `POST /v1/accounts/{accountId}/characters/{characterId}:select` |
| InteractSound | Resource triggers audio playback events specifying sound name and volume to target clients | `POST /v1/interact-sound/plays` logs and broadcasts; history via `GET /v1/interact-sound/plays/:characterId` |
| PolyZone | Resource defines polygonal zones for triggers | `GET /v1/zones`, `POST /v1/zones`, `DELETE /v1/zones/:id` manage zone records; `zone.created` and `zone.deleted` pushed via WebSocket/webhooks |
| Wise Audio | Resource manages character soundboard tracks | `GET /v1/wise-audio/tracks/:characterId`, `POST /v1/wise-audio/tracks` → pushes `wise-audio.track.created` |
| Wise Imports | Resource manages vehicle import orders | `GET /v1/wise-imports/orders/:characterId`, `POST /v1/wise-imports/orders`, `POST /v1/wise-imports/orders/{id}/deliver` → pushes `wise-imports.order.created`, scheduler pushes `wise-imports.order.ready`, delivery pushes `wise-imports.order.delivered` |
| import-Pack2 | Resource manages vehicle import packages with pricing and cancellation | `GET /v1/import-pack/orders/character/{characterId}`, `GET /v1/import-pack/orders/{id}`, `POST /v1/import-pack/orders`, `POST /v1/import-pack/orders/{id}/deliver`, `POST /v1/import-pack/orders/{id}/cancel` |
| WiseGuy-Vanilla | Base resource using account-scoped character management | `GET/POST/DELETE/POST select/GET selected /v1/accounts/{accountId}/characters` |
| Wise-UC | Resource manages undercover aliases for characters | `GET /v1/wise-uc/profiles/:characterId`, `POST /v1/wise-uc/profiles` → pushes `wise-uc.profile.upserted` |
| WiseGuy-Wheels | Resource records wheel spin outcomes per character | `GET /v1/wise-wheels/spins/:characterId`, `POST /v1/wise-wheels/spins` → pushes `wise-wheels.spin.created` |
| assets | Resource stores media or item assets linked to characters | `GET /v1/assets`, `GET /v1/assets/{id}`, `POST /v1/assets`, `DELETE /v1/assets/{id}` |
| assets_clothes | Resource saves and retrieves character outfits | `GET /v1/clothes`, `POST /v1/clothes`, `DELETE /v1/clothes/{id}` |
| apartments | Resource triggers events when characters claim or vacate apartments | `GET /v1/apartments` with optional `characterId` filter and resident assignment endpoints |
| banking | Resource processes deposits, withdrawals and transfers between characters | `POST /v1/characters/{characterId}/account:deposit`, `POST /v1/characters/{characterId}/account:withdraw`, `POST /v1/transactions` |
| maps | No server events; world mapping assets | N/A |
| furnished-shells | No server events; interior shell assets | N/A |
| Cron | Resource triggers scheduled events for maintenance and gameplay loops | `GET /v1/cron/jobs`, `POST /v1/cron/jobs` |
| hair-pack | No server events; cosmetic hair assets | N/A |
| mh65c | No server events; vehicle model asset | N/A |
| motel | No server events; building interior asset | N/A |
| shoes-pack | No server events; footwear assets | N/A |
| yuzler | No server events; clothing assets | N/A |
| baseevents | Emits player join, drop and kill events | `POST /v1/base-events` logs events; `GET /v1/base-events` lists history |
| boatshop | Resource sends purchase requests for boats | `GET /v1/boatshop`, `POST /v1/boatshop/purchase` |
| bob74_ipl | Loads interior proxies; no server events | N/A |
| camera | Resource captures photos and uploads metadata | `GET /v1/camera/photos/{characterId}`, `POST /v1/camera/photos`, `DELETE /v1/camera/photos/{id}` |
| carandplayerhud | Resource broadcasts HUD updates when preferences change | `GET /v1/characters/{characterId}/hud`, `PUT /v1/characters/{characterId}/hud` |
| carwash | Resource triggers wash events with plate and cost | `POST /v1/carwash`, `GET /v1/carwash/history/{characterId}`, `GET/PATCH /v1/vehicles/{plate}/dirt` |
| chat | Resource broadcasts chat messages | `POST /v1/chat/messages` logs message; history via `GET /v1/chat/messages/{characterId}` |
| connectqueue | Resource uses exports `AddPriority` and `RemovePriority` with account identifiers | `GET/POST/DELETE /v1/connectqueue/priorities` manage backend priority records |
| coordsaver | Resource lets players save named coordinates | `GET /v1/characters/{characterId}/coords`, `POST /v1/characters/{characterId}/coords`, `DELETE /v1/characters/{characterId}/coords/{id}` |
| drz_interiors | Resource triggers save/load events for apartment interior templates | `GET /v1/apartments/{apartmentId}/interior`, `POST /v1/apartments/{apartmentId}/interior` |
| emotes | Resource lets players mark favorite emote commands for quick selection | `GET/POST/DELETE /v1/characters/{characterId}/emotes` |
| emspack | Resource emits duty start/end and treatment events | `GET/POST/PATCH/DELETE /v1/ems/records`, `GET /v1/ems/shifts/active`, `POST /v1/ems/shifts`, `POST /v1/ems/shifts/{id}/end` |
| es_taxi | Players request taxi rides and drivers accept/complete them | `POST /v1/taxi/requests`, `POST /v1/taxi/requests/{id}/accept`, `POST /v1/taxi/requests/{id}/complete` |
| k9 | Police dog deployment and status commands | `GET/POST /v1/characters/{characterId}/k9s`, `PATCH /v1/characters/{characterId}/k9s/{k9Id}/active`, `DELETE /v1/characters/{characterId}/k9s/{k9Id}` |
| dispatch | Police dispatch alerts and code lists | `GET/POST /v1/dispatch/alerts`, `PATCH /v1/dispatch/alerts/{id}/ack`, `GET /v1/dispatch/codes` |
| furniture | Resource lets players place or remove furniture items | `GET /v1/characters/{characterId}/furniture`, `POST /v1/characters/{characterId}/furniture`, `DELETE /v1/characters/{characterId}/furniture/{id}` |
| gabz_mrpd | Map resource for Mission Row PD building; no events | N/A |
| gabz_pillbox_hospital | Resource handles hospital admissions and bed management | `GET /v1/hospital/admissions/active`, `POST /v1/hospital/admissions`, `POST /v1/hospital/admissions/{id}/discharge` |
| garages | Resource emits events when vehicles are stored or retrieved from garages | `/v1/garages` CRUD, `/v1/garages/{garageId}/store`, `/v1/garages/{garageId}/retrieve`, `/v1/characters/{characterId}/garages/{garageId}/vehicles` |
| ghmattimysql | Exports `execute`, `scalar` and `transaction` for MySQL queries | Core `db` repository offers `query`, `scalar` and `transaction` helpers with named parameters |
| hardcap | Connection attempts and slot checks | `GET /v1/hardcap/status`, `POST /v1/hardcap/sessions`, `DELETE /v1/hardcap/sessions/{id}` |
| heli | Resource logs helicopter flight start and end events | `POST /v1/heli/flights`, `POST /v1/heli/flights/{id}/end`, `GET /v1/characters/{characterId}/heli/flights` |
| isPed | Resource manages ped state updates like model, health and armor | `GET/PUT /v1/characters/{characterId}/ped` |
| jailbreak | Resource triggers jailbreak start and completion events with character and prison info | `POST /v1/jailbreaks`, `POST /v1/jailbreaks/{id}/complete`, `GET /v1/jailbreaks/active` |
| jobsystem | Resource manages job definitions and assignments | `GET /v1/jobs`, `POST /v1/jobs`, `GET /v1/jobs/{id}`, `POST /v1/jobs/assign`, `POST /v1/jobs/duty`, `GET /v1/jobs/{characterId}/assignments` |
| broadcaster | Event to attempt joining the broadcaster job | `POST /v1/broadcast/attempt` |
| srp-debug | Developer requests for runtime diagnostics | `GET /v1/debug/status` returns server metrics |
| srp-weathersync | Resource broadcasts weather and time updates to clients | `GET /v1/world/state`, `POST /v1/world/state`, `GET /v1/world/forecast`, `POST /v1/world/forecast` |
| climate-overrides | Resource applies custom timecycle XMLs | `/v1/world/timecycle` to set or clear presets |
