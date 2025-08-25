# Diamond Casino Module

Provides unified casino game handling (blackjack, slots, horse racing, spin wheel and more). Supports game creation, bet placement and result retrieval.

## Routes
- `POST /v1/diamond-casino/games`
- `GET /v1/diamond-casino/games/{gameId}`
- `POST /v1/diamond-casino/games/{gameId}/bets`

## Repository Contract
- `createGame({ gameType, metadata })`
- `addBet({ gameId, characterId, amount, betData })`
- `getGame(gameId)`
- `listPendingGames(beforeTs)`
- `resolveGame(gameId, result)`

## Edge Cases
- Missing `gameType` or `characterId` is rejected with `VALIDATION_ERROR`.
- Unknown `gameId` returns `NOT_FOUND`.
- Scheduler resolves stale games and broadcasts `gameResolved` events via WebSocket and webhooks.
