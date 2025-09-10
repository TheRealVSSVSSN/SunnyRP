# NoPixelServer Documentation

## DiamondBlackjack
- Updated `fxmanifest.lua` to use `cerulean` fx_version and removed duplicate panel includes.
- Replaced legacy `Citizen.CreateThread` and `Citizen.Wait` calls with modern `CreateThread` and `Wait` helpers.
- Added radius constant to blackjack table locator and corrected prop name outputs.
- Moved animation dictionary cleanup outside the dealer creation loop to prevent missing animation issues.
- Converted global state to local variables and tightened betting validation on the server.

## Banking
- Migrated to `fxmanifest.lua` and removed legacy `__resource.lua`.
- Added robust server-side validation for deposits, withdrawals, and transfers.
- Updated client scripts to use `CreateThread`/`Wait` and corrected player validation logic.
- Cleaned NUI JavaScript by removing duplicate functions and unused variables.
