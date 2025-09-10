# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## furniture
- Replaced legacy `__resource.lua` with modern `fxmanifest.lua` and enabled `lua54` for newer language features.
- Standardized thread helpers to `CreateThread`/`Wait` and swapped deprecated native calls for `ScaleformMovieMethodAddParamButtonName`.
- Fixed naming errors (Rotate, Forward) and function typos (`stopFurniture`, `placeCurrentObjects`).
- Added structured comment blocks and refreshed the server script placeholder.
