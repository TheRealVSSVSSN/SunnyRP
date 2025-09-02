# Hooks Module

Manages webhook endpoints for external integrations.

## REST Endpoints
- `GET /v1/hooks/endpoints` – list registered endpoints. Requires `hooks:read` scope.
- `POST /v1/hooks/endpoints` – add an endpoint. Requires `hooks:write` scope. Uses Idempotency-Key.
- `DELETE /v1/hooks/endpoints/{id}` – remove endpoint. Requires `hooks:write` scope. Uses Idempotency-Key.

## Scheduler Tasks
- `idempotency_purge` – removes expired idempotency keys every minute.

## Notes
Admin-only operations. Webhook deliveries are signed with HMAC-SHA256.
