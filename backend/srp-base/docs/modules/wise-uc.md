# Wise UC Module

The **Wise UC** module stores undercover aliases for characters.

## Feature flag

There is no feature flag for this module; it is always enabled.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/wise-uc/profiles/:characterId`** | Retrieve undercover profile for the specified character. | n/a | Required | Yes | None | `200 { ok, data: { profile: WiseUCProfile }, requestId, traceId }` |
| **POST `/v1/wise-uc/profiles`** | Create or update an undercover profile. | n/a | Required | Yes (use `X-Idempotency-Key`) | `WiseUCProfileCreateRequest` | `200 { ok, data: { profile: WiseUCProfile }, requestId, traceId }` |

### Schemas

* **WiseUCProfile** –
  ```yaml
  characterId: string
  alias: string
  active: boolean
  createdAt: integer (unix ms)
  updatedAt: integer (unix ms)
  ```

* **WiseUCProfileCreateRequest** –
  ```yaml
  characterId: string (required)
  alias: string (required)
  active: boolean (optional)
  ```

## Implementation details

* **Repository:** `src/repositories/wiseUCRepository.js` provides `upsertProfile` and `getProfileByCharacter`.
* **Migration:** `src/migrations/028_add_wise_uc.sql` creates the `wise_uc_profiles` table.
* **Routes:** `src/routes/wiseUC.routes.js` defines the HTTP endpoints and validation.
* **OpenAPI:** `openapi/api.yaml` documents the schemas and `/v1/wise-uc/profiles` paths.

## Future work

Future iterations may support multiple profiles per character or alias history.
