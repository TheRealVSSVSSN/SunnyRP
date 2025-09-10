# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## es_taxi
- Replaced legacy `__resource.lua` with a modern `fxmanifest.lua` and switched to `cerulean`.
- Refactored spawn and pickup logic into reusable tables and converted all waits to `Wait` helpers.
- Fixed `SetVehicleExtra` usage so taxi roof lights function correctly and corrected malformed coordinates.
- Updated server event registration to `RegisterNetEvent` for consistency with current FiveM APIs.
