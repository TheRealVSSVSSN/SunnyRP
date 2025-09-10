--[[
    -- Type: Server Script
    -- Name: main.lua
    -- Use: Relays sound events to clients for InteractSound
    -- Created: 2024-06-09
    -- By: VSSVSSN
--]]

--[[
    -- Type: Event
    -- Name: InteractSound_SV:PlayOnOne
    -- Use: Play sound on a specific client
    -- Created: 2024-06-09
    -- By: VSSVSSN
--]]
RegisterNetEvent('InteractSound_SV:PlayOnOne', function(clientNetId, soundFile, soundVolume)
    TriggerClientEvent('InteractSound_CL:PlayOnOne', clientNetId, soundFile, soundVolume)
end)

--[[
    -- Type: Event
    -- Name: InteractSound_SV:PlayOnSource
    -- Use: Play sound on the source client
    -- Created: 2024-06-09
    -- By: VSSVSSN
--]]
RegisterNetEvent('InteractSound_SV:PlayOnSource', function(soundFile, soundVolume)
    TriggerClientEvent('InteractSound_CL:PlayOnOne', source, soundFile, soundVolume)
end)

--[[
    -- Type: Event
    -- Name: InteractSound_SV:PlayOnAll
    -- Use: Broadcast sound to all clients
    -- Created: 2024-06-09
    -- By: VSSVSSN
--]]
RegisterNetEvent('InteractSound_SV:PlayOnAll', function(soundFile, soundVolume)
    TriggerClientEvent('InteractSound_CL:PlayOnAll', -1, soundFile, soundVolume)
end)

--[[
    -- Type: Event
    -- Name: InteractSound_SV:PlayWithinDistance
    -- Use: Play sound for clients within range of source
    -- Created: 2024-06-09
    -- By: VSSVSSN
--]]
RegisterNetEvent('InteractSound_SV:PlayWithinDistance', function(maxDistance, soundFile, soundVolume)
    TriggerClientEvent('InteractSound_CL:PlayWithinDistance', -1, source, maxDistance, soundFile, soundVolume)
end)

--[[
    -- Type: Event
    -- Name: InteractSound_SV:PlayWithinDistanceOfCoords
    -- Use: Play sound for clients near coordinates
    -- Created: 2024-06-09
    -- By: VSSVSSN
--]]
RegisterNetEvent('InteractSound_SV:PlayWithinDistanceOfCoords', function(maxDistance, soundFile, soundVolume, coords)
    TriggerClientEvent('InteractSound_CL:PlayWithinDistanceOfCoords', -1, maxDistance, soundFile, soundVolume, coords)
end)

--[[
    -- Type: Event
    -- Name: InteractSound_SV:PlayFlash
    -- Use: Play sound with fade on a specific client
    -- Created: 2024-06-09
    -- By: VSSVSSN
--]]
RegisterNetEvent('InteractSound_SV:PlayFlash', function(clientNetId, soundFile, soundVolume, time, hold)
    TriggerClientEvent('InteractSound_CL:PlayFlash', clientNetId, soundFile, soundVolume, time, hold)
end)

