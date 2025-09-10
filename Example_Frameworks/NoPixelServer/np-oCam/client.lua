--[[
    -- Type: Client Script
    -- Name: np-oCam
    -- Use: Handles camera view toggling and disables combat controls when needed
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]

local INPUT_AIM = 25
local useFPS = false
local justPressed = 0
local disable = 0

--[[
    -- Type: Function
    -- Name: handleCameraView
    -- Use: Toggles first-person view on quick aim and blocks unwanted camera modes
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
local function handleCameraView()
    while true do
        Wait(0)

        if IsControlPressed(0, INPUT_AIM) then
            justPressed = justPressed + 1
        end

        if IsControlJustReleased(0, INPUT_AIM) then
            if justPressed < 15 then
                useFPS = true
            end
            justPressed = 0
        end

        if GetFollowPedCamViewMode() == 1 or GetFollowVehicleCamViewMode() == 1 then
            SetFollowPedCamViewMode(0)
            SetFollowVehicleCamViewMode(0)
        end

        if useFPS then
            if GetFollowPedCamViewMode() == 0 or GetFollowVehicleCamViewMode() == 0 then
                SetFollowPedCamViewMode(4)
                SetFollowVehicleCamViewMode(4)
            else
                SetFollowPedCamViewMode(0)
                SetFollowVehicleCamViewMode(0)
            end
            useFPS = false
        end

        local ped = PlayerPedId()
        if IsPedArmed(ped, 1) or not IsPedArmed(ped, 7) then
            if IsControlJustPressed(0, 24) or IsControlJustPressed(0, 141) or IsControlJustPressed(0, 142) or IsControlJustPressed(0, 140) then
                disable = 50
            end
        end

        if disable > 0 then
            disable = disable - 1
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
        end
    end
end

--[[
    -- Type: Function
    -- Name: disableMeleeWhileArmed
    -- Use: Disables melee controls when player is armed
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
local function disableMeleeWhileArmed()
    while true do
        local ped = PlayerPedId()
        if IsPedArmed(ped, 6) then
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
            Wait(0)
        else
            Wait(1500)
        end
    end
end

CreateThread(handleCameraView)
CreateThread(disableMeleeWhileArmed)

