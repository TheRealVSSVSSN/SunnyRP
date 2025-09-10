# vorp_core-lua Documentation

## Overview
Provides the core utilities for RedM servers built on VORP. This resource handles player spawning, PVP toggling and other essential game mechanics.

## Table of Contents
- [client/spawnplayer.lua](#clientspawnplayerlua)
- [fxmanifest.lua](#fxmanifestlua)
- [version](#version)

## client/spawnplayer.lua
- Introduces `SetCanAttackFriendly` alongside `NetworkSetFriendlyFireOption` to fully respect the player's PVP choice.
- Fixes a high CPU usage bug by defaulting the main loop to a one-second wait, only running every frame when necessary.
- Adds parentheses around mount and vehicle checks to ensure proper logic when evaluating active PVP state.

## fxmanifest.lua
- Bumps resource version to `3.1.1` to reflect latest fixes and improvements.

## version
- Notes new entry for `3.1.1` describing PVP modernization and loop optimisation.
