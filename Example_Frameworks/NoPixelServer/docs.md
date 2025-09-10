# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## boatshop
- Migrated resource to `fxmanifest.lua` with Lua 5.4 support.
- Replaced legacy `Citizen` thread and wait calls with modern `CreateThread`, `Wait`, and clear native helpers.
- Fixed database lookups for storing and selling boats to validate ownership before updates.
- Removed unused helpers and localized state variables to prevent global leakage.
