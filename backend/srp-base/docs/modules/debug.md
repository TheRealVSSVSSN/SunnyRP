# Debug Module

Provides diagnostics for the SunnyRP backend.

## Routes

- `GET /v1/debug/status` – Returns server uptime, memory usage and load averages.

## Repository

`debugRepository.js` exposes `getSystemInfo()` which gathers runtime metrics without touching the database.

## Edge Cases

- Endpoint rate limited to mitigate abuse.
- Requires standard API token authentication.
