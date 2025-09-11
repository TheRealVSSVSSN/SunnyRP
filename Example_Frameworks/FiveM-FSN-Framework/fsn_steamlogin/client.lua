--[[
    -- Type: Client Script
    -- Name: Steam Login Client
    -- Use: Notifies server when resource starts to update player session
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]

--[[
    -- Type: Event
    -- Name: onClientResourceStart
    -- Use: Sends ready notification to server
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
AddEventHandler('onClientResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        TriggerServerEvent('fsn_steamlogin:clientReady')
    end
end)
