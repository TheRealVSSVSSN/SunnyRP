# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## isPed
- Replaced legacy `__resource.lua` with an `fxmanifest.lua` using the `cerulean` fx_version and Lua 5.4.
- Modernized ped utilities by switching to `GetGamePool` and `GetActivePlayers` natives.
- Consolidated `isPed` checks into a lookup table and added structured exports.
- Added documentation-style comments for maintainability.
