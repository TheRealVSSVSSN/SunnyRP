# Admin Operations

## Webhook Dispatcher
- Configure Discord sink via environment:
  - `DISCORD_WEBHOOK_URL`
  - `DISCORD_WEBHOOK_SECRET`
- Disabled by default when variables are unset.
- All WebSocket events are forwarded to loaded endpoints.

## Hook Endpoints API
- Protected by JWT scopes `hooks:read` and `hooks:write`.
- Manage endpoints via `/v1/hooks/endpoints`.

## Tokens
- Set `JWT_SECRET` to validate bearer tokens.

## System Time
- Configure timezone and broadcast interval via environment:
  - `TIMEZONE` (default `UTC`)
  - `TIME_BROADCAST_INTERVAL_MS` (default `60000`)

## Scoreboard
- Purge interval via `SCOREBOARD_STALE_MS` (default `30000`)

## Queue
- Stale entry threshold via `QUEUE_STALE_MS` (default `300000`)

## Roles
- Manage roles and scopes through `/v1/roles` and `/v1/accounts/{accountId}/roles`.

## Scheduler
- Tasks persist last run timestamps in `scheduler_runs`.
- Administrative endpoints:
  - `GET /v1/scheduler/runs` requires `scheduler:read`.
  - `POST /v1/scheduler/runs/{taskName}` requires `scheduler:write`.
- No external configuration yet.

## Metrics
- `/metrics` exposes Prometheus metrics; secure at network layer if needed.
