--[[
    -- Type: Server Script
    -- Name: fsn_timeandweather
    -- Use: Synchronizes time and weather across the server
    -- Created: 2024-02-14
    -- By: VSSVSSN
--]]

local admins = {
    'steam:11000010e0828a9'
}

local DynamicWeather = true
local debugprint = false

local AvailableWeatherTypes = {
    'EXTRASUNNY','CLEAR','NEUTRAL','SMOG','FOGGY','OVERCAST','CLOUDS',
    'CLEARING','RAIN','THUNDER','SNOW','BLIZZARD','SNOWLIGHT','XMAS','HALLOWEEN'
}

local CurrentWeather = 'EXTRASUNNY'
local baseTime, timeOffset = 0, 0
local freezeTime, blackout = false, false
local newWeatherTimer = 10
math.randomseed(os.time())

--[[
    -- Type: Function
    -- Name: isAllowedToChange
    -- Use: Validates if the player has permission to use admin commands
    -- Created: 2024-02-14
    -- By: VSSVSSN
--]]
local function isAllowedToChange(player)
    for _, id in ipairs(admins) do
        for _, pid in ipairs(GetPlayerIdentifiers(player)) do
            if debugprint then
                print(('admin id: %s\nplayer id: %s'):format(id, pid))
            end
            if string.lower(pid) == string.lower(id) then
                return true
            end
        end
    end
    return false
end

--[[
    -- Type: Event
    -- Name: fsn_timeandweather:requestSync
    -- Use: Sends current time and weather to all clients
    -- Created: 2024-02-14
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_timeandweather:requestSync', function()
    TriggerClientEvent('fsn_timeandweather:updateWeather', -1, CurrentWeather, blackout)
    TriggerClientEvent('fsn_timeandweather:updateTime', -1, baseTime, timeOffset, freezeTime)
end)

-- Command helpers
--[[
    -- Type: Function
    -- Name: setTimeCommand
    -- Use: Sets the time and notifies the player
    -- Created: 2024-02-14
    -- By: VSSVSSN
--]]
local function setTimeCommand(source, hour, minute, label)
    ShiftToMinute(minute)
    ShiftToHour(hour)
    if source == 0 then
        print(('Time has changed to %02d:%02d.'):format(hour, minute))
    else
        TriggerClientEvent('fsn_timeandweather:notify', source, 'Time set to ~y~' .. label .. '~s~.')
    end
    TriggerEvent('fsn_timeandweather:requestSync')
end

--[[
    -- Type: Function
    -- Name: ShiftToMinute
    -- Use: Adjusts timeOffset to the specified minute
    -- Created: 2024-02-14
    -- By: VSSVSSN
--]]
function ShiftToMinute(minute)
    timeOffset = timeOffset - (((baseTime + timeOffset) % 60) - minute)
end

--[[
    -- Type: Function
    -- Name: ShiftToHour
    -- Use: Adjusts timeOffset to the specified hour
    -- Created: 2024-02-14
    -- By: VSSVSSN
--]]
function ShiftToHour(hour)
    timeOffset = timeOffset - ((((baseTime + timeOffset) / 60) % 24) - hour) * 60
end

RegisterCommand('freezetime', function(source)
    if source == 0 or isAllowedToChange(source) then
        freezeTime = not freezeTime
        local msg = freezeTime and 'Time is now ~b~frozen~s~.' or 'Time is ~y~no longer frozen~s~.'
        if source == 0 then
            print(msg:gsub('~.-~', ''))
        else
            TriggerClientEvent('fsn_timeandweather:notify', source, msg)
        end
    else
        TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1You are not allowed to use this command.')
    end
end)

RegisterCommand('freezeweather', function(source)
    if source == 0 or isAllowedToChange(source) then
        DynamicWeather = not DynamicWeather
        local msg = DynamicWeather and 'Dynamic weather changes are now ~b~enabled~s~.' or 'Dynamic weather changes are now ~r~disabled~s~.'
        if source == 0 then
            print(msg:gsub('~.-~', ''))
        else
            TriggerClientEvent('fsn_timeandweather:notify', source, msg)
        end
    else
        TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1You are not allowed to use this command.')
    end
end)

--[[
    -- Type: Function
    -- Name: NextWeatherStage
    -- Use: Randomizes the next weather type
    -- Created: 2024-02-14
    -- By: VSSVSSN
--]]
local function NextWeatherStage()
    local newWeather = AvailableWeatherTypes[math.random(#AvailableWeatherTypes)]
    if newWeather == CurrentWeather then
        newWeather = AvailableWeatherTypes[math.random(#AvailableWeatherTypes)]
    end
    CurrentWeather = newWeather
    TriggerEvent('fsn_timeandweather:requestSync')
    if debugprint then
        print((':fsn_timeandweather: New random weather type: %s'):format(CurrentWeather))
        print(':fsn_timeandweather: Resetting timer to 10 minutes.')
    end
end

RegisterCommand('weather', function(source, args)
    local wtype = args[1] and string.upper(args[1]) or nil
    local validWeatherType = false
    for _, wt in ipairs(AvailableWeatherTypes) do
        if wt == wtype then
            validWeatherType = true
            break
        end
    end

    if not validWeatherType then
        local msg = 'Invalid weather type, valid weather types are: \n' .. table.concat(AvailableWeatherTypes, ' ')
        if source == 0 then
            print(msg)
        else
            TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1' .. msg)
        end
        return
    end

    if source == 0 or isAllowedToChange(source) then
        CurrentWeather = wtype
        newWeatherTimer = 10
        TriggerEvent('fsn_timeandweather:requestSync')
        if source == 0 then
            print('Weather has been updated.')
        else
            TriggerClientEvent('fsn_timeandweather:notify', source, 'Weather will change to: ~y~' .. string.lower(wtype) .. '~s~.')
        end
    else
        TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1You do not have access to that command.')
        print('Access for command /weather denied.')
    end
end, false)

RegisterCommand('blackout', function(source)
    if source == 0 or isAllowedToChange(source) then
        blackout = not blackout
        if source == 0 then
            print(blackout and 'Blackout is now enabled.' or 'Blackout is now disabled.')
        else
            local msg = blackout and 'Blackout is now ~b~enabled~s~.' or 'Blackout is now ~r~disabled~s~.'
            TriggerClientEvent('fsn_timeandweather:notify', source, msg)
            TriggerEvent('fsn_timeandweather:requestSync')
        end
    end
end)

RegisterCommand('morning', function(source)
    if source == 0 then return print('For console, use the "/time <hh> <mm>" command instead!') end
    if isAllowedToChange(source) then setTimeCommand(source, 9, 0, 'morning') end
end)

RegisterCommand('noon', function(source)
    if source == 0 then return print('For console, use the "/time <hh> <mm>" command instead!') end
    if isAllowedToChange(source) then setTimeCommand(source, 12, 0, 'noon') end
end)

RegisterCommand('evening', function(source)
    if source == 0 then return print('For console, use the "/time <hh> <mm>" command instead!') end
    if isAllowedToChange(source) then setTimeCommand(source, 18, 0, 'evening') end
end)

RegisterCommand('night', function(source)
    if source == 0 then return print('For console, use the "/time <hh> <mm>" command instead!') end
    if isAllowedToChange(source) then setTimeCommand(source, 23, 0, 'night') end
end)

RegisterCommand('time', function(source, args)
    local h, m = tonumber(args[1]), tonumber(args[2])
    if not h or not m then
        local msg = 'Invalid syntax, correct syntax is: time <hour> <minute> !'
        if source == 0 then
            print(msg)
        else
            TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1Invalid syntax. Use ^0/time <hour> <minute> ^1instead!')
        end
        return
    end
    if source == 0 or isAllowedToChange(source) then
        if h >= 24 then h = 0 end
        if m >= 60 then m = 0 end
        ShiftToHour(h)
        ShiftToMinute(m)
        if source == 0 then
            print(('Time has changed to %02d:%02d.'):format(h, m))
        else
            local newtime = string.format('%02d:%02d', math.floor(((baseTime + timeOffset) / 60) % 24), math.floor((baseTime + timeOffset) % 60))
            TriggerClientEvent('fsn_timeandweather:notify', source, 'Time was changed to: ~y~' .. newtime .. '~s~!')
        end
        TriggerEvent('fsn_timeandweather:requestSync')
    else
        TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1You do not have access to that command.')
        print('Access for command /time denied.')
    end
end)

-- Time and weather update loops
CreateThread(function()
    while true do
        Wait(1000)
        local newBaseTime = os.time(os.date('!*t')) / 2 + 360
        if freezeTime then
            timeOffset = timeOffset + baseTime - newBaseTime
        end
        baseTime = newBaseTime
    end
end)

CreateThread(function()
    while true do
        Wait(5000)
        TriggerClientEvent('fsn_timeandweather:updateTime', -1, baseTime, timeOffset, freezeTime)
    end
end)

CreateThread(function()
    while true do
        Wait(300000)
        TriggerClientEvent('fsn_timeandweather:updateWeather', -1, CurrentWeather, blackout)
    end
end)

CreateThread(function()
    while true do
        Wait(60000)
        newWeatherTimer = newWeatherTimer - 1
        if newWeatherTimer <= 0 then
            if DynamicWeather then
                NextWeatherStage()
            end
            newWeatherTimer = 10
        end
    end
end)

