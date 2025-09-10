--[[
    -- Type: Event
    -- Name: coordsaver:savePosition
    -- Use: Captures player coordinates and sends them to the server
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('coordsaver:savePosition', function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    TriggerServerEvent('coordsaver:save', coords.x, coords.y, coords.z)
end)

--[[
    -- Type: Command
    -- Name: /savepos
    -- Use: Saves the player's current position to a server file
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterCommand('savepos', function()
    TriggerEvent('coordsaver:savePosition')
    print('Coordinates saved')
end, false)

