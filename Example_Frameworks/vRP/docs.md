# vRP Resource Documentation

## Overview and Runtime Context
vRP provides a modular roleplay framework for FiveM. It offers user management, jobs, inventory, economy, and utility systems implemented through extensions that run on the server and client. Configuration and GUI assets allow server owners to tailor gameplay features.

## Table of Contents
- [Top-Level Files](#top-level-files)
- [Misc Assets](#misc-assets)
- [Documentation Assets](#documentation-assets)
- [VoIP Server](#voip-server)
- [vrp Framework](#vrp-framework)
  - [Core Files](#core-files)
  - [Client Scripts](#client-scripts)
  - [Server Modules](#server-modules)
  - [Configuration Files](#configuration-files)
  - [GUI (NUI) Files](#gui-nui-files)
  - [Library Files](#library-files)
- [Cross-Indexes](#cross-indexes)
  - [Events](#events)
  - [NUI Callbacks](#nui-callbacks)
  - [DB Usage](#db-usage)
- [Configuration & Integration Points](#configuration--integration-points)
- [Gaps & Inferences](#gaps--inferences)
- [Conclusion](#conclusion)

## Top-Level Files
### LICENSE
MIT license governing the framework.

### README.adoc
AsciiDoc overview of vRP, its features, and links to community resources.

## Misc Assets
### misc/logo.png and variants
Image assets for branding; no runtime effect.

## Documentation Assets
### doc/index.adoc
Entry point AsciiDoc describing project usage and building instructions.

### doc/build.sh
Shell script building documentation from AsciiDoc sources.

### doc/dev/index.adoc
Developer-oriented documentation index.

### doc/dev/modules/*.adoc
Per-module descriptive documents explaining behaviour and configuration of each extension.

## VoIP Server
### voip_server/config.js
Node configuration enabling WebSocket voice channels.

### voip_server/main.js
Node.js WebSocket server relaying positional audio data for the Audio module.

## vrp Framework
### Core Files
#### fxmanifest.lua / __resource.lua
Resource manifests defining script loading order and metadata for FiveM.

#### vRP.lua
Server-side core class that loads configuration, handles database drivers, dispatches events, and manages users.

#### vRPShared.lua
Shared logic used by both client and server, including data structures and helper functions.

#### User.lua
Defines the server-side User class managing player state, identifiers, and data persistence.

#### base.lua
Server bootstrap registering spawn/death events and delegating to vRP handlers.

### Client Scripts
#### client/base.lua
Initialises the client context, bridges to server via Tunnel/Proxy, and forwards spawn/death events to the server.

#### client/admin.lua
Implements client admin tools such as noclip and spectating controls.

#### client/audio.lua
Client half of Audio extension managing voice channels and forwarding NUI audio events.

#### client/garage.lua
Handles spawning and tracking owned vehicles, updating decorators and network ownership.

#### client/gui.lua
Client GUI management: keyboard controls, menu navigation, prompts, and request handling through NUI.

#### client/identity.lua
Stores registration numbers and exposes tunnelled method to update them.

#### client/iplloader.lua
Loads world IPLs (interior placement objects) for map customisation.

#### client/map.lua
Manages map areas, blips, entity commands, and remote positioning utilities.

#### client/ped_blacklist.lua
Removes blacklisted pedestrian models on spawn based on server-provided configuration.

#### client/phone.lua
Implements phone UI interactions and SMS sending via server tunnels.

#### client/player_state.lua
Tracks player vitals, weapons and state transitions for survival and respawn logic.

#### client/police.lua
Provides client-side police functions such as handcuffing and wanted level display.

#### client/radio.lua
Manages radio push-to-talk and membership in radio groups.

#### client/survival.lua
Implements coma and vital depletion mechanics, controlling health and hunger.

#### client/veh_blacklist.lua
Regularly deletes vehicles using forbidden models.

#### client/vRP.lua
Client core class loading client configuration.

#### client/warp.lua
Implements warp points and movement restrictions through map entities.

### Server Modules
#### modules/admin.lua
Admin menu allowing kicks, bans, teleports and user management.

#### modules/aptitude.lua
Education/skill system tracking experience and levels with configurable progress.

#### modules/atm.lua
Implements ATM interactions allowing players to deposit and withdraw cash.

#### modules/audio.lua
Server side of Audio extension distributing audio sources and voice channel states.

#### modules/business.lua
Company and money laundering system with directories and commerce menus.

#### modules/cloak.lua
Uniform and disguise system enabling cloaks and skin changes.

#### modules/edible.lua
Defines consumable items and applies effects when eaten.

#### modules/emotes.lua
Provides emote definitions and menu to trigger animations.

#### modules/garage.lua
Vehicle storage and retrieval with persistence, ownership checks, and state saving.

#### modules/group.lua
Group/permission framework assigning permissions and tiered groups to users.

#### modules/gui.lua
Server counterpart to GUI controlling menus, prompts, divs and NUI focus.

#### modules/hidden_transformer.lua
Hidden transformer locations for resource processing with discovery mechanics.

#### modules/home.lua
Housing system handling purchase, entry, storage and state updates.

#### modules/home_components.lua
Home component definitions such as chests and entry points.

#### modules/identity.lua
Identity management generating names, registrations, and IDs.

#### modules/inventory.lua
Item handling, chest management and parametric item definitions.

#### modules/login.lua
Authenticates players, handles whitelists and bans, and initialises user records.

#### modules/map.lua
Area and point-of-interest management allowing callbacks on enter/leave and command execution.

#### modules/mission.lua
Mission framework providing step-based tasks with blip routes and mission events.

#### modules/money.lua
Wallet and bank storage, salary payments and money change notifications.

#### modules/ped_blacklist.lua
Enforces pedestrian model restrictions by sending config to clients on spawn.

#### modules/phone.lua
Phone number allocation, SMS handling and contact management.

#### modules/player_state.lua
Server authority over vitals, weapons, and character state persistence.

#### modules/police.lua
Police tools including records, jail, weapon seizure and fines.

#### modules/profiler.lua
Runs server/client profiling and relays results via events.

#### modules/radio.lua
Radio group management, enabling join/leave and state sync with clients.

#### modules/shop.lua
Generic item shop framework handling purchase menus and item definitions.

#### modules/skinshop.lua
Skin customization shop applying clothing variations.

#### modules/survival.lua
Server survival mechanics maintaining vitals, coma state and related events.

#### modules/transformer.lua
Generic item transformation system converting reagents into products over time.

#### modules/veh_blacklist.lua
Sends blacklisted vehicle models to clients and enforces restrictions.

#### modules/warp.lua
Server side of warp system defining points and validating teleport actions.

### Configuration Files
Each file in `cfg/` configures associated modules or systems.

- base.lua: global settings such as database driver and save intervals.
- modules.lua: toggles available extensions.
- groups.lua: permission groups and abilities.
- aptitudes.lua, atms.lua, audio.lua, business.lua, cloakrooms.lua, edibles.lua, garages.lua, hidden_transformers.lua, homes.lua, identity.lua, inventory.lua, items.lua, login.lua, map.lua, mission.lua, money.lua, ped_blacklist.lua, phone.lua, player_state.lua, police.lua, radio.lua, shops.lua, skinshops.lua, survival.lua, transformers.lua, veh_blacklist.lua, warps.lua: module-specific configurations.
- gui.lua and client.lua: client behaviour and control mapping.
- home_components.lua, home components definitions.
- sanitizes.lua: string sanitation patterns.
- lang/*.lua: language translations for prompts and menus.

### GUI (NUI) Files
- index.html: root NUI page embedding dynamic JS components.
- design.css: styling for in-game menus and prompts.
- main.js, dynamic_classes.js, Menu.js, WPrompt.js, Div.js, ProgressBar.js, RequestManager.js, RadioDisplay.js, AnnounceManager.js, AudioEngine.js, countdown.js: JavaScript controllers for menus, prompts, announcements, audio and radio displays.
- images/, sounds/, lib/ (including libopus.wasm.js): assets required by the GUI.

### Library Files
Shared utilities used by both client and server.
- ActionDelay.lua: throttling utility preventing rapid repeated actions.
- EventDispatcher.lua: event dispatch system supporting vRP extension events.
- IDManager.lua: identifier allocator releasing ids when unused.
- Luang.lua: lightweight localisation framework loading language tables.
- Proxy.lua: inter-resource interface and RPC support via events.
- Tunnel.lua: bidirectional RPC layer between client and server using events.
- htmlEntities.lua: HTML entity escaping helpers.
- utils.lua: assorted utilities including profiling helpers and version checks.
- ELProfiler.lua: profiler implementation used by the Profiler module.
- Luaoop.lua: object-oriented programming helper.

## Cross-Indexes
### Events
| Event | Type | Handlers |
| --- | --- | --- |
| playerSpawned | client event | client/base.lua forwards spawn to server. |
| vRPcli:playerSpawned | server event | base.lua calls `onPlayerSpawned`. |
| vRPcli:playerDied | server event | base.lua calls `onPlayerDied`. |
| playerDropped | server event | base.lua cleans up user data. |
| playerConnecting | server raw event | login.lua performs authentication and whitelist checks. |
| vRP:profile | network event | utils.lua registers; profiler.lua triggers to start profiling. |
| vRP:profile:res | network event | profiler.lua handles profiling results. |
| playerSpawn | local event | handled by many modules: ATM, Audio, Business, Cloak, GUI, Garage, Group, HiddenTransformer, Home, Identity, Inventory, Map, Money, PedBlacklist, PlayerState, Police, Radio, Shop, SkinShop, Survival, Transformer, VehBlacklist, Warp. |
| playerDeath | local event | Money, PlayerState, Survival, Phone, Inventory, Home modules respond. |
| characterLoad | local event | Aptitude, Garage, Group, Home, Identity, Inventory, Money, Phone, PlayerState, Police, Survival modules load character data. |
| characterUnload | local event | Garage, GUI, Home, PlayerState modules save or cleanup. |
| playerLeave | local event | GUI, Home, Map, Police modules handle disconnect. |
| playerMoneyUpdate | local event | Money module notifies of balance changes. |
| playerStateLoaded | local event | Garage prepares owned vehicles. |
| playerMissionStart/Step/Stop | local event | Mission module tracks mission progress. |
| playerVitalChange/Overflow | local event | Survival module tracks vitals. |
| playerLeaveGroup/playerJoinGroup | local event | Radio updates membership. |
| characterIdentityUpdate | local event | Identity propagates new identity info. |
| save | local event | Garage persists vehicle state periodically. |
| playerJoin | local event | Login initialises user record after join. |

### NUI Callbacks
| Callback | File | Purpose |
| --- | --- | --- |
| audio | client/audio.lua | Relays voice channel speaking and transmitting state. |
| menu | client/gui.lua | Fires when a NUI menu option is selected or confirmed. |
| prompt | client/gui.lua | Handles closing of text prompts. |
| request | client/gui.lua | Receives accept/decline for server requests. |
| init | client/gui.lua | Signals NUI ready state. |

### DB Usage
`vRP.lua` defines a pluggable database driver system with `prepare` and `query` helpers. Modules use `vRP:execute` and related functions to persist data through whichever driver is configured.

## Configuration & Integration Points
- `fxmanifest.lua`/`__resource.lua` integrate the resource into FiveM.
- `cfg/base.lua` selects database drivers and logging options.
- `cfg/modules.lua` toggles which modules load, enabling custom server compositions.
- `voip_server` scripts integrate with external Node.js process for positional voice.

## Gaps & Inferences
- Module event behaviours are inferred from naming and limited inspection. (Inference: Medium)
- Database queries are abstracted; specific schema interactions depend on configured driver. (Inference: Low)
- NUI assets include large third-party libraries such as `libopus.wasm.js`; detailed behaviour inferred from context. (Inference: Low)

## Conclusion
vRP organises gameplay features into modular extensions backed by a robust event and RPC framework. Client scripts manage UI and game-side interactions, while server modules maintain persistent state, permissions and gameplay logic. Configuration files tailor the environment, and the included NUI and VoIP assets provide immersive interfaces.

DOCS COMPLETE
