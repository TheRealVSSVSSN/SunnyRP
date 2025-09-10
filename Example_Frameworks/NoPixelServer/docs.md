# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## baseevents
- Migrated to `fxmanifest.lua` with `cerulean` fx_version and Lua 5.4.
- Replaced all legacy `Citizen` calls with `CreateThread` and `Wait`.
- Fixed vehicle model lookup and cleaned unused state in `vehiclechecker.lua`.
- Added full server event handlers with standardized RCON logging.
- Improved death detection logic and dynamic player lookups.
