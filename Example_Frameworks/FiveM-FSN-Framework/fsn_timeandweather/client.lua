--[[
    -- Type: Client Script
    -- Name: fsn_timeandweather
    -- Use: Handles client-side time and weather synchronization
    -- Created: 2024-02-14
    -- By: VSSVSSN
--]]

local currentWeather = 'EXTRASUNNY'
local lastWeather = currentWeather
local baseTime, timeOffset, timer = 0, 0, 0
local freezeTime, blackout = false, false
local hour, minute = 0, 0

--[[
    -- Type: Function
    -- Name: getTime
    -- Use: Returns the current synced time
    -- Created: 2024-02-14
    -- By: VSSVSSN
--]]
function getTime()
    return { hour, minute }
end

RegisterNetEvent('fsn_timeandweather:updateWeather', function(newWeather, newBlackout)
    currentWeather = newWeather
    blackout = newBlackout
end)

CreateThread(function()
    while true do
        if lastWeather ~= currentWeather then
            lastWeather = currentWeather
            SetWeatherTypeOverTime(lastWeather, 15.0)
            Wait(15000)
        end

        Wait(1000)
        SetBlackout(blackout)
        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypePersist(lastWeather)
        SetWeatherTypeNow(lastWeather)
        SetWeatherTypeNowPersist(lastWeather)

        if lastWeather == 'XMAS' then
            SetForceVehicleTrails(true)
            SetForcePedFootstepsTracks(true)
        else
            SetForceVehicleTrails(false)
            SetForcePedFootstepsTracks(false)
        end
    end
end)

RegisterNetEvent('fsn_timeandweather:updateTime', function(base, offset, freeze)
    freezeTime = freeze
    timeOffset = offset
    baseTime = base
end)

CreateThread(function()
    while true do
        Wait(1000)
        local newBaseTime = baseTime
        if GetGameTimer() - 500 > timer then
            newBaseTime = newBaseTime + 0.25
            timer = GetGameTimer()
        end
        if freezeTime then
            timeOffset = timeOffset + baseTime - newBaseTime
        end
        baseTime = newBaseTime
        hour = math.floor(((baseTime + timeOffset) / 60) % 24)
        minute = math.floor((baseTime + timeOffset) % 60)
        NetworkOverrideClockTime(hour, minute, 0)
    end
end)

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('fsn_timeandweather:requestSync')
end)

--[[
    -- Type: Function
    -- Name: showNotification
    -- Use: Displays a notification above the minimap
    -- Created: 2024-02-14
    -- By: VSSVSSN
--]]
local function showNotification(text, blink)
    SetNotificationTextEntry('STRING')
    AddTextComponentSubstringPlayerName(text)
    DrawNotification(blink or false, false)
end

RegisterNetEvent('fsn_timeandweather:notify', function(message, blink)
    showNotification(message, blink)
end)

