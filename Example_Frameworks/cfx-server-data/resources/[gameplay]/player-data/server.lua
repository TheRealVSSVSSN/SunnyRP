--[[
    -- Type: Module
    -- Name: player-data
    -- Use: Provides persistent player identifier storage and lookup
    -- Created: 10 Sep 2025
    -- By: VSSVSSN
--]]

local PlayerRegistry = {}
PlayerRegistry.__index = PlayerRegistry

--[[
    -- Type: Function
    -- Name: new
    -- Use: Constructs the registry object
    -- Created: 10 Sep 2025
    -- By: VSSVSSN
--]]
function PlayerRegistry.new()
    return setmetatable({
        blocklist = { ip = true },
        players = {},
        playersById = {}
    }, PlayerRegistry)
end

--[[
    -- Type: Function
    -- Name: isBlocked
    -- Use: Checks if an identifier type is blocked
    -- Created: 10 Sep 2025
    -- By: VSSVSSN
--]]
function PlayerRegistry:isBlocked(identifier)
    local idType = identifier:match('([^:]+):')
    return self.blocklist[idType] or false
end

--[[
    -- Type: Function
    -- Name: nextId
    -- Use: Increments and returns the next player ID
    -- Created: 10 Sep 2025
    -- By: VSSVSSN
--]]
function PlayerRegistry:nextId()
    local nextId = GetResourceKvpInt('nextId')
    if nextId < 0 then
        nextId = 0
    end
    nextId = nextId + 1
    SetResourceKvpInt('nextId', nextId)
    return nextId
end

--[[
    -- Type: Function
    -- Name: getPlayerIdFromIdentifier
    -- Use: Retrieves the player ID associated with an identifier
    -- Created: 10 Sep 2025
    -- By: VSSVSSN
--]]
function PlayerRegistry:getPlayerIdFromIdentifier(identifier)
    local data = GetResourceKvpString(('identifier:%s'):format(identifier))
    if not data then
        return nil
    end

    local unpacked = msgpack.unpack(data)
    return unpacked and unpacked.id or nil
end

--[[
    -- Type: Function
    -- Name: setIdentifier
    -- Use: Binds an identifier to a player ID in storage
    -- Created: 10 Sep 2025
    -- By: VSSVSSN
--]]
function PlayerRegistry:setIdentifier(identifier, id)
    local key = ('identifier:%s'):format(identifier)
    SetResourceKvp(key, msgpack.pack({ id = id }))
    SetResourceKvp(('player:%s:identifier:%s'):format(id, identifier), 'true')
end

--[[
    -- Type: Function
    -- Name: hasIdentifierType
    -- Use: Determines whether a player already has an identifier of this type
    -- Created: 10 Sep 2025
    -- By: VSSVSSN
--]]
function PlayerRegistry:hasIdentifierType(id, idType)
    local prefix = ('player:%s:identifier:%s:'):format(id, idType)
    local handle = StartFindKvp(prefix)
    local key = FindKvp(handle)
    EndFindKvp(handle)
    return key ~= nil
end

--[[
    -- Type: Function
    -- Name: storeIdentifiers
    -- Use: Records new identifiers for the player
    -- Created: 10 Sep 2025
    -- By: VSSVSSN
--]]
function PlayerRegistry:storeIdentifiers(playerIdx, id)
    for _, identifier in ipairs(GetPlayerIdentifiers(playerIdx)) do
        if not self:isBlocked(identifier) then
            local idType = identifier:match('([^:]+):')
            if not self:hasIdentifierType(id, idType) then
                self:setIdentifier(identifier, id)
            end
        end
    end
end

--[[
    -- Type: Function
    -- Name: registerPlayer
    -- Use: Registers a new player ID
    -- Created: 10 Sep 2025
    -- By: VSSVSSN
--]]
function PlayerRegistry:registerPlayer(playerIdx)
    local id = self:nextId()
    self:storeIdentifiers(playerIdx, id)
    return id
end

--[[
    -- Type: Function
    -- Name: setupPlayer
    -- Use: Initializes player data and caches mapping
    -- Created: 10 Sep 2025
    -- By: VSSVSSN
--]]
function PlayerRegistry:setupPlayer(playerIdx)
    local lowestId = math.huge

    for _, identifier in ipairs(GetPlayerIdentifiers(playerIdx)) do
        if not self:isBlocked(identifier) then
            local id = self:getPlayerIdFromIdentifier(identifier)
            if id and id < lowestId then
                lowestId = id
            end
        end
    end

    local playerId
    if lowestId == math.huge then
        playerId = self:registerPlayer(playerIdx)
    else
        self:storeIdentifiers(playerIdx, lowestId)
        playerId = lowestId
    end

    if Player then
        Player(playerIdx).state['cfx.re/playerData@id'] = playerId
    end

    self.players[playerIdx] = { dbId = playerId }
    self.playersById[tostring(playerId)] = playerIdx
end

--[[
    -- Type: Function
    -- Name: removePlayer
    -- Use: Cleans cached data for a dropped player
    -- Created: 10 Sep 2025
    -- By: VSSVSSN
--]]
function PlayerRegistry:removePlayer(playerIdx)
    local player = self.players[playerIdx]
    if player then
        self.playersById[tostring(player.dbId)] = nil
        self.players[playerIdx] = nil
    end
end

--[[
    -- Type: Function
    -- Name: getId
    -- Use: Returns the database ID for a player index
    -- Created: 10 Sep 2025
    -- By: VSSVSSN
--]]
function PlayerRegistry:getId(playerIdx)
    local player = self.players[tostring(playerIdx)]
    return player and player.dbId or nil
end

--[[
    -- Type: Function
    -- Name: getPlayerById
    -- Use: Returns the player index for a database ID
    -- Created: 10 Sep 2025
    -- By: VSSVSSN
--]]
function PlayerRegistry:getPlayerById(id)
    return self.playersById[tostring(id)]
end

local registry = PlayerRegistry.new()

--[[
    -- Type: Event
    -- Name: playerConnecting
    -- Use: Initializes player data on connect
    -- Created: 10 Sep 2025
    -- By: VSSVSSN
--]]
AddEventHandler('playerConnecting', function()
    registry:setupPlayer(tostring(source))
end)

RegisterNetEvent('playerJoining')
--[[
    -- Type: Event
    -- Name: playerJoining
    -- Use: Handles server ID migration on join
    -- Created: 10 Sep 2025
    -- By: VSSVSSN
--]]
AddEventHandler('playerJoining', function(oldIdx)
    local oldId = tostring(oldIdx)
    local newId = tostring(source)
    local oldPlayer = registry.players[oldId]

    if oldPlayer then
        registry.players[newId] = oldPlayer
        registry.players[oldId] = nil
    else
        registry:setupPlayer(newId)
    end
end)

--[[
    -- Type: Event
    -- Name: playerDropped
    -- Use: Removes player data on disconnect
    -- Created: 10 Sep 2025
    -- By: VSSVSSN
--]]
AddEventHandler('playerDropped', function()
    registry:removePlayer(tostring(source))
end)

for _, player in ipairs(GetPlayers()) do
    registry:setupPlayer(player)
end

--[[
    -- Type: Command
    -- Name: playerData
    -- Use: Debug command to query player identifiers
    -- Created: 10 Sep 2025
    -- By: VSSVSSN
--]]
RegisterCommand('playerData', function(_, args)
    if not args[1] then
        print('Usage:')
        print('\tplayerData getId <dbId>: gets identifiers for ID')
        print('\tplayerData getIdentifier <identifier>: gets ID for identifier')
        return
    end

    if args[1] == 'getId' then
        local prefix = ('player:%s:identifier:'):format(args[2])
        local handle = StartFindKvp(prefix)
        local key
        repeat
            key = FindKvp(handle)
            if key then
                print('result:', key:sub(#prefix + 1))
            end
        until not key
        EndFindKvp(handle)
    elseif args[1] == 'getIdentifier' then
        print('result:', registry:getPlayerIdFromIdentifier(args[2]))
    end
end, true)

--[[
    -- Type: Export
    -- Name: getPlayerIdFromIdentifier
    -- Use: Export wrapper to fetch player ID by identifier
    -- Created: 10 Sep 2025
    -- By: VSSVSSN
--]]
exports('getPlayerIdFromIdentifier', function(identifier)
    return registry:getPlayerIdFromIdentifier(identifier)
end)

--[[
    -- Type: Export
    -- Name: getPlayerId
    -- Use: Export wrapper to fetch DB ID by player index
    -- Created: 10 Sep 2025
    -- By: VSSVSSN
--]]
exports('getPlayerId', function(playerIdx)
    return registry:getId(playerIdx)
end)

--[[
    -- Type: Export
    -- Name: getPlayerById
    -- Use: Export wrapper to fetch player index by DB ID
    -- Created: 10 Sep 2025
    -- By: VSSVSSN
--]]
exports('getPlayerById', function(playerId)
    return registry:getPlayerById(playerId)
end)

