# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## lmfao
- Migrated to `fxmanifest.lua` with Lua 5.4 support.
- Replaced deprecated `GetPlayerPed(-1)` and `Citizen` calls with modern `PlayerPedId`, `CreateThread`, and `Wait`.
- Corrected fishing reward logic and ped task cleanup to prevent script errors.
- Added server-side validation for mission payout events and simplified `/ooc` messaging.
