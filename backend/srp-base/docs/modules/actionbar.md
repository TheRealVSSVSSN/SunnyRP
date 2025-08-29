# Action Bar Module

The **action bar** module stores per-character quick action slots used by the client to map items to hotkeys and synchronizes updates in realtime.

## Feature flag

There is no feature flag; the module is always enabled.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/characters/{characterId}/action-bar`** | Retrieve action bar slots. | 60/min per IP | Required | Yes | None | `{ ok, data: ActionBarSlot[], requestId, traceId }` |
| **PUT `/v1/characters/{characterId}/action-bar`** | Replace action bar slots. | 30/min per IP | Required | Yes | `ActionBarUpdate` | `{ ok, data: ActionBarSlot[], requestId, traceId }` |

### Schemas

* **ActionBarSlot** –
  ```yaml
  slot: integer
  item: string, nullable
  ```
* **ActionBarUpdate** –
  ```yaml
  slots: [ActionBarSlot]
  ```

## Implementation details

* **Repository:** `src/repositories/actionBarRepository.js` handles slot persistence.
* **Routes:** `src/routes/actionBar.routes.js` exposes the REST API, broadcasting `hud.actionBar.updated` via WebSocket and webhooks.
* **Migration:** `src/migrations/087_add_action_bar_slots.sql` creates the `action_bar_slots` table.
* **OpenAPI:** `openapi/api.yaml` documents schemas and paths.

## Future work

Support configurable slot limits and per-item cooldown tracking.
