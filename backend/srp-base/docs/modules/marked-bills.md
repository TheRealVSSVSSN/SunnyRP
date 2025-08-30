# marked-bills module

Provides API for managing per-character marked bills (dirty money).

## Routes
- `GET /v1/characters/{characterId}/marked-bills`
- `POST /v1/characters/{characterId}/marked-bills:alter` — add or subtract (reason `ItemDrop` to drop).
- `POST /v1/characters/{characterId}/marked-bills:pickup` — converts marked bills to clean money.

## Repository
- `markedBillsRepository.getAmount(characterId)` — returns current amount.
- `markedBillsRepository.add(characterId, amount)`
- `markedBillsRepository.subtract(characterId, amount)` — throws `INSUFFICIENT_FUNDS` if balance too low.

## Realtime
WebSocket namespace `economy` events:
- `markedBills.add`
- `markedBills.drop`
- `markedBills.pickup`

Hooks dispatcher mirrors the same events.

## Edge Cases
- Attempts to drop more than balance return `INSUFFICIENT_FUNDS`.
