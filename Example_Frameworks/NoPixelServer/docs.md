# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## [map]/maps
- Replaced deprecated `__resource.lua` with modern `fxmanifest.lua` using the `cerulean` fx_version.
- Removed references to missing `def_props.ytyp` and `v_int_16.ytyp` files, retaining only existing `traphouse_shell` assets.
