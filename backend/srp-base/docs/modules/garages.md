# Garages Module

Provides CRUD for garages and per-character vehicle storage.

## Routes

- `GET /v1/garages` – list garages
- `POST /v1/garages` – create garage
- `PUT /v1/garages/{id}` – update garage
- `DELETE /v1/garages/{id}` – delete garage
- `POST /v1/garages/{garageId}/store` – store a vehicle for a character
- `POST /v1/garages/{garageId}/retrieve` – retrieve a stored vehicle
- `GET /v1/characters/{characterId}/garages/{garageId}/vehicles` – list character vehicles in a garage

## Repository Contracts

- `listGarages()` returns all garages
- `createGarage(name, location?, capacity?)` creates a garage
- `updateGarage(id, data)` updates fields on a garage
- `deleteGarage(id)` removes a garage
- `storeVehicle(garageId, vehicleId, characterId)` records storage
- `retrieveVehicle(garageId, vehicleId, characterId)` marks retrieval
- `listGarageVehicles(garageId, characterId)` lists stored vehicles for a character
- `deleteRetrievedBefore(cutoff)` purges retrieved records older than `cutoff`

## Edge Cases

- Storing the same vehicle multiple times creates separate records
- Retrieval is idempotent; repeated calls on the same record succeed

## Realtime

- WebSocket topic `vehicles` emits `garage.vehicleStored` and `garage.vehicleRetrieved`
- Webhook dispatcher mirrors the above events

## Scheduler

- Hourly `garage-vehicle-purge` removes entries with `retrieved_at` older than `GARAGE_VEHICLE_RETENTION_MS`

