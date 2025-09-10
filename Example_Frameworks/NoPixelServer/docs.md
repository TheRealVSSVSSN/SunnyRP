# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## connectqueue
- Migrated to `cerulean` fx_version, enabled `lua54`, and consolidated shared scripts.
- Replaced deprecated `Citizen` calls with `CreateThread` and `Wait` for both server and client contexts.
- Corrected hexadecimal Steam ID conversion to prevent runtime errors.
- Fixed join delay initialization so queue startup delay honors configuration.
- Registered `Queue:playerActivated` with `RegisterNetEvent` for network event compatibility.
