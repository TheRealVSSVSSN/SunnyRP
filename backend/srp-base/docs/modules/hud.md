# HUD Module

The **hud** module stores per-character vehicle and player HUD preferences and tracks vehicle HUD state such as seatbelt, harness and nitrous levels.

## Feature flag

There is no feature flag for hud; the module is always enabled.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/characters/{characterId}/hud`** | Retrieve HUD preferences. | 60/min per IP | Required | Yes | None | `{ ok, data: HudPreferences, requestId, traceId }` |
| **PUT `/v1/characters/{characterId}/hud`** | Update HUD preferences. | 30/min per IP | Required | Yes | `HudPreferencesInput` | `{ ok, data: HudPreferences, requestId, traceId }` |
| **GET `/v1/characters/{characterId}/vehicle-state`** | Retrieve vehicle HUD state. | 60/min per IP | Required | Yes | None | `{ ok, data: VehicleState, requestId, traceId }` |
| **PUT `/v1/characters/{characterId}/vehicle-state`** | Update vehicle HUD state and broadcast to WebSocket subscribers. | 30/min per IP | Required | Yes | `VehicleStateInput` | `{ ok, data: VehicleState, requestId, traceId }` |

### Schemas

* **HudPreferences** –
  ```yaml
  characterId: integer
  speedUnit: string (mph|kph)
  showFuel: boolean
  hudTheme: string (nullable)
  ```
* **HudPreferencesInput** –
  ```yaml
  speedUnit: string (mph|kph)
  showFuel: boolean
  hudTheme: string (nullable)
  ```

## Implementation details

* **Repositories:** `src/repositories/hudRepository.js` stores preferences; `src/repositories/vehicleStatusRepository.js` tracks vehicle state.
* **Migrations:** `src/migrations/037_add_character_hud_preferences.sql` and `src/migrations/070_add_character_vehicle_status.sql` create the tables.
* **Routes:** `src/routes/hud.routes.js` exposes the REST API and emits `hud.vehicleState` over WebSocket on updates.
* **OpenAPI:** `openapi/api.yaml` documents schemas and paths.

## Future work

Additional settings such as seatbelt reminders or layout profiles may be added later.
