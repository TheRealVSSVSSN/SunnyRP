# Chat Module

The chat module records text messages sent in game. Each message is tied to a character and includes the channel and timestamp.

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
* **Migration:** `src/migrations/039_add_chat_messages.sql` creates the `chat_messages` table.
* **Routes:** `src/routes/chat.routes.js` defines the REST API.
* **OpenAPI:** `openapi/api.yaml` documents schemas and paths.

## Future work

Chat logs could support moderation tools or extended channels.
