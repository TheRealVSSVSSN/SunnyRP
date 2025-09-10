local AUTHORIZED_STEAM_IDS = {
    ['steam:11000013bd84d46'] = true,
    ['steam:11000011c3fe668'] = true,
    ['steam:110000139236a0a'] = true
}

--[[
    -- Type: Event
    -- Name: np-stash:fetchInitialState
    -- Use: Sends current stash configuration to the client
    -- Created: 2025-09-10
    -- By: VSSVSSN
]]
RegisterNetEvent('np-stash:fetchInitialState', function()
    local src = source
    TriggerClientEvent('np-stash:setInitialState', src, Config.Stash)
end)

--[[
    -- Type: Event
    -- Name: stashesaddtoconfig
    -- Use: Appends a new stash definition to the server config file
    -- Created: 2025-09-10
    -- By: VSSVSSN
]]
RegisterNetEvent('stashesaddtoconfig', function(coords, pin, id, distance)
    local src = source
    local identifier = GetPlayerIdentifier(src, 0)
    if not AUTHORIZED_STEAM_IDS[identifier] then
        TriggerClientEvent('DoLongHudText', src, 'Cannot Do This Action', 2)
        return
    end

    TriggerClientEvent('DoLongHudText', src, 'StashHouse Added', 2)

    local path = GetResourcePath(GetCurrentResourceName())
    local file = io.open(path .. '/server/svstashes.lua', 'a')
    if file then
        file:write("\n    Config.Stash[#Config.Stash + 1] = {")
        file:write("\n        StashEntry = " .. coords .. ",")
        file:write("\n        RequiredPin = " .. pin .. ",")
        file:write("\n        ID = " .. id .. ",")
        file:write("\n        distance = " .. distance .. ",")
        file:write("\n}")
        file:close()
    end
end)

