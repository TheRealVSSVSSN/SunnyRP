--[[
    -- Type: Client Script
    -- Name: rconlog_client.lua
    -- Use: Sends player activation and name data to the server for RCON logging
    -- Created: 2024-05-23
    -- By: VSSVSSN
--]]

RegisterNetEvent('rlUpdateNames')

--[[
    -- Type: Function
    -- Name: onUpdateNames
    -- Use: Collects all active player names and forwards them to the server
    -- Created: 2024-05-23
    -- By: VSSVSSN
--]]
local function onUpdateNames()
    local names = {}

    for _, player in ipairs(GetActivePlayers()) do
        names[GetPlayerServerId(player)] = { id = player, name = GetPlayerName(player) }
    end

    TriggerServerEvent('rlUpdateNamesResult', names)
end
AddEventHandler('rlUpdateNames', onUpdateNames)

--[[
    -- Type: Thread
    -- Name: activationThread
    -- Use: Waits for the network session and notifies the server once ready
    -- Created: 2024-05-23
    -- By: VSSVSSN
--]]
CreateThread(function()
    while not NetworkIsSessionStarted() do
        Wait(500)
    end

    TriggerServerEvent('rlPlayerActivated')
end)

