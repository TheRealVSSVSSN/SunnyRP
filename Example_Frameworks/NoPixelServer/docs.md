# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## jobsystem
- Replaced legacy `__resource.lua` with modern `fxmanifest.lua` using the `cerulean` fx_version and Lua 5.4.
- Refactored client script to leverage `CreateThread`/`Wait` helpers and native vector math for distance checks.
- Updated GUI menu to use direct function references, removing global lookups.
- Cleaned duplicate notifications and unused variables for more maintainable job handling.
