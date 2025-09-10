# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## import-Pack
- Migrated from legacy `__resource.lua` to modern `fxmanifest.lua` with Cerulean runtime.
- Registered vehicle metadata and handling files using current `data_file` entries.
- Enabled Lua 5.4 support for future compatibility.
