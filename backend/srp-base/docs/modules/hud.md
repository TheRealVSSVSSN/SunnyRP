# HUD Module

The **hud** module stores per-character vehicle and player HUD preferences such as speed unit, fuel display and theme.

## Feature flag

There is no feature flag for hud; the module is always enabled.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/characters/{characterId}/hud`** | Retrieve HUD preferences. | 60/min per IP | Required | Yes | None | `{ ok, data: HudPreferences, requestId, traceId }` |
| **PUT `/v1/characters/{characterId}/hud`** | Update HUD preferences. | 30/min per IP | Required | Yes | `HudPreferencesInput` | `{ ok, data: HudPreferences, requestId, traceId }` |

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

* **Repository:** `src/repositories/hudRepository.js` stores and retrieves preferences.
* **Migration:** `src/migrations/037_add_character_hud_preferences.sql` creates the table.
* **Routes:** `src/routes/hud.routes.js` exposes the REST API.
* **OpenAPI:** `openapi/api.yaml` documents schemas and paths.

## Future work

Additional settings such as seatbelt reminders or layout profiles may be added later.
