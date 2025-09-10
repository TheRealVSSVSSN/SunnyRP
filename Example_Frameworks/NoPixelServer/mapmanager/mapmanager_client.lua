local maps = {}
local gametypes = {}

--[[
    -- Type: Function
    -- Name: decodeExtraData
    -- Use: Safely decode JSON metadata values
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
local function decodeExtraData(data)
    if not data or data == '' then
        return {}
    end

    local ok, decoded = pcall(json.decode, data)
    return ok and decoded or {}
end

--[[
    -- Type: Function
    -- Name: registerResource
    -- Use: Parses metadata and loads the map for a starting resource
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
local function registerResource(res)
    local num = GetNumResourceMetadata(res, 'map')
    if num > 0 then
        for i = 0, num - 1 do
            local file = GetResourceMetadata(res, 'map', i)
            if file then
                addMap(file, res)
            end
        end
    end

    local resType = GetResourceMetadata(res, 'resource_type', 0)
    if resType then
        local extraData = decodeExtraData(GetResourceMetadata(res, 'resource_type_extra', 0))

        if resType == 'map' then
            maps[res] = extraData
        elseif resType == 'gametype' then
            gametypes[res] = extraData
        end
    end

    loadMap(res)

    CreateThread(function()
        Wait(15)

        if maps[res] then
            TriggerEvent('onClientMapStart', res)
        elseif gametypes[res] then
            TriggerEvent('onClientGameTypeStart', res)
        end
    end)
end

--[[
    -- Type: Function
    -- Name: handleResourceStop
    -- Use: Cleans up when a resource stops
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
local function handleResourceStop(res)
    if maps[res] then
        TriggerEvent('onClientMapStop', res)
    elseif gametypes[res] then
        TriggerEvent('onClientGameTypeStop', res)
    end

    unloadMap(res)
end

--[[
    -- Type: Function
    -- Name: registerDirectives
    -- Use: Adds map directives such as vehicle generators
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
local function registerDirectives(add)
    if not CreateScriptVehicleGenerator then
        return
    end

    add('vehicle_generator', function(state, name)
        return function(opts)
            local x, y, z = opts.x or opts[1], opts.y or opts[2], opts.z or opts[3]
            local heading = opts.heading or 1.0
            local color1 = opts.color1 or -1
            local color2 = opts.color2 or -1

            CreateThread(function()
                local hash = GetHashKey(name)
                RequestModel(hash)

                while not HasModelLoaded(hash) do
                    Wait(0)
                end

                local carGen = CreateScriptVehicleGenerator(x, y, z, heading, 5.0, 3.0, hash, color1, color2, -1, -1, true, false, false, true, true, -1)
                SetScriptVehicleGenerator(carGen, true)
                SetAllVehicleGeneratorsActive(true)

                state.add('cargen', carGen)
            end)
        end
    end, function(state)
        print("deleting car gen " .. tostring(state.cargen))
        DeleteScriptVehicleGenerator(state.cargen)
    end)
end

AddEventHandler('onClientResourceStart', registerResource)
AddEventHandler('onResourceStop', handleResourceStop)
AddEventHandler('getMapDirectives', registerDirectives)

