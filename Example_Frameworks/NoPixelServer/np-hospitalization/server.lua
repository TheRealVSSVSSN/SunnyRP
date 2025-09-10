--[[
    -- Type: Event
    -- Name: stress:illnesslevel
    -- Use: Updates patient illness level
    -- Created: 2024-06-01
    -- By: VSSVSSN
--]]
RegisterNetEvent('stress:illnesslevel')
AddEventHandler('stress:illnesslevel', function(level)
    local src = source
    local user = exports['np-base']:getModule('Player'):GetUser(src)
    local char = user:getCurrentCharacter()
    local levelNum = tonumber(level) or 0
    exports.ghmattimysql:execute(
        "UPDATE hospital_patients SET level = @level WHERE cid = @cid",
        { ['level'] = levelNum, ['cid'] = char.id }
    )
end)

--[[
    -- Type: Event
    -- Name: stress:illnesslevel:new
    -- Use: Inserts or updates patient illness details
--]]
RegisterNetEvent('stress:illnesslevel:new')
AddEventHandler('stress:illnesslevel:new', function(injury, lengthOfInjury)
    local src = source
    local user = exports['np-base']:getModule('Player'):GetUser(src)
    local char = user:getCurrentCharacter()
    local lengthNum = tonumber(lengthOfInjury) or 0
    exports.ghmattimysql:execute(
        "UPDATE hospital_patients SET level = @length, illness = @injury, time = @time WHERE cid = @cid",
        { ['length'] = lengthNum, ['injury'] = injury, ['time'] = 60, ['cid'] = char.id }
    )
end)

local isNancyEnabled = false
RegisterServerEvent('doctor:enableTriage')
AddEventHandler('doctor:enableTriage', function()
    isNancyEnabled = true
    TriggerEvent('doctor:setTriageState')
end)

RegisterServerEvent('doctor:disableTriage')
AddEventHandler('doctor:disableTriage', function()
    isNancyEnabled = false
    TriggerEvent('doctor:setTriageState')
end)

RegisterServerEvent('doctor:setTriageState')
AddEventHandler('doctor:setTriageState', function()
    TriggerClientEvent('doctor:setTriageState', -1, isNancyEnabled)
end)