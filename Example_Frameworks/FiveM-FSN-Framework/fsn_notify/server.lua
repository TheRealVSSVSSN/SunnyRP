--[[ 
    -- Type: Function
    -- Name: fsn_notify:displayNotification
    -- Use: Sends a notification to a target client
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_notify:displayNotification', function(target, msg, place, time, nType)
    local playerId = target or source
    if not msg then return end
    TriggerClientEvent('pNotify:SendNotification', playerId, {
        text = msg,
        layout = place or 'topRight',
        timeout = time or 5000,
        type = nType or 'info'
    })
end)
