RegisterNetEvent('oxydelivery:server')
AddEventHandler('oxydelivery:server', function(money)
    local user = exports["np-base"]:getModule("Player"):GetUser(source)
    money = tonumber(money) or 0

	if user:getCash() >= money then
        user:removeMoney(money)

		TriggerClientEvent("oxydelivery:startDealing", source)
    else
        TriggerClientEvent('notification', source, 'You dont have enough money little stupid fucking bitch.', 2)
	end
end)

RegisterNetEvent('drugdelivery:server')
AddEventHandler('drugdelivery:server', function(money)
    local user = exports["np-base"]:getModule("Player"):GetUser(source)
    money = tonumber(money) or 0

	if user:getCash() >= money then
        user:removeMoney(money)
		
		TriggerClientEvent("drugdelivery:startDealing", source)
    else
        TriggerClientEvent('notification', source, 'You dont have enough money.', 2)
	end
end)

local counter = 0
RegisterNetEvent('delivery:status')
AddEventHandler('delivery:status', function(status)
    if status == -1 then
        counter = 0
    elseif status == 1 then
        counter = 2
    end
    TriggerClientEvent('delivery:deliverables', -1, counter, math.random(1,14))
end)



local activechop = {}
local newList = {}

--[[
    -- Type: Function
    -- Name: makenewlist
    -- Use: Builds a list of random vehicles for the chop shop
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function makenewlist()
    for i = 1, 5 do
        table.insert(newList, {["id"] = math.random(1, 118), ["rarity"] = math.random(1, 15), ["resolved"] = false})
    end
end

local timer = 60

--[[
    -- Type: Function
    -- Name: updatetimer
    -- Use: Updates and broadcasts chop shop timer
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function updatetimer()
    if timer > 0 then
        timer = timer - 1
        TriggerClientEvent("chop:CurrentCarList", -1, newList, timer)
    else
        newList = {}
        makenewlist()
        timer = 60
        TriggerClientEvent("chop:CurrentCarList", -1, newList, timer)
    end
end

RegisterNetEvent('request:chopshop')
AddEventHandler('request:chopshop', function()
    TriggerClientEvent("chop:CurrentCarList", -1, newList, timer)
end)

RegisterNetEvent('chopshop:removevehicle')
AddEventHandler('chopshop:removevehicle', function(vehicleid, plate, value)
    newList[vehicleid]["resolved"] = true
    TriggerClientEvent("chop:CurrentCarListRemove", -1, vehicleid)
    TriggerClientEvent("keys:remove", source, plate)
    TriggerClientEvent("payment:chopshopscrap", source, newList[vehicleid]["rarity"])
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    makenewlist()
    --print('The resource ' .. resourceName .. ' has been started.')
end)

CreateThread(function()
    while true do
        Wait(60000)
        updatetimer()
    end
end)
