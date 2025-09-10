local NPX = NPX or {}
NPX.Scoreboard = {}
NPX._Scoreboard = {
    Players = {},
    Recent = {}
}

--[[
    -- Type: Function
    -- Name: GetPlayerData
    -- Use: Builds scoreboard entry for a player source
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function GetPlayerData(src)
    local identifiers = GetPlayerIdentifiers(src)
    local steamIdentifier
    for _, v in ipairs(identifiers) do
        if string.find(v, "steam") then
            steamIdentifier = v
            break
        end
    end
    local stid = HexIdToSteamId(steamIdentifier)
    local ply = GetPlayerName(src)
    local scomid = steamIdentifier and steamIdentifier:gsub("steam:", "") or ""
    return { src = src, steamid = stid, comid = scomid, name = ply }
end

--[[
    -- Type: Event
    -- Name: playerJoining
    -- Use: Adds new player to scoreboard and syncs data
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
AddEventHandler('playerJoining', function()
    local src = source
    local data = GetPlayerData(src)
    NPX._Scoreboard.Players[src] = data
    TriggerClientEvent('np-scoreboard:AddPlayer', -1, data)
    TriggerClientEvent('np-scoreboard:Sync', src, NPX._Scoreboard.Players, NPX._Scoreboard.Recent)
end)

--[[
    -- Type: Event
    -- Name: playerDropped
    -- Use: Moves player to recent list and notifies clients
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
AddEventHandler('playerDropped', function()
    local src = source
    local data = NPX._Scoreboard.Players[src] or GetPlayerData(src)
    NPX._Scoreboard.Players[src] = nil
    NPX._Scoreboard.Recent[src] = data
    TriggerClientEvent('np-scoreboard:RemovePlayer', -1, data)
    SetTimeout(600000, function()
        NPX._Scoreboard.Recent[src] = nil
        TriggerClientEvent('np-scoreboard:RemoveRecent', -1, src)
    end)
end)

--[[
    -- Type: Function
    -- Name: HexIdToSteamId
    -- Use: Converts hexadecimal identifier to Steam ID format
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function HexIdToSteamId(hexId)
    local cid = math.floor(tonumber(string.sub(hexId, 7), 16))
    local steam64 = math.floor(tonumber(string.sub(cid, 2)))
    local a = steam64 % 2 == 0 and 0 or 1
    local b = math.floor(math.abs(6561197960265728 - steam64 - a) / 2)
    local sid = 'STEAM_0:' .. a .. ':' .. (a == 1 and b - 1 or b)
    return sid
end

