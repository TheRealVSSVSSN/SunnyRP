local blips = {}

local reasonColors = {
    ["Game crashed: green-music-cola (gta-core-five.dll+4A8E0)"] = 2,
    ["Game crashed: mockingbird-two-purple (GTA5+AA7719)"] = 58
}

--[[
    -- Type: Function
    -- Name: clearHeatMap
    -- Use: Removes all heatmap blips from the map
    -- Created: 2024-05-16
    -- By: VSSVSSN
--]]
local function clearHeatMap()
    for id, blip in pairs(blips) do
        RemoveBlip(blip)
        blips[id] = nil
    end
end
RegisterNetEvent('heatmap:clear', clearHeatMap)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        clearHeatMap()
    end
end)

--[[
    -- Type: Function
    -- Name: setHeatMap
    -- Use: Draws blips for crash locations provided by the server
    -- Created: 2024-05-16
    -- By: VSSVSSN
--]]
local function setHeatMap(locations)
    clearHeatMap()
    for k, v in ipairs(locations) do
        local pos = json.decode(v[1])
        local blip = AddBlipForCoord(pos[1], pos[2], pos[3])
        SetBlipCategory(blip, 2)
        SetBlipAsShortRange(blip, false)
        local color = reasonColors[v[2]] or 81
        SetBlipColour(blip, color)
        SetBlipScale(blip, 1.0)
        blips[k] = blip
    end
end
RegisterNetEvent('heatmap:set', setHeatMap)

