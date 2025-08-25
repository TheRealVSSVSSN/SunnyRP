# Manifest – 2025-08-25

## Summary

- Added taxi dispatch and ride logging APIs.
- Added furniture placement APIs.
- Added endpoint to retrieve the active character for multi-character support.

## File Changes

| Path | Status | Notes |
|---|---|---|
| `src/repositories/taxiRepository.js` | A | Persistence for taxi ride requests and completions |
| `src/routes/taxi.routes.js` | A | REST endpoints for taxi requests and ride lifecycle |
| `src/migrations/046_add_taxi_rides.sql` | A | Create `taxi_rides` table |
| `src/app.js` | M | Mounted taxi routes |
| `openapi/api.yaml` | M | Documented taxi schemas and paths |
| `docs/index.md` | M | Logged es_taxi update |
| `docs/progress-ledger.md` | M | Added es_taxi entry |
| `docs/events-and-rpcs.md` | M | Mapped taxi events |
| `docs/db-schema.md` | M | Documented `taxi_rides` table |
| `docs/migrations.md` | M | Listed migration 046 |
| `docs/admin-ops.md` | M | Added taxi table check |
| `docs/security.md` | M | Added taxi security note |
| `docs/testing.md` | M | Added taxi curl examples |
| `docs/modules/taxi.md` | A | Module documentation |
| `docs/research-log.md` | M | Logged research attempt |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented taxi endpoints |
| `docs/framework-compliance.md` | M | Noted taxi and furniture module compliance |
| `src/repositories/furnitureRepository.js` | A | Persistence for furniture items |
| `src/routes/furniture.routes.js` | A | REST endpoints for furniture |
| `src/migrations/047_add_furniture.sql` | A | Create `furniture` table |
| `openapi/api.yaml` | M | Documented furniture schemas and paths |
| `src/app.js` | M | Mounted furniture routes |
| `docs/index.md` | M | Logged furniture update |
| `docs/progress-ledger.md` | M | Added furniture entry |
| `docs/events-and-rpcs.md` | M | Mapped furniture events |
| `docs/db-schema.md` | M | Documented `furniture` table |
| `docs/migrations.md` | M | Listed migration 047 |
| `docs/admin-ops.md` | M | Added furniture table check |
| `docs/security.md` | M | Added furniture security note |
| `docs/testing.md` | M | Added furniture curl examples |
| `docs/modules/furniture.md` | A | Module documentation |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented furniture endpoints |
| `docs/research-log.md` | M | Logged furniture research attempt |
| `src/routes/accountCharacters.routes.js` | M | Added selected character retrieval |
| `openapi/api.yaml` | M | Documented selected character path |
| `docs/modules/characters.md` | M | Documented selected character endpoint |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented selected character endpoint |
| `docs/index.md` | M | Logged gabz_mrpd update |
| `docs/progress-ledger.md` | M | Added gabz_mrpd entry |
| `docs/events-and-rpcs.md` | M | Mapped gabz_mrpd resource |
| `docs/framework-compliance.md` | M | Noted characters module update |
| `docs/research-log.md` | M | Logged gabz_mrpd research |

## Startup Notes

- Run `node src/bootstrap/migrate.js` to apply migration `046_add_taxi_rides.sql`.
