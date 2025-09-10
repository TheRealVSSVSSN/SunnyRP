# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## Apartments
- Replaced deprecated `__resource.lua` with an `fxmanifest.lua` targeting the `cerulean` runtime and Lua 5.4.
- Switched all `Citizen.CreateThread` and `Citizen.Wait` usages to `CreateThread` and `Wait` for modern syntax.
- Updated apartment client text rendering to use `SetTextJustification` instead of the raw native hash and fixed missing ownership warning.
- Corrected server-side property sale and key distribution logic to reference target character data properly.
- Added final newlines and minor formatting cleanups in GUI and other scripts.
