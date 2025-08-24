# Progress Ledger – SRP‑Base Node Backend

| Index | Resource | Summary of Server Responsibilities | Decision | Notes |
|---|---|---|---|---|
| 1 | DiamondBlackjack | Casino blackjack tables; persist hand outcomes for analytics | Create | Added hand history API |
| 2 | InteractSound | Play sound effects for players; log sound playback events | Create | Added sound play API |
| 3 | LockDoors | Door state persistence and management | Extend | Added OpenAPI spec and documentation |
| 4 | PolicePack | Evidence custody chain and account character selection | Create | Added custody and selection APIs |
| 5 | PolyZone | Zone definitions and management | Create | Added zone storage API |
| 6 | Wise Audio | Custom audio track storage per character | Create | Added track storage API |
| 7 | Wise Imports | Vehicle import order tracking per character | Create | Added order storage API |
| 8 | Wise-UC | Undercover alias profiles per character | Create | Added profile API |
| 9 | WiseGuy-Vanilla | Baseline character management; remove legacy unscoped endpoints | Extend | Consolidated account-scoped APIs |
| 10 | WiseGuy-Wheels | Wheel spin logging per character | Create | Added spin history API |
| 11 | assets | Store and retrieve character-bound asset metadata | Create | Added asset APIs |
| 12 | assets_clothes | Save and manage character outfit data | Create | Added clothing outfit APIs |
| 13 | maps | World mapping assets; no server interaction | Skip | Asset-only |
| 14 | furnished-shells | Interior shell models; no persistence | Skip | Asset-only |
| 15 | hair-pack | Hair style models; no backend | Skip | Asset-only |
| 16 | mh65c | Helicopter model assets; no backend | Skip | Asset-only |
| 17 | motel | Motel interior assets; no backend | Skip | Asset-only |
| 18 | shoes-pack | Footwear model assets; no backend | Skip | Asset-only |
| 19 | yuzler | Clothing asset pack; no backend | Skip | Asset-only |
| 20 | apartments | Apartment definitions and resident assignments | Extend | Added character-scoped residency and GET filter |
| 21 | banking | Character bank accounts and transactions | Extend | Added account and transaction APIs |
| 22 | baseevents | Player lifecycle and combat events logging | Create | Added base event log API |
