# Peds Module

The peds module stores character ped model, health and armor for persistence across sessions.

## Feature flag

There is no feature flag for peds; the module is always enabled.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/characters/{characterId}/ped`** | Retrieve ped state for a character. | 60/min per IP | Required | Yes | None | `{ ok, data: { ped: PedState|null }, requestId, traceId }` |
| **PUT `/v1/characters/{characterId}/ped`** | Upsert ped state with `model`, `health` and `armor`. | 30/min per IP | Required | Yes | `PedStateUpdateRequest` | `{ ok, data: { ped: PedState }, requestId, traceId }` |

## Realtime

- **WebSocket topic:** `peds`
  - `peds.pedUpdated` – emitted when a character's ped state is stored.
  - `peds.healthRegen` – broadcast from scheduler with `{ amount, count }` when health regeneration runs.

## Scheduler

The `peds-health-regen` task runs every minute to regenerate ped health server-side and emits `peds.healthRegen` events.

### Schemas

* **PedState** –
  ```yaml
  characterId: integer
  model: string
  health: integer
  armor: integer
  updatedAt: string (date-time)
  ```
* **PedStateUpdateRequest** –
  ```yaml
  model: string
  health: integer
  armor: integer
  ```

## Implementation details

* **Repository:** `src/repositories/pedsRepository.js` stores and retrieves ped state.
* **Migration:** `src/migrations/054_add_character_peds.sql` creates the `character_peds` table.
* **Routes:** `src/routes/peds.routes.js` defines the REST API.
* **OpenAPI:** `openapi/api.yaml` documents schemas and paths.

## Future work

* Persist additional ped attributes such as position or appearance customization.
