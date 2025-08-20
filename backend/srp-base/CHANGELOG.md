# Changelog

## 2025‑08‑19 (Part 6)

### Added

* **Secondary jobs module.** Implemented a new set of endpoints for managing
  secondary job assignments.  The API exposes:
  * `GET /v1/secondary-jobs` – lists all secondary jobs for a character (requires `playerId` query parameter).
  * `POST /v1/secondary-jobs` – assigns a new secondary job to a character (requires `playerId` and `job` in the body).
  * `DELETE /v1/secondary-jobs` – removes all secondary jobs for a character (requires `playerId` query parameter).
  A new repository (`secondaryJobsRepository.js`) encapsulates database
  access and a migration (`016_add_secondary_jobs.sql`) creates the
  `secondary_jobs` table with indexes on `player_id`.

### Changed

* **app.js** – mounted the new secondary jobs router so that the API is available.

### Notes

This sprint continues our translation of NoPixel server
behaviours into RESTful endpoints.  The `np‑secondaryjobs` resource
originally used events to add or clear secondary jobs.  By exposing
simple HTTP endpoints we centralise persistence and enable FiveM Lua
resources to interact with the same underlying database.  Validation is
performed on inputs and standard error envelopes are returned on
failure.  Future work may include per‑job metadata and integration with
permissions or wages systems.