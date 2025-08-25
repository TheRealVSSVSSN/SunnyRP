# Import Pack Module

Provides persistence for vehicle import packages requested by characters.

## Routes

- `GET /v1/import-pack/orders/{characterId}` – list import package orders for a character.
- `POST /v1/import-pack/orders` – create a new import package order.
- `POST /v1/import-pack/orders/{id}/deliver` – mark an order as delivered.

## Repository Contracts

- `createOrder({ characterId, packageName })`
- `listOrdersByCharacter(characterId, limit)`
- `markDelivered(id)`

## Edge Cases

- Both `characterId` and `package` are required when creating orders.
- Deliver endpoint returns `404` when the order is missing.
