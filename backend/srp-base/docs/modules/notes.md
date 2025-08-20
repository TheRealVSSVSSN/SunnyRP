# Notes Module

The **notes** module provides a simple persistence layer for the
`np-notepad` resource.  In the original Lua implementation, notes
dropped into the world were stored in an in‑memory array and lost on
server restart【136491508201320†L0-L19】.  To improve reliability and
allow external services to query notes, the SRP backend exposes REST
endpoints for creating, listing and deleting notes.  Each note has
free‑form text and world coordinates (x, y, z).

## Feature flag

There is no feature flag for notes; the module is always enabled.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/notes`** | List all notes currently stored.  Returns an array of note objects. | 60/min per IP | Required | Yes | None | `{ ok, data: { notes: Note[] }, requestId, traceId }` |
| **POST `/v1/notes`** | Create a new note.  Requires `text` (string) and `x`, `y`, `z` coordinates (numbers).  Persists the note and returns the created record. | 30/min per IP | Required | Yes | `NoteCreateRequest` | `{ ok, data: { note: Note }, requestId, traceId }` |
| **DELETE `/v1/notes/{id}`** | Delete a note by ID.  Returns an empty `data` object on success. | 60/min per IP | Required | Yes | None | `{ ok, data: {}, requestId, traceId }` |

### Schemas

* **Note** –
  ```yaml
  id: integer
  text: string
  x: number
  y: number
  z: number
  created_at: string (date-time)
  updated_at: string (date-time)
  ```

* **NoteCreateRequest** –
  ```yaml
  text: string (required)
  x: number (required)
  y: number (required)
  z: number (required)
  ```

## Implementation details

* **Repository:** `src/repositories/notesRepository.js` contains functions to
  create, delete and list notes using parameterised SQL queries.
* **Migration:** `src/migrations/012_add_notes.sql` creates the `notes`
  table with columns `id`, `text`, `x`, `y`, `z`, `created_at` and
  `updated_at` and an index on coordinates for potential spatial queries.
* **Routes:** `src/routes/notes.routes.js` defines the Express routes and
  performs basic validation.  Responses use the standard success
  envelope with `ok`, `data`, `requestId` and `traceId` fields.
* **OpenAPI:** `openapi/api.yaml` defines `Note` and `NoteCreateRequest`
  schemas and the `/v1/notes` and `/v1/notes/{id}` paths.

## Future work

Currently notes are created anonymously and have no ownership.  Future
sprints may extend the schema to associate notes with characters and
enforce permissions so that only the owner or an authorised role can
delete them.  Additional metadata such as expiration time or
attachment of in‑game items could also be supported.