--[[
    -- Type: Server
    -- Name: fsn_clothing server
    -- Use: Handles default outfit assignment and saving
    -- Created: 2024-09-10
    -- By: VSSVSSN
--]]

local default_models = {
    1413662315,-781039234,1077785853,2021631368,1423699487,1068876755,2120901815,-106498753,
    131961260,-1806291497,1641152947,115168927,330231874,-1444213182,1809430156,1822107721,
    2064532783,-573920724,-782401935,808859815,-1106743555,-1606864033,1004114196,532905404,
    1699403886,-1656894598,1674107025,-88831029,-1244692252,951767867,1388848350,1090617681,
    379310561,-569505431,-1332260293,-840346158
}

local function buildDefault()
    return {
        model = default_models[math.random(#default_models)],
        new = true,
        clothing = {drawables = {0,0,0,0,0,0,0,0,0,0,0,0},textures = {2,0,1,1,0,0,0,0,0,0,0,0},palette = {0,0,0,0,0,0,0,0,0,0,0,0}},
        props = {drawables = {-1,-1,-1,-1,-1,-1,-1,-1}, textures = {-1,-1,-1,-1,-1,-1,-1,-1}},
        overlays = {drawables = {-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1}, opacity = {1,1,1,1,1,1,1,1,1,1,1,1,1}, colours = {{colourType = 0, colour = 0},{colourType = 0, colour = 0},{colourType = 0, colour = 0},{colourType = 0, colour = 0},{colourType = 0, colour = 0},{colourType = 0, colour = 0},{colourType = 0, colour = 0},{colourType = 0, colour = 0},{colourType = 0, colour = 0},{colourType = 0, colour = 0},{colourType = 0, colour = 0},{colourType = 0, colour = 0},{colourType = 0, colour = 0}}}
    }
end

--[[
    -- Type: Event
    -- Name: clothes:firstspawn
    -- Use: Sends a default outfit to new players
--]]
RegisterNetEvent("clothes:firstspawn", function()
    local src = source
    print('source has no clothes, sending some')
    TriggerClientEvent("clothes:spawn", src, buildDefault())
end)

--[[
    -- Type: Event
    -- Name: fsn_clothing:requestDefault
    -- Use: Provides default outfit on request
--]]
RegisterNetEvent('fsn_clothing:requestDefault', function()
    local src = source
    TriggerClientEvent('clothes:spawn', src, buildDefault())
end)

--[[
    -- Type: Event
    -- Name: fsn_clothing:save
    -- Use: Placeholder for persisting clothing data
--]]
RegisterNetEvent('fsn_clothing:save', function(data)
    print(('received clothing data from %s'):format(source))
end)
