--[[
    -- Type: Server Script
    -- Name: hardcap server.lua
    -- Use: Enforces player limit defined by sv_maxclients
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

local activePlayers = {}

-- seed active players in case of resource restart
for _, id in ipairs(GetPlayers()) do
    activePlayers[tonumber(id)] = true
end

local function countPlayers()
    local count = 0
    for _ in pairs(activePlayers) do
        count = count + 1
    end
    return count
end

AddEventHandler('playerConnecting', function(name, setReason, deferrals)
    local maxPlayers = GetConvarInt('sv_maxclients', 32)
    if countPlayers() >= maxPlayers then
        setReason(('This server is full (past %d players).'):format(maxPlayers))
        CancelEvent()
        return
    end

    activePlayers[source] = true
end)

AddEventHandler('playerDropped', function()
    activePlayers[source] = nil
end)

