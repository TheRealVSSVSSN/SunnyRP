local fovMax = 40.0
local fovMin = 4.0 -- max zoom level (smaller fov is more zoom)
local zoomSpeed = 10.0 -- camera zoom speed
local speedLR = 5.0 -- speed by which the camera pans left-right
local speedUD = 5.0 -- speed by which the camera pans up-down
local currentTime = { '00', '00' }
local camActive = false
local cam
local scaleform
local fov = (fovMax + fovMin) * 0.5
local storeCameraKey = 177 -- BACKSPACE

--[[
    -- Type: Event
    -- Name: phone:setServerTime
    -- Use: Updates the current server time for the camera UI
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('phone:setServerTime')
AddEventHandler('phone:setServerTime', function(time)
    local h, m = time:match('(%d+):(%d+)')
    if h and m then
        currentTime = { h, m }
    end
end)

--[[
    -- Type: Function
    -- Name: HideHUDThisFrame
    -- Use: Hides various HUD components each frame while the camera is active
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function HideHUDThisFrame()
    HideHelpTextThisFrame()
    HideHudAndRadarThisFrame()
    HideHudComponentThisFrame(1)
    HideHudComponentThisFrame(2)
    HideHudComponentThisFrame(3)
    HideHudComponentThisFrame(4)
    HideHudComponentThisFrame(6)
    HideHudComponentThisFrame(7)
    HideHudComponentThisFrame(8)
    HideHudComponentThisFrame(9)
    HideHudComponentThisFrame(11)
    HideHudComponentThisFrame(12)
    HideHudComponentThisFrame(13)
    HideHudComponentThisFrame(15)
    HideHudComponentThisFrame(18)
    HideHudComponentThisFrame(19)
end

--[[
    -- Type: Function
    -- Name: CheckInputRotation
    -- Use: Adjusts camera rotation based on player input
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function CheckInputRotation(camHandle, zoomValue)
    local rightAxisX = GetDisabledControlNormal(0, 220)
    local rightAxisY = GetDisabledControlNormal(0, 221)
    local rotation = GetCamRot(camHandle, 2)
    if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
        local newZ = rotation.z + rightAxisX * -1.0 * speedUD * (zoomValue + 0.1)
        local newX = math.max(math.min(20.0, rotation.x + rightAxisY * -1.0 * speedLR * (zoomValue + 0.1)), -89.5)
        SetCamRot(camHandle, newX, 0.0, newZ, 2)
        SetEntityHeading(PlayerPedId(), newZ)
    end
end

--[[
    -- Type: Function
    -- Name: HandleZoom
    -- Use: Handles camera zoom in and out controls
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function HandleZoom(camHandle)
    local ped = PlayerPedId()
    local scrollUp = IsPedSittingInAnyVehicle(ped) and 17 or 241
    local scrollDown = IsPedSittingInAnyVehicle(ped) and 16 or 242

    if IsControlJustPressed(0, scrollUp) then
        fov = math.max(fov - zoomSpeed, fovMin)
    end
    if IsControlJustPressed(0, scrollDown) then
        fov = math.min(fov + zoomSpeed, fovMax)
    end

    local currentFov = GetCamFov(camHandle)
    if math.abs(fov - currentFov) < 0.1 then
        fov = currentFov
    end
    SetCamFov(camHandle, currentFov + (fov - currentFov) * 0.05)
end

--[[
    -- Type: Function
    -- Name: StartCamera
    -- Use: Initializes and maintains the hand-held camera
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function StartCamera()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    camActive = true

    if not IsPedSittingInAnyVehicle(ped) then
        TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_PAPARAZZI', 0, true)
        PlayAmbientSpeech1(ped, 'GENERIC_CURSE_MED', 'SPEECH_PARAMS_FORCE')
        TriggerEvent('evidence:trigger')
    end

    Wait(2000)

    SetTimecycleModifier('default')
    SetTimecycleModifierStrength(0.3)

    scaleform = RequestScaleformMovie('security_cam')
    while not HasScaleformMovieLoaded(scaleform) do
        Wait(10)
    end

    cam = CreateCam('DEFAULT_SCRIPTED_FLY_CAMERA', true)
    AttachCamToEntity(cam, ped, 0.0, 0.0, 1.0, true)
    SetCamRot(cam, 0.0, 0.0, GetEntityHeading(ped))
    SetCamFov(cam, fov)
    RenderScriptCams(true, false, 0, true, false)

    local pos = GetEntityCoords(ped)
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local zoneName = GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z))

    PushScaleformMovieFunction(scaleform, 'SET_LOCATION')
    PushScaleformMovieFunctionParameterString(zoneName)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'SET_DETAILS')
    PushScaleformMovieFunctionParameterString(street1 .. ' / ' .. street2)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'SET_TIME')
    PushScaleformMovieFunctionParameterString(currentTime[1])
    PushScaleformMovieFunctionParameterString(currentTime[2])
    PopScaleformMovieFunctionVoid()

    CreateThread(function()
        while camActive and not IsEntityDead(ped) and GetVehiclePedIsIn(ped, false) == vehicle and IsPedUsingScenario(ped, 'WORLD_HUMAN_PAPARAZZI') do
            TriggerEvent('disabledWeapons', true)

            if IsControlJustPressed(0, storeCameraKey) then
                PlaySoundFrontend(-1, 'SELECT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
                ClearPedTasks(ped)
                camActive = false
            end

            local zoomValue = (1.0 / (fovMax - fovMin)) * (fov - fovMin)
            CheckInputRotation(cam, zoomValue)
            HandleZoom(cam)
            HideHUDThisFrame()
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)

            Wait(0)
        end

        TriggerEvent('disabledWeapons', false)
        ClearTimecycleModifier()
        fov = (fovMax + fovMin) * 0.5
        RenderScriptCams(false, false, 0, true, false)
        if scaleform then
            SetScaleformMovieAsNoLongerNeeded(scaleform)
        end
        if cam then
            DestroyCam(cam, false)
        end
        SetNightvision(false)
        SetSeethrough(false)
    end)
end

--[[
    -- Type: Event
    -- Name: camera:Activate2
    -- Use: Toggles the camera on or off
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('camera:Activate2')
AddEventHandler('camera:Activate2', function()
    TriggerServerEvent('phone:getServerTime')
    if camActive then
        ClearPedTasks(PlayerPedId())
        camActive = false
    else
        StartCamera()
    end
end)

