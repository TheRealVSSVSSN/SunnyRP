# Events and RPCs Mapping

| Resource | In-Game Events/RPCs | SRP Base API Mapping |
|---|---|---|
| DiamondBlackjack | Resource emits a server event after each blackjack hand with the character ID, table, bet and outcome | `POST /v1/diamond-blackjack/hands` persists the hand; clients can fetch history via `GET /v1/diamond-blackjack/hands/:characterId` |
