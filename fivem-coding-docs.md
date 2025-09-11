# FiveM Coding Docs — Server & Resource Development (Part 1: Scripting Manual)

> Scope of this part: summarize and operationalize the **Scripting Manual** on docs.fivem.net for coding a server and resources. Includes setup, resource anatomy, events, ConVars/commands, OneSync/state bags, ACL/permissions, and txAdmin basics. Later parts will enumerate **natives** (runtime.fivem) by client/server + category with usage examples.

---

## Table of Contents
- [Overview: Server Coding & Architecture](#overview-server-coding--architecture)
- [Environment Setup (FXServer, server.cfg, txAdmin)](#environment-setup-fxserver-servercfg-txadmin)
- [Resource Anatomy & `fxmanifest.lua`](#resource-anatomy--fxmanifestlua)
- [Runtimes: Lua, JavaScript, C#](#runtimes-lua-javascript-c)
- [Events: Listening, Triggering, Net Events](#events-listening-triggering-net-events)
- [ConVars & Commands](#convars--commands)
- [Networking & Sync: OneSync + State Bags](#networking--sync-onesync--state-bags)
- [Access Control (ACL), Principals & Permissions](#access-control-acl-principals--permissions)
- [Debugging & Profiling](#debugging--profiling)
- [Security & Best Practices Checklist](#security--best-practices-checklist)
- [Appendix A: Minimal Resource Templates](#appendix-a-minimal-resource-templates)
- [Appendix B: Server `server.cfg` Template](#appendix-b-server-servercfg-template)
- [Next Steps](#next-steps)

---

## Overview: Server Coding & Architecture

A FiveM server is a collection of **resources** (folders) containing client scripts, server scripts, shared files, and optional streamed assets. Resources are started/stopped independently and discovered by a **manifest** file (`fxmanifest.lua`). You’ll code behavior by wiring **events** (client ⇄ server), calling **natives**, configuring **ConVars/commands**, and leveraging **OneSync** for entity/state synchronization. txAdmin can run and manage the server, while **ACL/principals** secure admin actions ...

**Key primitives you will use constantly:**
- `fxmanifest.lua` to declare metadata and load order
- Client/server scripts in **Lua**, **JS**, or **C#**
- Events: `RegisterNetEvent`, `AddEventHandler`, `TriggerClientEvent`, `TriggerServerEvent`
- ConVars/commands in `server.cfg` and at runtime
- OneSync **state bags** for networked state
- ACL: `add_ace`, `add_principal`, `remove_ace`, `test_ace`

---

## Environment Setup (FXServer, `server.cfg`, txAdmin)

### Quick install (vanilla run)
1. Download artifacts and create `server` + `server-data` directories.
2. Put your license key into `server.cfg`.
3. Start FXServer from `server-data` and `+exec server.cfg`.

> See the full platform guide for OS-specific steps and troubleshooting.

### txAdmin
txAdmin provides a web UI to start/stop resources, manage players, and run diagnostics. Recommended for production, but you can still run plain FXServer for minimal setups.

---

## Resource Anatomy & `fxmanifest.lua`

Every resource lives in its own folder and **must** include `fxmanifest.lua`. This file is Lua with a declarative syntax for metadata and script lists. Typical fields:

- `fx_version`, `game`
- `author`, `description`, `version`
- `client_scripts`, `server_scripts`, `shared_scripts`
- `files`, `ui_page`, data `file` declarations
- `dependencies`, `provide`, `escrow_ignore` (when applicable)

### Example: Minimal resource (Lua)
```lua
-- resources/my_mode/fxmanifest.lua
fx_version 'cerulean'
game 'gta5'

name 'my_mode'
author 'Your Name'
description 'Example game mode'
version '1.0.0'

client_scripts {
  'client/main.lua'
}

server_scripts {
  'server/main.lua'
}

shared_scripts {
  'shared/config.lua'
}
```

### Example: Minimal resource (JavaScript)
```lua
-- resources/hello_js/fxmanifest.lua
fx_version 'cerulean'
game 'gta5'

name 'hello_js'
author 'Your Name'
description 'JS example'
version '1.0.0'

client_scripts { 'client/main.js' }
server_scripts { 'server/main.js' }
```

---

## Runtimes: Lua, JavaScript, C#

- **Lua (CfxLua / Lua 5.4-like)**: Idiomatic for many resources; supports vectors/quaternions and path literals.
- **JavaScript (ES2017)**: Modern JS with `console` API; not a browser or Node—no DOM/localStorage/etc.
- **C# (CitizenFX.Core)**: Strongly-typed runtime with `BaseScript`, attributes, and `API` static natives.

### Client command (Lua)
```lua
RegisterCommand('whereami', function()
  local ped = PlayerPedId()
  local coords = GetEntityCoords(ped)
  TriggerEvent('chat:addMessage', { args = { '[POS]', ('x=%.2f y=%.2f z=%.2f'):format(coords.x, coords.y, coords.z) } })
end, false)
```

### Client command (JS)
```js
RegisterCommand('whereami', () => {
  const ped = PlayerPedId();
  const [x, y, z] = GetEntityCoords(ped, false);
  emit('chat:addMessage', { args: ['[POS]', `x=${x.toFixed(2)} y=${y.toFixed(2)} z=${z.toFixed(2)}`] });
}, false);
```

---

## Events: Listening, Triggering, Net Events

**Basics**
- Use `AddEventHandler(name, cb)` to listen.
- Mark events for network use with `RegisterNetEvent(name[, cb])`.
- Trigger local events with `TriggerEvent(name, ...)`.
- From **client → server**: `TriggerServerEvent(name, ...)` (or latent variant).
- From **server → client(s)**: `TriggerClientEvent(name, playerId|-1, ...)`.

> **Tip:** On server, the implicit `source` global holds the player ID that invoked the handler—capture it to a local before any `Wait/await`.

### Example: client → server → broadcast (Lua)
```lua
-- client/main.lua
RegisterCommand('hello', function() 
  TriggerServerEvent('srp:hello', GetPlayerServerId(PlayerId()))
end)

-- server/main.lua
RegisterNetEvent('srp:hello', function(fromId)
  local src = source
  print(('hello from %s (claimed %s)'):format(src, fromId))
  TriggerClientEvent('chat:addMessage', -1, { args = { '[SRP]', ('%s says hello!'):format(src) } })
end)
```

### Example: cancellation and validation (JS)
```js
// server/main.js
RegisterNetEvent('bank:withdraw', (amount) => {
  const src = global.source; // capture immediately if you will await!
  if (typeof amount !== 'number' || amount <= 0 || amount > 2000) {
    CancelEvent(); // only cancels local event, not other handlers
    return;
  }
  // perform withdrawal...
  emitNet('chat:addMessage', src, { args: ['[BANK]', `Withdrew $${amount}`] });
});
```

---

## ConVars & Commands

ConVars configure features globally (`server.cfg`, console, or RCON) and can be read from scripts.

### In `server.cfg`
```cfg
# Identity & networking
sv_hostname "Sunny RP Dev"
sv_maxclients 48
endpoint_add_tcp "0.0.0.0:30120"
endpoint_add_udp "0.0.0.0:30120"

# License & owner
sv_licenseKey "REDACTED"

# Resources
ensure chat
ensure hardcap
ensure sessionmanager
ensure my_mode
```

### Reading in scripts (Lua/JS)
```lua
local debugMode = GetConvarInt('srp_debug', 0) == 1
SetConvarReplicated('srp_motd', 'Welcome to Sunny RP')
```
```js
const debugMode = GetConvarInt('srp_debug', 0) === 1;
SetConvarReplicated('srp_motd', 'Welcome to Sunny RP');
```

### Server/admin commands (ACL-protected)
- Create commands with `RegisterCommand` in server/client.
- Use ACL to permit/deny usage (see next section).

---

## Networking & Sync: OneSync + State Bags

**OneSync** enables large servers and authoritative entity sync. Prefer **state bags** for replicated, typed key/value state on entities/players/resources. They’re observable via handlers and work in both client and server runtimes.

### Example: Using state bags (Lua)
```lua
-- server: tag a player with a job
AddEventHandler('playerJoining', function(oldId)
  local src = source
  -- ensure a bag on the player entity and set a replicated key
  Entity(src).state:set('job', 'mechanic', true) -- true = replicated
end)

-- client: react to changes
AddStateBagChangeHandler('job', nil, function(bagName, key, value, _reserved, replicated)
  local ply = GetPlayerFromStateBagName(bagName)
  if ply == PlayerId() then
    TriggerEvent('chat:addMessage', { args = { '[JOB]', ('You are now %s'):format(value) } })
  end
end)
```

### Example: Server reads entity coords with OneSync (Lua)
```lua
-- server: requires OneSync
RegisterCommand('whereis', function(src, args)
  local target = tonumber(args[1] or '0') or 0
  if target <= 0 then return end
  local ped = GetPlayerPed(target)
  local coords = GetEntityCoords(ped)
  print(('Player %d at (%.2f, %.2f, %.2f)'):format(target, coords.x, coords.y, coords.z))
end, true)
```

---

## Access Control (ACL), Principals & Permissions

Use ACL to guard commands/resources:
- `add_ace group.admin command.kick allow`
- `add_principal identifier.steam:... group.admin`
- `remove_ace`, `remove_principal`, `test_ace`

**Pattern:**
1. Define command scope (`command.mycmd`).
2. Create/assign groups (e.g., `group.admin`).
3. Map player identifiers to groups using `add_principal`.

```cfg
# server.cfg
add_ace group.admin command allow
add_ace group.admin command.mycmd allow
add_principal identifier.fivem:123456 group.admin
```

---

## Debugging & Profiling

- Use the in-game/client console (F8) for prints/errors.
- Server console shows resource logs.
- Use the built-in profiler for hotspots.
- Prefer structured logging in production and rate-limit noisy events.

---

## Security & Best Practices Checklist

- **Never trust clients.** Revalidate amounts, item IDs, and entity ownership on the server. Rate-limit expensive handlers.
- **Validate events.** Check types, ranges, and invariants; use `CancelEvent()` for invalid calls.
- **Use state bags** for replicated state; avoid ad-hoc globals.
- **Avoid blocking the main thread.** Use `CreateThread`/`Wait` (Lua) or async (JS); offload heavy work.
- **Guard commands with ACL.**
- **Version control** your resources and keep `fx_version 'cerulean'` (or newer).
- **Document** each resource with a README and changelog.

---

## Appendix A: Minimal Resource Templates

### Lua
```lua
-- client/main.lua
RegisterCommand('ping', function() TriggerEvent('chat:addMessage', { args = {'[PONG]', 'pong!'} }) end)

-- server/main.lua
RegisterCommand('announce', function(src, args)
  if #args == 0 then return end
  TriggerClientEvent('chat:addMessage', -1, { args = { '[ANN]', table.concat(args, ' ') } })
end, true) -- true => restricted; use ACL
```

### JavaScript
```js
// client/main.js
RegisterCommand('ping', () => emit('chat:addMessage', { args: ['[PONG]', 'pong!'] }));

// server/main.js
RegisterCommand('announce', (src, args) => {
  if (!args || !args.length) return;
  emitNet('chat:addMessage', -1, { args: ['[ANN]', args.join(' ')] });
}, true);
```

---

## Appendix B: Server `server.cfg` Template
```cfg
# Identity
sv_hostname "Sunny RP Dev"
sets locale "en-US"
sets sv_projectName "Sunny Roleplay"
sets sv_projectDesc "Development server"

# Networking
sv_maxclients 64
endpoint_add_tcp "0.0.0.0:30120"
endpoint_add_udp "0.0.0.0:30120"

# License
sv_licenseKey "REDACTED"

# OneSync (opt-in flags may change over time)
set onesync on

# ACL examples
add_ace group.admin command allow
add_ace group.admin command.quit deny
add_principal identifier.fivem:123456 group.admin

# Resources
ensure chat
ensure hardcap
ensure sessionmanager
ensure my_mode
ensure hello_js
```

---

## Next Steps

1. **Enumerate Events** (client/server core lists) with usage examples and links.
2. **Natives Index (Phase 2+)**: organize by Client vs Server and by category; for each native include:
   - signature + hash
   - purpose and caveats
   - *Lua* and *JS* examples (and C# where relevant)
   - scope (client/server), OneSync requirements, and replication notes
3. txAdmin operations: recipes, scheduled restarts, player management.
4. Testing methodology: unit-style tests for pure logic, in-game test cases for networked flows.
5. Packaging & release notes: versioning resources, change logs, and migrations.
