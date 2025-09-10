-- track down what we've added to global state
local sentState = {}

-- money system
local ms = exports['money']

--[[
    -- Type: Function
    -- Name: getMoneyForId
    -- Use: Retrieve stored money amount for a fountain
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
local function getMoneyForId(fountainId)
    return GetResourceKvpInt(('money:%s'):format(fountainId)) / 100.0
end

--[[
    -- Type: Function
    -- Name: setMoneyForId
    -- Use: Persist fountain money and update global state
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
local function setMoneyForId(fountainId, money)
    GlobalState['fountain_' .. fountainId] = math.tointeger(money)
    return SetResourceKvpInt(('money:%s'):format(fountainId), math.tointeger(money * 100.0))
end

--[[
    -- Type: Function
    -- Name: getMoneyFountain
    -- Use: Returns fountain data when player is within range
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
local function getMoneyFountain(id, source)
    local coords = GetEntityCoords(GetPlayerPed(source))

    for _, v in pairs(moneyFountains) do
        if v.id == id and #(v.coords - coords) < 2.5 then
            return v
        end
    end

    return nil
end

--[[
    -- Type: Function
    -- Name: handleFountain
    -- Use: Handles pickup/place logic for the fountain
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
local function handleFountain(source, id, pickup)
    local fountain = getMoneyFountain(id, source)
    if not fountain then
        return
    end

    local player = Player(source)
    local nextUse = player.state['fountain_nextUse'] or 0

    if nextUse > GetGameTimer() then
        return
    end

    local success = false
    local money = getMoneyForId(fountain.id)

    if pickup then
        if money >= fountain.amount and ms:addMoney(source, 'cash', fountain.amount) then
            money = money - fountain.amount
            success = true
        end
    else
        if ms:removeMoney(source, 'cash', fountain.amount) then
            money = money + fountain.amount
            success = true
        end
    end

    if success then
        setMoneyForId(fountain.id, money)
        player.state['fountain_nextUse'] = GetGameTimer() + GetConvarInt('moneyFountain_cooldown', 5000)
    end
end

-- event for picking up fountain->player
RegisterNetEvent('money_fountain:tryPickup')
AddEventHandler('money_fountain:tryPickup', function(id)
    handleFountain(source, id, true)
end)

-- event for donating player->fountain
RegisterNetEvent('money_fountain:tryPlace')
AddEventHandler('money_fountain:tryPlace', function(id)
    handleFountain(source, id, false)
end)

-- listener: if a new fountain is added, set its current money in state
CreateThread(function()
    while true do
        Wait(500)

        for _, fountain in pairs(moneyFountains) do
            if not sentState[fountain.id] then
                GlobalState['fountain_' .. fountain.id] = math.tointeger(getMoneyForId(fountain.id))
                sentState[fountain.id] = true
            end
        end
    end
end)
