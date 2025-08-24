# apartments module

Provides persistence for apartment definitions and resident assignments.

## Routes
- `GET /v1/apartments?characterId={cid}` – list apartments, optionally filtered by resident.
- `POST /v1/apartments` – create an apartment (`name`, optional `location`, optional `price`).
- `POST /v1/apartments/{apartmentId}/residents` – assign a character to an apartment.
- `DELETE /v1/apartments/{apartmentId}/residents/{characterId}` – remove a resident.

## Repository contracts
- `listApartments(characterId?)`
- `createApartment(name, location, price)`
- `assignResident(apartmentId, characterId)`
- `vacateResident(apartmentId, characterId)`

## Edge cases
- No uniqueness constraint prevents duplicate resident entries; callers should avoid reassigning.
- Missing characters or apartments result in database errors propagated to the caller.
