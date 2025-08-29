# Run Summary — 2025-08-30 (np-actionbar)

- Added action bar slots API with realtime WebSocket and webhook dispatch.

## API Changes

- `GET /v1/characters/{characterId}/action-bar`
- `PUT /v1/characters/{characterId}/action-bar`

## Realtime & Webhooks

- WebSocket `hud.actionBar.updated` broadcast and webhook dispatch.

## Migrations

- `087_add_action_bar_slots.sql` — action bar slots table.

## Outstanding TODO/Gaps

- None.
