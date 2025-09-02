# Permissions Module

Handles role and scope management for accounts.

## REST Endpoints
- `GET /v1/roles` – list all roles.
- `POST /v1/roles` – create a new role.
- `POST /v1/roles/{roleId}/permissions` – attach a scope to a role.
- `GET /v1/accounts/{accountId}/roles` – list roles assigned to an account.
- `POST /v1/accounts/{accountId}/roles` – assign a role to an account.

## Security
- All endpoints require JWT scopes `roles:read` or `roles:write` as appropriate.

