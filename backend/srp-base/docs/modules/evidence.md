# Evidence Module

The **evidence** module persists forensic evidence such as shell casings or DNA swabs in the `evidence_items` table.
Each item records a type, description, optional location, owner and metadata.  Evidence records can be created,
retrieved, updated and deleted via REST endpoints.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/evidence/items`** | List recent evidence items. | 60/min per IP | Required | Yes | None | `{ ok, data: { items: EvidenceItem[] }, requestId, traceId }` |
| **GET `/v1/evidence/items/{id}`** | Fetch a specific evidence item by ID. | 60/min per IP | Required | Yes | None | `{ ok, data: { item: EvidenceItem }, requestId, traceId }` |
| **POST `/v1/evidence/items`** | Create a new evidence item with `type` and `description`. | 30/min per IP | Required | Yes | `EvidenceItemCreateRequest` | `{ ok, data: { item: EvidenceItem }, requestId, traceId }` |
| **PATCH `/v1/evidence/items/{id}`** | Update fields on an existing evidence item. | 30/min per IP | Required | Yes | `EvidenceItemUpdateRequest` | `{ ok, data: { item: EvidenceItem }, requestId, traceId }` |
| **DELETE `/v1/evidence/items/{id}`** | Remove an evidence item. | 30/min per IP | Required | Yes | None | `{ ok, data: { deleted: true }, requestId, traceId }` |

### Schemas

* **EvidenceItem** –
  ```yaml
  id: integer
  type: string
  description: string
  location: string (nullable)
  owner: string (nullable)
  metadata: object (nullable)
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
* **Migration:** Table defined in `src/migrations/002_extended_services.sql`.
* **Routes:** `src/routes/evidence.routes.js` wires HTTP verbs to repository functions.
* **OpenAPI:** `openapi/api.yaml` documents the schemas and paths listed above.

## Future work

Future sprints may extend the module with pagination, filtering and
linkage to case or character records.
