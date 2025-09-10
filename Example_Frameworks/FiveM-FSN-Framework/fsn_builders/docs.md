# fsn_builders Documentation

## Overview and Runtime Context
`fsn_builders` is a build-time utility for assembling GTA V handling metadata. It registers a custom FiveM build task that collects vehicle handling definitions from other resources, validates them against Lua-based schemas, and emits a consolidated `handling.meta` file. The resource operates exclusively on the server during build steps and has no runtime gameplay impact.

## Table of Contents
- [agents.md](#agentsmd)
- [fxmanifest.lua](#fxmanifestlua)
- [handling_builder.lua](#handling_builderlua)
- [schema.lua](#schemalua)
- [xml.lua](#xmllua)
- [schemas/ccarhandlingdata.lua](#schemasccarhandlingdatalua)
- [schemas/cbikehandlingdata.lua](#schemascbikehandlingdatalua)
- [schemas/chandlingdata.lua](#schemaschandlingdatalua)
- [Cross-Indexes](#cross-indexes)
- [Configuration & Integration](#configuration--integration)
- [Gaps & Inferences](#gaps--inferences)

## agents.md
**Role:** Documentation guidelines for contributors.
**Classification:** Support file.

- Explains expectations for generating comprehensive Markdown documentation for the resource.
- No effect on runtime behavior.

## fxmanifest.lua
**Role:** Resource manifest executed by the FiveM runtime.
**Classification:** Server configuration.

- Targets the `bodacious` FXServer build and the `gta5` game.
- Loads utility scripts from `fsn_main` on both client and server; these are external dependencies.
- Adds `xml.lua`, `schema.lua`, and `handling_builder.lua` as server scripts, making the local code server-side only.
- Includes `mysql-async` but the resource code does not perform database operations.

## handling_builder.lua
**Role:** Implements the custom `fsn_handling` build task.
**Classification:** Server script.

- Imports three schemas (`CCarHandlingData`, `CBikeHandlingData`, `CHandlingData`) using `LoadSchema`.
- `load_file(res, file)` executes a handling definition within an environment that exposes loaded schemas and global functions. It returns a table of XML fragments representing handling items.
- `builder.shouldBuild(res)` checks whether the target resource has `fsn_handling` metadata entries.
- `builder.build(res, finished)`
  - Opens an XML document with `CHandlingDataMgr` and `HandlingData` roots.
  - Iterates over every `fsn_handling` file declared in the resource manifest.
  - Runs each file via `pcall` to capture errors, then appends each returned handling entry to the XML builder.
  - Serializes the result to `out/handling.meta` and invokes `finished(true)` on success or `finished(false, err)` on failure.
- `RegisterResourceBuildTaskFactory("fsn_handling", factory)` exposes the builder so other resources can trigger it during their build process.
- **Security:** Handling definition files run as Lua code; only trusted resources should declare `fsn_handling` metadata to avoid executing untrusted scripts.
- **Performance:** Work occurs at build time; impact during gameplay is negligible.

## schema.lua
**Role:** Provides the schema system that translates Lua tables into XML handling items.
**Classification:** Server script.

- Maintains a global `Schemas` table storing class definitions and serializer callbacks.
- Defines type handlers (`string`, `float`, `integer`, `vector`, `SubHandlingData`) that convert typed values into XML nodes.
- `drop_guard` assists error reporting by ensuring field definitions specify names.
- `env_for_schema(class)` supplies helper functions (`Group`, `Field`, `Desc`, `Default`, etc.) used when loading schema files. Unknown types trigger an assertion.
- `LoadSchema(class, file)` reads a schema definition from the `schemas` directory, executes it in the generated environment, and returns a callable table that serializes data according to the schema.
- **TODO:** Comment notes an intent to relocate error handling (`drop_guard`) to `fsn_core`.

## xml.lua
**Role:** Lightweight XML builder supporting chained operations.
**Classification:** Shared utility (used server-side).

- `XML()` constructs a builder object with an internal operation list.
- Supports chained methods such as `comment`, `open`, `close`, `inline`, `void`, and `append`.
- `serialize()` walks the recorded operations to produce a formatted XML string with proper indentation.

## schemas/ccarhandlingdata.lua
**Role:** Schema for `CCarHandlingData` sub-handling structures.
**Classification:** Server configuration data.

- Lists float fields like `fBackEndPopUpCarImpulseMult`, `fCamberFront`, `fToeRear`, and `fEngineResistance` with default values suited for cars.
- Provides base parameters used when car-specific handling overrides are absent.

## schemas/cbikehandlingdata.lua
**Role:** Schema for `CBikeHandlingData` sub-handling structures.
**Classification:** Server configuration data.

- Defines bike-related parameters such as `fLeanFwdCOMMult`, `fMaxBankAngle`, `fWheelieBalancePoint`, and `fJumpForce`, each defaulting to zero.
- Establishes defaults for bike handling when explicit values are not supplied.

## schemas/chandlingdata.lua
**Role:** Comprehensive schema for the top-level `CHandlingData` class covering physical, transmission, braking, traction, suspension, damage, and miscellaneous attributes.
**Classification:** Server configuration data.

- Organizes fields into logical groups via `Group` directives, improving readability and categorization.
- Each field specifies its type, optional source name, default, and limits where applicable.
- Concludes with a `SubHandlingData` field embedding `CCarHandlingData` defaults, enabling nested sub-handling structures.

## Cross-Indexes
### Events
None.

### ESX Callbacks
None.

### Exports
None.

### Commands
None.

### NUI Messages
None.

## Configuration & Integration
- Other resources integrate by declaring `fsn_handling` metadata in their manifests and supplying Lua handling files. During the build step, `handling_builder` executes these files, validates them against schemas, and writes a merged `out/handling.meta` file.
- Utility scripts from `fsn_main` and `mysql-async` are loaded for shared helpers and potential database access, though this resource does not issue queries itself.

## Gaps & Inferences
- **Inferred (High):** Handling definition files executed by `load_file` return tables of schema-generated XML builders that serialize to `<Item>` nodes in `handling.meta`.
- **Inferred (Medium):** The `finished` callback used in `builder.build` follows the conventional `(success, errorMessage)` pattern.
- **TODO:** Error-handling helpers (`drop_guard`) are slated to move into a common `fsn_core` module.

DOCS COMPLETE
