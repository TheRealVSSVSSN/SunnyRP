# Commands Module

Provides CRUD for server command definitions used by gameplay roles.

## Routes
- `GET /v1/commands` – list available commands.
- `POST /v1/commands` – create a command.
- `DELETE /v1/commands/{id}` – remove a command.

## Repository Contract
- `list(limit, offset)` → array of commands.
- `create({ name, description, police, ems, judge })` → created command.
- `remove(id)` → delete command.

## Edge Cases
- Duplicate `name` yields database constraint error.
- All boolean flags default to `false` when omitted.
