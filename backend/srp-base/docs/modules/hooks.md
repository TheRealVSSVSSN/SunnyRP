# Hooks Module

Provides runtime management of outbound webhook sinks.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/hooks/endpoints`** | List registered webhook endpoints. | n/a | Required | Yes | None | `200 { ok, data: { endpoints: WebhookEndpoint[] }, requestId, traceId }` |
| **POST `/v1/hooks/endpoints`** | Register a new webhook endpoint. | n/a | Required | Yes (use `X-Idempotency-Key`) | `{ type, url, secret?, enabled? }` | `200 { ok, data: { endpoint: WebhookEndpoint }, requestId, traceId }` |
| **DELETE `/v1/hooks/endpoints/{id}`** | Remove an endpoint. | n/a | Required | Yes | None | `200 { ok, data: { removed: id }, requestId, traceId }` |

### Schemas

* **WebhookEndpoint** –
  ```yaml
  id: integer
  type: string
  url: string
  enabled: boolean
  ```

## Implementation details

* **Dispatcher:** `src/hooks/dispatcher.js` handles HMAC signing, retries and dead-letter logging.
* **Routes:** `src/routes/hooks.routes.js` exposes admin CRUD.
* **Config:** environment variables `WEBHOOK_*` configure retry behaviour and a scaffolded Discord sink.

## Edge cases

* Removing a non-existent endpoint is a no-op and returns the requested id.
* Secrets are write-only; retrieving endpoints does not return the secret value.
