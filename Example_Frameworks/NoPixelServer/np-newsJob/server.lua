--[[
    -- Type: Server
    -- Name: Light manager
    -- Use: Handles placement and removal of news lights
    -- Created: 2024-05-06
    -- By: VSSVSSN
--]]

local lights = {}

RegisterNetEvent('light:addNews')
AddEventHandler('light:addNews', function(rgb, id, pos)
    local light = {pos = pos, Object = id, rgb = rgb}
    lights[#lights + 1] = light
    TriggerClientEvent('news:updateLights', -1, lights)
end)

RegisterNetEvent('news:removeLight')
AddEventHandler('news:removeLight', function()
    for _, v in ipairs(lights) do
        TriggerClientEvent('light:removeLight', -1, v.Object)
    end
    lights = {}
end)

