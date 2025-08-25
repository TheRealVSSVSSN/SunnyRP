# Hardcap Module

Manages server connection limits and active sessions.

## Feature flag

There is no feature flag for hardcap; the module is always enabled.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/hardcap/status`** | Retrieve current max players, reserved slots and active count. | 30/min per IP | Required | Yes | None | `{ ok, data: { status: HardcapStatus }, requestId, traceId }` |
| **POST `/v1/hardcap/config`** | Update max player and reserved slot settings. | 30/min per IP | Required | Yes | `HardcapConfigRequest` | `{ ok, data: { config: HardcapStatus }, requestId, traceId }` |
| **POST `/v1/hardcap/sessions`** | Register an active account/character session. | 30/min per IP | Required | Yes | `HardcapSessionCreateRequest` | `{ ok, data: { session: HardcapSession }, requestId, traceId }` |
| **DELETE `/v1/hardcap/sessions/{id}`** | End an active session. | 30/min per IP | Required | Yes | None | `{ ok, data: { deleted: boolean }, requestId, traceId }` |

### Schemas

* **HardcapStatus** –
  ```yaml
  maxPlayers: integer
  reservedSlots: integer
  currentPlayers: integer
  ```
* **HardcapConfigRequest** –
  ```yaml
  maxPlayers: integer
  reservedSlots: integer
  ```
* **HardcapSession** –
  ```yaml
  id: integer
  accountId: integer
  characterId: integer
  connectedAt: string (date-time)
  disconnectedAt: string (date-time) | null
  ```
* **HardcapSessionCreateRequest** –
  ```yaml
  accountId: integer
  characterId: integer
  ```

## Implementation details

* **Repository:** `src/repositories/hardcapRepository.js` handles configuration and session persistence.
* **Migration:** `src/migrations/050_add_hardcap.sql` creates the `hardcap_config` and `hardcap_sessions` tables.
* **Routes:** `src/routes/hardcap.routes.js` exposes the REST API.
* **OpenAPI:** `openapi/api.yaml` documents schemas and paths.

## Future work

Consider exposing metrics for queue length and automatic capacity scaling.
