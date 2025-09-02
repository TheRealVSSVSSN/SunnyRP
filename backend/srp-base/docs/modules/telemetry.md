# Telemetry Module

Logs service error reports and distributes them in real time.

## API
- `GET /v1/telemetry/errors` – list recent error logs.
- `POST /v1/telemetry/errors` – submit a new error.

## Persistence
- `error_logs` table stores `service`, `level`, `message`, and `created_at`.

## Realtime
- Emits `srp.telemetry.error` WebSocket events for new logs.
- Scheduler task `telemetry_purge` removes logs older than seven days hourly.
