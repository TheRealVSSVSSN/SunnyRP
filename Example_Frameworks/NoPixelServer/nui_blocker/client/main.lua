--[[
    -- Type: Callback
    -- Name: detectDevtools
    -- Use: Notifies the server when NUI devtools are opened
    -- Created: 2024-03-09
    -- By: VSSVSSN
--]]

RegisterNUICallback('detectDevtools', function(_, cb)
    TriggerServerEvent('nui_blocker:devtoolsDetected')
    if cb then cb('ok') end
end)

