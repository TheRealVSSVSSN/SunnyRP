# vorp_core-lua Documentation

## Overview
Provides the core utilities for RedM servers built on VORP. This resource handles player spawning, PVP toggling and other essential game mechanics.

## Table of Contents
- [client/spawnplayer.lua](#clientspawnplayerlua)
- [client/callbacks.lua](#clientcallbackslua)
- [fxmanifest.lua](#fxmanifestlua)
- [server/init.lua](#serverinitlua)
- [server/class/callbacks.lua](#serverclasscallbackslua)
- [version](#version)
- [client/coreactions.lua](#clientcoreactionslua)
- [client/respawnsystem.lua](#clientrespawnsystemlua)

## client/spawnplayer.lua
- Introduces `SetCanAttackFriendly` alongside `NetworkSetFriendlyFireOption` to fully respect the player's PVP choice.
- Fixes a high CPU usage bug by defaulting the main loop to a one-second wait, only running every frame when necessary.
- Adds parentheses around mount and vehicle checks to ensure proper logic when evaluating active PVP state.
- Caches minimap state to avoid redundant `SetMinimapType` calls and uses corrected mount detection.
- Merges periodic health and stamina persistence into a single thread with a configurable save interval.

## client/callbacks.lua
- Validates callback names using proper logical checks to avoid accepting non-string identifiers.
- Adds optional timeout support for synchronous RPC calls to prevent indefinite waits.

## fxmanifest.lua
- Removes references to non-existent script folders and corrects the server script glob, ensuring all runtime files load properly.

## server/init.lua
- Detects the host operating system at runtime to surface helpful Linux-specific messaging.
- Localizes internal state variables and helper functions to reduce global namespace pollution.

## server/class/callbacks.lua
- Ensures callback names and sources are validated with correct boolean logic.
- Introduces configurable timeouts for awaited callbacks, resolving pending promises if no response is received.

## version
- Adds `3.1.3` for respawn fixes and native usage improvements.
- Retains `3.1.2` for RPC validation and timeout support.
- Notes prior entry for `3.1.1` describing PVP modernization and loop optimisation.

## client/coreactions.lua
- Replaces raw native hashes with `SetAttributeCoreValue` for health and stamina restoration.
- Documents `HealPlayer` using structured comments for clarity and maintainability.

## client/respawnsystem.lua
- Corrects vector distance checks and ensures teleportation respects heading.
- Utilizes `SetCinematicModeActive` and `SetEntityCoordsAndHeading` to align with FiveM APIs.
