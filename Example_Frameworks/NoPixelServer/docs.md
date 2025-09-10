# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## PolyZone
- Removed legacy `__resource.lua` and stray debug file, relying solely on a modern `fxmanifest.lua` with `lua54` enabled.
- Eliminated unused server script references to prevent missing file errors.
- Refactored threading to use `CreateThread` and `Wait` helpers throughout the library and creation utilities.
- Added namespace table utilities and cached native calls for improved performance and reduced global pollution.

## PolicePack
- Replaced legacy `__resource.lua` with modern `fxmanifest.lua` using `cerulean` fx_version and `gta5` game target.
- Removed invalid `vehiclelayouts.meta` references to prevent load errors.
- Cleaned up manifest to only include `vehicles`, `carvariations`, `carcols`, and `handling` meta files.
- Added missing newlines to meta files for improved compatibility.

## LockDoors
- Replaced legacy `__resource.lua` with modern `fxmanifest.lua` and enabled Lua 5.4.
- Updated vehicle detection to use `StartShapeTestRay` and vector math for reliability.
- Refactored locking logic into helper functions and localized variables to remove globals.
- Consolidated light flashing into a single function and switched to `Wait` helper.

## InteractSound
- Migrated to `fxmanifest.lua` with `cerulean` fx_version and Lua 5.4 support.
- Replaced invalid player checks with `NetworkIsPlayerActive` and added volume clamping.
- Removed jQuery dependency and refined NUI audio logic.
- Added server helpers for coordinated sound playback including distance and flash effects.
- Removed unused teleporter script and cleaned manifest ordering.
- Renamed internal variables for clarity and consolidated dealer helper functions.
- Improved server RNG seeding and scoped chip helpers locally for safety.