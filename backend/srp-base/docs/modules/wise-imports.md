# Wise Imports Module

The **Wise Imports** module tracks vehicle import orders per character.

## Feature flag

There is no feature flag for this module; it is always enabled.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/wise-imports/orders/:characterId`** | Retrieve up to 50 import orders for the specified character. | n/a | Required | Yes | None | `200 { ok, data: { orders: WiseImportOrder[] }, requestId, traceId }` |
| **POST `/v1/wise-imports/orders`** | Store a new vehicle import order. | n/a | Required | Yes (use `X-Idempotency-Key`) | `WiseImportOrderCreateRequest` | `200 { ok, data: { order: WiseImportOrder }, requestId, traceId }` |

### Schemas

* **WiseImportOrder** –
  ```yaml
  id: integer
  characterId: string
  model: string
  status: string
  createdAt: integer (unix ms)
  ```

* **WiseImportOrderCreateRequest** –
  ```yaml
  characterId: string (required)
  model: string (required)
  ```

## Implementation details

* **Repository:** `src/repositories/wiseImportsRepository.js` provides `createOrder` and `listOrdersByCharacter`.
* **Migration:** `src/migrations/027_add_wise_imports.sql` creates the `wise_import_orders` table.
* **Routes:** `src/routes/wiseImports.routes.js` defines the HTTP endpoints and validation.
* **OpenAPI:** `openapi/api.yaml` documents the schemas and `/v1/wise-imports/orders` paths.

## Future work

Future iterations may allow updating order status or cancelling orders.
