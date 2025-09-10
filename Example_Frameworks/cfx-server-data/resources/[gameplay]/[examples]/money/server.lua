local playerData = exports['cfx.re/playerData.v1alpha1']

local VALID_MONEY_TYPES = {
    bank = true,
    cash = true
}

--[[
    -- Type: Function
    -- Name: getMoneyForId
    -- Use: Reads stored money for a player from resource KVPs.
    -- Created: 2024-12-28
    -- By: VSSVSSN
--]]
local function getMoneyForId(playerId, moneyType)
    return GetResourceKvpInt(('money:%s:%s'):format(playerId, moneyType)) / 100.0
end

--[[
    -- Type: Function
    -- Name: setMoneyForId
    -- Use: Persists money for a player and emits update event.
    -- Created: 2024-12-28
    -- By: VSSVSSN
--]]
local function setMoneyForId(playerId, moneyType, amount)
    local src = playerData:getPlayerById(playerId)

    TriggerEvent('money:updated', {
        dbId = playerId,
        source = src,
        moneyType = moneyType,
        money = amount
    })

    return SetResourceKvpInt(('money:%s:%s'):format(playerId, moneyType), math.tointeger(amount * 100.0))
end

--[[
    -- Type: Function
    -- Name: addMoneyForId
    -- Use: Adjusts money for a player by a signed amount.
    -- Created: 2024-12-28
    -- By: VSSVSSN
--]]
local function addMoneyForId(playerId, moneyType, amount)
    local curMoney = getMoneyForId(playerId, moneyType)
    curMoney = curMoney + amount

    if curMoney >= 0 then
        setMoneyForId(playerId, moneyType, curMoney)
        return true, curMoney
    end

    return false, curMoney
end

local function isValidMoneyType(mType)
    return VALID_MONEY_TYPES[mType] == true
end

local function isValidAmount(amount)
    return type(amount) == 'number' and amount > 0 and amount <= (1 << 30)
end

--[[
    -- Type: Exported Function
    -- Name: addMoney
    -- Use: Adds funds to a player's account of the given type.
    -- Created: 2024-12-28
    -- By: VSSVSSN
--]]
exports('addMoney', function(playerIdx, moneyType, amount)
    local amt = tonumber(amount)
    if not isValidAmount(amt) or not isValidMoneyType(moneyType) then
        return false
    end

    local playerId = playerData:getPlayerId(playerIdx)
    local success, money = addMoneyForId(playerId, moneyType, amt)

    if success then
        local player = Player(playerIdx)
        player.state['money_' .. moneyType] = money
    end

    return success, money
end)

--[[
    -- Type: Exported Function
    -- Name: removeMoney
    -- Use: Removes funds from a player's account of the given type.
    -- Created: 2024-12-28
    -- By: VSSVSSN
--]]
exports('removeMoney', function(playerIdx, moneyType, amount)
    local amt = tonumber(amount)
    if not isValidAmount(amt) or not isValidMoneyType(moneyType) then
        return false
    end

    local playerId = playerData:getPlayerId(playerIdx)
    local success, money = addMoneyForId(playerId, moneyType, -amt)

    if success then
        local player = Player(playerIdx)
        player.state['money_' .. moneyType] = money
    end

    return success, money
end)

--[[
    -- Type: Exported Function
    -- Name: getMoney
    -- Use: Retrieves current funds for a player's account type.
    -- Created: 2024-12-28
    -- By: VSSVSSN
--]]
exports('getMoney', function(playerIdx, moneyType)
    if not isValidMoneyType(moneyType) then return 0 end
    local playerId = playerData:getPlayerId(playerIdx)
    return getMoneyForId(playerId, moneyType)
end)

-- player display bits
AddEventHandler('money:updated', function(data)
    if data.source then
        TriggerClientEvent('money:displayUpdate', data.source, data.moneyType, data.money)
    end
end)

RegisterNetEvent('money:requestDisplay')

AddEventHandler('money:requestDisplay', function()
    local src = source
    local playerId = playerData:getPlayerId(src)

    for type, _ in pairs(VALID_MONEY_TYPES) do
        local amount = getMoneyForId(playerId, type)
        TriggerClientEvent('money:displayUpdate', src, type, amount)

        local player = Player(src)
        player.state['money_' .. type] = amount
    end
end)

RegisterCommand('earn', function(src, args)
    local mType = args[1]
    local amt = tonumber(args[2])
    exports['money']:addMoney(src, mType, amt)
end, true)

RegisterCommand('spend', function(src, args)
    local mType = args[1]
    local amt = tonumber(args[2])
    if not exports['money']:removeMoney(src, mType, amt) then
        print('you are broke??')
    end
end, true)
