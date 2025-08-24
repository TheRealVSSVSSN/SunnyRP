# DiamondBlackjack Module

The **DiamondBlackjack** module persists blackjack hand history from the casino tables.

## Feature flag

There is no feature flag for this module; it is always enabled.

## Endpoints

| Method & Path | Description | Rate Limit | Auth | Idempotent | Request Body | Response |
|---|---|---|---|---|---|---|
| **GET `/v1/diamond-blackjack/hands/:characterId`** | Retrieve up to 50 recent hands for the specified character. | n/a | Required | Yes | None | `200 { ok, data: { hands: DiamondBlackjackHand[] }, requestId, traceId }` |
| **POST `/v1/diamond-blackjack/hands`** | Record a blackjack hand result. | n/a | Required | Yes (use `X-Idempotency-Key`) | `DiamondBlackjackHandCreateRequest` | `200 { ok, data: { hand: DiamondBlackjackHand }, requestId, traceId }` |

### Schemas

* **DiamondBlackjackHand** –
  ```yaml
  characterId: string
  tableId: integer
  bet: integer
  payout: integer
  dealerHand: string
  playerHand: string
  playedAt: integer (unix ms)
  ```
* **DiamondBlackjackHandCreateRequest** –
  ```yaml
  characterId: string (required)
  tableId: integer (required)
  bet: integer (required)
  payout: integer (required)
  dealerHand: string (required)
  playerHand: string (required)
  playedAt: integer (optional)
  ```

## Implementation details

* **Repository:** `src/repositories/diamondBlackjackRepository.js` provides `recordHand` and `listHandsByCharacter` using parameterised queries.
* **Migration:** `src/migrations/021_add_diamond_blackjack.sql` creates the `diamond_blackjack_hands` table.
* **Routes:** `src/routes/diamondBlackjack.routes.js` defines the HTTP endpoints and validation.
* **OpenAPI:** `openapi/api.yaml` documents the schemas and `/v1/diamond-blackjack/hands` paths.

## Future work

Future iterations may track chip balances, table limits and player analytics.
