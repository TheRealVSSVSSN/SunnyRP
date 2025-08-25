# Wise Imports Module

The **Wise Imports** module tracks vehicle import orders per character.

## Feature flag

There is no feature flag for this module; it is always enabled.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/wise-imports/orders/:characterId`** | Retrieve up to 50 import orders for the specified character. | n/a | Required | Yes | None | `200 { ok, data: { orders: WiseImportOrder[] }, requestId, traceId }` |
| **POST `/v1/wise-imports/orders`** | Store a new vehicle import order and broadcast `wise-imports.order.created` via WebSocket and webhook. | n/a | Required | Yes (use `X-Idempotency-Key`) | `WiseImportOrderCreateRequest` | `200 { ok, data: { order: WiseImportOrder }, requestId, traceId }` |
| **POST `/v1/wise-imports/orders/{id}/deliver`** | Mark a ready order as delivered, broadcasting `wise-imports.order.delivered`. | n/a | Required | Yes (use `X-Idempotency-Key`) | `{ characterId: string }` | `200 { ok, data: { delivered: true }, requestId, traceId }` |

### Schemas

* **WiseImportOrder** –
  ```yaml
  id: integer
  characterId: string
  model: string
  status: string
  createdAt: integer (unix ms)
  updatedAt: integer (unix ms)
  ```

* **WiseImportOrderCreateRequest** –
  ```yaml
  characterId: string (required)
  model: string (required)
  ```

## Implementation details

* **Repository:** `src/repositories/wiseImportsRepository.js` provides `createOrder`, `listOrdersByCharacter`, status updates and delivery.
* **Scheduler:** `src/tasks/wiseImports.js` promotes pending orders to `ready` and pushes `wise-imports.order.ready`.
* **Migration:** `src/migrations/027_add_wise_imports.sql` creates the `wise_import_orders` table and `063_update_wise_import_orders.sql` adds `updated_at` and status index.
* **Routes:** `src/routes/wiseImports.routes.js` defines the HTTP endpoints, pushes WebSocket events and dispatches webhooks.
* **OpenAPI:** `openapi/api.yaml` documents the schemas and `/v1/wise-imports/orders` paths.

## Future work

Add order cancellation and vehicle integration once workflows finalize.
