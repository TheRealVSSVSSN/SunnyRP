# Characters Module

Supports multi-character accounts. Provides endpoints to list, create, select and delete characters for a given account.

## Endpoints

| Method & Path | Description | Auth | Idempotent |
|---|---|---|---|
| **GET `/v1/accounts/{accountId}/characters`** | List characters owned by an account | Required | Yes |
| **POST `/v1/accounts/{accountId}/characters`** | Create a new character for the account | Required | Yes |
| **POST `/v1/accounts/{accountId}/characters/{characterId}:select`** | Select the active character for the session | Required | Yes |
| **DELETE `/v1/accounts/{accountId}/characters/{characterId}`** | Delete a character and clear selection if active | Required | Yes |

## Repository

- `characterRepository.js` – CRUD operations for `characters`.
- `characterSelectionRepository.js` – Track active selection in `character_selections`.

## Notes

- `character_selections` enforces one active character per account via primary key.
