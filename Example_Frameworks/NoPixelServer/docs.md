# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## drz_interiors
- Migrated resource to `fxmanifest.lua` and removed legacy `__resource.lua`.
- Standardized server event registration and added player tracking to prevent nil table errors.
- Fixed entity cleanup routine to properly release non-player entities using `DeleteEntity`.
