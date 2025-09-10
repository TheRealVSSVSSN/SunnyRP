--[[
    -- Type: Local
    -- Name: pointingKey
    -- Use: Control index for the B key used to point
    -- Created: 2025-06-09
    -- By: VSSVSSN
--]]
local pointingKey = 29

--[[
    -- Type: Local
    -- Name: pointing
    -- Use: Tracks if the player is currently pointing
    -- Created: 2025-06-09
    -- By: VSSVSSN
--]]
local pointing = false

--[[
    -- Type: Function
    -- Name: isPointingAllowed
    -- Use: Verifies that the player can perform the pointing emote
    -- Created: 2025-06-09
    -- By: VSSVSSN
--]]
local function isPointingAllowed()
    local ped = PlayerPedId()
    if exports["isPed"]:isPed("dead") then return false end
    if IsPedInAnyVehicle(ped, false) then return false end
    if IsEntityPlayingAnim(ped, "mp_arresting", "idle", 3) then return false end
    return true
end

--[[
    -- Type: Function
    -- Name: startPointing
    -- Use: Loads the pointing animation and starts the task
    -- Created: 2025-06-09
    -- By: VSSVSSN
--]]
local function startPointing()
    local ped = PlayerPedId()
    RequestAnimDict("anim@mp_point")
    while not HasAnimDictLoaded("anim@mp_point") do
        Citizen.Wait(0)
    end
    SetPedCurrentWeaponVisible(ped, false, true, true, true)
    SetPedConfigFlag(ped, 36, true)
    TaskMoveNetworkByName(ped, "task_mp_pointing", 0.5, false, "anim@mp_point", 24)
    RemoveAnimDict("anim@mp_point")
    pointing = true
end

--[[
    -- Type: Function
    -- Name: stopPointing
    -- Use: Stops the pointing task and clears related flags
    -- Created: 2025-06-09
    -- By: VSSVSSN
--]]
local function stopPointing()
    local ped = PlayerPedId()
    RequestTaskMoveNetworkStateTransition(ped, "Stop")
    if not IsPedInjured(ped) then
        ClearPedSecondaryTask(ped)
        SetPedCurrentWeaponVisible(ped, true, true, true, true)
        SetPedConfigFlag(ped, 36, false)
    end
    pointing = false
end

--[[
    -- Type: Function
    -- Name: updatePointing
    -- Use: Updates the pointing direction based on camera orientation
    -- Created: 2025-06-09
    -- By: VSSVSSN
--]]
local function updatePointing()
    Citizen.CreateThread(function()
        while pointing do
            local ped = PlayerPedId()
            local camPitch = GetGameplayCamRelativePitch()
            if camPitch < -70.0 then
                camPitch = -70.0
            elseif camPitch > 42.0 then
                camPitch = 42.0
            end
            camPitch = (camPitch + 70.0) / 112.0

            local camHeading = GetGameplayCamRelativeHeading()
            if camHeading < -180.0 then
                camHeading = -180.0
            elseif camHeading > 180.0 then
                camHeading = 180.0
            end
            camHeading = (camHeading + 180.0) / 360.0

            SetTaskMoveNetworkSignalFloat(ped, "Pitch", camPitch)
            SetTaskMoveNetworkSignalFloat(ped, "Heading", camHeading)
            SetTaskMoveNetworkSignalBool(ped, "isBlocked", false)
            SetTaskMoveNetworkSignalBool(ped, "isFirstPerson", GetFollowPedCamViewMode() == 4)
            Citizen.Wait(0)
        end
    end)
end

--[[
    -- Type: Event
    -- Name: np-base:playerSessionStarted
    -- Use: Initializes key handling once the player session is active
    -- Created: 2025-06-09
    -- By: VSSVSSN
--]]
AddEventHandler("np-base:playerSessionStarted", function()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if pointing then
                if not IsControlPressed(0, pointingKey) or not isPointingAllowed() then
                    stopPointing()
                end
            else
                if IsControlJustPressed(0, pointingKey) and isPointingAllowed() then
                    startPointing()
                    updatePointing()
                end
            end
        end
    end)
end)

---- Pointing emote ---- Segment end ----
