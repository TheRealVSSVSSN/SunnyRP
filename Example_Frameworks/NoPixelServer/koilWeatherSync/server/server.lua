--[[
    -- Type: Server
    -- Name: server.lua
    -- Use: Handles global time and weather synchronization
    -- Created: 2024-11-21
    -- By: VSSVSSN
--]]

local currentWeather = 'CLEAR'
local currentTime = 130000

--[[
    -- Type: Function
    -- Name: syncClient
    -- Use: Sends current weather and time to a client
    -- Created: 2024-11-21
    -- By: VSSVSSN
--]]
local function syncClient(src)
    TriggerClientEvent('kWeatherSync', src, currentWeather)
    TriggerClientEvent('kTimeSync', src, currentTime)
end

RegisterNetEvent('kGetWeather', function()
    syncClient(source)
end)

--[[
    -- Type: Function
    -- Name: setTime
    -- Use: Updates and broadcasts the current time
    -- Created: 2024-11-21
    -- By: VSSVSSN
--]]
local function setTime(time)
    currentTime = time
    TriggerClientEvent('kTimeSync', -1, currentTime)
end

RegisterNetEvent('kTimeSync', function(time)
    setTime(time)
end)

--[[
    -- Type: Function
    -- Name: setWeather
    -- Use: Updates and broadcasts the current weather
    -- Created: 2024-11-21
    -- By: VSSVSSN
--]]
local function setWeather(weather)
    currentWeather = weather
    TriggerClientEvent('kWeatherSync', -1, currentWeather)
end

RegisterNetEvent('kWeatherSync', function(weather)
    setWeather(weather)
end)

RegisterCommand('syncallweather', function()
    syncClient(-1)
end, false)

RegisterNetEvent('weather:time', function(_, time)
    setTime(tonumber(time) or currentTime)
    TriggerClientEvent('timeheader', -1, currentTime)
end)

RegisterNetEvent('weather:setWeather', function(_, weather)
    setWeather(tostring(weather or currentWeather))
end)

RegisterNetEvent('weather:receivefromcl', function(secondOfDay)
    currentTime = secondOfDay
end)

