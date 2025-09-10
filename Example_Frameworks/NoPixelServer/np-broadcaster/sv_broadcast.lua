--[[
    -- Type: Event
    -- Name: attemptBroadcast
    -- Use: Assigns the broadcaster job if slots are available
    -- Created: 2024-02-16
    -- By: VSSVSSN
--]]
RegisterNetEvent('attemptBroadcast')
AddEventHandler('attemptBroadcast', function()
    local src = source
    local user = exports['np-base']:getModule('Player'):GetUser(src)
    local jobManager = exports['np-base']:getModule('JobManager')
    local active = jobManager:CountJob('broadcaster')

    if active >= 5 then
        TriggerClientEvent('DoLongHudText', src, 'There are already too many broadcasters here', 2)
        return
    end

    jobManager:SetJob(user, 'broadcaster', false, function()
        TriggerClientEvent('broadcast:becomejob', src)
    end)
end)
