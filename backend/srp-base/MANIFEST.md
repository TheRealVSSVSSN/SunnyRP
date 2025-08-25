# Manifest – 2025-02-14

## Summary
- Added zone expiration with scheduler purge and real-time broadcasts.

## File Changes
| Path | Status | Notes |
|---|---|---|
| `src/repositories/zonesRepository.js` | M | add expiresAt and purge helper |
| `src/routes/zones.routes.js` | M | broadcast events, idempotency checks |
| `src/tasks/zones.js` | A | purge expired zones and broadcast |
| `src/server.js` | M | register zone-expiry scheduler |
| `src/migrations/062_add_zone_expiry.sql` | A | add expires_at column/index |
| `openapi/api.yaml` | M | document expiresAt |
| `docs/index.md` | M | log PolyZone update |
| `docs/progress-ledger.md` | M | add PolyZone entry |
| `docs/framework-compliance.md` | M | note zone expiration compliance |
| `docs/BASE_API_DOCUMENTATION.md` | M | zone API updates |
| `docs/events-and-rpcs.md` | M | map zone push events |
| `docs/db-schema.md` | M | document expires_at column |
| `docs/migrations.md` | M | record zone expiry migration |
| `docs/admin-ops.md` | M | zone expiry maintenance note |
| `docs/testing.md` | M | include expiresAt in examples |
| `docs/modules/zones.md` | M | document expiration and pushes |
| `docs/research-log.md` | M | log PolyZone references |
| `docs/run-docs.md` | M | run summary |

## Startup Notes
- Apply migration `062_add_zone_expiry.sql` via `node src/bootstrap/migrate.js`.
