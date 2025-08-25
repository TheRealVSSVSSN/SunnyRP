# Boatshop Module

## Purpose
Provides a catalog of purchasable boats and registers purchased boats to the owning character.

## Routes
- `GET /v1/boatshop` – List boats available for purchase.
- `POST /v1/boatshop/purchase` – Purchase a boat with `characterId`, `boatId`, `plate` and optional `properties`.

## Realtime
- Scheduler task `boatshop-catalog-broadcast` pushes the full catalog every 5 minutes via WebSocket `boatshop.catalog` and webhooks.
- Successful purchases emit `boatshop.purchase` over WebSocket and the webhook dispatcher.

## Repository Contracts
- `listBoats()` → Array of `{ id, model, price }`.
- `purchaseBoat({ characterId, boatId, plate, properties })` → `{ id, price }` or `null` if `boatId` not found.

## Edge Cases
- Returns 404 if a boatId is invalid.
- Properties object is stored as JSON without validation; callers must sanitize input.
