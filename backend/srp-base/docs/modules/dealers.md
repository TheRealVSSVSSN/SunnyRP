# dealers module

Manages temporary dealer offers for items.

## Routes

- `GET /v1/dealers/offers`
- `POST /v1/dealers/offers`

## Repository Contracts

- `createOffer({ item, price, expiresAt })` – create a new offer.
- `listActiveOffers()` – list offers with future expiry.
- `deleteExpired(now)` – remove offers past expiry and return ids.

## Realtime & Scheduler

- WebSocket `dealers.offer.created` and `dealers.offer.expired` with matching webhooks.
- Scheduler `dealer-offer-purge` removes expired offers every minute.

## Edge Cases

- `expiresAt` must be in the future.
- Listing returns an empty array when no offers exist.
