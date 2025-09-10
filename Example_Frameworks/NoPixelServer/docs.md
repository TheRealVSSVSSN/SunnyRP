# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## [assets]
- Migrated `__resource.lua` files to modern `fxmanifest.lua` across asset packages.
- Removed references to missing map files and corrected parenting data paths.
- Replaced deprecated `Citizen.CreateThread` and native hash invocations with `CreateThread` and `SetRainFxIntensity`.
- Simplified emitter logic and scoped interior identifiers to prevent global leakage.
