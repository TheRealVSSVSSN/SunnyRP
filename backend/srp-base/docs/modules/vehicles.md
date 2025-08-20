## Vehicles Module

The vehicles module manages ownership and metadata for vehicles owned by
players.  It persists vehicle records in the `vehicles` table and exposes
REST endpoints for registration, updates, and condition management.  It
does **not** handle spawning or in‑game mechanics; those remain in Lua
resources.  This module centralises all server‑authoritative data about
vehicles so that other domains (e.g. garages, jobs, tuning) can rely on a
consistent source of truth.

### Endpoints

| Method | Path | Description |
|-------|-----|-------------|
| `GET` | `/v1/vehicles/:playerId` | List vehicles owned by a player.  Returns an array of vehicles with `id`, `model`, `plate` and `properties`. |
| `POST` | `/v1/vehicles` | Register a new vehicle (body: `{ playerId, model, plate, properties? }`).  Returns the generated vehicle ID. |
| `POST` | `/v1/vehicles/:id/update` | Update an existing vehicle.  Only provided fields are modified (model, plate, properties).  Returns the number of rows updated. |
| `GET` | `/v1/vehicles/shop` | Placeholder endpoint to list vehicles available for purchase.  Currently returns an empty array. |
| `GET` | `/v1/vehicles/{plate}/condition` | Retrieve the condition of a vehicle (engine damage, body damage, fuel level and degradation array).  Returns `null` if no condition is recorded. |
| `PATCH` | `/v1/vehicles/{plate}/condition` | Update the engine damage, body damage or fuel level for a vehicle.  The request body may include any subset of these fields. |
| `PATCH` | `/v1/vehicles/{plate}/degradation` | Update the degradation array (eight integers) for a vehicle. |
| `GET` | `/v1/vehicles/harness/{plate}` | Retrieve the harness durability for a vehicle.  Returns `null` if no harness value is stored. |
| `PATCH` | `/v1/vehicles/harness/{plate}` | Update the harness durability for a vehicle.  Returns the number of rows updated. |
| `POST` | `/v1/vehicles/plate-change` | Change a vehicle’s license plate.  Expects `{ oldPlate, newPlate }` in the body and returns the number of rows updated. |

All endpoints require authentication via `X-API-Token` and optional HMAC
headers.  Mutating operations (`POST`, `PATCH`) also support
idempotency via an `Idempotency-Key` header.

### Repository

`src/repositories/vehiclesRepository.js` implements the data access logic
for this module.  Important methods include:

* `getVehicles(playerId)` – fetches all vehicles owned by the given player.
* `registerVehicle({ playerId, model, plate, properties })` – inserts a
  new vehicle record.
* `updateVehicle(id, data)` – updates model, plate or properties for a
  vehicle by ID.
* `getHarnessByPlate(plate)` and `updateHarnessByPlate(plate, durability)` –
  retrieve and update the harness durability.
* `changePlate(oldPlate, newPlate)` – update the plate for an existing vehicle.
* `getVehicleConditionByPlate(plate)` – fetch engine damage, body damage,
  fuel and degradation for a vehicle.  Degradation is parsed from a comma‑
  separated string into an array.  Returns `null` if not set.
* `updateVehicleConditionByPlate(plate, { engineDamage, bodyDamage, fuel })` –
  update engine/body/fuel fields.  Ignores undefined fields.
* `updateVehicleDegradationByPlate(plate, degradation)` – update the
  degradation array (stored as comma‑separated string).

### Database Schema

The `vehicles` table is created in `migration 003` with columns for
`player_id`, `model`, `plate`, `properties`, `created_at` and
`updated_at`.  Subsequent migrations extend the schema:

* **013_add_vehicle_harness.sql** – adds a nullable `harness` column and an index on `plate`.
* **017_add_vehicle_condition.sql** – adds `engine_damage`, `body_damage`, `fuel` and `degradation`
  columns.  `degradation` is stored as a `VARCHAR(255)` containing
  comma‑separated integers.  Future migrations may normalise this to a
  separate table if needed.

### Feature Flags

Vehicle condition and harness endpoints can be toggled via feature flags.
Ensure that `FEATURE_VEHICLES=1` is set in configuration to enable these
routes.  When disabled, the router will return 404 for condition and
harness endpoints.

### Troubleshooting

* **Vehicle not found** – If the condition endpoints return `null`, ensure the
  vehicle exists in the database and that condition fields have been set via
  the update endpoints.
* **Degradation array length** – The update route expects an array of
  integers.  The backend does not enforce a strict length but the game
  expects eight values.  Provide exactly eight numbers to avoid
  inconsistent behaviour.
* **Index missing** – Ensure all migrations have been applied (run
  `node src/bootstrap/migrate.js`) before interacting with the API.