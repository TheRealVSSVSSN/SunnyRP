# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## coordsaver
- Migrated resource to `fxmanifest.lua` using the `cerulean` fx_version.
- Removed debug prints and unused object creation from the client command.
- Replaced deprecated `GetPlayerPed(-1)` with `PlayerPedId` and streamlined events.
- Server now sanitizes player names and persists coordinates with `SaveResourceFile`.
