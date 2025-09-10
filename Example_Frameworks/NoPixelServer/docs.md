# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## Jailbreak
- Migrated to `fxmanifest.lua` and enabled Lua 5.4 support.
- Replaced deprecated `Citizen` helpers with modern `CreateThread`/`Wait` usage and improved tray cleanup logic to delete objects safely.
- Secured jail time events with parameterized queries, corrected the `unjail` command to update the target character, and added a compatibility alias for the misspelled spawn event.
