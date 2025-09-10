# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## PolyZone
- Removed legacy `__resource.lua` and stray debug file, relying solely on a modern `fxmanifest.lua` with `lua54` enabled.
- Eliminated unused server script references to prevent missing file errors.
- Refactored threading to use `CreateThread` and `Wait` helpers throughout the library and creation utilities.
- Added namespace table utilities and cached native calls for improved performance and reduced global pollution.
