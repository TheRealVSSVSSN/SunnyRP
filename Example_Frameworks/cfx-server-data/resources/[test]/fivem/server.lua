--[[
    -- Type: Event Handler
    -- Name: handlePlayerJoin
    -- Use: Welcomes players and logs join events to the server console
    -- Created: 10 Sep 2025
    -- By: VSSVSSN
--]]
local function handlePlayerJoin()
    local src = source
    local playerName = GetPlayerName(src)
    print(('[FiveM Test] %s joined the server (ID: %s)'):format(playerName, src))
    TriggerClientEvent('fivem:welcome', src, ('Welcome %s to the server!'):format(playerName))
end

AddEventHandler('playerJoining', handlePlayerJoin)
