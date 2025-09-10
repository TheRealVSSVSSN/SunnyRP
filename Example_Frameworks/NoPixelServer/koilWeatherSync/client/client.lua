--[[
    -- Type: Client
    -- Name: client.lua
    -- Use: Synchronizes weather and time with the server
    -- Created: 2024-11-21
    -- By: VSSVSSN
--]]

local syncEnabled = true
local currentWeather = 'CLEAR'
local secondOfDay = 130000
local syncTimer = 0

--[[
    -- Type: Function
    -- Name: applyWeather
    -- Use: Applies the current weather locally
    -- Created: 2024-11-21
    -- By: VSSVSSN
--]]
local function applyWeather()
    ClearWeatherTypePersist()
    SetWeatherTypeOverTime(currentWeather, 15.0)
    Wait(15000)
    SetWeatherTypeNowPersist(currentWeather)
end

--[[
    -- Type: Function
    -- Name: applyTime
    -- Use: Applies the current time locally
    -- Created: 2024-11-21
    -- By: VSSVSSN
--]]
local function applyTime()
    local hour = math.floor(secondOfDay / 3600)
    local minute = math.floor((secondOfDay % 3600) / 60)
    NetworkOverrideClockTime(hour, minute, 0)
end

--[[
    -- Type: Function
    -- Name: SetEnableSync
    -- Use: Enables or disables weather/time synchronization
    -- Created: 2024-11-21
    -- By: VSSVSSN
--]]
function SetEnableSync(state)
    if state == nil then
        syncEnabled = not syncEnabled
    else
        syncEnabled = state
    end

    if syncEnabled then
        TriggerServerEvent('kGetWeather')
    end
end

exports('SetEnableSync', SetEnableSync)

RegisterNetEvent('kWeatherSync', function(weather)
    if not syncEnabled then return end
    currentWeather = weather
    applyWeather()
end)

RegisterNetEvent('kTimeSync', function(time)
    if not syncEnabled then return end
    secondOfDay = time
    applyTime()
end)

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('kGetWeather')
end)

CreateThread(function()
    while true do
        Wait(1000)
        if syncEnabled then
            secondOfDay = (secondOfDay + 1) % 86400
            applyTime()
            syncTimer = syncTimer + 1
            if syncTimer >= 30 then
                TriggerServerEvent('weather:receivefromcl', secondOfDay)
                syncTimer = 0
            end
        end
    end
end)

