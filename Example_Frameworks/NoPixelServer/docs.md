# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## import-Pack2
- Replaced deprecated `__resource.lua` with `fxmanifest.lua` using `cerulean` fx_version and Lua 5.4 support.
- Added `vehicle_names.lua` to register human-friendly vehicle names through `AddTextEntry`.
- Declared all vehicle metadata files explicitly in the new manifest.
