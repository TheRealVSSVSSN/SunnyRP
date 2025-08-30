# Events and RPCs Mapping

| Resource | In-Game Events/RPCs | SRP Base API Mapping |
|---|---|---|
| DiamondCasino | Resource emits events for casino games such as blackjack, slots and horse racing | `POST /v1/diamond-casino/games` creates a game; bets via `POST /v1/diamond-casino/games/{gameId}/bets` and history via `GET /v1/diamond-casino/games/{gameId}` |
| medicgarage | Events `medicg:s_classic*`, `medicg:s_helico`, `medicg:firetruk` spawn EMS vehicles | `POST /v1/ems/vehicles` (vehicleType) → WebSocket `ems.vehicle.spawn` |
| PolicePack | Resource emits events for evidence custody updates and character selections | Custody via `GET/POST /v1/evidence/items/{id}/custody`; selection via `POST /v1/accounts/{accountId}/characters/{characterId}:select` |
| InteractSound | Resource triggers audio playback events specifying sound name and volume to target clients | `POST /v1/interact-sound/plays` logs and broadcasts; history via `GET /v1/interact-sound/plays/:characterId` |
| PolyZone | Resource defines polygonal zones for triggers | `GET /v1/zones`, `POST /v1/zones`, `DELETE /v1/zones/:id` manage zone records; `zone.created` and `zone.deleted` pushed via WebSocket/webhooks |
| Wise Audio | Resource manages character soundboard tracks | `GET /v1/wise-audio/tracks/:characterId`, `POST /v1/wise-audio/tracks` → pushes `wise-audio.track.created` |
| Wise Imports | Resource manages vehicle import orders | `GET /v1/wise-imports/orders/:characterId`, `POST /v1/wise-imports/orders`, `POST /v1/wise-imports/orders/{id}/deliver` → pushes `wise-imports.order.created`, scheduler pushes `wise-imports.order.ready`, delivery pushes `wise-imports.order.delivered` |
| Import Pack | Vehicle import packages with pricing, delivery, cancellation and expiry | `GET /v1/import-pack/orders/character/{characterId}`, `GET /v1/import-pack/orders/{id}`, `POST /v1/import-pack/orders`, `POST /v1/import-pack/orders/{id}/deliver`, `POST /v1/import-pack/orders/{id}/cancel` – WS `import-pack.order.created`, `import-pack.order.delivered`, `import-pack.order.canceled`, scheduler emits `import-pack.order.expired` |
| WiseGuy-Vanilla | Base resource using account-scoped character management | `GET/POST/DELETE/POST select/GET selected /v1/accounts/{accountId}/characters` |
| Wise-UC | Resource manages undercover aliases for characters | `GET /v1/wise-uc/profiles/:characterId`, `POST /v1/wise-uc/profiles` → pushes `wise-uc.profile.upserted` |
| WiseGuy-Wheels | Resource records wheel spin outcomes per character | `GET /v1/wise-wheels/spins/:characterId`, `POST /v1/wise-wheels/spins` → pushes `wise-wheels.spin.created`; scheduler emits `wise-wheels.spin.expired` |
| assets | Resource stores media or item assets linked to characters | `GET /v1/assets`, `GET /v1/assets/{id}`, `POST /v1/assets`, `DELETE /v1/assets/{id}` → pushes `assets.assetCreated`/`assets.assetDeleted` |
| assets_clothes | Resource saves and retrieves character outfits | `GET /v1/clothes`, `POST /v1/clothes`, `DELETE /v1/clothes/{id}` |
| properties | Resource manages apartments, garages and rentals with ownership and lease events | `GET/POST/PATCH/DELETE /v1/properties`; broadcasts `properties.propertyCreated`/`properties.propertyUpdated`/`properties.propertyDeleted` |
| banking | Resource processes deposits, withdrawals, transfers and invoices | `POST /v1/characters/{characterId}/account:deposit`, `POST /v1/characters/{characterId}/account:withdraw`, `POST /v1/transactions`, `POST /v1/invoices` |
| bob74_ipl | Resource toggles interior proxies (IPLs) for world interiors | `GET/POST/DELETE /v1/world/ipls` → pushes `world.ipl.updated` via WebSocket/webhooks; scheduler broadcasts `world.ipl.sync` |
| maps | No server events; world mapping assets | N/A |
| furnished-shells | No server events; interior shell assets | N/A |
| Cron | Resource triggers scheduled events for maintenance and gameplay loops | `GET /v1/cron/jobs`, `POST /v1/cron/jobs`; scheduler broadcasts `cron.execute` |
| hair-pack | No server events; cosmetic hair assets | N/A |
| mh65c | No server events; vehicle model asset | N/A |
| motel | No server events; building interior asset | N/A |
| shoes-pack | No server events; footwear assets | N/A |
| yuzler | No server events; clothing assets | N/A |
| baseevents | Emits player join, drop and kill events | `POST /v1/base-events` logs events and broadcasts `base-events.logged`; `GET /v1/base-events` lists history |
| boatshop | Resource sends purchase requests for boats | `GET /v1/boatshop`, `POST /v1/boatshop/purchase` → broadcasts `boatshop.catalog` (scheduled) and `boatshop.purchase` |
| camera | Resource captures photos and uploads metadata | `GET /v1/camera/photos/{characterId}`, `POST /v1/camera/photos`, `DELETE /v1/camera/photos/{id}` → pushes `camera.photo.created`/`camera.photo.deleted` |
| carandplayerhud | Resource broadcasts HUD updates and vehicle state changes | `GET /v1/characters/{characterId}/hud`, `PUT /v1/characters/{characterId}/hud`, `GET /v1/characters/{characterId}/vehicle-state`, `PUT /v1/characters/{characterId}/vehicle-state` → WebSocket `hud.vehicleState` |
| np-actionbar | Client manages quick action slots and holster events | `GET/PUT /v1/characters/{characterId}/action-bar` → WebSocket `hud.actionBar.updated` |
| carwash | `carwash:checkmoney`, `carwash:success`, `notenoughmoney` | `POST /v1/carwash`, `GET /v1/carwash/history/{characterId}`, `GET/PATCH /v1/vehicles/{plate}/dirt`; dirt changes push `vehicles.dirt.update` |
| chat | Resource broadcasts chat messages | `POST /v1/chat/messages` logs and pushes `chat.message`; history via `GET /v1/chat/messages/{characterId}`; scheduler `chat-purge` removes old logs |
| connectqueue | Resource uses exports `AddPriority` and `RemovePriority` with account identifiers and now pushes `priority.upserted`, `priority.removed` and `priority.expired` over WebSocket and webhooks | `GET/POST/DELETE /v1/connectqueue/priorities` manage backend priority records |
| coordinates | Resource lets players save named coordinates. Events broadcast on WebSocket topic `coordinates` and dispatcher events `coordinates.saved`/`coordinates.deleted`. | `GET /v1/characters/{characterId}/coordinates`, `POST /v1/characters/{characterId}/coordinates`, `DELETE /v1/characters/{characterId}/coordinates/{id}` |
| np-barriers | Client places road barriers and toggles them open or closed | `GET /v1/barriers`, `POST /v1/barriers`, `PATCH /v1/barriers/{barrierId}/state` → `barriers.created`, `barriers.state` |
| drz_interiors | Resource triggers save/load events for apartment interior templates | `GET /v1/apartments/{apartmentId}/interior`, `POST /v1/apartments/{apartmentId}/interior` → `interiors.apartment.updated` |
| emotes | Resource lets players mark favorite emote commands for quick selection and sync updates via `emotes.favoriteAdded`/`emotes.favoriteRemoved`/`emotes.favoriteExpired` | `GET/POST/DELETE /v1/characters/{characterId}/emotes` |
| emspack | Duty start/end and treatment events | `GET/POST/PATCH/DELETE /v1/ems/records`, `GET /v1/ems/shifts/active`, `POST /v1/ems/shifts`, `POST /v1/ems/shifts/{id}/end` → broadcasts `ems.record.*`, `ems.shift.started`, `ems.shift.ended`, `ems.shifts.active` |
| es_taxi | Players request taxi rides and drivers accept/complete them | `POST /v1/taxi/requests`, `POST /v1/taxi/requests/{id}/accept`, `POST /v1/taxi/requests/{id}/complete` | `taxi.request.created`, `taxi.request.accepted`, `taxi.request.completed`, `taxi.request.expired` |
| k9 | Police dog deployment and status commands | `GET /v1/k9s/active`, `GET/POST /v1/characters/{characterId}/k9s`, `PATCH /v1/characters/{characterId}/k9s/{k9Id}/active`, `DELETE /v1/characters/{characterId}/k9s/{k9Id}` – WS `k9.created`, `k9.updated`, `k9.retired`, `k9.activeList` |
| isPed | Persists ped model, health and armor; server ticks regenerate health | `GET/PUT /v1/characters/{characterId}/ped`; WebSocket `peds.pedUpdated`; scheduler emits `peds.healthRegen` |
| dispatch | Police dispatch alerts and code lists | `GET/POST /v1/dispatch/alerts`, `PATCH /v1/dispatch/alerts/{id}/ack`, `GET /v1/dispatch/codes` |
| furniture | Resource lets players place or remove furniture items | `GET /v1/characters/{characterId}/furniture`, `POST /v1/characters/{characterId}/furniture`, `DELETE /v1/characters/{characterId}/furniture/{id}` (WS/webhook: `furniture.placed`, `furniture.removed`) |
| gabz_mrpd | Mission Row PD duty roster with push updates | `/v1/police/roster`, `/v1/police/roster/{characterId}:duty` → `police.duty` |
| gabz_pillbox_hospital | Resource handles hospital admissions and bed management | `GET /v1/hospital/admissions/active`, `POST /v1/hospital/admissions`, `POST /v1/hospital/admissions/{id}/discharge` – WS `hospital.*`, webhook mirrors |
| garages | Store and retrieve vehicle events | `/v1/garages` CRUD, `/v1/garages/{garageId}/store`, `/v1/garages/{garageId}/retrieve`, `/v1/characters/{characterId}/garages/{garageId}/vehicles` → pushes `garage.vehicleStored`/`garage.vehicleRetrieved` |
| ghmattimysql | Exports `execute`, `scalar` and `transaction` for MySQL queries | Core `db` repository offers `query`, `scalar` and `transaction` helpers with named parameters |
| hardcap | Connection limits and session tracking; broadcasts `hardcap.config.updated`, `hardcap.session.created`, `hardcap.session.ended`, `hardcap.session.expired` | `GET /v1/hardcap/status`, `POST /v1/hardcap/config`, `POST /v1/hardcap/sessions`, `DELETE /v1/hardcap/sessions/{id}` |
| heli | Resource logs helicopter flight start and end events | `POST /v1/heli/flights`, `POST /v1/heli/flights/{id}/end`, `GET /v1/characters/{characterId}/heli/flights` → `heli.flightStarted`, `heli.flightEnded`, `heli.flightExpired` |
| jailbreak | Resource triggers jailbreak start/completion and auto-expiry events with character and prison info | `POST /v1/jailbreaks`, `POST /v1/jailbreaks/{id}/complete`, `GET /v1/jailbreaks/active` → WS `jailbreaks.attempt`, `jailbreaks.completed`, `jailbreaks.expired`; webhooks mirror `jailbreak.*` |
| jobsystem | Resource manages job definitions and assignments | `GET /v1/jobs`, `POST /v1/jobs`, `GET /v1/jobs/{id}`, `POST /v1/jobs/assign`, `POST /v1/jobs/duty`, `GET /v1/jobs/{characterId}/assignments`; WS `jobs.assigned`, `jobs.duty`, `jobs.roster` |
| broadcast | Assign broadcaster job and push messages | `POST /v1/broadcast/attempt`, `POST /v1/broadcast/messages` → WS `broadcast.message` |
| srp-debug | Developer requests for runtime diagnostics | `GET /v1/debug/status` returns server metrics |
| srp-weathersync | Resource broadcasts weather and time updates; proxies api.weather.gov | `GET/POST /v1/weathersync/forecast`, `GET /v1/weathersync/weather.gov`, legacy `/v1/world/forecast` (deprecated) |
| climate-overrides | Resource applies custom timecycle XMLs; emits `world.timecycle.set`/`world.timecycle.clear` | `/v1/world/timecycle` to set or clear presets; scheduler auto-clears expired |
| lmfao | Recycling job mission events giving money and materials | `POST /v1/recycling/deliveries`, `GET /v1/recycling/deliveries/{characterId}` |
| lux_vehcontrol | Siren/powercall/indicator toggle events | `GET/POST /v1/vehicles/{plate}/control` → pushes `vehicles.control.update` |
| minimap | Minimap zoom/blip configuration | `GET/POST/DELETE /v1/minimap/blips` → WS `minimap.blips` |
| admin | Ban management and noclip toggles | `POST /v1/admin/ban`, `POST /v1/admin/unban`, `GET /v1/admin/bans/{playerId}`, `POST /v1/admin/noclip` | WS `admin.ban.added`, `admin.ban.removed`, `admin.noclip` |
| np-bennys | Vehicle upgrade orders and completion events | `POST /v1/mechanic/orders`, `GET /v1/mechanic/orders/{id}` → WS `mechanic.orders.*` |
