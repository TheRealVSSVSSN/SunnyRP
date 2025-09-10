# vorp_core-lua Documentation

## Overview
Provides the core utilities for RedM servers built on VORP. This resource handles player spawning, PVP toggling and other essential game mechanics.

## Table of Contents
- [client/spawnplayer.lua](#clientspawnplayerlua)
- [fxmanifest.lua](#fxmanifestlua)
- [server/init.lua](#serverinitlua)
- [version](#version)

## client/spawnplayer.lua
- Introduces `SetCanAttackFriendly` alongside `NetworkSetFriendlyFireOption` to fully respect the player's PVP choice.
- Fixes a high CPU usage bug by defaulting the main loop to a one-second wait, only running every frame when necessary.
- Adds parentheses around mount and vehicle checks to ensure proper logic when evaluating active PVP state.

## fxmanifest.lua
- Removes references to non-existent script folders and corrects the server script glob, ensuring all runtime files load properly.

## server/init.lua
- Detects the host operating system at runtime to surface helpful Linux-specific messaging.
- Localizes internal state variables and helper functions to reduce global namespace pollution.

## version
- Notes new entry for `3.1.1` describing PVP modernization and loop optimisation.
