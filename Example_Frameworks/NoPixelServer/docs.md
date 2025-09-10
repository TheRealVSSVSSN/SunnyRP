# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## bob74_ipl
- Migrated to `fxmanifest.lua` with `lua54` and `cerulean` for modern compatibility.
- Replaced legacy threading and wait calls with `CreateThread` and `Wait`.
- Corrected prize vehicle freeze logic to use boolean parameters.
- Converted shared helpers to local functions to reduce global namespace pollution.
