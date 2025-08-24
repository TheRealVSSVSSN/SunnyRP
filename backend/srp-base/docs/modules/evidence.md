# Evidence Module

The **evidence** module persists forensic evidence collected by police or citizens. It exposes REST endpoints for creating, retrieving, updating and deleting evidence items, replacing the ad-hoc event forwarding found in the original resource.

## Feature flag

There is no feature flag for evidence; the module is always enabled.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/evidence/items`** | List recent evidence items. | 60/min per IP | Required | Yes | None | `{ ok, data: { items: EvidenceItem[] }, requestId, traceId }` |
| **POST `/v1/evidence/items`** | Create a new evidence item. Requires `type` and `description`; optional `location`, `owner`, `metadata`. | 30/min per IP | Required | Yes | `EvidenceItemCreateRequest` | `{ ok, data: { item: EvidenceItem }, requestId, traceId }` |
| **GET `/v1/evidence/items/{id}`** | Retrieve a specific evidence item by ID. | 60/min per IP | Required | Yes | None | `{ ok, data: { item: EvidenceItem }, requestId, traceId }` |
| **PATCH `/v1/evidence/items/{id}`** | Update fields on an evidence item. Any of `type`, `description`, `location`, `owner`, `metadata` may be supplied. | 30/min per IP | Required | Yes | `EvidenceItemUpdateRequest` | `{ ok, data: { item: EvidenceItem }, requestId, traceId }` |
| **DELETE `/v1/evidence/items/{id}`** | Delete an evidence item. | 30/min per IP | Required | Yes | None | `{ ok, data: { deleted: true }, requestId, traceId }` |
| **GET `/v1/evidence/items/{id}/custody`** | List custody chain entries for an evidence item. | 60/min per IP | Required | Yes | None | `{ ok, data: { entries: EvidenceChainEntry[] }, requestId, traceId }` |
| **POST `/v1/evidence/items/{id}/custody`** | Add a custody chain entry. Requires `handlerId` and `action`; optional `notes`. | 30/min per IP | Required | Yes | `EvidenceChainEntryCreateRequest` | `{ ok, data: { entry: EvidenceChainEntry }, requestId, traceId }` |

### Schemas

* **EvidenceItem** –
  ```yaml
  id: integer
  type: string
  description: string
  location: string | null
  owner: string | null
  metadata: object | null
  created_at: string (date-time)
  updated_at: string (date-time)
  ```
* **EvidenceItemCreateRequest** –
  ```yaml
  type: string (required)
  description: string (required)
  location: string (optional)
  owner: string (optional)
  metadata: object (optional)
  ```
* **EvidenceItemUpdateRequest** – same fields as create request but all optional for partial updates.

## Implementation details

* **Repository:** `src/repositories/evidenceRepository.js` performs parameterised SQL queries against `evidence_items`.
* **Routes:** `src/routes/evidence.routes.js` wires HTTP verbs to repository functions.
* **Migration:** `src/migrations/002_extended_services.sql` defines the `evidence_items` table.
* **OpenAPI:** `openapi/api.yaml` defines schemas and paths for evidence endpoints.

## Future work

Future sprints may link evidence to case files or upload attachments such as images or DNA data. Search filters and pagination could also be added to improve usability.
