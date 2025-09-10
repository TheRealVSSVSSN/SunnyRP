--[[
    -- Type: Module
    -- Name: mapmanager_server
    -- Use: Manages server-side map and gametype resources
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]

local maps = {}
local gametypes = {}

--[[
    -- Type: Function
    -- Name: decodeExtraData
    -- Use: Safely decodes JSON metadata values
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
    -- Name: refreshResources
    -- Use: Builds lookup tables of available maps and gametypes
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
local function refreshResources()
    local numResources = GetNumResources()
    local gameName = GetConvar('gamename', 'gta5')

    for i = 0, numResources - 1 do
        local resource = GetResourceByFindIndex(i)

        if GetNumResourceMetadata(resource, 'resource_type') > 0 then
            local resType = GetResourceMetadata(resource, 'resource_type', 0)
            local params = decodeExtraData(GetResourceMetadata(resource, 'resource_type_extra', 0))

            local valid = false
            local games = GetNumResourceMetadata(resource, 'game')

            if games > 0 then
                for j = 0, games - 1 do
                    local game = GetResourceMetadata(resource, 'game', j)
                    if game == gameName or game == 'common' then
                        valid = true
                        break
                    end
                end
            else
                valid = true
            end

            if valid then
                if resType == 'map' then
                    maps[resource] = params
                elseif resType == 'gametype' then
                    gametypes[resource] = params
                end
            end
        end
    end
end

AddEventHandler('onResourceListRefresh', function()
    refreshResources()
end)

refreshResources()

--[[
    -- Type: Function
    -- Name: onResourceStarting
    -- Use: Handles resources registering before they fully start
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
local function onResourceStarting(resource)
    local num = GetNumResourceMetadata(resource, 'map')

    if num and num > 0 then
        for i = 0, num - 1 do
            local file = GetResourceMetadata(resource, 'map', i)
            if file then
                addMap(file, resource)
            end
        end
    end

    if maps[resource] then
        if getCurrentMap() and getCurrentMap() ~= resource then
            if doesMapSupportGameType(getCurrentGameType(), resource) then
                print("Changing map from " .. getCurrentMap() .. " to " .. resource)
                changeMap(resource)
            else
                local map = maps[resource]
                local count = 0
                local gt

                for type, flag in pairs(map.gameTypes) do
                    if flag then
                        count = count + 1
                        gt = type
                    end
                end

                if count == 1 then
                    print("Changing map from " .. getCurrentMap() .. " to " .. resource .. " (gt " .. gt .. ")")
                    changeGameType(gt)
                    changeMap(resource)
                end
            end

            CancelEvent()
        end
    elseif gametypes[resource] then
        if getCurrentGameType() and getCurrentGameType() ~= resource then
            print("Changing gametype from " .. getCurrentGameType() .. " to " .. resource)
            changeGameType(resource)
            CancelEvent()
        end
    end
end

AddEventHandler('onResourceStarting', onResourceStarting)

math.randomseed(os.time())

local currentGameType = nil
local currentMap = nil

--[[
    -- Type: Function
    -- Name: onResourceStart
    -- Use: Handles resources after they start
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
local function onResourceStart(resource)
    if maps[resource] then
        if not getCurrentGameType() then
            for gt, _ in pairs(maps[resource].gameTypes) do
                changeGameType(gt)
                break
            end
        end

        if getCurrentGameType() and not getCurrentMap() and doesMapSupportGameType(currentGameType, resource) then
            if TriggerEvent('onMapStart', resource, maps[resource]) then
                local mapName = maps[resource].name or resource
                print('Started map ' .. mapName)
                SetMapName(mapName)
                currentMap = resource
            else
                currentMap = nil
            end
        end
    elseif gametypes[resource] then
        if not getCurrentGameType() then
            if TriggerEvent('onGameTypeStart', resource, gametypes[resource]) then
                currentGameType = resource
                local gtName = gametypes[resource].name or resource

                SetGameType(gtName)
                print('Started gametype ' .. gtName)

                SetTimeout(50, function()
                    if not currentMap then
                        local possibleMaps = {}
                        for map, data in pairs(maps) do
                            if data.gameTypes[currentGameType] then
                                table.insert(possibleMaps, map)
                            end
                        end

                        if #possibleMaps > 0 then
                            local rnd = math.random(#possibleMaps)
                            changeMap(possibleMaps[rnd])
                        end
                    end
                end)
            else
                currentGameType = nil
            end
        end
    end

    loadMap(resource)
end

AddEventHandler('onResourceStart', onResourceStart)

local function handleRoundEnd()
    local possibleMaps = {}

    for map, data in pairs(maps) do
        if data.gameTypes[currentGameType] then
            table.insert(possibleMaps, map)
        end
    end

    if #possibleMaps > 1 then
        local mapName = currentMap
        while mapName == currentMap do
            local rnd = math.random(#possibleMaps)
            mapName = possibleMaps[rnd]
        end
        changeMap(mapName)
    elseif #possibleMaps > 0 then
        local rnd = math.random(#possibleMaps)
        changeMap(possibleMaps[rnd])
    end
end

AddEventHandler('mapmanager:roundEnded', function()
    SetTimeout(50, handleRoundEnd)
end)

function roundEnded()
    SetTimeout(50, handleRoundEnd)
end

--[[
    -- Type: Function
    -- Name: onResourceStop
    -- Use: Cleans up when a resource stops
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
local function onResourceStop(resource)
    if resource == currentGameType then
        TriggerEvent('onGameTypeStop', resource)
        currentGameType = nil

        if currentMap then
            StopResource(currentMap)
        end
    elseif resource == currentMap then
        TriggerEvent('onMapStop', resource)
        currentMap = nil
    end

    unloadMap(resource)
end

AddEventHandler('onResourceStop', onResourceStop)

--[[
    -- Type: Function
    -- Name: handleRconCommand
    -- Use: Processes map and gametype rcon commands
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
local function handleRconCommand(commandName, args)
    if commandName == 'map' then
        if #args ~= 1 then
            RconPrint("usage: map [mapname]\n")
        end

        if not maps[args[1]] then
            RconPrint('no such map ' .. args[1] .. "\n")
            CancelEvent()
            return
        end

        if currentGameType == nil or not doesMapSupportGameType(currentGameType, args[1]) then
            local map = maps[args[1]]
            local count = 0
            local gt

            for t, flag in pairs(map.gameTypes) do
                if flag then
                    count = count + 1
                    gt = t
                end
            end

            if count == 1 then
                print("Changing map from " .. getCurrentMap() .. " to " .. args[1] .. " (gt " .. gt .. ")")
                changeGameType(gt)
                changeMap(args[1])
                RconPrint('map ' .. args[1] .. "\n")
            else
                RconPrint('map ' .. args[1] .. ' does not support ' .. tostring(currentGameType) .. "\n")
            end

            CancelEvent()
            return
        end

        changeMap(args[1])
        RconPrint('map ' .. args[1] .. "\n")
        CancelEvent()
    elseif commandName == 'gametype' then
        if #args ~= 1 then
            RconPrint("usage: gametype [name]\n")
        end

        if not gametypes[args[1]] then
            RconPrint('no such gametype ' .. args[1] .. "\n")
            CancelEvent()
            return
        end

        changeGameType(args[1])
        RconPrint('gametype ' .. args[1] .. "\n")
        CancelEvent()
    end
end

AddEventHandler('rconCommand', handleRconCommand)

--[[
    -- Type: Function
    -- Name: getCurrentGameType
    -- Use: Returns the active gametype resource name
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
function getCurrentGameType()
    return currentGameType
end

--[[
    -- Type: Function
    -- Name: getCurrentMap
    -- Use: Returns the active map resource name
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
function getCurrentMap()
    return currentMap
end

--[[
    -- Type: Function
    -- Name: getMaps
    -- Use: Provides the internal map registry
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
function getMaps()
    return maps
end

--[[
    -- Type: Function
    -- Name: changeGameType
    -- Use: Switches the active gametype
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
function changeGameType(gameType)
    if currentMap and not doesMapSupportGameType(gameType, currentMap) then
        StopResource(currentMap)
    end

    if currentGameType then
        StopResource(currentGameType)
    end

    StartResource(gameType)
end

--[[
    -- Type: Function
    -- Name: changeMap
    -- Use: Switches the active map
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
function changeMap(map)
    if currentMap then
        StopResource(currentMap)
    end

    StartResource(map)
end

--[[
    -- Type: Function
    -- Name: doesMapSupportGameType
    -- Use: Checks if a map supports a gametype
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
function doesMapSupportGameType(gameType, map)
    if not gametypes[gameType] then
        return false
    end

    if not maps[map] then
        return false
    end

    if not maps[map].gameTypes then
        return true
    end

    return maps[map].gameTypes[gameType]
end
