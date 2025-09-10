# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## chat
- Migrated resource to `fxmanifest.lua` and registered all scripts explicitly.
- Added missing handler for `chat:addSuggestions` and improved command refresh logic.
- Refactored client code to use configurable keybind, modern natives, and cleaner NUI callbacks.
- Replaced legacy XMLHttpRequest usage with `fetch` and upgraded JavaScript to strict equality and const/let conventions.
