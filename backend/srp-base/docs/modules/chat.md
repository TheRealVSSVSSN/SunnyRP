# Chat Module

The chat module records text messages sent in game. Each message is tied to a character and includes the channel and timestamp.
New messages are broadcast to connected clients via WebSocket and to external sinks via the webhook dispatcher. A scheduler
purges messages older than `CHAT_RETENTION_MS` (default 7 days).

## Feature flag

There is no feature flag for chat; the module is always enabled.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/chat/messages/{characterId}`** | List chat messages for a character. | 60/min per IP | Required | Yes | None | `{ ok, data: { messages: ChatMessage[] }, requestId, traceId }` |
| **POST `/v1/chat/messages`** | Create a new chat message. Requires `characterId`, `channel` and `message`. | 30/min per IP | Required | Yes | `ChatMessageCreateRequest` | `{ ok, data: { message: ChatMessage }, requestId, traceId }` |

### Schemas

* **ChatMessage** –
  ```yaml
  id: integer
  characterId: integer
  channel: string
  message: string
  createdAt: string (date-time)
  ```
* **ChatMessageCreateRequest** –
  ```yaml
  characterId: integer (required)
  channel: string (required)
  message: string (required)
  ```

## Implementation details

* **Repository:** `src/repositories/chatRepository.js` stores and retrieves messages.
* **Migration:** `src/migrations/039_add_chat_messages.sql` creates the `chat_messages` table. Index `idx_chat_messages_created_at`
  is added in `072_add_chat_messages_created_index.sql` for retention cleanup.
* **Routes:** `src/routes/chat.routes.js` defines the REST API and emits `chat.message` events over WebSocket and webhooks.
* **Task:** `src/tasks/chat.js` purges messages older than `config.chat.retentionMs`.
* **OpenAPI:** `openapi/api.yaml` documents schemas and paths including event notes.

## Future work

Chat logs could support moderation tools or extended channels.
