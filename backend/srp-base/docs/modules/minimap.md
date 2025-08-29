# Minimap Module

## Purpose
Provides dynamic blip data for the in-game minimap. Enables creation and removal of blips and broadcasts updates over WebSockets to connected clients.

## Routes
- `GET /v1/minimap/blips` — List all blips.
- `POST /v1/minimap/blips` — Create a blip. Requires `x`, `y`, `z`, `sprite`, `color`, `label`.
- `DELETE /v1/minimap/blips/{id}` — Remove a blip.

## Repository
`src/repositories/minimapRepository.js`
- `listBlips()`
- `createBlip({ x, y, z, sprite, color, label })`
- `deleteBlip(id)`

## Scheduler
Task `minimap-blips-broadcast` pushes blip lists every 30s via the `world` WebSocket namespace.

## Edge Cases
- Invalid input returns `INVALID_INPUT` error.
- Large blip counts may require pagination in future.
