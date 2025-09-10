# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## heli
- Migrated from `__resource.lua` to `fxmanifest.lua` with `cerulean` fx_version.
- Rewrote client and server scripts for readability and modularity.
- Fixed spotlight synchronization by using `NetworkIsPlayerActive` instead of the deprecated `DoesPlayerExist`.
