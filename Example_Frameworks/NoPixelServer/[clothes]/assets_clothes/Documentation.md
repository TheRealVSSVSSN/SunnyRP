# assets_clothes Documentation

## Overview
Provides baseline clothing overrides and custom models for the NoPixelServer framework. The resource adjusts default freemode character component ranges and streams additional clothing assets.

## File Structure
- **fxmanifest.lua**: Defines resource metadata and registers override JSON files as clothing data.
- **mp_m_freemode_01.override.json**: Restricts male freemode component and prop slots to custom ranges.
- **mp_f_freemode_01.override.json**: Restricts female freemode component and prop slots to custom ranges.
- **stream/**: Folder containing 5,172 YDD/YTD/YMT files that provide custom clothing meshes and textures.

## fxmanifest.lua
Declares the `cerulean` manifest version, enables Lua 5.4 runtime, and ensures both male and female override JSON files are loaded via the `clothing` data type. The manifest also lists these JSON files so the engine packages them during resource build.

## mp_m_freemode_01.override.json
Maps each male freemode component (`head`, `uppr`, `lowr`, etc.) and prop (`head`, `eyes`, `ears`, etc.) to a single drawable range. This prevents players from selecting default GTA clothing items outside the custom range.

## mp_f_freemode_01.override.json
Performs the same restriction for female freemode components and props, enforcing the custom clothing range for female characters.

## stream/
Streams thousands of model (`.ydd`) and texture (`.ytd`) files as well as updated metadata (`.ymt`) used by the override definitions. These assets supply the actual clothing pieces players can wear.

## Conclusion
The resource centralizes clothing customization by limiting base freemode drawables and introducing a large library of custom outfits.

