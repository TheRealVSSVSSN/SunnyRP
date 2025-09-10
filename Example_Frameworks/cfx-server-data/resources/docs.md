# Resource Documentation (Formatted)

This document consolidates the provided documentation for multiple resources into a single, cleanly formatted Markdown file. **All `agents.md` parts and references have been intentionally omitted**, as requested. Everything else is preserved and formatted.

---

## Table of Contents

- [fivem-map-hipster](#fivem-map-hipster)
- [fivem-map-skater](#fivem-map-skater)
- [redm-map-one](#redm-map-one)
- [basic-gamemode](#basic-gamemode)
- [money](#money)
- [money-fountain](#money-fountain)
- [money-fountain-example-map](#money-fountain-example-map)
- [ped-money-drops](#ped-money-drops)
- [chat](#chat)
- [chat-theme-gtao](#chat-theme-gtao)
- [player-data](#player-data)
- [playernames](#playernames)
- [mapmanager](#mapmanager)
- [spawnmanager](#spawnmanager)
- [webpack](#webpack)
- [yarn](#yarn)
- [baseevents](#baseevents)
- [hardcap](#hardcap)
- [rconlog](#rconlog)
- [runcode](#runcode)
- [sessionmanager](#sessionmanager)
- [sessionmanager-rdr3](#sessionmanager-rdr3)
- [example-loadscreen](#example-loadscreen)
- [fivem](#fivem)

---

## fivem-map-hipster

**Overview**  
Map resource that supplies hipster-themed spawn points and a single vehicle generator for the basic-gamemode example. It defines only server-side configuration—no client scripts—so all gameplay logic is handled by FiveM’s map manager and spawn manager.

### Table of Contents
- fxmanifest.lua
- map.lua

### fxmanifest.lua — Shared manifest
- **Metadata:** Version 1.0.0, author Cfx.re, and a short description (“Example spawn points for FiveM with a ‘hipster’ model”).
- **Resource type:** Registers as a map and restricts usage to the basic-gamemode, ensuring the map manager loads this resource only when that gametype runs.
- **Map entry:** Points to `map.lua`, which supplies spawn data and a vehicle generator.
- **Compatibility:** Targets the adamant FX build for GTA V, enabling modern natives and data files.

### map.lua — Server-side map configuration

**Vehicle Generator**  
- Declares a single `vehicle_generator` for an airtug at `(-54.27, -1679.55, 28.44)` with a heading of about `228°`.
- The map manager creates and maintains this vehicle, respawning it if removed so players always have access.

**Player Spawn Points**  
- Enumerates numerous `spawnpoint` directives for `a_m_y_hipster_01` and `a_m_y_hipster_02` models.
- Each entry specifies exact world coordinates across Los Santos and Blaine County, providing varied spawn locations:
  - Urban positions (e.g., Vinewood, downtown, industrial zones)
  - Rural and wilderness areas (mountains, countryside, shoreline)
- When a player spawns or respawns, the spawn manager selects a point matching the player’s ped model and places them at the defined coordinates. The list alternates between the two hipster variants to evenly distribute spawn opportunities.
- No additional events or functions are defined; the script simply supplies static configuration that the server’s map and spawn managers interpret.

### Conclusion
`fxmanifest.lua` registers this resource as a map for the basic gamemode and links to `map.lua`. The map script defines one airtug vehicle generator and a wide array of hipster-model spawn points. Together, they form a minimal example of providing player and vehicle placement data for FiveM without any client-side logic.

---

## fivem-map-skater

**Overview**  
Hipster-themed map resource for basic-gamemode that defines numerous skater-model spawn points across San Andreas. There is no client logic or vehicle spawning; the server simply loads the spawn definitions, while shared metadata registers the resource.

**Runtime Context**  
- Client: none  
- Server: `map.lua`  
- Shared/Meta: `fxmanifest.lua`  

### Table of Contents
- fxmanifest.lua
- map.lua
- Conclusion

### fxmanifest.lua
- Shared manifest that registers the resource with the FiveM runtime.
- **Metadata:** Declares version 1.0.0, author details, a skater-model description, and the repository link.
- **Resource Type:** Marks this resource as a map and restricts it to the basic-gamemode game type so the map manager only loads it when that gamemode is active.
- **Map Entry:** Points to `map.lua`, which contains all spawn definitions.
- **Compatibility:** Targets the adamant build for GTA V, ensuring access to modern natives.
- **Role:** Shared/Meta

### map.lua
- Server-side configuration interpreted by the spawn manager.

**Player Spawn Points**  
- Contains 60 `spawnpoint` directives that alternate between `a_m_y_skater_01` and `a_m_y_skater_02` ped models, each with precise world coordinates.
- Example entries show the pattern and coverage across urban centers, countryside, and mountain regions, giving players varied starting locations.
- The spawn manager selects a spawnpoint matching the player’s model when they join or respawn, placing them at the specified coordinates.
- No vehicle generators or additional scripting are defined; the file purely supplies static spawn data.
- **Role:** Server

### Conclusion
`fxmanifest.lua` registers the resource and ties it to `map.lua`, which enumerates extensive skater-themed spawn points. With no client scripts or extra gameplay logic, the resource serves as a straightforward example of providing spawn data for a custom FiveM gamemode.

---

## redm-map-one

**Overview**  
Example RedM map resource that supplies two static spawn locations for basic-gamemode. There is no client logic; the server loads a map script that defines spawn points for different player archetypes.

**Runtime Context**  
- Client: none  
- Server: `map.lua`  
- Shared/Meta: `fxmanifest.lua`  

### Table of Contents
- fxmanifest.lua
- map.lua
- Conclusion

### fxmanifest.lua
- Shared manifest that registers the map with the RedM runtime.
- **Metadata:** Declares version 1.0.0, author information, a brief description, and the Git repository link.
- **Resource Type:** Marks this resource as a map, restricted to the basic-gamemode. The map manager loads it only when that gametype is active.
- **Map Entry:** Points to `map.lua`, which contains the spawn definitions.
- **Compatibility:** Targets the adamant build for the RedM (`rdr3`) game. Includes a `rdr3_warning` acknowledging prerelease status.
- **Role:** Shared/Meta

### map.lua
- Server-side configuration interpreted by the spawn manager.

**Player Spawn Points**  
- Defines two `spawnpoint` directives, each paired with a specific player archetype:
  - `player_three` – Position `(-262.849, 793.404, 118.087)`
  - `player_zero` – Same coordinates as above.
- At runtime, the spawn manager checks the player’s archetype (e.g., `player_three`) and places them at the matching spawn point.
- No other directives (vehicles, etc.) are included; the file strictly supplies spawn data.
- The map manager handles the actual spawn event, cycling through or selecting a defined spawn point when a player joins or respawns.
- **Role:** Server

### Conclusion
`fxmanifest.lua` registers this resource as a map for RedM’s basic gamemode and ties it to `map.lua`. The map script enumerates two spawn points for different player archetypes, providing minimal but functional configuration to place players in the world.

---

## basic-gamemode

**Overview**  
Minimal freeroam gametype that relies entirely on the spawnmanager resource for player spawning. Contains a single client script that activates automatic respawn when a map loads. No server logic or extra client features are included.

**Runtime Context**  
- Client: `basic_client.lua`  
- Server: none  
- Shared/Meta: `fxmanifest.lua`  

### Table of Contents
- fxmanifest.lua
- basic_client.lua
- Conclusion

### fxmanifest.lua
- Shared manifest that registers the resource as a gametype.
- **Metadata:** Declares version 1.0.0, author, description (“basic freeroam gametype using default spawn logic”), and repository link.
- **Resource Type:** Marks this resource as a gametype named “Freeroam”.
- **Client Script:** Loads `basic_client.lua`; no server scripts are defined.
- **Compatibility:** Targets the adamant FX build for the common (GTA V/RedM) game set.
- **Role:** Shared/Meta

### basic_client.lua
- Client script that activates spawn behavior when a map loads.

**Event: `onClientMapStart`**  
- Triggered once the client finishes loading a map.
- Calls `exports.spawnmanager:setAutoSpawn(true)` to enable automatic respawns whenever the player dies or leaves the game world.
- Immediately invokes `exports.spawnmanager:forceRespawn()` to place the player at a spawn point as soon as the map starts.
- These functions come from the `spawnmanager` resource and handle all player positioning; this script simply enables and triggers them.
- **Role:** Client

### Conclusion
`fxmanifest.lua` declares the resource as a freeroam gametype and references `basic_client.lua`, which activates automatic spawning via the `spawnmanager`. With no server scripts or extra client logic, this resource serves as a minimal example gamemode that relies on existing spawn functionality.

---

## money

**Overview**  
Example gameplay resource that implements a lightweight money system using Cfx key-value pairs (KVP). It tracks each player’s cash and bank balances, exposes server exports for modifying these amounts, and synchronizes the resulting values to the client’s HUD.

**Runtime Context**  
- Client: `client.lua`  
- Server: `server.lua`  
- Shared/Meta: `fxmanifest.lua`  

### Table of Contents
- fxmanifest.lua
- client.lua
- server.lua
- Conclusion

### fxmanifest.lua
- Shared manifest that registers the resource with FiveM.
- **Metadata:** Version (1.0.0), author (“Cfx.re”), a brief description, and repository link.
- **Runtime Target:** Uses the bodacious build of GTA V, enabling Lua 5.4 features (`lua54 'yes'`).
- **Scripts:** Declares `client.lua` and `server.lua` as the client and server entry points.
- **Optional Dependency:** A commented dependency `'cfx.re/playerData.v1alpha1'` hints at using the `playerData` resource for identifier handling.
- By loading both scripts, it stitches the client and server halves into a functional money system.
- **Role:** Shared/Meta

### client.lua
- Client script that updates HUD cash/bank values and lets players temporarily display their balances.

**Constants**  
- `moneyTypes`: Maps logical names (cash, bank) to GTA stat identifiers used by the HUD.

**Event: `money:displayUpdate`**  
- When the server broadcasts new balances, this handler looks up the correct stat ID.
- Rounds the amount down (to avoid fractions) and writes the result to the stat, causing the HUD to reflect the new total.

**Initialization**  
- Immediately after loading, the client sends `money:requestDisplay` to ask the server for current balances.

**Input Loop**  
- Runs continuously, checking for control `20` (default key: `Z`).
- When pressed:
  - Calls `SetMultiplayerBankCash()` and `SetMultiplayerWalletCash()` to show bank and wallet amounts on screen.
  - Waits roughly `4.35 s`.
  - Calls the corresponding `RemoveMultiplayer*` functions to hide the HUD again.
- This provides an on-demand display of the player’s finances without permanently occupying HUD space.
- **Role:** Client

### server.lua
- Server-side logic that persists money, exposes an API, and synchronizes HUD updates.

**Dependencies and Setup**  
- Imports playerData helpers from `cfx.re/playerData.v1alpha1` to translate between player indices and stable database IDs.
- Defines `validMoneyTypes` (currently cash and bank) to validate operations.

**Internal Helpers**  
- `getMoneyForId(playerId, moneyType)`: Reads the KVP entry for the specified player and type, returning the stored amount (converted from integer cents to float dollars).
- `setMoneyForId(playerId, moneyType, money)`: Persists a new balance, triggers a `money:updated` event, and stores the value as integer cents to avoid floating-point drift.
- `addMoneyForId(playerId, moneyType, amount)`: Adds a signed amount to the balance, rejecting the update if it would drop below zero.

**Exported API**  
- `addMoney(playerIdx, moneyType, amount)`: Validates inputs, resolves the player’s ID, and calls `addMoneyForId`. On success, updates the player’s state bag (`money_cash` or `money_bank`).
- `removeMoney(playerIdx, moneyType, amount)`: Mirrors `addMoney` but subtracts funds, returning false if insufficient balance.
- `getMoney(playerIdx, moneyType)`: Returns the current balance for inspection by other resources.

**HUD Synchronization**  
- Event `money:updated` is fired whenever `setMoneyForId` commits a change. If the update includes a valid player source, the server forwards the new amount to that client via `money:displayUpdate`.
- Event `money:requestDisplay` responds to client initialization by sending the latest cash and bank amounts and syncing them to the player’s state bag.

**Administrative Commands**  
- `/earn <type> <amount>`: Uses `addMoney` to grant funds. Restricted to administrators.
- `/spend <type> <amount>`: Attempts to remove funds; prints a warning if the player lacks sufficient balance.
- **Role:** Server

### Conclusion
`fxmanifest.lua` ties the resource together and targets the correct runtime. `client.lua` updates HUD stats and provides a toggle to show or hide balances. `server.lua` stores money amounts in KVP, exports functions for other scripts, synchronizes updates to clients, and offers simple admin testing commands. Combined, they form a self-contained example of a persistent money system that other resources can interact with.

---

## money-fountain

**Overview**  
Interactive gameplay example where players can deposit or withdraw cash from marked “money fountain” locations. The resource reads fountain positions from map directives, synchronizes balances across clients via shared state, and enforces per‑player cooldowns on the server.

### Table of Contents
- fxmanifest.lua
- mapdata.lua
- client.lua
- server.lua
- Conclusion

### fxmanifest.lua
- Shared manifest that registers the resource with the Cfx runtime.
- **Metadata & Target:** Declares version, description, repository link, and author. Sets **bodacious** as the FX build for GTA V and enables Lua 5.4.
- **Scripts:** Loads `client.lua`, `server.lua`, and shared `mapdata.lua`.
- **Dependencies:** Requires `mapmanager` (for map directives) and `money` (currency system).
- **Role:** Shared/Meta

### mapdata.lua
- Shared registry that allows maps to define fountain locations.
- **Data Structures:** Initializes a global `moneyFountains` table and maintains an incremental `fountainIdx` for tracking entries.
- **Map Directive:** Registers a `money_fountain` directive. When a map calls this directive, it stores the fountain’s ID, coordinates, and per‑use cash amount (default 100) in `moneyFountains`, then remembers the index for removal on unload.
- **Role:** Shared

### client.lua
- Client-side script that renders fountains and handles player interaction.
- **Help Texts:** Defines several `AddTextEntry` messages for different fountain/player states (normal, drained, broke, cooldown).
- **Polling Thread:** A `CreateThread` loop adjusts its wait time based on proximity to fountains, draws markers when within 40 units, and checks for use when within 1 unit.
- **Cooldown & Input:** If the player’s `fountain_nextUse` state is still active, displays a cooldown message. Otherwise listens for `INPUT_PICKUP` to withdraw cash and `INPUT_DETONATE` to deposit, triggering the respective server events and debouncing key presses.
- **Help Message Logic:** Chooses among the four help prompts depending on whether the player has enough cash and whether the fountain holds sufficient funds, then displays the selected text with current amounts.
- **Role:** Client

### server.lua
- Server-side logic that validates fountain usage and maintains balances.

**Utility Functions**  
- `getMoneyForId` / `setMoneyForId` – Read/write fountain balances in KVP and mirror them to `GlobalState` for client visibility.  
- `getMoneyFountain` – Locates a fountain by ID and verifies the requesting player is within 2.5 units.

**Core Handler**  
- `handleFountainStuff(source, id, pickup)` – Common routine for both deposit and withdrawal:
  - Confirms proximity and per-player cooldown.
  - Retrieves fountain balance.
  - If withdrawing (`pickup=true`), ensures the fountain has enough money and credits the player via `ms:addMoney`; if depositing, removes cash using `ms:removeMoney`.
  - Persists the new balance and sets `fountain_nextUse` to the configured cooldown.

**Events & State**  
- `money_fountain:tryPickup` / `money_fountain:tryPlace` – Receive client requests and invoke the handler with withdrawal or deposit semantics.
- Background thread publishes initial balances for newly registered fountains into `GlobalState`, ensuring clients can display amounts immediately.
- **Role:** Server

### Conclusion
`fxmanifest.lua` ties the resource together and declares dependencies. `mapdata.lua` registers a `money_fountain` map directive and maintains fountain definitions. `client.lua` renders fountain markers, guides player interactions, and triggers deposit/withdraw events. `server.lua` validates proximity, enforces cooldowns, updates fountain balances, and integrates with the money resource. Together, these files create a synchronized, map-driven money fountain system.

---

## money-fountain-example-map

**Overview**
Map resource that defines a sample fountain location for the `money-fountain` system. It supplies coordinates and payout using a map directive so the main resource can spawn the fountain and manage its cash reserve.

### Table of Contents
- fxmanifest.lua
- map.lua
- Conclusion

### fxmanifest.lua — Role: Shared / Meta
- Declares version `1.1.0`, author, description, and repository link.
- Targets the **cerulean** FX build for GTA V and enables Lua 5.4.
- Registers `map.lua` and depends on `money-fountain`.

### map.lua — Role: Map
- Sets fountain coordinates at `vec3(97.334, -973.621, 29.36)`.
- Calls `money_fountain 'test_fountain'` with a payout of `amount = 75`.

### Conclusion
`fxmanifest.lua` links the map to the money-fountain system, and `map.lua` declares a single fountain definition with location and payout for testing purposes.

---

## ped-money-drops

**Overview**  
Example gameplay resource that spawns temporary cash pickups whenever a pedestrian dies. The client detects death events and creates pickups; the server validates claims and pays nearby players using the money resource. All logic is contained in a single client script, a single server script, and a shared manifest.

### Table of Contents
- fxmanifest.lua
- client.lua
- server.lua
- Conclusion

### fxmanifest.lua — Role: Shared/Meta
- Declares metadata (version, description, author, repository) and targets the bodacious FX build with Lua 5.4 enabled.
- Registers the resource’s scripts:
  - `client.lua` for client‑side behavior.
  - `server.lua` for server‑side validation.
- No extra dependencies or configuration—this manifest simply binds the two scripts into a usable resource.

### client.lua — Role: Client

**Event: `gameEventTriggered`**  
- Listens for all game events and filters for `CEventNetworkEntityDamage`.
- Extracts the victim and culprit peds plus a flag indicating if the victim died.

**On Ped Death — Spawn pickup**  
- Retrieves the victim’s coordinates.
- Creates a `PICKUP_MONEY_VARIABLE` slightly below the corpse.
- Converts the ped to a network ID for server reference.

**Proximity monitor thread**  
- Repeats every `50 ms`.
- If the player is within `2.5` units and the pickup is collected, triggers `money:tryPickup` and removes the pickup.
- Marks the thread as finished to stop further checks.

**Timeout cleanup**  
- After `15 s`, deletes the pickup if still present and stops the monitor thread.

**Server notification**  
- Sends `money:allowPickupNear` with the ped’s network ID so the server records the pickup’s location.
- This script performs all client duties: spawning the visible pickup, managing local collection logic, and communicating with the server for verification and payout.

### server.lua — Role: Server

**Data Store**  
- `safePositions` table maps ped network IDs to their drop coordinates.

**Event: `money:allowPickupNear`**  
- Receives the ped ID when the client spawns a pickup.
- After a short delay:
  - Validates the entity still exists and is dead.
  - Records its world position in `safePositions`.

**Event: `money:tryPickup`**  
- Fired when a client claims a pickup.
- Ensures the ped ID exists in `safePositions`.
- Checks the player’s distance to the stored coordinates (`< 2.5` units).
- Awards 40 cash via `exports['money']:addMoney`.
- Removes the entry to prevent reuse.

**Cleanup**  
- `entityRemoved` handler clears `safePositions` if a ped disappears before being claimed.
- The server guarantees that only legitimate, nearby players receive cash, preventing spoofed pickup events or long‑distance claims.

### Conclusion
`fxmanifest.lua` wires together a small yet complete resource. `client.lua` handles pickup creation and local detection, while `server.lua` confirms proximity and grants money. Together, they showcase a synchronized client–server workflow for dynamic world drops that integrate with the example money system.

---

## chat

**Overview**  
Browser-based chat system that provides text communication for players. Client scripts render the UI, handle key bindings, and send messages; server scripts route messages, manage modes, and broadcast system events. A TypeScript/Vue NUI bundle supplies the web interface.

### Table of Contents
- README.md
- fxmanifest.lua
- cl_chat.lua
- sv_chat.lua
- package.json
- webpack.config.js
- yarn.lock
- html/
  - index.html
  - index.css
  - tsconfig.json
  - App.ts
  - App.vue
  - Message.ts
  - Message.vue
  - Suggestions.ts
  - Suggestions.vue
  - config.ts
  - index.d.ts
  - main.ts
  - utils.ts
  - vendor/animate.3.5.2.min.css
  - vendor/flexboxgrid.6.3.1.min.css
  - vendor/latofonts.css
  - vendor/fonts/*.woff2

### README.md — Role: Shared
A minimal placeholder identifying the resource. It offers no functional logic but serves as a reference point when browsing the repository.

### fxmanifest.lua — Role: Shared/Meta
- Declares version, author, description, and repository link.
- Sets the NUI page (`dist/ui.html`) and registers client (`cl_chat.lua`) and server (`sv_chat.lua`) scripts.
- Includes vendor CSS and fonts as extra files.
- Targets the “adamant” FX build for GTA V/RedM, enabling compatibility with modern natives.

### cl_chat.lua — Role: Client

**Event Routing**  
- Registers handlers for `chat:addMessage`, `chat:addSuggestion`, `chat:clear`, and `chat:removeSuggestion`, forwarding data to the NUI window.

**NUI Callback: `chatResult`**  
- Receives typed text from the UI.
- If the string starts with `/`, it executes the command locally and sends a confirmation back to the UI.
- Otherwise, triggers `_chat:messageEntered` on the server.

**Command & Theme Refresh**  
- `refreshCommands` builds the suggestion list by scanning registered commands and checking ACE permissions.
- `refreshThemes` searches started resources for `chat_theme` metadata and sends the result to the UI, allowing runtime skinning.

**Lifecycle Hooks**  
- When the resource starts or other resources stop, the script refreshes commands and themes so the UI remains accurate.
- The NUI loaded callback fires `chat:init` to inform the server the client is ready.

**Visibility Management**  
- Implements a `toggleChat` function that cycles hide states and saves the choice in KVP.
- A continuous thread watches the chat key (default `245`), opens the input box, and hides/shows the window based on gameplay context (pause screen, screen fade).

### sv_chat.lua — Role: Server

**Message API**  
- Exposes `addMessage` to push structured messages to players or broadcast to everyone.
- `registerMessageHook` lets other resources intercept or modify messages. Hooks can cancel, rewrite, or redirect delivery.
- `registerMode` allows creation of custom chat channels, optionally requiring security objects to restrict usage.

**Routing Logic**  
- `routeMessage` builds a message object, applies registered hooks, checks channel permissions, and finally dispatches to targets or prints to console.
- Handles `_chat:messageEntered` for player submissions and `__cfx_internal:commandFallback` for unknown commands.

**Join/Leave Notices**  
- Emits automated messages on player connect/disconnect when convars `chat_showJoins` or `chat_showQuits` enable the behavior.

**Initialization & Cleanup**  
- `refreshCommands` gathers ACE-allowed commands per player and sends them to the client.
- `unregisterHooks` removes hooks and modes when resources stop, preventing stale UI data.

**Console Command**  
- Provides a `/say` command usable by players or the server console to broadcast arbitrary text.

### package.json — Role: Build Configuration
Lists dependencies for compiling the NUI front end: Vue, TypeScript, Webpack, loaders, and build scripts. Defines npm/yarn commands for development and production builds.

### webpack.config.js — Role: Build Configuration
Configures Webpack to process TypeScript and Vue files, copy `index.css`, and output `dist/ui.html` plus bundled JavaScript (`chat.js`) for the NUI environment.

### yarn.lock — Role: Dependency Lock
Pins exact versions of all Node.js packages used during builds, ensuring reproducible builds across environments.

### html/ — Client-side NUI code written in TypeScript and Vue.

**html/index.html — Client UI entry point**  
- Loads vendor stylesheets, the compiled CSS, and the bundled `chat.js`. Provides a root `<div id="app">` where Vue mounts the chat interface.

**html/index.css — Client UI styling**  
- Defines chat window layout, color schemes, input box appearance, suggestion list styling, and animation classes. Uses Lato fonts for consistent typography.

**html/tsconfig.json — Client build config**  
- TypeScript compiler options targeting ES6 modules and DOM APIs for all `.ts` and `.vue` files in this directory.

**html/App.ts — Client logic**  
- Implements the root Vue component controlling chat visibility, message history, suggestion data, and active chat mode. Handles input history navigation and dispatches user messages back to Lua via the `chatResult` callback.

**html/App.vue — Client template**  
- HTML structure for the chat window and input box. Uses Vue directives to render messages, suggestion lists, and hide-state indicators.

**html/Message.ts — Client logic**  
- Processes individual message objects: performs template substitution, applies color codes (e.g., `^1` for red), and supports markdown-like toggles for bold, underline, or strike-through.

**html/Message.vue — Client template**  
- Defines how a single message renders inside the chat window, with support for multi-line messages and color spans.

**html/Suggestions.ts — Client logic**  
- Maintains command suggestions, filtering entries based on current input and marking unavailable ones as disabled.

**html/Suggestions.vue — Client template**  
- Displays the filtered suggestion list, showing command names and parameter hints.

**html/config.ts — Client config**  
- Holds static configuration such as default templates, fade timeout, suggestion limit, and base window dimensions.

**html/index.d.ts — Client typings**  
- Allows TypeScript to import `.vue` files by declaring their module shape.

**html/main.ts — Client bootstrap**  
- Entry point that creates a Vue app from `App.vue` and mounts it to `#app`.

**html/utils.ts — Client helpers**  
- Provides a `post` function for sending JSON to Lua callbacks and debug helpers (`emulate`, `demo`) for testing the UI outside FiveM.

**html/vendor/animate.3.5.2.min.css**  
- External animation classes used for message fade-in and UI transitions.

**html/vendor/flexboxgrid.6.3.1.min.css**  
- Grid layout library supplying flexbox utilities for positioning elements.

**html/vendor/latofonts.css**  
- CSS declarations referencing bundled Lato font files.

**html/vendor/fonts/*.woff2**  
- Six WOFF2 font files (LatoBold, LatoBold2, LatoLight, LatoLight2, LatoRegular, LatoRegular2) providing the typefaces used throughout the UI.

### Conclusion
`fxmanifest.lua` stitches together the client and server scripts and points to the NUI bundle. `cl_chat.lua` relays server messages to the browser UI, manages suggestions and visibility, and handles user input. `sv_chat.lua` validates and routes messages, manages chat modes, and broadcasts system events. The `html` directory houses the TypeScript/Vue interface, styled by vendor assets and compiled via Webpack as configured in `package.json` and `webpack.config.js`. Together, these files implement a fully-featured chat system with a customizable UI and extensible server-side API.

---

## chat-theme-gtao

**Overview**  
GTA Online–inspired theme that skins the baseline chat resource. It provides a CSS stylesheet and a JavaScript filter script to mimic GTAO text styling. No server-side logic is included—only client assets and manifest metadata.

### Table of Contents
- fxmanifest.lua
- style.css
- shadow.js
- Conclusion

### fxmanifest.lua — Role: Shared/Meta
- Declares version 1.0.0, author (Cfx.re), description, and repository URL.
- Registers two theme assets: `style.css` and `shadow.js`.
- Defines a `chat_theme` named **gtao**:
  - `styleSheet` → `style.css`
  - `script` → `shadow.js`
  - `msgTemplates` → `<b>{0}</b><span>{1}</span>` (bold speaker name followed by message text).
- Targets the “adamant” FX build and supports both GTA V and RedM.
- No server scripts are listed, confirming that all functionality is client-side.

### style.css — Role: Client
Comprehensive stylesheet that recreates GTA Online chat visuals.

**Layout & Positioning:**  
- Places the chat window along the right side at mid-screen height using viewport-relative custom properties.
- Disables text selection and pointer events on the message list to prevent accidental highlighting.

**Font & Text:**  
- Imports two GTA Online fonts (`Font2` and `Font2_cond`) from external URLs.
- Sets font weights and line heights dynamically to match GTAO’s scaling.

**Message Styling:**  
- `.msg` class displays each message with white text and applies `filter: url(#svgDropShadowFilter)`—the filter defined in `shadow.js`.
- Nested selector `.msg > span > span > b` applies the condensed font to speaker names, removes bold weight, and adds spacing for authenticity.

**Input Box (`.chat-input`):**  
- Anchored bottom-right with semi-transparent black background and subtle outline.
- Contains a `.prefix` element that brackets slash-prefixed commands and dims generic prefix text.
- Suggestion text floats above the input, and `.suggestions` styling mirrors GTAO’s transparent panels.

**Textarea & Suggestions:**  
- Transparent background; text cursor and spacing optimized for clarity.
- `.suggestions` entries inherit the theme colors and overlay just above the input field.

**Ultra-wide Support:**  
- Media queries shift the chat window inward for 21:9 and 32:9 aspect ratios, preventing HUD overlap on wide monitors.

### shadow.js — Role: Client
Sets up SVG filters to render blurred drop shadows behind chat text, mimicking GTA Online’s UI.

**Initialization:**  
- Immediately invoked function expression (IIFE) creates a hidden `<svg>` with `<defs>` containing two filters: `svgBlurFilter` and `svgDropShadowFilter`.
- Appends the SVG to the document, making filters available to CSS.

**Filter Composition:**  
- `svgDropShadowFilter` combines:
  - `feGaussianBlur` on source alpha for softness.
  - `feOffset` to shift the blur diagonally.
  - `feFlood` to apply a black color.
  - Two `feComposite` stages to mask and merge the shadow with the original text.
  - `feMerge` to stack shadow and source.

**Dynamic Scaling:**  
- Calculates a scale factor based on page width.
- Updates blur deviation, offset (`dx`, `dy`), and color attributes to keep the shadow consistent across resolutions.
- Exposes internal filter nodes via a `Filters` object, enabling potential runtime adjustments (though none are invoked here).

**Usage:**  
- The stylesheet references `url(#svgDropShadowFilter)`; whenever an element uses the `.msg` class, this script ensures the filter renders a crisp GTAO-style shadow.

### Conclusion
`fxmanifest.lua` registers the GTAO theme assets for the base chat resource. `style.css` restyles the chat window and input to match GTA Online’s look, while `shadow.js` injects SVG filters that provide the characteristic drop-shadow text. Together, these client-side files offer a plug-and-play theme with no server logic required.

---

## player-data

**Overview**  
Resource that assigns a persistent database ID to every connecting player by indexing their identifiers (Steam, license, etc.) in Key‑Value Pairs (KVP). It exposes the `cfx.re/playerData.v1alpha1` API to other resources so they can query players by identifier or by the assigned ID. All logic is server‑side.

### Table of Contents
- fxmanifest.lua
- server.lua
- Conclusion
- Testing

### fxmanifest.lua — Role: Shared / Meta
- Declares metadata: version 1.0.0, author, description, and repository link.
- Targets the bodacious FX server build and the “common” game set, enabling Lua 5.4 features.
- Registers `server.lua` as the sole script.
- Exposes the spec identifier `cfx.re/playerData.v1alpha1` via the `provides` block so other resources can import its exports.

### server.lua — Role: Server
Server script that assigns and persists player IDs, keeps lookup tables for connected players, and exports query helpers.

**Identifier Handling**  
- `identifierBlocklist` lists low‑trust identifier types (e.g., `ip`) that should not influence ID assignment.
- `isIdentifierBlocked(identifier)` extracts the identifier type and checks against the blocklist.

**Data Schema (KVP)**  
- `player: player:<id>:identifier:<identifier> → "true"`  
- `identifier: identifier:<identifier> → { id = <playerId> }`  
- Maintains two in-memory tables:
  - `players[playerIdx] = { dbId = <id> }`
  - `playersById[dbId] = playerIdx`

**ID Generation**  
- `incrementId()` reads `nextId` from KVP, increments it, stores it back, and returns the new value.

**Lookup & Storage**  
- `getPlayerIdFromIdentifier(identifier)` retrieves a stored ID from `identifier:<identifier>`.
- `setPlayerIdFromIdentifier(identifier, id)` writes both identifier→ID and player→identifier KVP entries.
- `storeIdentifiers(playerIdx, newId)` iterates the player’s identifiers, ignores blocked types, and stores new mappings.

**Player Setup**  
- `registerPlayer(playerIdx)` → allocates a new ID via `incrementId` and stores the player’s identifiers.
- `setupPlayer(playerIdx)` → attempts to find the lowest existing ID across all identifiers; registers a new ID if none are found.
- Sets state bag field `cfx.re/playerData@id` to expose the ID to other scripts.
- Updates `players` and `playersById` caches.

**Lifecycle Events**  
- `playerConnecting` → calls `setupPlayer` early during handshake.
- `playerJoining` → handles potential resource restarts, migrating cached data from the old player index if possible.
- `playerDropped` → removes cache entries when a player disconnects.
- On resource start, loops through `GetPlayers()` to initialize already‑connected clients.

**Debug Command**  
- `/playerData getId <dbId>` → lists all identifiers stored for the given ID.
- `/playerData getIdentifier <identifier>` → prints the player ID associated with the identifier.

**Export Compatibility Helpers**  
- `getExportEventName` and `AddExport` shim the `provides` mechanism for older server builds.

**Exports provided under `cfx.re/playerData.v1alpha1`:**  
- `getPlayerIdFromIdentifier(identifier)`  
- `getPlayerId(playerIdx)` → returns the assigned ID for a given player index.  
- `getPlayerById(dbId)` → returns the current player index associated with the stored ID.

### Conclusion
`fxmanifest.lua` registers the resource and exposes the player-data API. `server.lua` assigns persistent numeric IDs to players, stores identifier mappings in KVP, updates state bags, and offers exports for cross-resource lookups. Together, they provide a lightweight identity system that other scripts can use to reference players reliably.

---

## playernames

**Overview**  
Client–server resource that attaches configurable gamer tags above players’ heads. Both sides share an API that exports functions to adjust tag colors, visibility, alpha, wanted level and the underlying name template. Clients render the tags; the server manages template updates and re‑broadcasts saved settings.

### Table of Contents
- fxmanifest.lua
- playernames_api.lua
- playernames_cl.lua
- playernames_sv.lua
- template/LICENSE
- template/template.lua
- Conclusion

### fxmanifest.lua — Role: Shared / Meta
- Registers a shared API script and the distinct client/server logic scripts so both sides can access common functions.
- Exports six customization helpers (`setComponentColor`, `setComponentAlpha`, `setComponentVisibility`, `setWantedLevel`, `setHealthBarColor`, `setNameTemplate`) for external resources.
- Packages the third‑party template engine located in `template/template.lua` for runtime loading.

### playernames_api.lua — Role: Shared

**Configuration Dispatch**  
- `getTriggerFunction(key)` builds wrapper functions that either fire `playernames:configure` locally (client) or broadcast and record the setting (server).
- `reconfigure(source)` replays all stored settings to a newly connected client so their tags match existing players.
- Exposes helpers such as `setComponentColor`, `setComponentAlpha`, `setComponentVisibility`, `setWantedLevel`, `setHealthBarColor`, `setNameTemplate`, and `setName`, each created through the wrapper above.

**Name Tag Formatting**  
- Loads a Lua template engine and renders name tags through `formatPlayerNameTag(i, templateStr)`:
  - Temporarily overrides `template.print` to collect output.
  - Builds a context containing the player’s name, server ID, and any data injected via `playernames:extendContext`.
  - Invokes `template.render` to produce a final string.

### playernames_cl.lua — Role: Client

**Local State**  
- Keeps per‑player gamer tag handles and settings tables that store color, alpha, toggles, wanted level, and health bar color overrides.

**Tag Rendering Loop**  
- `updatePlayerNames()` runs every frame:
  - Ignores processing until a template is supplied.
  - Iterates over all active players, creating or refreshing a `CreateMpGamerTag` if missing.
  - Shows tags only when nearby and in line of sight, while applying stored overrides (visibility, alpha, color, wanted level, health bar color).
  - Removes tags for players that no longer exist.

**Network Configuration**  
- `playernames:configure` applies incoming changes: toggles, alphas, colors, wanted level, health bar color, server-sent names, and template string; setting a new template marks all tags for rename.
- `playernames:extendContext` enriches the rendering context with the server-provided name for template use.

**Lifecycle**  
- On resource stop, removes any remaining gamer tags to avoid leaks.
- On startup, notifies the server via `playernames:init` and schedules the render loop.

### playernames_sv.lua — Role: Server

**Template & Tag Updates**  
- `detectUpdates()` runs every `500 ms`:
  - Checks `playerNames_template` convar for client tag layout; if it changes, broadcasts the new template using `setNameTemplate`.
  - Checks `playerNames_svTemplate` for server-only name overrides and pushes updated names via `setName`.
  - Purges tag cache entries for players that have left.

**Player Management**  
- On `playerDropped`, removes the player from active tracking tables.
- On `playernames:init`, replays any stored configuration (`reconfigure`) and flags the player as active.

### template/LICENSE — Role: Shared / Legal
BSD‑style license granting redistribution rights for the embedded template library and disclaiming warranties.

### template/template.lua — Role: Shared / Utility
Self-contained Lua templating engine used to render name tags. Defines HTML/CODE entity tables, file loading helpers, and a `template.render` function that compiles and executes templates with a provided context.

### Conclusion
The `playernames` resource combines a shared API, client-side rendering loop, and server-side template management to display dynamic gamer tags over players. Exports allow other resources to adjust individual tag components or change the tag format entirely. A bundled template engine enables flexible string interpolation, while the server keeps tag settings in sync across reconnects.

---

## mapmanager

**Overview**  
Flexible manager that maps game types to maps, loads map files for both clients and server, and exposes APIs for starting and switching maps or gametypes.

### Table of Contents
- fxmanifest.lua
- mapmanager_shared.lua
- mapmanager_client.lua
- mapmanager_server.lua
- Conclusion
- Testing

### fxmanifest.lua — Role: Shared/Meta
- Declares version, author, description and repository for the resource.
- Registers shared and role-specific scripts:
  - **Client:** `mapmanager_shared.lua`, `mapmanager_client.lua`
  - **Server:** `mapmanager_shared.lua`, `mapmanager_server.lua`
- Targets the adamant build for both GTA V and RedM, and exports management helpers (`getCurrentGameType`, `changeMap`, etc.) for other resources to call.

### mapmanager_shared.lua — Role: Shared
Central library that parses map files and tracks undo callbacks for both client and server.
- `addMap(file, owningResource)` — registers a map file under its resource so it can be parsed later.
- `loadMap(res)` — iterates the registered map files for a resource and parses each one.
- `unloadMap(res)` — runs stored undo callbacks and clears registrations when a map resource stops.
- `parseMap(file, owningResource)` — builds a sandboxed environment, exposes map directives from `getMapDirectives`, ignores unknown directives via a metatable, loads the map file with `load`, executes it, and pushes undo handlers to `undoCallbacks`.

### mapmanager_client.lua — Role: Client
Handles client-side metadata parsing, map loading, and local map directives.
- On each resource start, scans metadata for map entries and registers them; reads `resource_type` to catalog maps vs. gametypes; then loads the map and fires either `onClientMapStart` or `onClientGameTypeStart` after a short delay.
- On resource stop, triggers the corresponding stop events and unloads any maps registered by that resource.
- Registers a `vehicle_generator` directive for map files: loads the model, creates a `CreateScriptVehicleGenerator`, keeps the handle in state for cleanup, and removes the generator when the map unloads.

### mapmanager_server.lua — Role: Server
Supervises maps and gametypes, orchestrates resource startup/stop, and exposes control APIs.
- `refreshResources()` scans all resources for metadata, recording those tagged as maps or gametypes that support the current game build.
- Responds to list refreshes by rerunning `refreshResources`.
- `onResourceStarting` parses map metadata to register map files; if a new map or gametype conflicts with the active one, it swaps maps or gametypes accordingly, preventing duplicates.
- `handleRoundEnd` selects a random map compatible with the current gametype; exposed via the `mapmanager:roundEnded` event and the `roundEnded` export.
- `onResourceStop` cleans up when the active map or gametype resource stops, shutting down the other side and unloading map data.
- **Exports:**
  - Query: `getCurrentGameType`, `getCurrentMap`, `getMaps`
  - Actions: `changeGameType`, `changeMap`, `doesMapSupportGameType`

### Conclusion
`mapmanager_shared.lua` supplies the map-parsing core. `mapmanager_client.lua` consumes metadata to load maps and directives on each client. `mapmanager_server.lua` maintains authoritative state—scanning resources, swapping maps/gametypes, reacting to round ends, and offering server exports. Together, these files provide a unified system for managing map cycles and game modes across both GTA V and RedM servers.

---

## spawnmanager

**Overview**  
Client-side manager that provides a unified API for adding spawn points and automatically respawning players. It integrates with mapmanager via directives, exposes convenience exports, and handles all local spawn logic.

### Table of Contents
- fxmanifest.lua
- spawnmanager.lua
- Conclusion
- Testing

### fxmanifest.lua — Role: Shared / Meta
- Declares version, author, description, and repository for the resource.
- Registers `spawnmanager.lua` as the sole client script, targeting the adamant build for both GTA V and RedM.

### spawnmanager.lua — Role: Client

**Map Directive Integration**  
- Listens for `getMapDirectives` to register a `spawnpoint` directive that adds or removes spawn locations defined by map scripts. Positions and models are validated and stored in memory.

**Spawn Data Loading**  
- `loadSpawns(spawnString)` decodes JSON, expects a `spawns` array, and adds each entry via `addSpawnPoint`.

**Spawn Point Management**  
- `addSpawnPoint(spawn)` validates coordinates, heading, and model, hashes model names, assigns an index, and stores the entry in `spawnPoints`.
- `removeSpawnPoint(id)` deletes a previously added spawn by index.

**Auto-Spawn Control**  
- `setAutoSpawn(enabled)` toggles automatic respawning, while `setAutoSpawnCallback(cb)` registers a custom function to run instead of the default spawn logic.

**Utility Functions**  
- `freezePlayer(id, freeze)` temporarily locks or unlocks player control, visibility, and collision during spawn transitions.
- `loadScene(x, y, z)` preloads world collisions at the target spawn location if supported by the game build.

**Core Spawning**  
- `spawnPlayer(spawnIdx?, cb?)` selects a spawn (random if none provided), handles screen fades, sets player model and position, clears weapons and wanted level, loads collisions, and finally unfreezes the player and triggers `playerSpawned`.

**Automatic Respawn Thread**  
- Background thread monitors player death; when auto-spawn is enabled and the player has been dead for two seconds (or `forceRespawn` was called), it either invokes the custom callback or `spawnPlayer`.

**Manual Respawn & Exports**  
- `forceRespawn()` unlocks spawning and flags a forced respawn on the next loop iteration.
- **Exports:** `spawnPlayer`, `addSpawnPoint`, `removeSpawnPoint`, `loadSpawns`, `setAutoSpawn`, `setAutoSpawnCallback`, and `forceRespawn` for use by other resources.

### Conclusion
`spawnmanager.lua` supplies the full spawning workflow—adding spawn points, freezing/unfreezing players, handling models, and auto-respawning after death. `fxmanifest.lua` registers the script for client use across GTA V and RedM. Together they provide a centralized spawning solution other resources can leverage via exported functions and map directives.

---

## webpack

**Overview**  
Build helper that compiles resource assets with webpack when a resource is started or refreshed. Scripts run server-side to detect changes, spawn webpack workers, and cache build state for faster rebuilds. Meta files describe dependencies and package configuration.

### Table of Contents
- .gitignore
- fxmanifest.lua
- package.json
- webpack_builder.js
- webpack_runner.js
- yarn.lock
- Conclusion

### .gitignore — Role: Shared / Meta
Lists build artifacts that should not be tracked in version control:
- `.yarn.installed` – marker created when Yarn finishes installing dependencies
- `node_modules/` – third-party packages installed locally for webpack builds

### fxmanifest.lua — Role: Shared / Meta
- Declares metadata (version, author, description, repository link) for the webpack builder resource.
- Declares a dependency on `yarn`, ensuring Node modules are available before builds run.
- Registers `webpack_builder.js` as a server script, since build tasks run in the server runtime.
- Targets the adamant FX build and the common game set, making the builder usable across GTA V and RedM.

### package.json — Role: Shared / Configuration
Defines the Node package used to drive builds:
- Specifies module name (`webpack-builder`), version (`1.0.1`), and a placeholder main file.
- Lists runtime dependencies:
  - `async` – utility helpers for coordinating asynchronous tasks
  - `webpack` – compiler used to bundle client resources
  - `worker-farm` – spawns child processes to run webpack in parallel without blocking the main thread
- Includes a stub test script for completeness.
- This configuration ensures the resource can install and run the JavaScript modules needed to compile assets.

### webpack_builder.js — Role: Server
Server-side build task factory that orchestrates webpack compilation for any resource specifying `webpack_config` metadata.

**Key Components**  
- **State Variables:** `buildingInProgress` and `currentBuildingModule` prevent concurrent builds and provide status logging.
- **Custom Stack Trace Reset:** Temporarily removes `Error.prepareStackTrace` to avoid conflicts with certain modules.

**shouldBuild(resourceName)**  
- Iterates `webpack_config` metadata entries for the given resource.
- For each config file:
  - Loads a JSON cache (`cache/<resource>/<config>.json`) that records file stats from the last build.
  - Rebuilds if cache is absent or if any file’s metadata (mtime, size, inode) has changed.
- Returns `true` if any config needs rebuilding, `false` otherwise.

**build(resourceName, cb)**  
- Collects all `webpack_config` entries and resolves their absolute paths.
- Ensures cache directories exist for storing file stat snapshots.
- For each config:
  - Requires the configuration module.
  - Spawns a worker process (`worker-farm`) running `webpack_runner.js`.
  - Serializes builds if another module is currently building, logging wait messages.
  - Pushes each worker invocation onto a promise array for aggregated error handling.
- After all promises resolve:
  - Resets build state.
  - Invokes the callback with success or error information.

**sleep(ms)**  
- Convenience helper used while waiting for other builds to complete.

**Factory Registration**  
- `RegisterResourceBuildTaskFactory('z_webpack', …)` exposes the build task to the resource loader so any resource can specify `build_task 'z_webpack'` in its manifest.

### webpack_runner.js — Role: Server (Worker Process)
Worker module invoked by `worker-farm` to run webpack for a single configuration.

**Components**  
- `getStat(path)` – Reads file metadata (mtime, size, inode) for cache comparison.

**SaveStatePlugin**  
- Custom webpack plugin:
  - During `afterCompile`, records metadata for every file in the compilation.
  - During `done`, writes the collected metadata array to the provided cache file, enabling `shouldBuild` to detect future changes.

**Exported Function**  
- Loads the target webpack config and adjusts:
  - `context` to the resource’s root path.
  - `output.path` to an absolute path inside the resource (if defined).
- Injects `SaveStatePlugin` into the config’s plugin array.
- Runs webpack:
  - On fatal errors: returns the error via callback.
  - On compilation errors: returns a JSON representation of webpack’s error list.
  - On success: returns an empty object.
- Writes the cache file before completing to record the state of all compiled files.
- This worker isolates builds from the main server thread and produces cache metadata for incremental rebuilds.

### yarn.lock — Role: Shared / Dependency Lock
Records exact versions and integrity hashes for all Node dependencies listed in `package.json`. Ensures reproducible installations across environments and prevents accidental version drift.

### Conclusion
The webpack builder resource provides server-side logic for compiling other resources with webpack. The manifest registers a build task that, when triggered, uses `webpack_builder.js` to check file caches, serialize builds, and spawn `webpack_runner.js` workers. `webpack_runner.js` executes webpack with a custom plugin to capture file metadata and store it in cache files, enabling incremental builds. Support files (`package.json`, `yarn.lock`, `.gitignore`) define dependencies and exclude local artifacts. Together, these files form a self-contained build system that seamlessly integrates webpack asset bundling into the Cfx.re runtime.

---

## yarn

**Overview**  
Server-side builder resource that automatically runs Yarn to install Node.js dependencies when other resources start or refresh. It registers a build task named `yarn`, spawns a bundled Yarn CLI in a child process, and marks completed installations to skip redundant work.

### Table of Contents
- fxmanifest.lua
- yarn_builder.js
- yarn_cli.js
- Conclusion
- Testing

### fxmanifest.lua — Role: Shared / Meta
- Declares version, author, description, and repository link for the builder resource.
- Targets the adamant FX build and the common game set so the builder works across all platforms.
- Registers `yarn_builder.js` as a server script, exposing the build task to the runtime.

### yarn_builder.js — Role: Server
Server-side build-task factory that ensures Yarn dependencies are installed once per resource and serializes multiple build requests.

**State & Utilities**  
- `buildingInProgress` / `currentBuildingModule` track whether another resource is currently installing dependencies.
- `trimOutput(data)` prefixes subprocess output with `[yarn]` for consistent logging.

**shouldBuild(resourceName)**  
- Checks for a `package.json` in the resource and compares its modification time to a `.yarn.installed` marker.
- If the marker is missing or older than `package.json`, returns `true` to trigger installation.

**build(resourceName, cb)**  
- Waits while another build is in progress to avoid concurrent installs.
- Forks `yarn_cli.js` as a child process with `install --ignore-scripts`, using shared cache and mutex files.
- Pipes stdout/stderr through `trimOutput` and writes `.yarn.installed` upon success.
- Resets state and invokes the callback with the result.

**sleep(ms)**  
- Simple Promise wrapper used to pause while waiting for another build to finish.

**Task Registration**  
- `RegisterResourceBuildTaskFactory('yarn', () => yarnBuildTask);` exposes the task so other resources can declare `build_task 'yarn'` in their manifests.

### yarn_cli.js — Role: Server (Utility)
Bundled, webpack-compiled Yarn 1.x CLI. It embeds the full Yarn implementation and its dependencies in a single file, allowing `yarn_builder.js` to spawn it without requiring a global Yarn installation. The script begins with a Node shebang and webpack bootstrap that loads modules from an internal cache.

### Conclusion
`fxmanifest.lua` registers the builder and points to `yarn_builder.js`. `yarn_builder.js` manages concurrency, decides whether dependencies need reinstalling, and invokes the bundled `yarn_cli.js` to run `yarn install` with shared cache and mutex files. This setup guarantees deterministic, serialized Yarn installations for any resource that declares the yarn build task.

---

## baseevents

**Overview**  
Provides foundational death and vehicle events for other resources to consume. Client scripts watch the player’s state and send standardized event messages to the server, which in turn exposes the events to any listener and writes basic information to RCON logs.

### Table of Contents
- fxmanifest.lua
- client/deathevents.lua
- client/vehiclechecker.lua
- client/utils.lua
- server/main.lua

### fxmanifest.lua — Role: Shared / Meta
- Declares version, author, description, and repository for the resource.
- Registers client scripts (`client/utils.lua`, `client/vehiclechecker.lua`, `client/deathevents.lua`) and the server script (`server/main.lua`).
- Targets the adamant FX build for GTA V, making the events available to other resources through standard FiveM mechanisms.

### client/deathevents.lua — Role: Client
Continuously monitors the local player to broadcast death-related events.

**Main Thread**  
- Runs every frame to detect when the player becomes fatally injured or recovers.
- Tracks the time of death to distinguish between **killed by someone** and **died on own** events.
- When death is detected:
  - Determines the killer’s entity, weapon, vehicle involvement, and seat information (using `GetPedVehicleSeat` from `client/utils.lua`).
  - Calls `baseevents:onPlayerKilled` if another player caused the death, passing attacker ID, weapon hash, vehicle name, seat, and kill position.
  - Calls `baseevents:onPlayerDied` when the player dies without another player’s involvement (e.g., suicide or environment), supplying the player’s position and killer type.
  - Emits `baseevents:onPlayerWasted` if a death occurs without explicitly being marked as killed (useful for respawn logic).

**Helper Function: `GetPlayerByEntityID`**  
- Iterates active network players to map an entity handle back to a player index, enabling identification of the killer’s server ID.

These client events are mirrored to the server with `TriggerServerEvent`, allowing server-side scripts to respond or forward them.

### client/vehiclechecker.lua — Role: Client
Watches the local player’s interaction with vehicles and sends standardized events to the server.

**Main Thread**  
- Polls frequently (every `50 ms`) to determine whether the player is entering, aborting entry, appearing inside, or leaving a vehicle.
- When detecting an attempt to enter a vehicle, triggers `baseevents:enteringVehicle` with the vehicle handle, seat index, model name, and network ID.
- Cancels the attempt with `baseevents:enteringAborted` if the player stops trying before entry.
- When the player successfully appears inside a vehicle (including teleports), sends `baseevents:enteredVehicle` with vehicle details and the seat occupied.
- On exit or death while in a vehicle, triggers `baseevents:leftVehicle` with the vehicle info and seat.

Uses `GetPedVehicleSeat` from `client/utils.lua` to determine which seat the player occupies.

These messages allow server-side logic to react to vehicle entry/exit without each resource implementing its own polling.

### client/utils.lua — Role: Client
Defines `GetPedVehicleSeat(ped)`, returning the seat index occupied by the given ped or `-2` if not in a vehicle. Shared utility used by the death and vehicle checker threads.

### server/main.lua — Role: Server
Registers the base event channels and provides basic logging for death events.

**Registered Events**
- `baseevents:onPlayerDied`
- `baseevents:onPlayerKilled`
- `baseevents:onPlayerWasted`
- `baseevents:enteringVehicle`
- `baseevents:enteringAborted`
- `baseevents:enteredVehicle`
- `baseevents:leftVehicle`

**Handlers**
- For `onPlayerKilled`: logs the victim, attacker ID, and additional data (weapon, vehicle info) using `RconLog`.
- For `onPlayerDied`: logs the victim, attacker type (e.g., environment or vehicle impact), and death position.
- The remaining registered events are made available for other resources to attach handlers to; they are not processed further by this file, keeping the server script lightweight and extensible.

### Conclusion
The baseevents resource centralizes player death and vehicle interaction detection. Client scripts (`client/deathevents.lua`, `client/vehiclechecker.lua`, `client/utils.lua`) watch local state and send uniform event messages. `server/main.lua` registers these events for use across the server and provides minimal logging hooks, while `fxmanifest.lua` ties the components together. Other resources can listen to these events to implement game logic without re‑implementing death or vehicle checks.

---

## hardcap

**Overview**  
Enforces a hard player cap by tracking active players and denying new connections once the limit defined by `sv_maxclients` is reached. A small client script signals activation to the server, which maintains a live count and validates connections.

### Table of Contents
- fxmanifest.lua
- client.lua
- server.lua
- Conclusion
- Testing

### fxmanifest.lua — Role: Shared / Meta
- Declares version, author, description, and repository link.
- Registers `client.lua` and `server.lua` as the client and server scripts.
- Targets the adamant FX build for both GTA V and RedM, acknowledging the prerelease state of RedM.
- States that the resource limits players to the number set by `sv_maxclients` in `server.cfg`.

### client.lua — Role: Client
Runs a continuous thread that waits for the network session to start. Once the session begins, triggers the server event `hardcap:playerActivated` to indicate the player should be counted, then exits the thread. This single event call is the client’s only responsibility, signaling the server to include the player in the current population count.

### server.lua — Role: Server
Maintains `playerCount` and a list tracking which players have reported activation.
- On `hardcap:playerActivated`, increments `playerCount` and marks the source player as active if not already listed.
- `playerDropped` decrements the count and removes the player from the list.
- During `playerConnecting`, retrieves `sv_maxclients`; if the count is at or above this limit, sets a rejection reason and cancels the event, preventing additional players from joining.
- Prints connection attempts and rejection notices to the server console for transparency.

### Conclusion
The `hardcap` resource comprises a lightweight client notifier and a server-side counter that enforces the population limit defined in configuration. By denying connections beyond `sv_maxclients`, it ensures server stability and predictable player capacity.

---

## rconlog

**Overview**  
Handles legacy RCON logging and player management commands. A client script reports active players to the server, while the server script logs lifecycle events, relays rename updates, and exposes a handful of RCON commands (`status`, `clientkick`, `tempbanclient`).

### Table of Contents
- fxmanifest.lua
- rconlog_client.lua
- rconlog_server.lua
- Conclusion
- Testing

### fxmanifest.lua — Role: Shared / Meta
- Supplies metadata (version, author, description, repository link).
- Registers one client script (`rconlog_client.lua`) and one server script (`rconlog_server.lua`).
- Targets the adamant FX build for both GTA V and RedM, acknowledging prerelease status for RedM (`rdr3_warning`).
- No exports or dependencies; this manifest solely ties the two scripts together.

### rconlog_client.lua — Role: Client

**Event: `rlUpdateNames`**  
- Collects all active network players (up to 32 slots).
- Builds a table mapping each player’s server ID to their local index and name.
- Sends the table back to the server via `rlUpdateNamesResult`.
- **Purpose:** Enables the server to detect when players change names or leave without firing `playerDropped`.

**Thread: `Citizen.CreateThread`**  
- Waits for the network session to start; once ready, triggers `rlPlayerActivated` on the server and exits.
- Signals that this client is active so the server can log the connection.
- The client script’s only jobs are reporting the local player list and notifying the server that the player has joined a session.

### rconlog_server.lua — Role: Server

**Startup Log**  
- Immediately calls `RconLog` with `serverStart`, broadcasting hostname and max player count to RCON logs.

**Event: `rlPlayerActivated`**  
- Triggered by clients after session start.
- Logs activation with player name, GUID, and IP (`RconLog`).
- Stores the player’s name and ID in a `names` table.
- If a host exists, requests a fresh player list via `rlUpdateNames`.

**Event: `rlUpdateNamesResult`**  
- Executed only when the sender is the current host.
- Compares the received list of `(id, name)` pairs against cached data:
  - Adds new entries for players that were not previously tracked.
  - When a name or local index changes, updates the cache and logs `playerRenamed`.
  - Removes entries for players no longer present.

**Event: `playerDropped`**  
- Logs disconnects and removes the player from the cache.

**Event: `chatMessage`**  
- Logs every chat message with player ID, name, message text, and GUID.

**Event: `rconCommand`** (legacy)  
- Modern resources should use `RegisterCommand` instead.
  - `status` – Iterates cached players and prints their ID, GUID, name, IP, and ping to the RCON console; cancels the event so default handling doesn’t run.
  - `clientkick <id> <reason>` – Drops a player with the given message, then cancels the event.
  - `tempbanclient <id> <reason>` – Temporarily bans a player with the given message, then cancels the event.

### Conclusion
`fxmanifest.lua` links the client and server scripts. `rconlog_client.lua` reports player names and signals when a player becomes active. `rconlog_server.lua` logs server start, joins, renames, disconnects, and chat messages, while also providing legacy RCON commands for status reporting and player moderation. Together, they form a lightweight RCON logging system for legacy server administration.

---

## runcode

**Overview**  
Enables administrators to execute arbitrary Lua or JavaScript snippets on the server or on specific clients. Provides a web‑based editor, an in‑game NUI, and console commands that route code through shared helpers to evaluate snippets and return results.

### Table of Contents
- fxmanifest.lua
- runcode.js
- runcode_shared.lua
- runcode_sv.lua
- runcode_cl.lua
- runcode_ui.lua
- runcode_web.lua
- web/index.html
- web/nui.html
- Conclusion

### fxmanifest.lua — Role: Shared / Meta
- Declares resource metadata (version, author, description, repository) and targets the bodacious FX build for all games.
- Registers scripts:
  - **Client:** `runcode_cl.lua`, `runcode_ui.lua`
  - **Server:** `runcode_sv.lua`, `runcode_web.lua`
  - **Shared:** `runcode_shared.lua`, `runcode.js`
- Defines the NUI page (`web/nui.html`) and exposes its asset files.
- **Purpose:** ties together the JavaScript executor, shared helpers, server commands, client UI, and web handler.

### runcode.js — Role: Shared
Exports a single function `runJS` that evaluates JavaScript snippets:
- Validates the caller; on the server side, only the `runcode` resource may invoke the export.
- Executes the snippet via `new Function(snippet)()` and returns `[result, false]`.
- On error, catches the exception and returns `[false, errorString]`.
- Used by Lua code (through `exports.runJS`) to support cross-language execution.

### runcode_shared.lua — Role: Shared
Central helper that dispatches code execution for multiple languages.

- `runners.lua(arg)`  
  Attempts to compile `arg` as Lua, first prefixed with `return`, then raw. Runs the compiled chunk with `pcall` and returns its result or error.
- `runners.js(arg)`  
  Delegates to the JavaScript export defined in `runcode.js`.
- `RunCode(lang, str)`  
  General entry point; selects the appropriate runner (`lua` or `js`) and returns the result and error (if any).

All scripts (server, client, web) rely on `RunCode` to evaluate snippets.

### runcode_sv.lua — Role: Server
Implements console commands and privilege checks.

- `GetPrivs(source)` – Returns three boolean flags (`canServer`, `canClient`, `canSelf`) based on ACE permissions (`command.run`, `command.crun`, `runcode.self`).
- `/run <code>` – Executes Lua code server‑side via `RunCode`.
- `/crun <code>` – Sends a Lua snippet to the invoking client by firing `runcode:gotSnippet`.
- `/runcode` – Opens the in‑game UI:
  - Reads `data.json` to retrieve the last used snippet/language.
  - Assembles privilege info and saved data.
  - Triggers `runcode:openUi` on the caller with these options.

This script enforces permissions, runs server snippets, and brokers client runs through events.

### runcode_cl.lua — Role: Client
Executes code received from the server and reports results.

- **Event:** `runcode:gotSnippet (id, lang, code)`  
  Runs the snippet with `RunCode`. If the result is a vector or table, JSON‑encodes it for transmission. Sends the outcome back via `runcode:gotResult` to the server. Supports remote execution when `/crun` or the web UI targets a client.

### runcode_ui.lua — Role: Client
Handles the in‑game NUI wrapper.

- **Event:** `runcode:openUi`  
  Stores options (privilege flags, resource URL) and sends an “open” message to the HTML UI.
- **NUI Callbacks:**  
  - `getOpenData` → returns the stored open data to the page.  
  - `doOk` / `doClose` → show or hide the iframe and toggle focus accordingly.  
  - `runCodeInBand` → forwards code requests to the server (`runcode:runInBand`), storing per‑request callbacks.
- **Event:** `runcode:inBandResult` – Receives results for in-band runs and resolves the stored callback.
- Cleans up NUI focus on resource stop.
- Allows in-game editing and execution through a pop‑up window.

### runcode_web.lua — Role: Server
Provides the HTTP endpoint, permission checks, and cross‑client execution logic.

- **File Server (`sendFile`)** – Caches and serves files from the `web/` directory, handling 404s for missing resources.
- **`handleRunCode(data, res)` – Core executor:**  
  - Defaults language to Lua.  
  - If `data.client` is empty: runs code on the server in a new thread and returns JSON `{ result, error }`.  
  - Otherwise: assigns a code ID, stores the response handle, and triggers `runcode:gotSnippet` on the target client. Results are later returned by `runcode:gotResult`.
- **`runcode:runInBand` Event** – Invoked from the NUI when “Run” is pressed:  
  - Validates privileges (server, client, self) using `GetPrivs`.  
  - Optionally rewrites the target client to the caller if only self-execution is allowed.  
  - Saves the snippet and language to `data.json` for UI persistence.  
  - Calls `handleRunCode` to execute.
- **POST Handler (`handlePost`)** – Accepts HTTP POST requests with `{ password, code, client?, lang? }`:  
  - Verifies RCON password and rate‑limits failed attempts.  
  - Passes validated requests to `handleRunCode`.
- **Result Tracking (`codes` Table)** – Stores pending client requests with timeouts. `returnCode` delivers the final response or a timeout message.
- **HTTP Server (`SetHttpHandler`)** – Routes:  
  - `/clients` → returns a list of `[name, id]` pairs for current players.  
  - `/` → serves `index.html` by default.  
  - Other paths → sanitized and passed to `sendFile`.
- **Security Measures:** rate-limits bad password attempts; strips `..` from paths; uses ACE permissions for execution.

This file integrates HTTP access, NUI calls, and client responses into a unified execution service.

### web/index.html — Role: Client UI (Browser)
Full-featured web interface for running code:
- Includes Bulmaswatch styling and Font Awesome icons.
- Uses Monaco Editor for syntax highlighting (Lua or JS/TS), dynamically loading definition files for client or server APIs.
- **UI Elements:**
  - Player dropdown for targeting clients.
  - Language toggle (Lua/JS).
  - Password field for RCON authentication.
  - Run button displaying results with success/error styling.
- If loaded as an in-game NUI:
  - Offers “OK” and “Close” buttons that trigger `doOk`/`doClose` callbacks.
  - Pulls initial data (last snippet, language) through `getOpenData`.
  - Fetches `/runcode/` (HTTP) or `https://<resource>/runCodeInBand` (NUI) to execute code, then shows result text and origin info (client name/id).
- Provides both web and in-game editing environments.

### web/nui.html — Role: Client UI Container
Minimal page that acts as the NUI shell:
- Renders an empty `<div>`; upon receiving a message event:
  - `"open"` – creates an `<iframe>` pointing to the web interface URL and appends it to the DOM, initially hidden.
  - `"ok"` – reveals the iframe after the user confirms.
  - `"close"` – removes the iframe from the DOM.
- CSS sets a transparent background and stretches the iframe to fill the viewport.
- Serves as the bridge between FiveM’s NUI system and the full-featured `index.html`.

### Conclusion
The `runcode` resource enables privileged users to evaluate Lua or JavaScript on the server or specific clients. `runcode.js` and `runcode_shared.lua` provide the execution core; `runcode_sv.lua` exposes console commands and permission checks; `runcode_cl.lua` runs client snippets and returns results; `runcode_ui.lua` and `web/nui.html` integrate a browser-based editor into the game; and `runcode_web.lua` exposes an HTTP API with security measures. Together, these components deliver a versatile code‑execution toolkit intended for development and debugging scenarios.

---

## sessionmanager

**Overview**  
Coordinates network host assignment for non-OneSync servers. A small server script manages a host lock so that only one player acquires host status at a time, and a placeholder client script ensures the shared callback scheduler loads on the client.

### Table of Contents
- fxmanifest.lua
- client/empty.lua
- server/host_lock.lua
- Conclusion

### fxmanifest.lua — Role: Shared / Meta
- Registers the resource with FiveM (`fx_version 'cerulean'`) for GTA IV and GTA V.
- Declares metadata (version, author, description, repository) and warns against disabling the resource.
- Specifies the script entry points:
  - **Server:** `server/host_lock.lua`
  - **Client:** `client/empty.lua`
- **Purpose:** loads the host-lock logic server‑side and ensures a client script runs so remote callbacks can function both ways.

### client/empty.lua — Role: Client
Contains only comments explaining its existence. Loading a client script triggers `scheduler.lua` (elsewhere in the runtime) to load on the client, enabling client→server remote callbacks. No executable code; its mere presence ensures the resource participates in the client-side scheduling system.

### server/host_lock.lua — Role: Server
Manages a host acquisition lock so that only one client at a time can become the network host.

**Events**
- `hostingSession`  
  Fired by clients attempting to become host.  
  **Logic:**
  - If `currentHosting` is set, the requester is told to wait and their callback is queued.
  - If no lock but the current host responded within the last second (`GetPlayerLastMsg`), the requester gets a conflict message.
  - Otherwise, the requester receives `go` and `currentHosting` is set to their source ID.
  - A 5‑second timeout clears the lock and notifies all queued callbacks.
- `hostedSession`  
  Fired by the client once it has successfully hosted the session.  
  Only the client that previously held the lock (`currentHosting`) may call it.  
  Releases the lock and runs all queued callbacks to notify waiting clients.

**Internal State**
- `currentHosting` — Tracks which player currently holds the lock.
- `hostReleaseCallbacks` — Queue of functions to call when the lock is released.

**Additional Features**
- Uses `TriggerClientEvent('sessionHostResult', source, <result>)` to inform clients whether to wait, retry, or proceed.
- Mentions TODOs for timeout handling and fraud checks (e.g., dropping clients that lie about hosting).
- Ends with `EnableEnhancedHostSupport(true)` to activate enhanced host handling in the runtime.

### Conclusion
The `sessionmanager` resource ensures orderly network host negotiation: `fxmanifest.lua` ties the components together and mandates the resource’s presence; `client/empty.lua` loads client-side scheduling infrastructure; `server/host_lock.lua` serializes host acquisition, resolving conflicts and notifying waiting clients. Together, they maintain stable session hosting in non-OneSync environments.

---

## sessionmanager-rdr3

**Overview**  
Implements the Social Club session API for RedM, assigning player slots, relaying protobuf RPC messages, and coordinating the session host for non-OneSync servers. The resource runs entirely on the server and exposes no client scripts.

### Table of Contents
- fxmanifest.lua
- .gitignore
- package.json
- yarn.lock
- rline.proto
- sm_server.js
- Conclusion
- Testing

### fxmanifest.lua — Role: Shared / Meta
- Declares metadata (version 1.0.0, author, description, repository).
- Targets the adamant FX server build and restricts the resource to RedM (game `rdr3`) with a prerelease warning.
- Declares a dependency on the `yarn` builder to install Node modules.
- Registers `sm_server.js` as the sole server script; no client scripts are defined.

### .gitignore — Role: Shared / Meta
Excludes `node_modules/` and `.yarn.installed` from version control, ensuring build artifacts and the Yarn marker file are not committed.

### package.json — Role: Shared / Configuration
Marks the package as private and lists a single dependency: `@citizenfx/protobufjs@6.8.8`, the library used to load and encode protobuf definitions (`rline.proto`).

### yarn.lock — Role: Shared / Dependency Lock
Autogenerated file pinning exact versions and integrity hashes for `@citizenfx/protobufjs` and its transitive dependencies, guaranteeing reproducible Yarn installs.

### rline.proto — Role: Shared / Data Definition
Protobuf schema defining all RPC messages exchanged between the client and session manager.

**Core Messages:** `RpcMessage`, `RpcResponseMessage`, `RpcHeader`, and associated Error structures.  
**Player & Session Structures:** `MpGamerHandleDto`, `MpPeerAddressDto`, `PlayerIdSto`, `MpSessionRequestIdDto`, and others describing identities and queue requests.  
**Commands & Results:**
- Queueing (`QueueForSession_Seamless_Parameters`, `QueueForSessionResult`, `QueueEntered_Parameters`).
- Transitioning (`TransitionReady_PlayerQueue_Parameters`, `TransitionToSession_Parameters`, `TransitionToSessionResult`).
- Session subcommands (`EnterSession`, `AddPlayer`, `RemovePlayer`, `HostChanged`, etc.) bundled in `scmds_Parameters`.

The server script loads these definitions to encode/decode messages exchanged with clients.

### sm_server.js — Role: Server
Node.js implementation of the RedM session manager using the protobuf types above.

**Session State & Utilities**  
- `playerDatas`: Tracks per-player data (gamer handle, address, assigned slot, etc.).
- `slotsUsed` / `assignSlotId()`: Bitmask and helper function that allocate one of 32 slot indices; returns `-1` if full.
- `hostIndex`: Tracks which slot currently hosts the session; auto-reassigned when the host disconnects.
- `isOneSync`: Detects whether the server runs in OneSync mode, altering host logic accordingly.

**Protobuf Setup**  
- On startup, loads `rline.proto` and looks up all required message types (RPC wrappers, session commands, queue requests/results).
- **Helper functions:**
  - `toArrayBuffer(buf)` – converts Node `Buffer` instances to `ArrayBuffer` for network emission.
  - `emitMsg(target, data)` – broadcasts a raw protobuf payload to a client via `__cfx_internal:pbRlScSession`.
  - `emitSessionCmds(target, cmd, cmdname, msg)` – wraps session subcommands into an RPC message.
  - Shortcuts `emitAddPlayer`, `emitRemovePlayer`, and `emitHostChanged` use the above to inform clients of session changes.

**Event: `playerDropped`**  
- For non-OneSync servers:
  - Removes the player from `playerDatas` and frees their slot.
  - If the departing player was host, selects a new host and notifies all clients with `HostChanged`.
  - Sends `RemovePlayer` commands to remaining players.

**RPC Response Helper**  
- `makeResponse(type, data)` builds a standard protobuf response container, used by all RPC method handlers.

**RPC Handlers (`handlers` object)**  
- `InitSession` – Responds with a blank session ID (and optional token, currently commented out).
- `InitPlayer2` – Stores gamer handle, peer address, and discriminator for non-OneSync servers; returns success code `0`.
- `GetRestrictions` – Returns an empty restriction set.
- `ConfirmSessionEntered` – No-op acknowledgment.
- `TransitionToSession` – Decodes the request and returns success (code: `1`).
- `QueueForSession_Seamless` – Core queue logic:
  - Decodes the request and, for non-OneSync, stores request ID, player ID, and assigns a slot.
  - After short delays:
    - Sends `QueueEntered` and `TransitionReady_PlayerQueue` messages.
    - Determines the host slot (fixed `16` for OneSync; otherwise first player).
    - Sends an `EnterSession` session command with slot, host index, and session parameters.
    - On non-OneSync servers, broadcasts `AddPlayer` commands so the new player and existing players know about each other.
  - Concludes with `QueueForSessionResult` (code: `1`).

**Message Dispatch**  
- `handleMessage(source, method, data)` routes incoming RPC calls to the appropriate handler.
- Network listener `__cfx_internal:pbRlScSession` decodes incoming messages, invokes `handleMessage`, and replies with encoded responses (including the original `RequestId`).

**Overall**  
The script emulates Social Club session behavior, assigning slots, relaying session commands, and keeping track of players and the host in RedM.

### Conclusion
The `sessionmanager-rdr3` resource is a server-only implementation of RedM’s session conductor. `fxmanifest.lua` registers the resource and its Node dependencies; `.gitignore`, `package.json`, and `yarn.lock` manage the build environment; `rline.proto` defines the protobuf schema; and `sm_server.js` handles all session logic—queueing players, assigning slot IDs, choosing a host, and relaying session commands via protobuf messages.

---

## example-loadscreen

**Overview**  
Example load screen resource that displays a themed HTML page while the game initializes. The page shows a background image, titles, animated loading bar, and dynamic messages based on load progress events.

### Table of Contents
- fxmanifest.lua
- index.html
- keks.css
- bankgothic.ttf
- loadscreen.jpg
- Conclusion
- Testing

### fxmanifest.lua — Role: Shared / Meta
- Declares resource metadata (version, author, description, repository).
- Lists required files (`index.html`, `keks.css`, `bankgothic.ttf`, `loadscreen.jpg`) for the load screen.
- Registers `index.html` as the active load screen, targeting the **Bodacious** build for GTA V.

### index.html — Role: Client
HTML page and script driving the load screen UI.

**Structure:** Displays titles, a load bar, and placeholder text over a backdrop container.

**Event Handlers:**
- `startInitFunctionOrder` – resets total step count and appends an emoji indicating stage order.
- `initFunctionInvoking` – updates the bar width based on current index and total count.
- `startDataFileEntries` – sets up count for data files and adds a rice-ball emoji to the progress header.
- `performMapLoadFunction` – advances the bar as map load tasks complete.
- `onLogLine` – replaces the help text with log lines from the loading process.

**Messaging:** A message event listener routes incoming load events to the above handlers.

### keks.css — Role: Client
Styles the load screen elements.
- Sets the full-screen backdrop using `loadscreen.jpg` as the background image.
- Imports the BankGothic font from `bankgothic.ttf` for titles and headers.
- Positions titles, load bar, and progress text to mirror GTA-style loading screens.

### bankgothic.ttf — Role: Client Asset
TrueType font referenced in the stylesheet to render stylized titles and headings. Included in the file list for the resource and loaded via `@font-face`.

### loadscreen.jpg — Role: Client Asset
Background image filling the viewport during loading. Linked through the stylesheet and declared in the manifest’s file list.

### Conclusion
The `example-loadscreen` resource delivers a themed HTML/CSS load screen. `fxmanifest.lua` registers the necessary assets and the load page, `index.html` handles event-driven updates to progress displays, and `keks.css` applies the visual style using a custom font and background image. No server scripts are included—the resource operates purely on the client.

---

## fivem

**Overview**  
Compatibility wrapper that ensures the basic-gamemode resource loads in test environments. Contains only a manifest; no client or server scripts are included.

### Table of Contents
- fxmanifest.lua
- Conclusion

### fxmanifest.lua — Role: Shared / Meta
Declares metadata and establishes the resource as a compatibility layer:
- **Version / Author / Description / Repository** – Identifies the resource and links back to the Cfx.re asset pack.
- `fx_version 'adamant'` – Targets the modern FX build.
- `game 'common'` – Marks compatibility with all games supported by the platform.
- `dependency 'basic-gamemode'` – Forces the `basic-gamemode` resource to load whenever this resource is started, providing default gameplay functionality for test setups.

No client or server scripts are listed; starting this resource simply triggers loading of `basic-gamemode`.

### Conclusion
The `[test]/fivem` resource is a minimal compatibility wrapper. Its `fxmanifest.lua` declares metadata and depends on `basic-gamemode`, ensuring that the default freeroam gametype initializes during tests. There are no client or server scripts, events, or additional assets.

