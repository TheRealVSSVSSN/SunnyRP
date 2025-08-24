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
