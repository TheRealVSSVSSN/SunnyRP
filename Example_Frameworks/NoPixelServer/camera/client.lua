--[[
    -- Type: Event
    -- Name: selfiePhone
    -- Use: Activates the in-vehicle selfie camera and handles capture flow
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

local TakePhoto = N_0xa67c35c56eb1bd9d
local WasPhotoTaken = N_0x0d6ca79eeebd8ca3
local SavePhoto = N_0x3dec726c25a11bac
local ClearPhoto = N_0xd801cc02177fa3f1

local phoneActive = false
local firstTime = true
local displayDoneMission = false

local function setSelfieMode(toggle)
    -- Wrap native 0x2491A93618B7D838 for readability
    Citizen.InvokeNative(0x2491A93618B7D838, toggle)
end

RegisterNetEvent('selfiePhone', function()
    if phoneActive or not IsPedInAnyVehicle(PlayerPedId(), false) then
        return
    end

    CreateMobilePhone(2)
    CellCamActivate(true, true)
    setSelfieMode(true)
    phoneActive = true

    while phoneActive do
        local dead = exports['isPed']:isPed('dead')
        if IsControlJustPressed(0, 176) or IsControlJustPressed(0, 322) or dead then
            phoneActive = false
        end
        Wait(0)
    end

    DestroyMobilePhone()
    CellCamActivate(false, false)

    if firstTime then
        firstTime = false
        Wait(2500)
        displayDoneMission = true
    end
end)

