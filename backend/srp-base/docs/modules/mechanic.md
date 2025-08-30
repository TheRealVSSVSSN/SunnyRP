# Mechanic Module

Provides backend support for vehicle upgrade and repair work orders. Requests create persistent orders that complete asynchronously and dispatch realtime events.

## Routes

- `POST /v1/mechanic/orders` – create work order (requires `X-Idempotency-Key`).
- `GET /v1/mechanic/orders/{id}` – retrieve work order status.

## Repository Contracts

- `createOrder(vehiclePlate, characterId, description)`
- `getOrder(id)`
- `listPending()`
- `completeOrder(id)`

## Edge Cases

- Unknown order IDs return `null`.
- Orders auto-complete via scheduler after ~15s; clients should listen for `mechanic.orders.completed` events.
