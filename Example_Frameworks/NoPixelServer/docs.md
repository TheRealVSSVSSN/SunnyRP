# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## hardcap
- Removed client-side activation event and now enforce slot limits entirely server-side via `playerConnecting` and `playerDropped`.
- Updated `fxmanifest.lua` to use the `cerulean` fx_version and enable Lua 5.4.
- Refactored codebase with modern FiveM natives and added restart-safe player tracking.
