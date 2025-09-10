# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## gabz_pillbox_hospital
- Modernized `fxmanifest.lua` with `cerulean` fx_version, Lua 5.4 support, and streamlined client script declaration.
- Refactored `main.lua` to use `CreateThread` and consolidated IPL removals into a single loop.
- Added interior validation and explicit loading before refreshing to ensure reliable map updates.
