# Manifest – 2025-08-25

## Summary

- Added taxi dispatch and ride logging APIs.
- Added furniture placement APIs.
- Added endpoint to retrieve the active character for multi-character support.
- Added hospital admission APIs.
- Added hardcap configuration and session tracking APIs.
- Added heli flight logging APIs.
- Added import pack order APIs.
- Extended import pack order APIs with pricing, retrieval and cancellation.

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
| `src/repositories/importPackRepository.js` | M | Added pricing, retrieval and cancelation support |
| `src/routes/importPack.routes.js` | M | Added order retrieval and cancelation endpoints |
| `src/migrations/053_add_import_pack_order_price_cancel.sql` | A | Add price and canceled_at columns |
| `openapi/api.yaml` | M | Documented import pack pricing and cancel paths |
| `docs/index.md` | M | Logged import-Pack2 update |
| `docs/progress-ledger.md` | M | Added import-Pack2 entry |
| `docs/framework-compliance.md` | M | Noted import pack module compliance |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented import pack retrieval and cancel endpoints |
| `docs/events-and-rpcs.md` | M | Mapped import-Pack2 events |
| `docs/db-schema.md` | M | Documented import pack order pricing columns |
| `docs/migrations.md` | M | Listed migration 053 |
| `docs/admin-ops.md` | M | Added import pack table check |
| `docs/security.md` | M | Added import pack security note |
| `docs/testing.md` | M | Added import pack curl examples |
| `docs/modules/import-pack.md` | M | Module documentation updated for pricing and cancelation |
| `docs/research-log.md` | M | Logged import-Pack2 research |
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
| `src/repositories/hospitalRepository.js` | A | Persistence for hospital admissions |
| `src/routes/hospital.routes.js` | A | REST endpoints for hospital admissions |
| `src/migrations/048_add_hospital_admissions.sql` | A | Create `hospital_admissions` table |
| `src/app.js` | M | Mounted hospital routes |
| `openapi/api.yaml` | M | Documented hospital schemas and paths |
| `docs/index.md` | M | Logged gabz_pillbox_hospital update |
| `docs/progress-ledger.md` | M | Added gabz_pillbox_hospital entry |
| `docs/events-and-rpcs.md` | M | Mapped gabz_pillbox_hospital resource |
| `docs/db-schema.md` | M | Documented `hospital_admissions` table |
| `docs/migrations.md` | M | Listed migration 048 |
| `docs/admin-ops.md` | M | Added hospital table check |
| `docs/security.md` | M | Added hospital security note |
| `docs/testing.md` | M | Added hospital curl examples |
| `docs/modules/hospital.md` | A | Module documentation |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented hospital endpoints |
| `docs/framework-compliance.md` | M | Noted hospital module compliance |
| `docs/research-log.md` | M | Logged gabz_pillbox_hospital research |
| `src/repositories/hardcapRepository.js` | A | Persistence for hardcap configuration and sessions |
| `src/routes/hardcap.routes.js` | A | REST endpoints for hardcap operations |
| `src/migrations/050_add_hardcap.sql` | A | Create hardcap tables |
| `src/app.js` | M | Mounted hardcap routes |
| `openapi/api.yaml` | M | Documented hardcap schemas and paths |
| `docs/index.md` | M | Logged hardcap update |
| `docs/progress-ledger.md` | M | Added hardcap entry |
| `docs/framework-compliance.md` | M | Noted hardcap module compliance |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented hardcap endpoints |
| `docs/events-and-rpcs.md` | M | Mapped hardcap events |
| `docs/db-schema.md` | M | Documented hardcap tables |
| `docs/migrations.md` | M | Listed migration 050 |
| `docs/admin-ops.md` | M | Added hardcap table check |
| `docs/security.md` | M | Added hardcap security note |
| `docs/testing.md` | M | Added hardcap curl examples |
| `docs/modules/hardcap.md` | A | Module documentation |
| `docs/research-log.md` | M | Logged hardcap research attempt |
| `src/repositories/heliRepository.js` | A | Persist helicopter flights |
| `src/routes/heli.routes.js` | A | REST endpoints for flight logging |
| `src/migrations/051_add_heli_flights.sql` | A | Create `heli_flights` table |
| `src/app.js` | M | Mounted heli routes |
| `openapi/api.yaml` | M | Documented heli schemas and paths |
| `docs/index.md` | M | Logged heli update |
| `docs/progress-ledger.md` | M | Added heli entry |
| `docs/framework-compliance.md` | M | Noted heli module compliance |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented heli endpoints |
| `docs/events-and-rpcs.md` | M | Mapped heli events |
| `docs/db-schema.md` | M | Documented `heli_flights` table |
| `docs/migrations.md` | M | Listed migration 051 |
| `docs/admin-ops.md` | M | Added heli table check |
| `docs/security.md` | M | Added heli security note |
| `docs/testing.md` | M | Added heli curl examples |
| `docs/modules/heli.md` | A | Module documentation |
| `docs/research-log.md` | M | Logged heli research attempt |
| `src/repositories/importPackRepository.js` | A | Persistence for import package orders |
| `src/routes/importPack.routes.js` | A | REST endpoints for import package orders |
| `src/migrations/052_add_import_pack_orders.sql` | A | Create `import_pack_orders` table |
| `src/app.js` | M | Mounted import pack routes |
| `openapi/api.yaml` | M | Documented import pack schemas and paths |
| `docs/index.md` | M | Logged import pack update |
| `docs/progress-ledger.md` | M | Added import-pack entry |
| `docs/framework-compliance.md` | M | Noted import pack module compliance |
| `docs/BASE_API_DOCUMENTATION.md` | M | Documented import pack endpoints |
| `docs/events-and-rpcs.md` | M | Mapped import pack events |
| `docs/db-schema.md` | M | Documented `import_pack_orders` table |
| `docs/migrations.md` | M | Listed migration 052 |
| `docs/modules/import-pack.md` | A | Module documentation |
| `docs/research-log.md` | M | Logged import-pack research |

## Startup Notes

- Run `node src/bootstrap/migrate.js` to apply migration `046_add_taxi_rides.sql`.
- Run `node src/bootstrap/migrate.js` to apply migration `048_add_hospital_admissions.sql`.
- Run `node src/bootstrap/migrate.js` to apply migration `051_add_heli_flights.sql`.
- Run `node src/bootstrap/migrate.js` to apply migration `052_add_import_pack_orders.sql`.
