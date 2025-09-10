local displaying = {}

--[[
    -- Type: Function
    -- Name: fetchHeatmapData
    -- Use: Retrieves heatmap entries from the database
    -- Created: 2024-05-16
    -- By: VSSVSSN
--]]
local function fetchHeatmapData()
    local p = promise.new()
    exports['ghmattimysql']:execute('SELECT coords, reason FROM heatmap', {}, function(rows)
        p:resolve(rows)
    end)
    return Citizen.Await(p)
end

--[[
    -- Type: Event Handler
    -- Name: heatmap:display
    -- Use: Toggles heatmap visibility for a player
    -- Created: 2024-05-16
    -- By: VSSVSSN
--]]
RegisterNetEvent('heatmap:display', function()
    local src = source
    if displaying[src] then
        TriggerClientEvent('heatmap:clear', src)
        displaying[src] = nil
        return
    end

    local result = fetchHeatmapData() or {}
    local locations = {}
    for _, row in ipairs(result) do
        locations[#locations + 1] = {row.coords, row.reason}
    end

    TriggerClientEvent('heatmap:set', src, locations)
    displaying[src] = true
end)

AddEventHandler('playerDropped', function()
    displaying[source] = nil
end)

