--[[
    -- Type: Event
    -- Name: rlUpdateNames
    -- Use: Sends active player identifiers and names to the server
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
RegisterNetEvent('rlUpdateNames', function()
    local names = {}

    for _, player in ipairs(GetActivePlayers()) do
        names[GetPlayerServerId(player)] = { id = player, name = GetPlayerName(player) }
    end

    TriggerServerEvent('rlUpdateNamesResult', names)
end)

--[[
    -- Type: Thread
    -- Name: SessionWatcher
    -- Use: Notifies the server when the client session becomes active
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
CreateThread(function()
    while true do
        Wait(500)

        if NetworkIsSessionStarted() then
            TriggerServerEvent('rlPlayerActivated')
            break
        end
    end
end)

