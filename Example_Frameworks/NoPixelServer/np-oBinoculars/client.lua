local FOV_MAX, FOV_MIN = 70.0, 5.0 --[[ Max and min field of view ]]--
local ZOOM_SPEED = 10.0 --[[ Camera zoom speed ]]--
local PAN_SPEED_LR = 8.0 --[[ Speed for panning left-right ]]--
local PAN_SPEED_UD = 8.0 --[[ Speed for panning up-down ]]--
local STORE_KEY = 177 --[[ BACKSPACE key to exit binoculars ]]--

local fov = (FOV_MAX + FOV_MIN) * 0.5
local using = false
local cam, scaleform

--[[
    -- Type: Function
    -- Name: hideHud
    -- Use: Hides HUD elements while binoculars are active
    -- Created: 2024-08-30
    -- By: VSSVSSN
--]]
local function hideHud()
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
    -- Name: handleRotation
    -- Use: Adjusts camera rotation based on player input
    -- Created: 2024-08-30
    -- By: VSSVSSN
--]]
local function handleRotation(zoomValue)
    local rightX = GetDisabledControlNormal(0, 220)
    local rightY = GetDisabledControlNormal(0, 221)
    local rot = GetCamRot(cam, 2)
    if rightX ~= 0.0 or rightY ~= 0.0 then
        local newZ = rot.z + rightX * -1.0 * PAN_SPEED_UD * (zoomValue + 0.1)
        local newX = math.max(math.min(20.0, rot.x + rightY * -1.0 * PAN_SPEED_LR * (zoomValue + 0.1)), -89.5)
        SetCamRot(cam, newX, 0.0, newZ, 2)
        SetEntityHeading(PlayerPedId(), newZ)
    end
end

--[[
    -- Type: Function
    -- Name: handleZoom
    -- Use: Handles zooming of binocular camera
    -- Created: 2024-08-30
    -- By: VSSVSSN
--]]
local function handleZoom()
    local ped = PlayerPedId()
    local inVehicle = IsPedSittingInAnyVehicle(ped)
    local up, down = 241, 242
    if inVehicle then
        up, down = 17, 16
    end
    if IsControlJustPressed(0, up) then
        fov = math.max(fov - ZOOM_SPEED, FOV_MIN)
    end
    if IsControlJustPressed(0, down) then
        fov = math.min(fov + ZOOM_SPEED, FOV_MAX)
    end
    local currentFov = GetCamFov(cam)
    if math.abs(fov - currentFov) < 0.1 then
        fov = currentFov
    end
    SetCamFov(cam, currentFov + (fov - currentFov) * 0.05)
end

--[[
    -- Type: Function
    -- Name: stopBinoculars
    -- Use: Cleans up camera and resets effects
    -- Created: 2024-08-30
    -- By: VSSVSSN
--]]
local function stopBinoculars()
    local ped = PlayerPedId()
    ClearPedTasks(ped)
    ClearTimecycleModifier()
    fov = (FOV_MAX + FOV_MIN) * 0.5
    RenderScriptCams(false, false, 0, true, false)
    if scaleform then
        SetScaleformMovieAsNoLongerNeeded(scaleform)
        scaleform = nil
    end
    if cam then
        DestroyCam(cam, false)
        cam = nil
    end
    SetNightvision(false)
    SetSeethrough(false)
    TriggerEvent("disabledWeapons", false)
end

--[[
    -- Type: Function
    -- Name: startBinoculars
    -- Use: Initializes binocular camera and control loop
    -- Created: 2024-08-30
    -- By: VSSVSSN
--]]
local function startBinoculars()
    local ped = PlayerPedId()
    TriggerEvent("disabledWeapons", true)
    if not IsPedSittingInAnyVehicle(ped) then
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_BINOCULARS", 0, true)
        PlayAmbientSpeech1(ped, "GENERIC_CURSE_MED", "SPEECH_PARAMS_FORCE")
    end
    Wait(2000)
    SetTimecycleModifier("default")
    SetTimecycleModifierStrength(0.3)
    scaleform = RequestScaleformMovie("BINOCULARS")
    while not HasScaleformMovieLoaded(scaleform) do
        Wait(0)
    end
    cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
    AttachCamToEntity(cam, ped, 0.0, 0.0, 1.0, true)
    SetCamRot(cam, 0.0, 0.0, GetEntityHeading(ped))
    SetCamFov(cam, fov)
    RenderScriptCams(true, false, 0, true, false)
    PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
    PushScaleformMovieFunctionParameterInt(0)
    PopScaleformMovieFunctionVoid()
    while using and not IsEntityDead(ped) and IsPedUsingScenario(ped, "WORLD_HUMAN_BINOCULARS") do
        if IsControlJustPressed(0, STORE_KEY) then
            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
            using = false
        end
        local zoomValue = (1.0 / (FOV_MAX - FOV_MIN)) * (fov - FOV_MIN)
        handleRotation(zoomValue)
        handleZoom()
        hideHud()
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
        Wait(0)
    end
    stopBinoculars()
end

--[[
    -- Type: Event
    -- Name: binoculars:Activate2
    -- Use: Toggles binocular usage
    -- Created: 2024-08-30
    -- By: VSSVSSN
--]]
RegisterNetEvent('binoculars:Activate2', function()
    using = not using
    if using then
        CreateThread(startBinoculars)
    else
        stopBinoculars()
        TriggerEvent("animation:c")
    end
end)

--[[
    -- Type: Command
    -- Name: togglebinoculars
    -- Use: Key mapping to toggle binoculars
    -- Created: 2024-08-30
    -- By: VSSVSSN
--]]
RegisterCommand('togglebinoculars', function()
    TriggerEvent('binoculars:Activate2')
end, false)
RegisterKeyMapping('togglebinoculars', 'Toggle Binoculars', 'keyboard', 'b')
