# World Module

Manages weather, zones, barriers, character coordinates, and infinity entity streaming.

## REST Endpoints
- `GET /v1/world/weather`
- `PUT /v1/world/weather`
- `GET /v1/world/coords/{characterId}`
- `POST /v1/world/coords`
- `GET /v1/world/infinity/entities/{entityId}`
- `POST /v1/world/infinity/entities`
- `GET /v1/world/zones`
- `POST /v1/world/zones`
- `DELETE /v1/world/zones/{id}`
- `GET /v1/world/barriers`
- `POST /v1/world/barriers`
- `DELETE /v1/world/barriers/{id}`

## WebSocket Events
- `srp.world.weather`
- `srp.world.zone.create`
- `srp.world.zone.delete`
- `srp.world.barrier.create`
- `srp.world.barrier.delete`
- `srp.world.coords`
- `srp.world.infinity.entity`

## Scheduler
- Purges stale infinity entity records every `INFINITY_STALE_MS`.
