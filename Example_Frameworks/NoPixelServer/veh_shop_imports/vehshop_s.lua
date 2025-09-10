--[[
    -- Type: Server Script
    -- Name: vehshop_s.lua
    -- Use: Manages import vehicle shop server-side logic
    -- Created: 2025-02-15
    -- By: VSSVSSN
--]]

local carTable = {
	[1] = { ["model"] = "focusrs", ["baseprice"] = 285000, ["commission"] = 15 }, 
	[2] = { ["model"] = "fnfrx7", ["baseprice"] = 275000, ["commission"] = 15 },
	[3] = { ["model"] = "r1", ["baseprice"] = 250000, ["commission"] = 15 },
	[4] = { ["model"] = "fnf4r34", ["baseprice"] = 325000, ["commission"] = 15 },
	[5] = { ["model"] = "gt63", ["baseprice"] = 375000, ["commission"] = 15 },
}
--[[
    -- Type: Server Event
    -- Name: carshop:table2
    -- Use: Updates the available vehicle list and syncs it with all clients
    -- Created: 2025-02-15
    -- By: VSSVSSN
--]]
RegisterServerEvent('carshop:table2')
AddEventHandler('carshop:table2', function(tbl)
    if tbl ~= nil then
        carTable = tbl
        TriggerClientEvent('veh_shop:returnTable2', -1, carTable)
    end
end)

--[[
    -- Type: Server Event
    -- Name: BuyForVeh2
    -- Use: Inserts purchased vehicles into the database, supporting financing
    -- Created: 2025-02-15
    -- By: VSSVSSN
--]]
RegisterServerEvent('BuyForVeh2')
AddEventHandler('BuyForVeh2', function(platew, name, vehicle, price, financed)
    local user = exports["np-base"]:getModule("Player"):GetUser(source)
    local char = user:getVar("character")
    local player = user:getVar("hexid")

    if financed then
        local cols = 'owner, cid, license_plate, name, purchase_price, financed, last_payment, model, vehicle_state, payments_left'
        local val = '@owner, @cid, @license_plate, @name, @buy_price, @financed, @last_payment, @model, @veh_state, @payments_left'
        local downPay = math.ceil(price / 4)
        exports.ghmattimysql:execute('INSERT INTO characters_cars ( '..cols..' ) VALUES ( '..val..' )', {
            ['@owner'] = player,
            ['@cid'] = char.id,
            ['@license_plate'] = platew,
            ['@model'] = vehicle,
            ['@name'] = name,
            ['@buy_price'] = price,
            ['@financed'] = price - downPay,
            ['@last_payment'] = 7,
            ['@payments_left'] = 12,
            ['@veh_state'] = "Out",
        })
    else
        exports.ghmattimysql:execute('INSERT INTO characters_cars (owner, cid, license_plate, name, model, purchase_price, vehicle_state) VALUES (@owner, @cid, @license_plate, @name, @model, @buy_price, @veh_state)', {
            ['@owner'] = player,
            ['@cid'] = char.id,
            ['@license_plate'] = platew,
            ['@name'] = name,
            ['@model'] = vehicle,
            ['@buy_price'] = price,
            ['@veh_state'] = "Out"
        })
    end
end)




--[[
    -- Type: Server Event
    -- Name: CheckMoneyForVeh3
    -- Use: Validates player funds and finalizes purchase or financing
    -- Created: 2025-02-15
    -- By: VSSVSSN
--]]
RegisterServerEvent('CheckMoneyForVeh3')
AddEventHandler('CheckMoneyForVeh3', function(name, model, price, financed)
    local user = exports["np-base"]:getModule("Player"):GetUser(source)
    local cash = tonumber(user:getCash())

    if financed then
        local financedPrice = math.ceil(price / 4)
        if cash >= financedPrice then
            user:removeMoney(financedPrice)
            TriggerClientEvent('FinishMoneyCheckForVeh2', user.source, name, model, price, financed)
        else
            TriggerClientEvent('DoLongHudText', user.source, 'You dont have enough money on you!', 2)
            TriggerClientEvent('carshop:failedpurchase2', user.source)
        end
    else
        if cash >= price then
            user:removeMoney(price)
            TriggerClientEvent('FinishMoneyCheckForVeh2', user.source, name, model, price, financed)
        else
            TriggerClientEvent('DoLongHudText', user.source, 'You dont have enough money on you!', 2)
            TriggerClientEvent('carshop:failedpurchase2', user.source)
        end
    end
end)

RegisterServerEvent('finance:enable2')
AddEventHandler('finance:enable2', function(plate)
TriggerClientEvent('finance:enableOnClient2', plate)
end)