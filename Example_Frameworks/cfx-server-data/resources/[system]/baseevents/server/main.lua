--[[
    -- Type: Utility
    -- Name: logEvent
    -- Use: Sends payload to the RCON logger if available
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function logEvent(payload)
    RconLog(payload)
end

RegisterNetEvent('baseevents:onPlayerDied')
--[[
    -- Type: Event
    -- Name: onPlayerDied
    -- Use: Triggered when a player dies without a killer
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
AddEventHandler('baseevents:onPlayerDied', function(killerType, pos)
    local victim = source
    logEvent({msgType = 'playerDied', victim = victim, attackerType = killerType, pos = pos})
end)

RegisterNetEvent('baseevents:onPlayerKilled')
--[[
    -- Type: Event
    -- Name: onPlayerKilled
    -- Use: Triggered when a player is killed by another entity
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
AddEventHandler('baseevents:onPlayerKilled', function(killedBy, data)
    local victim = source
    logEvent({msgType = 'playerKilled', victim = victim, attacker = killedBy, data = data})
end)

RegisterNetEvent('baseevents:onPlayerWasted')
--[[
    -- Type: Event
    -- Name: onPlayerWasted
    -- Use: Triggered when a player dies without finishing death logic
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
AddEventHandler('baseevents:onPlayerWasted', function(pos)
    local victim = source
    logEvent({msgType = 'playerWasted', victim = victim, pos = pos})
end)

RegisterNetEvent('baseevents:enteringVehicle')
--[[
    -- Type: Event
    -- Name: enteringVehicle
    -- Use: Triggered when a player starts entering a vehicle
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
AddEventHandler('baseevents:enteringVehicle', function(vehicle, seat, name, netId)
    local player = source
    logEvent({msgType = 'enteringVehicle', player = player, vehicle = vehicle, seat = seat, name = name, netId = netId})
end)

RegisterNetEvent('baseevents:enteringAborted')
--[[
    -- Type: Event
    -- Name: enteringAborted
    -- Use: Triggered when a player aborts entering a vehicle
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
AddEventHandler('baseevents:enteringAborted', function()
    local player = source
    logEvent({msgType = 'enteringAborted', player = player})
end)

RegisterNetEvent('baseevents:enteredVehicle')
--[[
    -- Type: Event
    -- Name: enteredVehicle
    -- Use: Triggered when a player successfully enters a vehicle
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
AddEventHandler('baseevents:enteredVehicle', function(vehicle, seat, name, netId)
    local player = source
    logEvent({msgType = 'enteredVehicle', player = player, vehicle = vehicle, seat = seat, name = name, netId = netId})
end)

RegisterNetEvent('baseevents:leftVehicle')
--[[
    -- Type: Event
    -- Name: leftVehicle
    -- Use: Triggered when a player exits a vehicle
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
AddEventHandler('baseevents:leftVehicle', function(vehicle, seat, name, netId)
    local player = source
    logEvent({msgType = 'leftVehicle', player = player, vehicle = vehicle, seat = seat, name = name, netId = netId})
end)

