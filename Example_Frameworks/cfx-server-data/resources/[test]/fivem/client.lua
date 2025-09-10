--[[
    -- Type: Event Handler
    -- Name: displayWelcomeMessage
    -- Use: Displays welcome messages sent from the server
    -- Created: 10 Sep 2025
    -- By: VSSVSSN
--]]
RegisterNetEvent('fivem:welcome')
AddEventHandler('fivem:welcome', function(message)
    TriggerEvent('chat:addMessage', {
        color = {255, 255, 0},
        args = {'Server', message}
    })
end)

--[[
    -- Type: Event Handler
    -- Name: onResourceStart
    -- Use: Notifies the player when this client script initializes
    -- Created: 10 Sep 2025
    -- By: VSSVSSN
--]]
AddEventHandler('onClientResourceStart', function(resName)
    if resName ~= GetCurrentResourceName() then return end
    print('[FiveM Test] Client script initialized.')
end)
