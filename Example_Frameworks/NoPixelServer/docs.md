# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.
- Removed unused teleporter script and cleaned manifest ordering.
- Renamed internal variables for clarity and consolidated dealer helper functions.
- Improved server RNG seeding and scoped chip helpers locally for safety.

## garages
- Migrated to `fxmanifest.lua` and removed missing `s_chopshop.lua` reference.
- Replaced deprecated `Citizen` threading, waiting, and deletion calls with modern `CreateThread`, `Wait`, and `DeleteVehicle` APIs.
- Fixed misconfigured upgrade value definitions and pruned unused data tables.
- Eliminated duplicate vehicle deletions to prevent script errors.
