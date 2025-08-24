# interiors module

Provides storage for apartment interior layouts scoped to characters.

## Routes
- `GET /v1/apartments/{apartmentId}/interior?characterId={cid}` – fetch interior layout for an apartment.
- `POST /v1/apartments/{apartmentId}/interior` – save interior layout for an apartment (`characterId`, `template`).

## Repository contracts
- `getInterior(apartmentId, characterId)`
- `setInterior(apartmentId, characterId, template)`

## Edge cases
- Requesting an apartment without a saved interior returns 404.
- Template data is stored as JSON; large payloads may exceed MySQL limits.
