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

# Run Summary — 2025-08-30 (np-admin)

- Extended admin module with ban status query and unban logging.

## API Changes

- `POST /v1/admin/unban`
- `GET /v1/admin/bans/{playerId}`

## Realtime & Webhooks

- WebSocket namespace `admin` emits `ban.added` and `ban.removed`.

## Migrations

- `088_add_unban_events.sql` — audit log for unban actions.

## Outstanding TODO/Gaps

- None.
