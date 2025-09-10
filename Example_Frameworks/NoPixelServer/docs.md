# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## koilWeatherSync
- Migrated from `__resource.lua` to modern `fxmanifest.lua` with Lua 5.4 support.
- Refactored server logic into modular functions for time and weather control.
- Rewrote client synchronization with toggleable export `SetEnableSync` and cleaner event handling.
