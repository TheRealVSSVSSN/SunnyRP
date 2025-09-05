# Testing

- Manual testing via `npm start` and hitting HTTP endpoints.
- Automated tests run with `npm test` covering health, voice, system, metrics, scheduler persistence, and auth enforcement for sessions, world, ux, and telemetry endpoints.
- Automated tests run with `npm test` covering health, voice, system, metrics, scheduler persistence, and sessions, jobs, and weather auth enforcement.
- Automated tests run with `npm test` covering health, voice, system, metrics, scheduler persistence, and sessions auth enforcement.
- Automated tests run with `npm test` covering coordinate saving, spawn logging, broadcaster state, and notification endpoints.
- Automated tests run with `npm test` covering gateway namespaces and handshake validation.

## Token Authentication Examples

Use the `/v1/info` endpoint to exercise the `tokenAuth` middleware.

```sh
# Missing Authorization header
curl -i http://localhost:3000/v1/info

# Malformed header
curl -i -H "Authorization: Bearer" http://localhost:3000/v1/info

# Expired token
curl -i -H "Authorization: Bearer <expired-token>" http://localhost:3000/v1/info

# Invalid token
curl -i -H "Authorization: Bearer invalid" http://localhost:3000/v1/info
```

Expected responses:

| Scenario                | Status | Body                                |
|-------------------------|--------|-------------------------------------|
| Missing header          | 401    | `{ "error": "Missing Authorization header" }` |
| Malformed header        | 401    | `{ "error": "Malformed Authorization header" }` |
| Expired token           | 401    | `{ "error": "Token expired" }` |
| Invalid token           | 401    | `{ "error": "Invalid token" }` |

## Queue API Examples

```sh
# Enqueue account 1 with priority 10
curl -X POST -H "Authorization: Bearer <token>" -H "Idempotency-Key: abc" -H "Content-Type: application/json" \
  -d '{"accountId":1,"priority":10}' http://localhost:3000/v1/queue

# List queue
curl -H "Authorization: Bearer <token>" http://localhost:3000/v1/queue

# Remove from queue
curl -X DELETE -H "Authorization: Bearer <token>" -H "Idempotency-Key: def" http://localhost:3000/v1/queue/1
```

## Scheduler API Examples

```sh
# List scheduler runs
curl -H "Authorization: Bearer <token>" http://localhost:3000/v1/scheduler/runs

# Manually trigger task `cleanup`
curl -X POST -H "Authorization: Bearer <token>" -H "Idempotency-Key: xyz" \
  http://localhost:3000/v1/scheduler/runs/cleanup
```
