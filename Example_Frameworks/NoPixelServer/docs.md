# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## PolicePack
- Replaced legacy `__resource.lua` with modern `fxmanifest.lua` using `cerulean` fx_version and `gta5` game target.
- Removed invalid `vehiclelayouts.meta` references to prevent load errors.
- Cleaned up manifest to only include `vehicles`, `carvariations`, `carcols`, and `handling` meta files.
- Added missing newlines to meta files for improved compatibility.
