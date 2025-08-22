# Phone Module

The **phone** module exposes tweet functionality for the in-game phone application. The original Lua resource stores tweets in a MySQL table via events like `GetTweets` and `Tweet`. This module provides REST endpoints so tweets persist across restarts and can be accessed by external services.

## Feature flag

There is no feature flag for the phone module; it is always enabled.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/phone/tweets`** | Retrieve up to the 50 most recent tweets in chronological order. | 60/min per IP | Required | Yes | None | `{ ok, data: { tweets: Tweet[] }, requestId, traceId }` |
| **POST `/v1/phone/tweets`** | Create a new tweet with `handle` and `message` (and optional `time`). | 30/min per IP | Required | Yes | `TweetCreateRequest` | `{ ok, data: { tweet: Tweet }, requestId, traceId }` |

### Schemas

* **Tweet** –
  ```yaml
  handle: string (max 64)
  message: string (max 280)
  time: integer (unix ms)
  ```
* **TweetCreateRequest** –
  ```yaml
  handle: string (required, max 64)
  message: string (required, max 280)
  time: integer (optional)
  ```

## Implementation details

* **Repository:** `src/repositories/phoneRepository.js` provides `listTweets` and `createTweet` using parameterised queries.
* **Migration:** `src/migrations/018_add_tweets.sql` creates the `tweets` table and indexes `time` for efficient retrieval.
* **Routes:** `src/routes/phone.routes.js` defines the HTTP endpoints and handles validation.
* **OpenAPI:** `openapi/api.yaml` documents the `Tweet` and `TweetCreateRequest` schemas and the `/v1/phone/tweets` path.

## Future work

Future iterations may add contacts, messaging and call history. Authentication and rate limits may be refined as new features arrive.
