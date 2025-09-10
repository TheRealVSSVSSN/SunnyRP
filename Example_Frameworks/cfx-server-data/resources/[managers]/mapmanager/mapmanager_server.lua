--[[
    -- Type: Module
    -- Name: mapmanager_server
    -- Use: Server-side management for map and gametype resources
    -- Created: 2024-07-20
    -- By: VSSVSSN
--]]

local maps = {}
local gametypes = {}

-- forward declarations for exported functions
local getCurrentGameType, getCurrentMap, getMaps
local changeGameType, changeMap, doesMapSupportGameType, roundEnded

--[[
    -- Type: Function
    -- Name: refreshResources
    -- Use: Scans all resources and populates map and gametype metadata
    -- Created: 2024-07-20
    -- By: VSSVSSN
--]]
local function refreshResources()
    local numResources = GetNumResources()

    for i = 0, numResources - 1 do
        local resource = GetResourceByFindIndex(i)

        if GetNumResourceMetadata(resource, 'resource_type') > 0 then
            local resourceType = GetResourceMetadata(resource, 'resource_type', 0)
            local paramsStr = GetResourceMetadata(resource, 'resource_type_extra', 0)
            local params = {}

            if paramsStr and paramsStr ~= '' then
                local ok, decoded = pcall(json.decode, paramsStr)
                if ok and decoded then
                    params = decoded
                end
            end

            local valid = false
            local games = GetNumResourceMetadata(resource, 'game')

            if games > 0 then
                for j = 0, games - 1 do
                    local game = GetResourceMetadata(resource, 'game', j)

                    if game == GetConvar('gamename', 'gta5') or game == 'common' then
                        valid = true
                    end
                end
            end

            if valid then
                if resourceType == 'map' then
                    maps[resource] = params
                elseif resourceType == 'gametype' then
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

AddEventHandler('onResourceStarting', function(resource)
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
                -- check if there's only one possible game type for the map
                local mapData = maps[resource]
                local count, gt = 0, nil

                for gType, flag in pairs(mapData.gameTypes) do
                    if flag then
                        count = count + 1
                        gt = gType
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
end)

math.randomseed(GetInstanceId())

local currentGameType = nil
local currentMap = nil

AddEventHandler('onResourceStart', function(resource)
    if maps[resource] then
        if not getCurrentGameType() then
            for gt, _ in pairs(maps[resource].gameTypes) do
                changeGameType(gt)
                break
            end
        end

        if getCurrentGameType() and not getCurrentMap() then
            if doesMapSupportGameType(currentGameType, resource) then
                if TriggerEvent('onMapStart', resource, maps[resource]) then
                    if maps[resource].name then
                        print('Started map ' .. maps[resource].name)
                        SetMapName(maps[resource].name)
                    else
                        print('Started map ' .. resource)
                        SetMapName(resource)
                    end

                    currentMap = resource
                else
                    currentMap = nil
                end
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

    -- handle starting
    loadMap(resource)
end)

local function handleRoundEnd()
	local possibleMaps = {}

	for map, data in pairs(maps) do
		if data.gameTypes[currentGameType] then
			table.insert(possibleMaps, map)
		end
    end

    if #possibleMaps > 1 then
        local mapname = currentMap

        while mapname == currentMap do
            local rnd = math.random(#possibleMaps)
            mapname = possibleMaps[rnd]
        end

        changeMap(mapname)
    elseif #possibleMaps > 0 then
        local rnd = math.random(#possibleMaps)
        changeMap(possibleMaps[rnd])
	end
end

AddEventHandler('mapmanager:roundEnded', function()
    -- set a timeout as we don't want to return to a dead environment
    SetTimeout(50, handleRoundEnd)
end)

--[[
    -- Type: Function
    -- Name: roundEnded
    -- Use: Exposed API to cycle to a new map at the end of a round
    -- Created: 2024-07-20
    -- By: VSSVSSN
--]]
function roundEnded()
    SetTimeout(50, handleRoundEnd)
end

AddEventHandler('onResourceStop', function(resource)
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

    -- unload the map
    unloadMap(resource)
end)

AddEventHandler('rconCommand', function(commandName, args)
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

            for type, flag in pairs(map.gameTypes) do
                if flag then
                    count = count + 1
                    gt = type
                end
            end

            if count == 1 then
                print("Changing map from " .. getCurrentMap() .. " to " .. args[1] .. " (gt " .. gt .. ")")

                changeGameType(gt)
                changeMap(args[1])

                RconPrint('map ' .. args[1] .. "\n")
            else
                RconPrint('map ' .. args[1] .. ' does not support ' .. currentGameType .. "\n")
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
end)

--[[
    -- Type: Function
    -- Name: getCurrentGameType
    -- Use: Retrieves the active gametype resource
    -- Created: 2024-07-20
    -- By: VSSVSSN
--]]
function getCurrentGameType()
    return currentGameType
end

--[[
    -- Type: Function
    -- Name: getCurrentMap
    -- Use: Retrieves the active map resource
    -- Created: 2024-07-20
    -- By: VSSVSSN
--]]
function getCurrentMap()
    return currentMap
end

--[[
    -- Type: Function
    -- Name: getMaps
    -- Use: Returns the map metadata table
    -- Created: 2024-07-20
    -- By: VSSVSSN
--]]
function getMaps()
    return maps
end

--[[
    -- Type: Function
    -- Name: changeGameType
    -- Use: Switches the active gametype, ensuring map compatibility
    -- Created: 2024-07-20
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
    -- Use: Starts a new map resource, stopping the previous one
    -- Created: 2024-07-20
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
    -- Use: Checks if a map is compatible with a given gametype
    -- Created: 2024-07-20
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

exports('getCurrentGameType', getCurrentGameType)
exports('getCurrentMap', getCurrentMap)
exports('changeGameType', changeGameType)
exports('changeMap', changeMap)
exports('doesMapSupportGameType', doesMapSupportGameType)
exports('getMaps', getMaps)
exports('roundEnded', roundEnded)
