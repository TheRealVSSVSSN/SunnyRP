--[[
    -- Type: Client Script
    -- Name: main.lua
    -- Use: Handles client-side sound playback for InteractSound
    -- Created: 2024-06-09
    -- By: VSSVSSN
--]]

local defaultVolume = 1.0

--[[
    -- Type: Function
    -- Name: clampVolume
    -- Use: Ensures volume remains within 0.0 - 1.0
    -- Created: 2024-06-09
    -- By: VSSVSSN
--]]
local function clampVolume(vol)
    vol = tonumber(vol) or defaultVolume
    if vol < 0.0 then vol = 0.0 end
    if vol > 1.0 then vol = 1.0 end
    return vol
end

--[[
    -- Type: Function
    -- Name: playSound
    -- Use: Sends NUI message to play a sound file
    -- Created: 2024-06-09
    -- By: VSSVSSN
--]]
local function playSound(soundFile, soundVolume)
    SendNUIMessage({
        transactionType   = 'playSound',
        transactionFile   = soundFile,
        transactionVolume = clampVolume(soundVolume)
    })
end

--[[
    -- Type: Function
    -- Name: playFlashSound
    -- Use: Plays sound and fades volume after hold
    -- Created: 2024-06-09
    -- By: VSSVSSN
--]]
local function playFlashSound(soundFile, soundVolume, time, hold)
    SendNUIMessage({
        transactionType   = 'playSoundFlash',
        transactionFile   = soundFile,
        transactionVolume = clampVolume(soundVolume),
        transactionTime   = time,
        transactionHold   = hold
    })
end

--[[
    -- Type: Event
    -- Name: InteractSound_CL:PlayOnOne
    -- Use: Play sound locally on this client
    -- Created: 2024-06-09
    -- By: VSSVSSN
--]]
RegisterNetEvent('InteractSound_CL:PlayOnOne', function(soundFile, soundVolume)
    playSound(soundFile, soundVolume)
end)

--[[
    -- Type: Event
    -- Name: InteractSound_CL:PlayOnAll
    -- Use: Play sound on all clients
    -- Created: 2024-06-09
    -- By: VSSVSSN
--]]
RegisterNetEvent('InteractSound_CL:PlayOnAll', function(soundFile, soundVolume)
    playSound(soundFile, soundVolume)
end)

--[[
    -- Type: Event
    -- Name: InteractSound_CL:PlayWithinDistance
    -- Use: Play sound when within range of a target player
    -- Created: 2024-06-09
    -- By: VSSVSSN
--]]
RegisterNetEvent('InteractSound_CL:PlayWithinDistance', function(playerNetId, maxDistance, soundFile, soundVolume)
    local player = GetPlayerFromServerId(playerNetId)
    if player == -1 or not NetworkIsPlayerActive(player) then return end

    local lCoords = GetEntityCoords(PlayerPedId())
    local eCoords = GetEntityCoords(GetPlayerPed(player))
    if #(lCoords - eCoords) <= maxDistance then
        playSound(soundFile, soundVolume)
    end
end)

--[[
    -- Type: Event
    -- Name: InteractSound_CL:PlayWithinDistanceOfCoords
    -- Use: Play sound when within range of provided coordinates
    -- Created: 2024-06-09
    -- By: VSSVSSN
--]]
RegisterNetEvent('InteractSound_CL:PlayWithinDistanceOfCoords', function(maxDistance, soundFile, soundVolume, coords)
    local lCoords = GetEntityCoords(PlayerPedId())
    local targetCoords = vector3(coords[1], coords[2], coords[3])
    if #(lCoords - targetCoords) <= maxDistance then
        playSound(soundFile, soundVolume)
    end
end)

--[[
    -- Type: Event
    -- Name: InteractSound_CL:PlayFlash
    -- Use: Play sound with fade effect
    -- Created: 2024-06-09
    -- By: VSSVSSN
--]]
RegisterNetEvent('InteractSound_CL:PlayFlash', function(soundFile, soundVolume, time, hold)
    playFlashSound(soundFile, soundVolume, time, hold)
end)

