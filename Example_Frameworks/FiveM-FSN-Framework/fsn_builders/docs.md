# fsn_builders Documentation

## Overview
`fsn_builders` provides server-side tooling for constructing GTA V handling metadata at build time. It registers a custom build task that scans other resources for `fsn_handling` metadata entries, loads Lua-based handling definitions, and emits a consolidated `handling.meta` file using XML serialization.

## Table of Contents
- [fxmanifest.lua](#fxmanifestlua)
- [handling_builder.lua](#handling_builderlua)
- [schema.lua](#schemalua)
- [xml.lua](#xmllua)
- [schemas/cbikehandlingdata.lua](#schemasecbikehandlingdatalua)
- [schemas/ccarhandlingdata.lua](#schemaseccarhandlingdatalua)
- [schemas/chandlingdata.lua](#schemasechandlingdatalua)
- [Cross-Indexes](#cross-indexes)
- [Configuration & Integration](#configuration--integration)
- [Gaps & Inferences](#gaps--inferences)

## fxmanifest.lua
**Role:** Resource manifest executed by the FiveM runtime.  
**Classification:** Server configuration.

- Declares compatibility with the `bodacious` FXServer build and the `gta5` game.  
- Includes utility scripts from `fsn_main` and the `mysql-async` library. These references are external and provide shared utilities and database access.  
- Registers `xml.lua`, `schema.lua`, and `handling_builder.lua` as server scripts, making the resource entirely server-side.  

## handling_builder.lua
**Role:** Implements the custom `fsn_handling` build task.  
**Classification:** Server script.

- Loads three handling schemas (`CCarHandlingData`, `CBikeHandlingData`, `CHandlingData`) through `LoadSchema`.  
- `load_file(res, file)` executes a handling definition file within a sandbox that exposes loaded schemas. It returns a table of XML snippets representing handling items.  
- `builder.shouldBuild(res)` checks whether a resource declares any `fsn_handling` metadata entries.  
- `builder.build(res, finished)` iterates over each declared metadata file, parses it via `load_file`, appends the resulting handling items to an XML document, and saves the final output to `out/handling.meta`. The `finished` callback reports success or error.  
- `RegisterResourceBuildTaskFactory("fsn_handling", factory)` registers the builder with the FiveM build system so other resources can invoke it by adding `fsn_handling` metadata.  

## schema.lua
**Role:** Defines the schema system used to translate Lua tables into XML handling items.  
**Classification:** Server script.

- Maintains a global `Schemas` table that stores class definitions.  
- Provides type handlers (`string`, `float`, `integer`, `vector`, `SubHandlingData`) that convert Lua values into XML nodes.  
- Supplies `LoadSchema(class, file)` which reads schema files from the `schemas` directory, populates `Schemas[class]`, and returns a callable object that serializes data according to the schema.  
- Includes a `drop_guard` mechanism for clearer error messages when required fields or names are missing.  
- Contains a TODO noting the intent to move error handling to `fsn_core`.  

## xml.lua
**Role:** Lightweight XML builder supporting chained operations.  
**Classification:** Shared utility (server-side usage).

- `XML()` creates a builder object that records operations and can serialize them into a full XML document.  
- Supports operations such as `comment`, `open`, `close`, `inline`, and `void` to emit elements, text content, or self-closing tags.  
- `append` merges the operations from another builder, enabling composition of nested XML fragments.  

## schemas/cbikehandlingdata.lua
**Role:** Schema for `CBikeHandlingData` sub-handling structures.  
**Classification:** Server configuration data.

- Lists float fields such as `fLeanFwdCOMMult`, `fMaxBankAngle`, `fInAirSteerMult`, and more, each with a default value of `0.0`.  
- These defaults allow bike-specific handling adjustments when no explicit value is supplied in a definition file.  

## schemas/ccarhandlingdata.lua
**Role:** Schema for `CCarHandlingData` sub-handling structures.  
**Classification:** Server configuration data.

- Defines float fields like `fBackEndPopUpCarImpulseMult`, `fCamberFront`, `fCastor`, and others.  
- Defaults represent typical car parameters; for example, `fBackEndPopUpCarImpulseMult` defaults to `0.05`.  

## schemas/chandlingdata.lua
**Role:** Comprehensive schema for the top-level `CHandlingData` class covering physical, transmission, braking, traction, suspension, damage, and miscellaneous attributes.  
**Classification:** Server configuration data.

- Groups fields into logical sections such as *Physical*, *Transmission*, *Brake*, *Traction*, *Suspension*, *Damage*, and *Misc*.  
- Each field specifies a type, source name, default value, and optional limits.  
- Concludes with a `SubHandlingData` field that nests `CCarHandlingData` defaults, allowing complex handling setups.  

## Cross-Indexes
### Events
_No events defined._

### ESX Callbacks
_None._

### Exports
_None._

### Commands
_None._

## Configuration & Integration
- Other resources integrate by listing Lua handling files under the `fsn_handling` metadata in their manifests. During the build step, those files are executed by `handling_builder` and serialized into `out/handling.meta`.  
- The builder relies on `LoadSchema` and schema files to convert Lua tables into the format required by GTA V handling metadata.  

## Gaps & Inferences
- **Inferred (High):** Handling definition files invoked by `load_file` are expected to return tables of schema-generated XML elements. This is deduced from how their results are iterated and appended within `builder.build`.  
- **Inferred (Medium):** The `finished` callback supplied to `builder.build` follows the conventional `(success, error)` pattern; its exact implementation is external.  
- **TODO:** None identified.

DOCS COMPLETE
