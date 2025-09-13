# Example_Frameworks Documentation

This document indexes the Example_Frameworks/ directory to guide development of a new FiveM framework. It is updated incrementally with directory structure, functions, events, and native currency checks.

## Scan Stamp & Inventory Overview

 TREE-SCAN-STAMP — 2025-09-13T00:43:16+00:00 — dirs:783 files:14434

| Folder | Resources | Files | Server Files | Client Files | Shared Files |
| --- | --- | --- | --- | --- | --- |
| FiveM-FSN-Framework | 58 | 723 | 75 | 124 | 3 |
| ND_Core-main | 1 | 43 | 8 | 11 | 1 |
| NoPixelServer | 192 | 13412 | 111 | 290 | 13 |
| cfx-server-data | 24 | 117 | 11 | 12 | 2 |
| es_extended | 1 | 50 | 6 | 8 | 0 |
| essentialmode | 2 | 20 | 7 | 2 | 0 |
| qb-core | 1 | 84 | 7 | 5 | 8 |
| vRP | 1 | 179 | 0 | 18 | 0 |
| vorp_core-lua | 1 | 65 | 20 | 17 | 0 |


## Processing Ledger

| Scope | Total | Done | Remaining | Last Updated |
| --- | --- | --- | --- | --- |
| File Enumeration | 14434 | 751 | 13683 | 2025-09-13 |
| Function Extraction | 28 | 28 | 0 | 2025-09-13 |
| Event Extraction | 38 | 38 | 0 | 2025-09-13 |
| Native Currency Checks | 87 | 87 | 0 | 2025-09-13 |
| Similarity Merges | 2 | 2 | 0 | 2025-09-13 |

## Function & Event Registry

### 5.1 Methodology & Classification
- Classification derives from `fxmanifest.lua` declarations and file path conventions (e.g., `client/`, `server/`, `shared/`).
- Events detected via patterns like `RegisterNetEvent`, `AddEventHandler`, `TriggerClientEvent`, and `TriggerServerEvent`.

### 5.2 Consolidated Index

#### Functions
- [cancelFishing](#cancelfishing)
- [cancelHunt](#cancelhunt)
- [cancelYoga](#cancelyoga)
- [createBlips](#createblips)
- [getAdminName](#getadminname)
- [EnterMyApartment](#entermyapartment)
- [EnterRoom](#enterroom)
- [fsn_closeATM](#fsn_closeatm)
- [fsn_drawText3D](#fsn_drawtext3d)
- [getAvailableAppt](#getavailableappt)
- [getModeratorName](#getmoderatorname)
- [getNearestSpot](#getnearestspot)
- [getSteamIdentifier](#getsteamidentifier)
- [inInstance](#ininstance)
- [isAdmin](#isadmin)
- [isModerator](#ismoderator)
- [isNearStorage](#isnearstorage)
- [nearPos](#nearpos)
- [registerAdminCommands](#registeradmincommands)
- [registerAdminSuggestions](#registeradminsuggestions)
- [registerModeratorCommands](#registermoderatorcommands)
- [registerModeratorSuggestions](#registermoderatorsuggestions)
- [saveApartment](#saveapartment)
- [spawnAnimal](#spawnanimal)
- [startFishing](#startfishing)
- [startHunt](#starthunt)
- [startYoga](#startyoga)
- [table.contains](#tablecontains)
- [ToggleActionMenu](#toggleactionmenu)

#### Events
- [chat:addMessage](#chataddmessage)
- [depositMoney](#depositmoney)
- [fsn_admin:FreezeMe](#fsn_adminfreezeme)
- [fsn_admin:enableAdminCommands](#fsn_adminenableadmincommands)
- [fsn_admin:enableModeratorCommands](#fsn_adminenablemoderatorcommands)
- [fsn_admin:receiveXYZ](#fsn_adminreceivexyz)
- [fsn_admin:requestXYZ](#fsn_adminrequestxyz)
- [fsn_admin:sendXYZ](#fsn_adminsendxyz)
- [fsn_admin:spawnVehicle](#fsn_adminspawnvehicle)
- [fsn_apartments:characterCreation](#fsn_apartmentscharactercreation)
- [fsn_apartments:instance:debug](#fsn_apartmentsinstancedebug)
- [fsn_apartments:instance:join](#fsn_apartmentsinstancejoin)
- [fsn_apartments:instance:leave](#fsn_apartmentsinstanceleave)
- [fsn_apartments:instance:update](#fsn_apartmentsinstanceupdate)
- [fsn_apartments:inv:update](#fsn_apartmentsinvupdate)
- [fsn_apartments:outfit:add](#fsn_apartmentsoutfitadd)
- [fsn_apartments:sendApartment](#fsn_apartmentssendapartment)
- [fsn_apartments:stash:add](#fsn_apartmentsstashadd)
- [fsn_apartments:stash:take](#fsn_apartmentsstashtake)
- [fsn_bank:change:bankAdd](#fsn_bankchangebankadd)
- [fsn_bank:change:bankandwallet](#fsn_bankchangebankandwallet)
- [fsn_bank:change:bankMinus](#fsn_bankchangebankminus)
- [fsn_bank:database:update](#fsn_bankdatabaseupdate)
- [fsn_bank:request:both](#fsn_bankrequestboth)
- [fsn_bank:transfer](#fsn_banktransfer)
- [fsn_bank:update:both](#fsn_bankupdateboth)
- [fsn_cargarage:makeMine](#fsn_cargaragemakemine)
- [fsn_main:displayBankandMoney](#fsn_maindisplaybankandmoney)
- [fsn_main:logging:addLog](#fsn_mainloggingaddlog)
- [fsn_needs:stress:remove](#fsn_needsstressremove)
- [fsn_notify:displayNotification](#fsn_notifydisplaynotification)
- [fsn_phones:SYS:addTransaction](#fsn_phonessysaddtransaction)
- [fsn_yoga:checkStress](#fsn_yogacheckstress)
- [fsn:playerReady](#fsnplayerready)
- [toggleGUI](#togglegui)
- [transferMoney](#transfermoney)
- [withdrawMoney](#withdrawmoney)

### 5.3 Functions — Detailed Entries

#### createBlips
- **Name**: createBlips
- **Type**: Client
- **Defined In**:
  - Example_Frameworks/FiveM-FSN-Framework/fsn_activities/fishing/client.lua (47-60)
  - Example_Frameworks/FiveM-FSN-Framework/fsn_activities/hunting/client.lua (46-59)
  - Example_Frameworks/FiveM-FSN-Framework/fsn_activities/yoga/client.lua (48-61)
- **Signature(s)**: `createBlips()`
- **Purpose**: Generates map blips for activity locations.
- **Key Flows**:
  - Loops configured blip table and sets properties.
- **Natives Used**:
  - AddBlipForCoord — OK
  - SetBlipHighDetail — OK
  - SetBlipSprite — OK
  - SetBlipDisplay — OK
  - SetBlipScale — OK
  - SetBlipColour — OK
  - SetBlipAsShortRange — OK
  - BeginTextCommandSetBlipName — OK
  - AddTextComponentString — OK
  - EndTextCommandSetBlipName — OK
- **OneSync / Networking Notes**: Client-only blip creation; purely visual.
- **Examples**:
```lua
-- Create activity blips on resource start
CreateThread(function()
    createBlips()
end)
```
- **Security / Anti-Abuse**: Static data; no inputs.
- **References**:
  - https://docs.fivem.net/natives/

#### getNearestSpot
- **Name**: getNearestSpot
- **Type**: Client
- **Defined In**:
  - Example_Frameworks/FiveM-FSN-Framework/fsn_activities/fishing/client.lua (69-79)
  - Example_Frameworks/FiveM-FSN-Framework/fsn_activities/yoga/client.lua (70-80)
- **Signature(s)**: `getNearestSpot(playerPos)`
- **Purpose**: Returns closest predefined activity position.
- **Key Flows**:
  - Iterates configured vectors; tracks nearest.
- **Natives Used**: none.
- **OneSync / Networking Notes**: Local computation only.
- **Examples**:
```lua
local dist, pos = getNearestSpot(GetEntityCoords(PlayerPedId()))
```
- **Security / Anti-Abuse**: relies on trusted client data.
- **References**:
  - https://docs.fivem.net/docs/

#### cancelFishing
- **Name**: cancelFishing
- **Type**: Client
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_activities/fishing/client.lua (88-95)
- **Signature(s)**: `cancelFishing(ped)`
- **Purpose**: Stops fishing scenario and resets state.
- **Key Flows**:
  - Sends HUD note, clears ped tasks, resets flags.
- **Natives Used**:
  - ClearPedTasksImmediately — OK
- **OneSync / Networking Notes**: Client-only; no server notification.
- **Examples**:
```lua
if IsControlJustPressed(0, fishEndKey) then
    cancelFishing(PlayerPedId())
end
```
- **Security / Anti-Abuse**: none; affects local ped.
- **References**:
  - https://docs.fivem.net/natives/

#### startFishing
- **Name**: startFishing
- **Type**: Client
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_activities/fishing/client.lua (104-112)
- **Signature(s)**: `startFishing(ped)`
- **Purpose**: Plays fishing scenario and rewards fish.
- **Key Flows**:
  - Notifies user, starts scenario, waits random time, clears tasks.
- **Natives Used**:
  - TaskStartScenarioInPlace — OK
  - ClearPedTasksImmediately — OK
- **OneSync / Networking Notes**: Outcome not synced; server unaware.
- **Examples**:
```lua
fishing = true
startFishing(PlayerPedId())
fishing = false
```
- **Security / Anti-Abuse**: Local-only reward; vulnerable to client manipulation.
- **References**:
  - https://docs.fivem.net/natives/

#### spawnAnimal
- **Name**: spawnAnimal
- **Type**: Client
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_activities/hunting/client.lua (68-76)
- **Signature(s)**: `spawnAnimal(ped)`
- **Purpose**: Spawns roaming deer ahead of player.
- **Key Flows**:
  - Requests model, waits for load, creates ped, sets wander behavior.
- **Natives Used**:
  - GetHashKey — OK
  - RequestModel — OK
  - HasModelLoaded — OK
  - GetOffsetFromEntityInWorldCoords — OK
  - CreatePed — OK
  - TaskWanderStandard — OK
  - SetEntityAsMissionEntity — OK
- **OneSync / Networking Notes**: Spawned entity exists only client-side.
- **Examples**:
```lua
spawnAnimal(PlayerPedId())
```
- **Security / Anti-Abuse**: Clients can spawn peds freely; no validation.
- **References**:
  - https://docs.fivem.net/natives/

#### cancelHunt
- **Name**: cancelHunt
- **Type**: Client
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_activities/hunting/client.lua (85-91)
- **Signature(s)**: `cancelHunt()`
- **Purpose**: Cancels hunting session and removes animal.
- **Key Flows**:
  - Sends HUD note, deletes spawned entity.
- **Natives Used**:
  - DoesEntityExist — OK
  - DeleteEntity — OK
- **OneSync / Networking Notes**: Local cleanup; server not informed.
- **Examples**:
```lua
if IsControlJustPressed(0, huntEndKey) then
    cancelHunt()
end
```
- **Security / Anti-Abuse**: Local-only; no safeguards.
- **References**:
  - https://docs.fivem.net/natives/

#### startHunt
- **Name**: startHunt
- **Type**: Client
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_activities/hunting/client.lua (100-104)
- **Signature(s)**: `startHunt(ped)`
- **Purpose**: Begins hunt by spawning target and setting state.
- **Key Flows**:
  - Notifies user and calls `spawnAnimal`.
- **Natives Used**: none.
- **OneSync / Networking Notes**: No server sync; purely client.
- **Examples**:
```lua
if IsControlJustPressed(0, huntStartKey) then
    startHunt(PlayerPedId())
end
```
- **Security / Anti-Abuse**: No validation; client decides start.
- **References**:
  - https://docs.fivem.net/docs/

#### cancelYoga
- **Name**: cancelYoga
- **Type**: Client
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_activities/yoga/client.lua (89-93)
- **Signature(s)**: `cancelYoga(ped)`
- **Purpose**: Aborts yoga scenario.
- **Key Flows**:
  - Notifies user, clears ped task, resets flag.
- **Natives Used**:
  - ClearPedTasksImmediately — OK
- **OneSync / Networking Notes**: Local only.
- **Examples**:
```lua
cancelYoga(PlayerPedId())
```
- **Security / Anti-Abuse**: none.
- **References**:
  - https://docs.fivem.net/natives/

#### startYoga
- **Name**: startYoga
- **Type**: Client
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_activities/yoga/client.lua (102-109)
- **Signature(s)**: `startYoga(ped)`
- **Purpose**: Runs yoga scenario and triggers stress relief.
- **Key Flows**:
  - Shows message, waits, starts scenario, after 15s triggers `fsn_yoga:checkStress` and clears task.
- **Natives Used**:
  - TaskStartScenarioInPlace — OK
  - ClearPedTasksImmediately — OK
- **OneSync / Networking Notes**: Stress removal performed client-side; not validated server-side.
- **Examples**:
```lua
doingYoga = true
startYoga(PlayerPedId())
```
- **Security / Anti-Abuse**: Client can fake completion; no server check.
- **References**:
  - https://docs.fivem.net/natives/

#### getSteamIdentifier
- **Name**: getSteamIdentifier
- **Type**: Server
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/server/server.lua (32-38)
- **Signature(s)**: `getSteamIdentifier(src)`
- **Purpose**: Returns the Steam identifier for a player.
- **Key Flows**:
  - Iterates identifiers from `GetPlayerIdentifiers` and selects the `steam:` entry.
- **Natives Used**:
  - GetPlayerIdentifiers — OK
- **OneSync / Networking Notes**: depends on identifiers provided at connect time.
- **Examples**:
```lua
local steam = getSteamIdentifier(source)
```
- **Security / Anti-Abuse**: returns `nil` if no Steam identifier is present.
- **References**:
  - https://docs.fivem.net/docs/scripting-reference/runtimes/server/server-functions/#getplayeridentifiers

#### isModerator
- **Name**: isModerator
- **Type**: Server
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/server/server.lua (41-50)
- **Signature(s)**: `isModerator(src)`
- **Purpose**: Checks if a player's Steam ID is in the moderator list.
- **Key Flows**:
  - Uses `getSteamIdentifier` to resolve Steam ID.
- **Natives Used**: none
- **OneSync / Networking Notes**: relies on client identifiers; spoofing requires Steam override.
- **Examples**:
```lua
if isModerator(source) then
  -- allow staff action
end
```
- **Security / Anti-Abuse**: list is static; ensure Config.Moderators is secure.
- **References**:
  - https://docs.fivem.net/docs/

#### isAdmin
- **Name**: isAdmin
- **Type**: Server
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/server/server.lua (52-60)
- **Signature(s)**: `isAdmin(src)`
- **Purpose**: Validates if a player is an administrator.
- **Key Flows**:
  - Compares Steam ID against `Config.Admins`.
- **Natives Used**: none
- **OneSync / Networking Notes**: same trust considerations as `isModerator`.
- **Examples**:
```lua
if isAdmin(source) then
  registerAdminCommands()
end
```
- **Security / Anti-Abuse**: ensure Config.Admins is restricted.
- **References**:
  - https://docs.fivem.net/docs/

#### getModeratorName
- **Name**: getModeratorName
- **Type**: Server
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/server/server.lua (63-65)
- **Signature(s)**: `getModeratorName(src)`
- **Purpose**: Retrieves a moderator's display name.
- **Key Flows**:
  - Wrapper around `GetPlayerName`.
- **Natives Used**:
  - GetPlayerName — OK
- **OneSync / Networking Notes**: name reflects current session.
- **Examples**:
```lua
local name = getModeratorName(source)
```
- **Security / Anti-Abuse**: none.
- **References**:
  - https://docs.fivem.net/docs/scripting-reference/runtimes/server/server-functions/#getplayername

#### getAdminName
- **Name**: getAdminName
- **Type**: Server
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/server/server.lua (67-69)
- **Signature(s)**: `getAdminName(src)`
- **Purpose**: Retrieves an administrator's display name.
- **Key Flows**:
  - Calls `GetPlayerName` directly.
- **Natives Used**:
  - GetPlayerName — OK
- **OneSync / Networking Notes**: name is session-scoped.
- **Examples**:
```lua
local admin = getAdminName(source)
```
- **Security / Anti-Abuse**: none.
- **References**:
  - https://docs.fivem.net/docs/scripting-reference/runtimes/server/server-functions/#getplayername

#### registerModeratorCommands
- **Name**: registerModeratorCommands
- **Type**: Server
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/server/server.lua (71-85)
- **Signature(s)**: `registerModeratorCommands()`
- **Purpose**: Registers staff chat for moderators.
- **Key Flows**:
  - Adds `/sc` command that broadcasts to other moderators.
- **Natives Used**:
  - RegisterCommand — OK
  - GetPlayers — OK
  - TriggerClientEvent — OK
- **OneSync / Networking Notes**: uses server command routing; messages only sent to moderators.
- **Examples**:
```lua
registerModeratorCommands()
```
- **Security / Anti-Abuse**: command validates caller is moderator.
- **References**:
  - https://docs.fivem.net/docs/scripting-reference/runtimes/server/server-functions/#registercommand
  - https://docs.fivem.net/docs/scripting-reference/runtimes/server/server-functions/#getplayers
  - https://docs.fivem.net/docs/scripting-reference/runtimes/server/server-functions/#triggerclientevent

#### registerAdminCommands
- **Name**: registerAdminCommands
- **Type**: Server
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/server/server.lua (87-255)
- **Signature(s)**: `registerAdminCommands()`
- **Purpose**: Registers administrative commands (chat, menus, teleport, moderation).
- **Key Flows**:
  - Adds `/sc`, `/adminmenu`, `/amenu`, `/freeze`, `/announce`, `/goto`, `/bring`, `/kick`, and `/ban`.
- **Natives Used**:
  - RegisterCommand — OK
  - GetPlayers — OK
  - TriggerClientEvent — OK
  - DropPlayer — OK
- **OneSync / Networking Notes**: commands perform server authority actions like teleporting and kicking.
- **Examples**:
```lua
registerAdminCommands()
```
- **Security / Anti-Abuse**: every command checks `isAdmin` and validates inputs.
- **References**:
  - https://docs.fivem.net/docs/scripting-reference/runtimes/server/server-functions/#registercommand
  - https://docs.fivem.net/docs/scripting-reference/runtimes/server/server-functions/#dropplayer

#### registerModeratorSuggestions
- **Name**: registerModeratorSuggestions
- **Type**: Server
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/server/server.lua (258-264)
- **Signature(s)**: `registerModeratorSuggestions(source)`
- **Purpose**: Adds chat suggestions for moderator commands.
- **Key Flows**:
  - Sends `chat:addSuggestion` for `/sc`.
- **Natives Used**:
  - TriggerClientEvent — OK
- **OneSync / Networking Notes**: suggestion sent only if caller is moderator.
- **Examples**:
```lua
registerModeratorSuggestions(source)
```
- **Security / Anti-Abuse**: verifies `isModerator` before sending.
- **References**:
  - https://docs.fivem.net/docs/scripting-reference/runtimes/server/server-functions/#triggerclientevent

#### registerAdminSuggestions
- **Name**: registerAdminSuggestions
- **Type**: Server
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/server/server.lua (266-292)
- **Signature(s)**: `registerAdminSuggestions(source)`
- **Purpose**: Adds chat suggestions for admin commands.
- **Key Flows**:
  - Provides `/sc`, `/adminmenu`, `/amenu`, `/freeze`, `/goto`, `/bring`, `/kick`, `/ban` suggestions.
- **Natives Used**:
  - TriggerClientEvent — OK
- **OneSync / Networking Notes**: suggestions only sent to admins.
- **Examples**:
```lua
registerAdminSuggestions(source)
```
- **Security / Anti-Abuse**: validates admin status before sending.
- **References**:
  - https://docs.fivem.net/docs/scripting-reference/runtimes/server/server-functions/#triggerclientevent

#### inInstance
- **Name**: inInstance
- **Type**: Client (Export)
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/cl_instancing.lua (8-10)
- **Signature(s)**: `inInstance()`
- **Purpose**: Indicates whether the player is inside an apartment instance.
- **Key Flows**:
  - Returns boolean `instanced` flag.
- **Natives Used**: none
- **OneSync / Networking Notes**: state managed locally; exported for other resources.
- **Examples**:
```lua
if inInstance() then
  -- restrict interactions
end
```
- **Security / Anti-Abuse**: client-controlled; trust cautiously.
- **References**:
  - https://docs.fivem.net/docs/

#### table.contains
- **Name**: table.contains
- **Type**: Shared
- **Defined In**:
  - Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/cl_instancing.lua (73-79)
  - Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/sv_instancing.lua (64-71)
- **Signature(s)**: `table.contains(tbl, element)`
- **Purpose**: Utility to check if a table contains a value.
- **Key Flows**:
  - Iterates pairs and compares values.
- **Natives Used**: none
- **OneSync / Networking Notes**: none.
- **Examples**:
```lua
if table.contains(myinstance.players, id) then
  -- player is in instance
end
```
- **Security / Anti-Abuse**: none.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_drawText3D
- **Name**: fsn_drawText3D
- **Type**: Client
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua (4-20)
- **Signature(s)**: `fsn_drawText3D(x, y, z, text)`
- **Purpose**: Renders 3D world text at the given position.
- **Key Flows**:
  - Projects world coordinates to screen space and draws styled text.
- **Natives Used**:
  - World3dToScreen2d — OK
  - SetTextScale — OK
  - SetTextFont — OK
  - SetTextProportional — OK
  - SetTextColour — OK
  - SetTextDropshadow — OK
  - SetTextEdge — OK
  - SetTextDropShadow — OK
  - SetTextOutline — OK
  - SetTextEntry — OK
  - SetTextCentre — OK
  - AddTextComponentString — OK
  - DrawText — OK
- **OneSync / Networking Notes**: client-only rendering.
- **Examples**:
```lua
fsn_drawText3D(storage.x, storage.y, storage.z, 'Storage')
```
- **Security / Anti-Abuse**: none.
- **References**:
  - https://docs.fivem.net/natives/

#### nearPos
- **Name**: nearPos
- **Type**: Client
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua (26-27)
- **Signature(s)**: `nearPos(pos, radius)`
- **Purpose**: Checks player distance from a coordinate.
- **Key Flows**:
  - Compares `GetEntityCoords(PlayerPedId())` with target position.
- **Natives Used**:
  - GetEntityCoords — OK
- **OneSync / Networking Notes**: client spatial check.
- **Examples**:
```lua
if nearPos(storage, 0.5) then
  -- interact
end
```
- **Security / Anti-Abuse**: none.
- **References**:
  - https://docs.fivem.net/natives/?_0x3FEF770D40960D5A

#### EnterMyApartment
- **Name**: EnterMyApartment
- **Type**: Client
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua (68-70)
- **Signature(s)**: `EnterMyApartment()`
- **Purpose**: Enters the player into their assigned apartment.
- **Key Flows**:
  - Calls `EnterRoom` with the saved room number.
- **Natives Used**: none
- **OneSync / Networking Notes**: relies on local room state.
- **Examples**:
```lua
EnterMyApartment()
```
- **Security / Anti-Abuse**: ensure room number validated by server.
- **References**:
  - https://docs.fivem.net/docs/

#### EnterRoom
- **Name**: EnterRoom
- **Type**: Client
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua (432-442)
- **Signature(s)**: `EnterRoom(id)`
- **Purpose**: Teleports player to the apartment interior and creates an instance.
- **Key Flows**:
  - Fades screen, sets coordinates, triggers server instance creation.
- **Natives Used**:
  - DoScreenFadeOut — OK
  - SetEntityCoords — OK
  - DoScreenFadeIn — OK
  - TriggerServerEvent — OK
  - FreezeEntityPosition — OK
- **OneSync / Networking Notes**: server instance ownership assigned after teleport.
- **Examples**:
```lua
EnterRoom(5)
```
- **Security / Anti-Abuse**: validate `id` before teleport.
- **References**:
  - https://docs.fivem.net/natives/

#### ToggleActionMenu
- **Name**: ToggleActionMenu
- **Type**: Client
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua (265-288)
- **Signature(s)**: `ToggleActionMenu()`
- **Purpose**: Opens or closes the apartment storage menu.
- **Key Flows**:
  - Initializes inventory tables and toggles NUI focus.
- **Natives Used**:
  - SetNuiFocus — OK
  - SendNUIMessage — OK
- **OneSync / Networking Notes**: local UI only.
- **Examples**:
```lua
if nearPos(storage,0.5) then ToggleActionMenu() end
```
- **Security / Anti-Abuse**: restrict usage to apartment context.
- **References**:
  - https://docs.fivem.net/docs/

#### isNearStorage
- **Name**: isNearStorage
- **Type**: Client
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua (346-347)
- **Signature(s)**: `isNearStorage()`
- **Purpose**: Returns if player is near the apartment storage spot.
- **Key Flows**:
  - Exposes `instorage` state for other resources.
- **Natives Used**: none
- **OneSync / Networking Notes**: state local to client.
- **Examples**:
```lua
if isNearStorage() then ... end
```
- **Security / Anti-Abuse**: none.
- **References**:
  - https://docs.fivem.net/docs/

#### saveApartment
- **Name**: saveApartment
- **Type**: Client
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua (480-482)
- **Signature(s)**: `saveApartment()`
- **Purpose**: Persists apartment state to the server.
- **Key Flows**:
  - Triggers server save with current apartment details.
- **Natives Used**:
  - TriggerServerEvent — OK
- **OneSync / Networking Notes**: relies on server authority.
- **Examples**:
```lua
saveApartment()
```
- **Security / Anti-Abuse**: server validates data.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_closeATM
- **Name**: fsn_closeATM
- **Type**: Client
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_bank/client.lua (166-178)
- **Signature(s)**: `fsn_closeATM()`
- **Purpose**: Resets player state after leaving ATM UI.
- **Key Flows**:
  - Unfreezes player, removes focus, hides NUI.
- **Natives Used**:
  - FreezeEntityPosition — OK
  - SetEntityCollision — OK
  - ClearPedTasks — OK
  - SetNuiFocus — OK
  - SendNUIMessage — OK
- **OneSync / Networking Notes**: client local.
- **Examples**:
```lua
fsn_closeATM()
```
- **Security / Anti-Abuse**: prevents stuck state.
- **References**:
  - https://docs.fivem.net/natives/

#### getAvailableAppt
- **Name**: getAvailableAppt
- **Type**: Server
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/server.lua (55-67)
- **Signature(s)**: `getAvailableAppt(src)`
- **Purpose**: Finds or assigns an unoccupied apartment slot.
- **Key Flows**:
  - Iterates apartment list; marks slot occupied by `src`.
- **Natives Used**: none
- **OneSync / Networking Notes**: server-only logic.
- **Examples**:
```lua
local id = getAvailableAppt(source)
```
- **Security / Anti-Abuse**: ensures one apartment per source.
- **References**:
  - https://docs.fivem.net/docs/

### 5.4 Events — Detailed Entries

#### chat:addMessage
- **Event**: chat:addMessage
- **Direction**: Intra-Client
- **Type**: LocalEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/client/client.lua (78-88)
- **Payload**:
  - template:string
  - args:table
- **Typical Callers / Listeners**: called from admin freeze handler; handled by default chat resource.
- **Natives Used**: none
- **OneSync / Replication Notes**: local UI update only.
- **Examples**:
```lua
TriggerEvent('chat:addMessage', {template = 'Message', args = {}})
```
- **Security / Anti-Abuse**: relies on client; no rate limiting.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_admin:FreezeMe
- **Event**: fsn_admin:FreezeMe
- **Direction**: Server→Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/client/client.lua (74-93)
- **Payload**:
  - adminName:string
- **Typical Callers / Listeners**: Triggered by admin commands; listened by client to toggle freeze.
- **Natives Used**:
  - FreezeEntityPosition — OK
- **OneSync / Replication Notes**: freeze state is client-side; may desync without server checks.
- **Examples**:
```lua
TriggerClientEvent('fsn_admin:FreezeMe', targetId, 'Admin')
```
- **Security / Anti-Abuse**: requires server-side permission checks.
- **References**:
  - https://docs.fivem.net/natives/

#### fsn_admin:receiveXYZ
- **Event**: fsn_admin:receiveXYZ
- **Direction**: Server→Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/client/client.lua (69-72)
- **Payload**:
  - coords:vector3
- **Typical Callers / Listeners**: server sends coordinates; client teleports.
- **Natives Used**:
  - SetEntityCoords — OK
- **OneSync / Replication Notes**: teleport not validated server-side.
- **Examples**:
```lua
TriggerClientEvent('fsn_admin:receiveXYZ', player, GetEntityCoords(PlayerPedId()))
```
- **Security / Anti-Abuse**: ensure server validates sender.
- **References**:
  - https://docs.fivem.net/natives/

#### fsn_admin:requestXYZ
- **Event**: fsn_admin:requestXYZ
- **Direction**: Server→Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/client/client.lua (63-67)
- **Payload**:
  - sendto:number
- **Typical Callers / Listeners**: server requests coordinates; client responds via `fsn_admin:sendXYZ`.
- **Natives Used**:
  - GetEntityCoords — OK
- **OneSync / Replication Notes**: coordinate data sent without verification.
- **Examples**:
```lua
TriggerClientEvent('fsn_admin:requestXYZ', player, adminId)
```
- **Security / Anti-Abuse**: ensure only authorized admins invoke.
- **References**:
  - https://docs.fivem.net/natives/

#### fsn_admin:sendXYZ
- **Event**: fsn_admin:sendXYZ
- **Direction**: Client→Server
- **Type**: NetEvent
 - **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/client/client.lua (66); Example_Frameworks/FiveM-FSN-Framework/fsn_admin/server/server.lua (302-305)
- **Payload**:
  - sendto:number
  - coords:vector3
- **Typical Callers / Listeners**: client sends position to server; server teleports or relays.
- **Natives Used**: none
- **OneSync / Replication Notes**: trust boundary from client to server.
- **Examples**:
```lua
TriggerServerEvent('fsn_admin:sendXYZ', target, GetEntityCoords(PlayerPedId()))
```
- **Security / Anti-Abuse**: server must sanitize coordinates and source.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_admin:spawnVehicle
- **Event**: fsn_admin:spawnVehicle
- **Direction**: Server→Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/client/client.lua (39-61)
- **Payload**:
  - vehmodel:string
- **Typical Callers / Listeners**: admin command on server triggers; client spawns and owns vehicle.
- **Natives Used**:
  - PlayerPedId — OK
  - GetEntityCoords — OK
  - GetEntityHeading — OK
  - SetVehicleOnGroundProperly — OK
  - SetVehicleNumberPlateTextIndex — OK
  - SetPedIntoVehicle — OK
  - GetDisplayNameFromVehicleModel — OK
  - GetEntityModel — OK
  - GetVehicleNumberPlateText — OK
- **OneSync / Replication Notes**: vehicle ownership handled via subsequent events.
- **Examples**:
```lua
TriggerClientEvent('fsn_admin:spawnVehicle', player, 'adder')
```
- **Security / Anti-Abuse**: ensure server restricts usage to admins.
- **References**:
  - https://docs.fivem.net/natives/

#### fsn_cargarage:makeMine
- **Event**: fsn_cargarage:makeMine
- **Direction**: Intra-Client
- **Type**: LocalEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/client/client.lua (56)
- **Payload**:
  - vehicle:entity
  - name:string
  - plate:string
- **Typical Callers / Listeners**: triggered after vehicle spawn to transfer ownership; listener in cargarage resource.
- **Natives Used**:
  - GetDisplayNameFromVehicleModel — OK
  - GetEntityModel — OK
  - GetVehicleNumberPlateText — OK
- **OneSync / Replication Notes**: relies on client to inform garage.
- **Examples**:
```lua
TriggerEvent('fsn_cargarage:makeMine', veh, model, plate)
```
- **Security / Anti-Abuse**: susceptible to spoofing; validate server-side.
- **References**:
  - https://docs.fivem.net/natives/

#### fsn_needs:stress:remove
- **Event**: fsn_needs:stress:remove
- **Direction**: Intra-Client
- **Type**: LocalEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_activities/yoga/client.lua (148)
- **Payload**:
  - amount:number
- **Typical Callers / Listeners**: triggered after yoga to reduce stress; handled by needs system.
- **Natives Used**: none
- **OneSync / Replication Notes**: client-side stat change; vulnerable to manipulation.
- **Examples**:
```lua
TriggerEvent('fsn_needs:stress:remove', 10)
```
- **Security / Anti-Abuse**: server should validate stress removal.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_notify:displayNotification
- **Event**: fsn_notify:displayNotification
- **Direction**: Intra-Client
- **Type**: LocalEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/client/client.lua (58-59)
- **Payload**:
  - message:string
  - position:string
  - duration:number
  - style:string
- **Typical Callers / Listeners**: used to show HUD notifications; listener in notify resource.
- **Natives Used**: none
- **OneSync / Replication Notes**: UI only.
- **Examples**:
```lua
TriggerEvent('fsn_notify:displayNotification', 'Hello', 'centerLeft', 2000, 'info')
```
- **Security / Anti-Abuse**: spam risk; rate limit recommended.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_yoga:checkStress
- **Event**: fsn_yoga:checkStress
- **Direction**: Intra-Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_activities/yoga/client.lua (145-153)
- **Payload**: none
- **Typical Callers / Listeners**: triggered after yoga; listener removes stress.
- **Natives Used**: none
- **OneSync / Replication Notes**: not validated server-side.
- **Examples**:
```lua
TriggerEvent('fsn_yoga:checkStress')
```
- **Security / Anti-Abuse**: susceptible to manual triggering.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_admin:enableAdminCommands
- **Event**: fsn_admin:enableAdminCommands
- **Direction**: Client→Server
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/server/server.lua (307-310)
- **Payload**: `source:number`
- **Typical Callers / Listeners**: triggered when player is ready to provide admin chat suggestions.
- **Natives Used**:
  - TriggerClientEvent — OK
- **OneSync / Replication Notes**: suggestions sent to a single player.
- **Examples**:
```lua
TriggerEvent('fsn_admin:enableAdminCommands', playerId)
```
- **Security / Anti-Abuse**: only invoke for verified admins.
- **References**:
  - https://docs.fivem.net/docs/scripting-reference/runtimes/server/server-functions/#triggerclientevent

#### fsn_admin:enableModeratorCommands
- **Event**: fsn_admin:enableModeratorCommands
- **Direction**: Client→Server
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/server/server.lua (312-315)
- **Payload**: `source:number`
- **Typical Callers / Listeners**: enables moderator command suggestions.
- **Natives Used**:
  - TriggerClientEvent — OK
- **OneSync / Replication Notes**: single-target suggestion dispatch.
- **Examples**:
```lua
TriggerEvent('fsn_admin:enableModeratorCommands', playerId)
```
- **Security / Anti-Abuse**: verify moderator status before calling.
- **References**:
  - https://docs.fivem.net/docs/scripting-reference/runtimes/server/server-functions/#triggerclientevent

#### fsn:playerReady
- **Event**: fsn:playerReady
- **Direction**: Client→Server
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_admin/server/server.lua (317-327)
- **Payload**: none
- **Typical Callers / Listeners**: client notifies server on spawn; server assigns command suggestions.
- **Natives Used**:
  - TriggerEvent — OK
- **OneSync / Replication Notes**: depends on source id; processed after brief delay.
- **Examples**:
```lua
TriggerServerEvent('fsn:playerReady')
```
- **Security / Anti-Abuse**: ensure server checks permissions after trigger.
- **References**:
  - https://docs.fivem.net/docs/scripting-reference/runtimes/server/server-functions/#triggerevent

#### fsn_apartments:instance:join
- **Event**: fsn_apartments:instance:join
- **Direction**: Server→Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/cl_instancing.lua (51-55)
- **Payload**: `inst:table`
- **Typical Callers / Listeners**: server assigns player to an instance; client sets state.
- **Natives Used**: none
- **OneSync / Replication Notes**: affects local visibility.
- **Examples**:
```lua
AddEventHandler('fsn_apartments:instance:join', function(inst) ... end)
```
- **Security / Anti-Abuse**: server controls membership to prevent spoofing.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_apartments:instance:update
- **Event**: fsn_apartments:instance:update
- **Direction**: Server→Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/cl_instancing.lua (57-60)
- **Payload**: `inst:table`
- **Typical Callers / Listeners**: server updates instance player list.
- **Natives Used**: none
- **OneSync / Replication Notes**: provides synchronized instance data.
- **Examples**:
```lua
AddEventHandler('fsn_apartments:instance:update', function(inst) ... end)
```
- **Security / Anti-Abuse**: rely on server authority.
- **References**:
  - https://docs.fivem.net/docs/

#### depositMoney
- **Event**: depositMoney
- **Direction**: NUI→Client
- **Type**: NUI
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_bank/client.lua (179-213)
- **Payload**: `tbl` {deposit:number, atbank:boolean}
- **Typical Callers / Listeners**: ATM UI posts form data; client validates and updates wallet/bank.
- **Natives Used**:
  - TriggerEvent — OK
  - TriggerServerEvent — OK
- **OneSync / Replication Notes**: balance changes synced via follow-up events.
- **Examples**:
```lua
RegisterNUICallback('depositMoney', function(data) ... end)
```
- **Security / Anti-Abuse**: amount capped at $500k and requires bank context.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_apartments:characterCreation
- **Event**: fsn_apartments:characterCreation
- **Direction**: Server→Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua (447-469)
- **Payload**: none
- **Typical Callers / Listeners**: server instructs client to begin character creation flow.
- **Natives Used**:
  - TriggerServerEvent — OK
  - SetEntityCoords — OK
- **OneSync / Replication Notes**: player frozen during creation; instance created server-side.
- **Examples**:
```lua
AddEventHandler('fsn_apartments:characterCreation', function() ... end)
```
- **Security / Anti-Abuse**: restricted to new characters.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_apartments:inv:update
- **Event**: fsn_apartments:inv:update
- **Direction**: Intra-Client
- **Type**: LocalEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua (292-295)
- **Payload**: `tbl:table`
- **Typical Callers / Listeners**: inventory resource sends updated apartment inventory.
- **Natives Used**: none
- **OneSync / Replication Notes**: client-side cache refresh only.
- **Examples**:
```lua
AddEventHandler('fsn_apartments:inv:update', function(t) ... end)
```
- **Security / Anti-Abuse**: trust source resource.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_apartments:outfit:add
- **Event**: fsn_apartments:outfit:add (Aliases: fsn_apartments:outfit:use, fsn_apartments:outfit:remove, fsn_apartments:outfit:list)
- **Direction**: Server→Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua (141-190)
- **Payload**: varies (`key:string` or none)
- **Typical Callers / Listeners**: server relays outfit management commands; client updates wardrobe.
- **Natives Used**:
  - TriggerEvent — OK
  - TriggerServerEvent — OK
- **OneSync / Replication Notes**: wardrobe state synchronized through server saves.
- **Examples**:
```lua
TriggerEvent('fsn_apartments:outfit:add', 'casual')
```
- **Security / Anti-Abuse**: requires proximity to wardrobe.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_apartments:sendApartment
- **Event**: fsn_apartments:sendApartment
- **Direction**: Server→Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua (72-139)
- **Payload**: `tbl` {number:int, apptinfo:table}
- **Typical Callers / Listeners**: server provides apartment data to player after login.
- **Natives Used**:
  - TriggerEvent — OK
- **OneSync / Replication Notes**: sets local apartment state.
- **Examples**:
```lua
AddEventHandler('fsn_apartments:sendApartment', function(data) ... end)
```
- **Security / Anti-Abuse**: server validates ownership before send.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_apartments:stash:add
- **Event**: fsn_apartments:stash:add
- **Direction**: Server→Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua (30-49)
- **Payload**: `amt:number`
- **Typical Callers / Listeners**: server command deposits cash into apartment stash.
- **Natives Used**:
  - TriggerEvent — OK
  - TriggerServerEvent — OK
- **OneSync / Replication Notes**: server persists stash after client update.
- **Examples**:
```lua
TriggerClientEvent('fsn_apartments:stash:add', src, 1000)
```
- **Security / Anti-Abuse**: enforces 150k stash limit and affordability.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_apartments:stash:take
- **Event**: fsn_apartments:stash:take
- **Direction**: Server→Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/client.lua (51-66)
- **Payload**: `amt:number`
- **Typical Callers / Listeners**: server command withdraws cash from stash.
- **Natives Used**:
  - TriggerEvent — OK
  - TriggerServerEvent — OK
- **OneSync / Replication Notes**: stash balance synchronized after withdrawal.
- **Examples**:
```lua
TriggerClientEvent('fsn_apartments:stash:take', src, 500)
```
- **Security / Anti-Abuse**: ensures player has sufficient stash funds.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_bank:update:both
- **Event**: fsn_bank:update:both
- **Direction**: Server→Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_bank/client.lua (90-99)
- **Payload**: `wallet:number`, `bank:number`
- **Typical Callers / Listeners**: server sends wallet and bank balances.
- **Natives Used**:
  - SendNUIMessage — OK
- **OneSync / Replication Notes**: keeps client HUD in sync.
- **Examples**:
```lua
TriggerClientEvent('fsn_bank:update:both', src, wallet, bank)
```
- **Security / Anti-Abuse**: values sourced from server database.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_bank:change:bankAdd
- **Event**: fsn_bank:change:bankAdd
- **Direction**: Server→Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_bank/client.lua (101-109)
- **Payload**: `amount:number`
- **Typical Callers / Listeners**: server notifies client of bank deposit.
- **Natives Used**:
  - SendNUIMessage — OK
- **OneSync / Replication Notes**: HUD update only.
- **Examples**:
```lua
TriggerClientEvent('fsn_bank:change:bankAdd', src, 200)
```
- **Security / Anti-Abuse**: amounts validated server-side.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_bank:change:bankMinus
- **Event**: fsn_bank:change:bankMinus
- **Direction**: Server→Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_bank/client.lua (111-119)
- **Payload**: `amount:number`
- **Typical Callers / Listeners**: server notifies client of bank withdrawal.
- **Natives Used**:
  - SendNUIMessage — OK
- **OneSync / Replication Notes**: HUD update only.
- **Examples**:
```lua
TriggerClientEvent('fsn_bank:change:bankMinus', src, 200)
```
- **Security / Anti-Abuse**: amounts validated server-side.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_bank:change:bankandwallet
- **Event**: fsn_bank:change:bankandwallet
- **Direction**: Intra-Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_bank/client.lua (84,207-208,242)
- **Payload**: `wallet:number`, `bank:number`
- **Typical Callers / Listeners**: NUI deposit/withdraw callbacks emit to sync balances; core money system listens.
- **Natives Used**:
  - TriggerEvent — OK
- **OneSync / Replication Notes**: Local broadcast; external listener should persist.
- **Examples**:
```lua
TriggerEvent('fsn_bank:change:bankandwallet', new_wallet, new_bank)
```
- **Security / Anti-Abuse**: trusts client-supplied amounts.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_bank:database:update
- **Event**: fsn_bank:database:update
- **Direction**: Client→Server
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_bank/server.lua (1-15)
- **Payload**: `charid:number`, `wallet:number|false`, `bank:number|false`
- **Typical Callers / Listeners**: resources persist wallet/bank columns after transactions.
- **Natives Used**: none
- **OneSync / Replication Notes**: Uses synchronous MySQL queries; heavy use may block.
- **Examples**:
```lua
TriggerServerEvent('fsn_bank:database:update', charId, wallet, bank)
```
- **Security / Anti-Abuse**: input unvalidated; server trusts caller.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_bank:request:both
- **Event**: fsn_bank:request:both
- **Direction**: Intra-Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_bank/client.lua (85,144)
- **Payload**: none
- **Typical Callers / Listeners**: ATM interaction requests balance data from core.
- **Natives Used**:
  - TriggerEvent — OK
- **OneSync / Replication Notes**: expects external handler to reply with balances.
- **Examples**:
```lua
TriggerEvent('fsn_bank:request:both')
```
- **Security / Anti-Abuse**: none.
- **References**:
  - https://docs.fivem.net/docs/
- **Limitations / Notes**: TODO(next-run): verify server handler.

#### fsn_bank:transfer
- **Event**: fsn_bank:transfer
- **Direction**: Client→Server
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_bank/server.lua (17-36)
- **Payload**: `receive:number`, `amount:number`
- **Typical Callers / Listeners**: triggered by `transferMoney` NUI callback to move funds between players.
- **Natives Used**:
  - GetPlayerName — OK
  - TriggerClientEvent — OK
  - TriggerEvent — OK
- **OneSync / Replication Notes**: sender and receiver balances updated on server; database persistence handled separately.
- **Examples**:
```lua
TriggerServerEvent('fsn_bank:transfer', targetId, amount)
```
- **Security / Anti-Abuse**: validates target online and funds ≥ amount; no further checks.
- **References**:
  - https://docs.fivem.net/natives/  
  - https://docs.fivem.net/docs/
- **Limitations / Notes**: TODO(next-run): confirm logging of failed transfers.

#### fsn_main:displayBankandMoney
- **Event**: fsn_main:displayBankandMoney
- **Direction**: Intra-Client
- **Type**: LocalEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_bank/client.lua (172)
- **Payload**: none
- **Typical Callers / Listeners**: `fsn_closeATM` restores HUD via core listener.
- **Natives Used**:
  - TriggerEvent — OK
- **OneSync / Replication Notes**: local HUD update.
- **Examples**:
```lua
TriggerEvent('fsn_main:displayBankandMoney')
```
- **Security / Anti-Abuse**: none.
- **References**:
  - https://docs.fivem.net/docs/
- **Limitations / Notes**: TODO(next-run): locate handler in fsn_main.

#### fsn_main:logging:addLog
- **Event**: fsn_main:logging:addLog
- **Direction**: Client→Server
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_bank/client.lua (208,243)
- **Payload**: `playerId:number`, `category:string`, `text:string`
- **Typical Callers / Listeners**: deposit and withdraw callbacks log transactions on the server.
- **Natives Used**:
  - TriggerServerEvent — OK
- **OneSync / Replication Notes**: server decides log persistence.
- **Examples**:
```lua
TriggerServerEvent('fsn_main:logging:addLog', GetPlayerServerId(PlayerId()), 'money', message)
```
- **Security / Anti-Abuse**: client can spoof message contents.
- **References**:
  - https://docs.fivem.net/docs/
- **Limitations / Notes**: TODO(next-run): verify server-side sanitization.

#### fsn_phones:SYS:addTransaction
- **Event**: fsn_phones:SYS:addTransaction
- **Direction**: Intra-Client
- **Type**: LocalEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_bank/client.lua (201-206,236-241)
- **Payload**: `{title:string, trantype:string, systype:string, tranamt:number}`
- **Typical Callers / Listeners**: banking callbacks log transactions to the phone app.
- **Natives Used**:
  - TriggerEvent — OK
- **OneSync / Replication Notes**: purely client; no server sync.
- **Examples**:
```lua
TriggerEvent('fsn_phones:SYS:addTransaction', {title='Bank Deposit', trantype='CREDIT', systype='credit', tranamt=deposit})
```
- **Security / Anti-Abuse**: client controls log content.
- **References**:
  - https://docs.fivem.net/docs/
- **Limitations / Notes**: TODO(next-run): confirm phone app persistence.
#### fsn_apartments:instance:leave
- **Event**: fsn_apartments:instance:leave
- **Direction**: Server→Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/cl_instancing.lua (62-66)
- **Payload**: none
- **Typical Callers / Listeners**: server removes player from instance and resets state.
- **Natives Used**: none
- **OneSync / Replication Notes**: resets density multipliers client-side.
- **Examples**:
```lua
AddEventHandler('fsn_apartments:instance:leave', function() instanced=false end)
```
- **Security / Anti-Abuse**: server should validate requester is member.
- **References**:
  - https://docs.fivem.net/docs/

#### fsn_apartments:instance:debug
- **Event**: fsn_apartments:instance:debug
- **Direction**: Server→Client
- **Type**: NetEvent
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_apartments/cl_instancing.lua (68-70)
- **Payload**: none
- **Typical Callers / Listeners**: toggles instance debug overlay.
- **Natives Used**: none
- **OneSync / Replication Notes**: local visualization only.
- **Examples**:
```lua
TriggerEvent('fsn_apartments:instance:debug')
```
- **Security / Anti-Abuse**: restrict to developers to avoid spam.
- **References**:
  - https://docs.fivem.net/docs/
-
#### toggleGUI
- **Event**: toggleGUI
- **Direction**: NUI→Client
- **Type**: NUI
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_bank/client.lua (271-273)
- **Payload**: none
- **Typical Callers / Listeners**: ATM UI requests close; client invokes `fsn_closeATM`.
- **Natives Used**: none
- **OneSync / Replication Notes**: UI-local; no network traffic.
- **Examples**:
```lua
RegisterNUICallback('toggleGUI', function() fsn_closeATM() end)
```
- **Security / Anti-Abuse**: none.
- **References**:
  - https://docs.fivem.net/docs/

#### transferMoney
- **Event**: transferMoney
- **Direction**: NUI→Client
- **Type**: NUI
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_bank/client.lua (250-269)
- **Payload**: `tbl` {transferAmount:number, transferTo:number}
- **Typical Callers / Listeners**: ATM UI posts transfer form; client forwards to server via `fsn_bank:transfer`.
- **Natives Used**:
  - TriggerServerEvent — OK
  - TriggerEvent — OK
- **OneSync / Replication Notes**: server processes transfer; client updates on response.
- **Examples**:
```lua
RegisterNUICallback('transferMoney', function(data)
  TriggerServerEvent('fsn_bank:transfer', tonumber(data.transferTo), tonumber(data.transferAmount))
end)
```
- **Security / Anti-Abuse**: amount capped at $500k; client-side validation only.
- **References**:
  - https://docs.fivem.net/docs/

#### withdrawMoney
- **Event**: withdrawMoney
- **Direction**: NUI→Client
- **Type**: NUI
- **Defined In**: Example_Frameworks/FiveM-FSN-Framework/fsn_bank/client.lua (215-248)
- **Payload**: `tbl` {withdraw:number}
- **Typical Callers / Listeners**: ATM UI posts withdrawal; client adjusts balances and logs.
- **Natives Used**:
  - TriggerEvent — OK
  - TriggerServerEvent — OK
- **OneSync / Replication Notes**: server notified only through follow-up events.
- **Examples**:
```lua
RegisterNUICallback('withdrawMoney', function(data) ... end)
```
- **Security / Anti-Abuse**: capped at $500k; server trusts client.
- **References**:
  - https://docs.fivem.net/docs/

## Similarity Merge Report
- Canonicalized identical helper functions.
- Merged `createBlips` definitions (fishing, hunting, yoga).
- Merged `getNearestSpot` definitions (fishing, yoga).
- Grouped outfit management events under `fsn_apartments:outfit:add`.
- TODO(next-run): review other activity helpers for consolidation.
- TODO(next-run): reconcile duplicated instance events across client/server.

## Troubleshooting & Profiling Hooks
- TODO(next-run): document recommended debug commands and profiling tools.

## References
- https://docs.fivem.net/docs/
- https://docs.fivem.net/natives/

## PROGRESS MARKERS (EOF)

CONTINUE-HERE — 2025-09-13T00:43:16+00:00 — next: FiveM-FSN-Framework/fsn_bankrobbery/agents.md @ line 1
MERGE-QUEUE — 2025-09-13T00:43:16+00:00 — remaining: 0 (top 5: n/a)
