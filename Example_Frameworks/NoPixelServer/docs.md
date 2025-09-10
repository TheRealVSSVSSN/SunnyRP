# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## [mod] resource manifests
- Migrated legacy `__resource.lua` files to `fxmanifest.lua` for `furnished-shells`, `hair-pack`, `mh65c`, `motel`, `shoes-pack`, and `yuzler`.
- Enabled Lua 5.4 and `cerulean` fx_version across all `[mod]` resources.
- Cleaned up the `mh65c` manifest by removing references to missing files and adding `dlctext.meta` support.
