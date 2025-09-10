# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## cron
- Migrated resource to `fxmanifest.lua` and enabled Lua 5.4 support.
- Replaced legacy timer loop with `CreateThread` scheduler that accounts for skipped minutes.
- Added `cron:runAt` event and `RunAt` export for registering scheduled callbacks.
