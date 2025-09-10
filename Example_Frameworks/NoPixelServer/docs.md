# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## WiseGuy-UC
- Replaced legacy `__resource.lua` with a modern `fxmanifest.lua` using the `cerulean` fx_version and Lua 5.4.
- Refactored vehicle name registration into a table-driven script and swapped `Citizen.CreateThread` for `CreateThread`.
