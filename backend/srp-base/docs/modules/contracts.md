# Contracts Module

## Purpose

The contracts module enables players to form simple agreements that
involve a payment. Each contract records a sender, receiver, amount
(in whole cents) and optional information text. Contracts remain in a
pending state until the receiver accepts or declines them. When
accepted, funds are transferred from the receiver to the sender using
the existing economy helpers.

## Endpoints

### `GET /v1/contracts?playerId=cid`
Lists contracts where the given player is either the sender or the
receiver. The response contains an array of contract objects with
fields matching the database schema.

### `POST /v1/contracts`
Creates a new contract. Required body fields: `senderId`, `receiverId`
and `amount`. Optional field `info` stores descriptive text. The
response returns the identifier of the newly created contract.

### `POST /v1/contracts/{id}/accept`
Accepts a contract on behalf of the receiver. Body must include
`playerId` to verify the actor. On success the service transfers the
amount and marks the contract as paid and accepted.

### `POST /v1/contracts/{id}/decline`
Declines a pending contract. No body is required. The contract is
marked as resolved without moving any funds.

## Repository

`contractsRepository.js` exposes helper functions:

- **listContractsForPlayer(playerId)** – fetches contracts involving a
  particular player.
- **createContract({ senderId, receiverId, amount, info })** – inserts a
  new contract row and returns its id.
- **getContract(id)** – retrieves a single contract by id.
- **markAccepted(id)** – sets `paid` to 1 and `accepted` to 1.
- **markDeclined(id)** – sets `accepted` to 0 for unresolved contracts.

## Database Migration

`018_add_contracts.sql` creates the `contracts` table with the columns
used by the repository. Indices on `sender_id` and `receiver_id` allow
fast lookups for either party.

## Notes

* Amounts are stored as integers representing cents. Clients should
  multiply dollar values accordingly.
* All endpoints require standard authentication and idempotency
  headers.
* Once a contract is accepted or declined it cannot be changed again.
