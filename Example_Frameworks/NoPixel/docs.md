# NoPixel Documentation

## WiseGuy Imports

This resource provides custom vehicle imports for the NoPixel framework.

### Recent Changes

- Converted legacy `__resource.lua` to modern `fxmanifest.lua` using the `cerulean` fx_version and enabling Lua 5.4.
- Refactored `vehicle_names.lua` to register vehicle names using a table-driven approach and `AddTextEntryByHash` within a `CreateThread`.

### Usage

Add the resource to your `server.cfg` to load custom vehicles and their display names.

