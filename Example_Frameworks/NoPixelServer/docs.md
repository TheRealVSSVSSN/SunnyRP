# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## k9
- Migrated resource to `fxmanifest.lua` with Lua 5.4 support.
- Fixed uninitialized bone index in render helper preventing marker display.
- Corrected variable typo causing `attacking` logic to break when entering vehicles.
- Refactored dog spawning into a dedicated `spawnDog` function and sanitized debug code.
- Replaced legacy `Citizen` helpers with modern `CreateThread`/`Wait` for better performance.
