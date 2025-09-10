# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## koil-debug
- Migrated from `__resource.lua` to `fxmanifest.lua` with `cerulean` fx_version.
- Refactored client script to use `PlayerPedId` and modern entity enumerators.
- Replaced deprecated `Citizen` functions with native `CreateThread`/`Wait` helpers.
- Added configurable debug toggles for freezing entities and low gravity.

