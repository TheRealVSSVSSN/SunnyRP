# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## [clothes]/assets_clothes
- Switched manifest to the `cerulean` fx_version, declared `lua54` support and registered clothing override data files.
- Added explicit `data_file` entries so male and female freemode override JSONs load correctly.
- Normalized override JSON files to end with newlines to prevent file concatenation issues.

