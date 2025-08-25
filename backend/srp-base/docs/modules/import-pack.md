# Import Pack Module

Provides persistence for vehicle import packages requested by characters, including pricing, retrieval and cancellation.

## Routes

- `GET /v1/import-pack/orders/character/{characterId}` – list import package orders for a character.
- `GET /v1/import-pack/orders/{id}?characterId={characterId}` – fetch an import package order.
- `POST /v1/import-pack/orders` – create a new import package order.
- `POST /v1/import-pack/orders/{id}/deliver` – mark an order as delivered.
- `POST /v1/import-pack/orders/{id}/cancel` – cancel a pending order.

## Repository Contracts

- `createOrder({ characterId, packageName, price })`
- `listOrdersByCharacter(characterId, limit)`
- `getOrder(id, characterId)`
- `markDelivered(id)`
- `cancelOrder(id, characterId)`

## Edge Cases

- `characterId`, `package` and numeric `price` are required when creating orders.
- Fetch and cancel endpoints require `characterId` to match the order owner.
- Cancel endpoint returns `404` when the order is missing or not pending.
- Deliver endpoint returns `404` when the order is missing.
