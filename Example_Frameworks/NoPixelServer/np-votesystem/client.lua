--[[
    -- Type: Function
    -- Name: registerPayEvents
    -- Use: Registers net events for adjusting pay values sent to the server
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
local function registerPayEvents(prefix, serverEvent, values)
    for _, value in ipairs(values) do
        local eventName = prefix .. tostring(value)
        RegisterNetEvent(eventName)
        AddEventHandler(eventName, function()
            TriggerServerEvent(serverEvent, value)
        end)
    end
end

registerPayEvents('settax', 'setTaxGlobal', {0, 5, 10, 15})
registerPayEvents('setEMS', 'setEmsPay', {0, 50, 100, 200})
registerPayEvents('setPolice', 'setPolicePay', {0, 50, 100, 200})
registerPayEvents('setCivilian', 'setCivilianPay', {0, 50, 100})

--[[
    -- Type: Function
    -- Name: registerRelayEvents
    -- Use: Forwards simple client events to the server with the same name
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
local function registerRelayEvents(eventList)
    for _, name in ipairs(eventList) do
        RegisterNetEvent(name)
        AddEventHandler(name, function()
            TriggerServerEvent(name)
        end)
    end
end

registerRelayEvents({'updatepasses', 'checkmayorcash', 'nextElection', 'nextValueCheck'})

local mayorTax = 0
RegisterNetEvent('setTax')
AddEventHandler('setTax', function(mayorTaxValue)
    mayorTax = mayorTaxValue
    TriggerEvent("DoLongHudText", "Tax is currently set to: " .. mayorTax .. "%", 1)
end)

--[[
    -- Type: Function
    -- Name: getTax
    -- Use: Returns the current cached mayor tax percentage
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
function getTax()
    return mayorTax
end

local messaged = false
RegisterNetEvent('taxMessage')
AddEventHandler('taxMessage', function()
    if messaged then return end
    messaged = true
    TriggerEvent("chatMessage", "Info: ", {255, 0, 0}, "All seen payments do not include the Mayor tax.")
    Citizen.SetTimeout(10000, function()
        messaged = false
    end)
end)
