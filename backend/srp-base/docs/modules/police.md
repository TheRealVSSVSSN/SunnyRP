# police module

## Purpose
Manages Mission Row PD duty roster with WebSocket and webhook notifications.

## Routes
- `GET /v1/police/roster` – list officers
- `POST /v1/police/roster` – assign officer
- `PUT /v1/police/roster/{id}` – update officer rank
- `POST /v1/police/roster/{characterId}:duty` – set duty status

## Repository Contracts
- `listOfficers()`
- `assignOfficer(characterId, rank, onDuty)`
- `updateOfficer(id, rank)`
- `setDuty(characterId, onDuty)`
- `setOffDutyOlderThan(cutoff)`

## Edge Cases
- `onDuty` field is required when toggling duty.
- `police-duty-check` scheduler resets officers who have not updated within `POLICE_DUTY_TIMEOUT_MS`.
