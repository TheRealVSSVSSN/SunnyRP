# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## WiseGuy-Vanilla
- Replaced legacy `__resource.lua` with modern `fxmanifest.lua` using `cerulean` `fx_version` and enabled Lua 5.4.
- Refactored `vehicle_names.lua` into a table-driven registry using `CreateThread` for clarity and efficiency.
- Removed duplicate entry calls by consolidating labels in a single structure.
