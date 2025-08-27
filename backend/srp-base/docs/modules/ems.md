# EMS Module

## Purpose
Logs medical treatment records and tracks EMS duty shifts.

## Routes
- `GET /v1/ems/records` – List recent EMS records.
- `GET /v1/ems/records/{id}` – Retrieve a record.
- `POST /v1/ems/records` – Create a record (`patient_id`, `doctor_id`, `treatment`, optional `status`).
- `PATCH /v1/ems/records/{id}` – Update a record’s treatment or status.
- `DELETE /v1/ems/records/{id}` – Remove a record.
- `GET /v1/ems/shifts/active` – List active EMS shifts.
- `POST /v1/ems/shifts` – Start a shift (`characterId`).
- `POST /v1/ems/shifts/{id}/end` – End a shift.

## Realtime
- WebSocket topic `ems` broadcasts:
  - `record.created`, `record.updated`, `record.deleted`
  - `shift.started`, `shift.ended`
  - `shifts.active` snapshot of all active shifts
- Webhook dispatcher mirrors these events for external sinks.

## Scheduler
- Job `ems-shift-sync` runs every `EMS_BROADCAST_INTERVAL_MS`.
  - Ends shifts exceeding `EMS_MAX_SHIFT_DURATION_MS`.
  - Broadcasts `shifts.active` after cleanup.

## Repository Contracts
- `getRecords()` → Array of records.
- `getRecord(id)` → Record or `null`.
- `createRecord({ patient_id, doctor_id, treatment, status })` → Record.
- `updateRecord(id, { treatment, status })` → Record or `null`.
- `deleteRecord(id)` → boolean.
- `getActiveShifts()` → Array of `{ id, characterId, startTime }`.
- `startShift(characterId)` → `{ id, characterId, startTime }`.
- `endShift(id)` → `{ id, characterId, startTime, endTime }` or `null`.

## Edge Cases
- Starting a shift while one is active returns the existing active shift.
- Ending a non-existent or completed shift yields a 404.

