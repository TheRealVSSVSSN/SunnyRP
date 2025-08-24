# Events and RPCs Mapping

| Resource | In-Game Events/RPCs | SRP Base API Mapping |
|---|---|---|
| DiamondBlackjack | Resource emits a server event after each blackjack hand with the character ID, table, bet and outcome | `POST /v1/diamond-blackjack/hands` persists the hand; clients can fetch history via `GET /v1/diamond-blackjack/hands/:characterId` |
| InteractSound | Resource triggers audio playback events specifying sound name and volume to target clients | `POST /v1/interact-sound/plays` logs the play; history via `GET /v1/interact-sound/plays/:characterId` |
| LockDoors | Resource emits door lock/unlock events with door identifier and state | `POST /v1/doors` upserts door records; `PATCH /v1/doors/:doorId/state` toggles lock state |
| PolicePack | Resource emits events for evidence custody updates and character selections | Custody via `GET/POST /v1/evidence/items/{id}/custody`; selection via `POST /v1/accounts/{accountId}/characters/{characterId}:select` |
| PolyZone | Resource defines polygonal zones for triggers | `GET /v1/zones`, `POST /v1/zones`, `DELETE /v1/zones/:id` manage zone records |
| Wise Audio | Resource manages character soundboard tracks | `GET /v1/wise-audio/tracks/:characterId`, `POST /v1/wise-audio/tracks` |
| Wise Imports | Resource manages vehicle import orders | `GET /v1/wise-imports/orders/:characterId`, `POST /v1/wise-imports/orders` |
| WiseGuy-Vanilla | Base resource using account-scoped character management | `GET/POST/DELETE/POST select /v1/accounts/{accountId}/characters` |
| Wise-UC | Resource manages undercover aliases for characters | `GET /v1/wise-uc/profiles/:characterId`, `POST /v1/wise-uc/profiles` |
| WiseGuy-Wheels | Resource records wheel spin outcomes per character | `GET /v1/wise-wheels/spins/:characterId`, `POST /v1/wise-wheels/spins` |
| assets | Resource stores media or item assets linked to characters | `GET /v1/assets`, `GET /v1/assets/{id}`, `POST /v1/assets`, `DELETE /v1/assets/{id}` |
| assets_clothes | Resource saves and retrieves character outfits | `GET /v1/clothes`, `POST /v1/clothes`, `DELETE /v1/clothes/{id}` |
| apartments | Resource triggers events when characters claim or vacate apartments | `GET /v1/apartments` with optional `characterId` filter and resident assignment endpoints |
| banking | Resource processes deposits, withdrawals and transfers between characters | `POST /v1/characters/{characterId}/account:deposit`, `POST /v1/characters/{characterId}/account:withdraw`, `POST /v1/transactions` |
| maps | No server events; world mapping assets | N/A |
| furnished-shells | No server events; interior shell assets | N/A |
| hair-pack | No server events; cosmetic hair assets | N/A |
| mh65c | No server events; vehicle model asset | N/A |
| motel | No server events; building interior asset | N/A |
| shoes-pack | No server events; footwear assets | N/A |
| yuzler | No server events; clothing assets | N/A |
| baseevents | Emits player join, drop and kill events | `POST /v1/base-events` logs events; `GET /v1/base-events` lists history |
| boatshop | Resource sends purchase requests for boats | `GET /v1/boatshop`, `POST /v1/boatshop/purchase` |
| bob74_ipl | Loads interior proxies; no server events | N/A |
| camera | Resource captures photos and uploads metadata | `GET /v1/camera/photos/{characterId}`, `POST /v1/camera/photos`, `DELETE /v1/camera/photos/{id}` |
