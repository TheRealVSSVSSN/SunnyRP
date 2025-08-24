# Sprint Overview – 2025-08-23

This sprint resets the documentation ledger and introduces foundational support for the **DiamondBlackjack** resource. A new REST API records blackjack hands for each character, enabling future casino analytics while respecting multi-character ownership.

### Highlights

* Added Diamond Blackjack module with `GET` and `POST /v1/diamond-blackjack/hands` endpoints, repository, migration and OpenAPI documentation.
* Added Interact Sound module with `GET` and `POST /v1/interact-sound/plays` endpoints for sound playback history.
* Reset the progress ledger to begin a new parity run.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/diamondBlackjack.md`.

## Update – 2025-08-24

Extended parity for the **LockDoors** resource by documenting existing door management endpoints and aligning the OpenAPI specification.

* Added Interact Sound module with `GET` and `POST /v1/interact-sound/plays` endpoints for sound playback history.

* Reset the progress ledger to begin a new parity run.

For resource decisions see `progress-ledger.md`. Module details are documented in `modules/diamondBlackjack.md`.
