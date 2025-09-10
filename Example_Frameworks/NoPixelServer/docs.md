# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## lux_vehcontrol
- Migrated resource to `fxmanifest.lua` with `cerulean` target and explicit Lua 5.4 support.
- Replaced jQuery NUI logic with vanilla JavaScript for panic and metal detector alerts.
- Fixed default siren muting by switching to `SetVehicleHasMutedSirens` and switched player lookups to `PlayerPedId()`.
- Updated threading helpers to `CreateThread`/`Wait` and modernized server events with `RegisterNetEvent`.
