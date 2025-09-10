--[[
    -- Type: Client Script
    -- Name: heli_client.lua
    -- Use: Provides helicopter camera, spotlight and rappel functions
    -- Created: 06/06/2024
    -- By: VSSVSSN
--]]

local cfg = {
    fovMax = 80.0,
    fovMin = 10.0,
    zoomSpeed = 5.0,
    panSpeedLR = 3.0,
    panSpeedUD = 3.0
}

local controls = {
    helicam = 38,
    vision = 25,
    rappel = 154,
    spotlight = 183
}

local state = {
    activeCam = false,
    fov = (cfg.fovMax + cfg.fovMin) * 0.5,
    vision = 0,
    spotlight = false
}

RegisterNetEvent('event:control:update', function(tbl)
    controls.helicam = tbl.heliCam[1]
    controls.vision = tbl.helivision[1]
    controls.rappel = tbl.helirappel[1]
    controls.spotlight = tbl.helispotlight[1]
end)

--[[
    -- Type: Function
    -- Name: isPlayerInPoliceHeli
    -- Use: Determines if the player is inside the configured police helicopter
    -- Created: 06/06/2024
    -- By: VSSVSSN
--]]
local function isPlayerInPoliceHeli(ped)
    local veh = GetVehiclePedIsIn(ped, false)
    return veh ~= 0 and IsVehicleModel(veh, joaat('maverick2'))
end

--[[
    -- Type: Function
    -- Name: isHeliHighEnough
    -- Use: Checks helicopter altitude before rappelling
    -- Created: 06/06/2024
    -- By: VSSVSSN
--]]
local function isHeliHighEnough(heli)
    return GetEntityHeightAboveGround(heli) > 5.5
end

--[[
    -- Type: Function
    -- Name: changeVision
    -- Use: Toggles night and thermal vision modes
    -- Created: 06/06/2024
    -- By: VSSVSSN
--]]
local function changeVision()
    if state.vision == 0 then
        SetNightvision(true)
        state.vision = 1
    elseif state.vision == 1 then
        SetNightvision(false)
        SetSeethrough(true)
        state.vision = 2
    else
        SetSeethrough(false)
        state.vision = 0
    end
end

--[[
    -- Type: Function
    -- Name: hideHud
    -- Use: Hides HUD components while in helicam mode
    -- Created: 06/06/2024
    -- By: VSSVSSN
--]]
local function hideHud()
    HideHelpTextThisFrame()
    HideHudAndRadarThisFrame()
    for _, comp in ipairs({1,2,3,4,13,15,18,19}) do
        HideHudComponentThisFrame(comp)
    end
end

--[[
    -- Type: Function
    -- Name: checkInputRotation
    -- Use: Rotates camera based on player input
    -- Created: 06/06/2024
    -- By: VSSVSSN
--]]
local function checkInputRotation(cam, zoom)
    local rightX = GetDisabledControlNormal(0, 220)
    local rightY = GetDisabledControlNormal(0, 221)
    local rot = GetCamRot(cam, 2)

    if rightX ~= 0.0 or rightY ~= 0.0 then
        local newZ = rot.z + rightX * -1.0 * cfg.panSpeedLR * (zoom + 0.1)
        local newX = math.max(math.min(20.0, rot.x + rightY * -1.0 * cfg.panSpeedUD * (zoom + 0.1)), -89.5)
        SetCamRot(cam, newX, 0.0, newZ, 2)
    end
end

--[[
    -- Type: Function
    -- Name: handleZoom
    -- Use: Manages camera zoom behaviour
    -- Created: 06/06/2024
    -- By: VSSVSSN
--]]
local function handleZoom(cam)
    if IsControlJustPressed(0, 241) then
        state.fov = math.max(state.fov - cfg.zoomSpeed, cfg.fovMin)
    elseif IsControlJustPressed(0, 242) then
        state.fov = math.min(state.fov + cfg.zoomSpeed, cfg.fovMax)
    end

    local current = GetCamFov(cam)
    SetCamFov(cam, current + (state.fov - current) * 0.05)
end

--[[
    -- Type: Function
    -- Name: toggleSpotlight
    -- Use: Toggles and syncs helicopter spotlight
    -- Created: 06/06/2024
    -- By: VSSVSSN
--]]
local function toggleSpotlight()
    state.spotlight = not state.spotlight
    TriggerServerEvent('heli:spotlight_update', GetPlayerServerId(PlayerId()), state.spotlight)
end

--[[
    -- Type: Function
    -- Name: startHeliCam
    -- Use: Creates and activates the helicam
    -- Created: 06/06/2024
    -- By: VSSVSSN
--]]
local cam
local function startHeliCam(ped, heli)
    cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
    AttachCamToEntity(cam, heli, 0.0, 0.0, -1.5, true)
    SetCamRot(cam, 0.0, 0.0, GetEntityHeading(heli), 2)
    SetCamFov(cam, state.fov)
    RenderScriptCams(true, false, 0, true, false)
    state.activeCam = true
end

--[[
    -- Type: Function
    -- Name: stopHeliCam
    -- Use: Destroys the helicam and resets vision
    -- Created: 06/06/2024
    -- By: VSSVSSN
--]]
local function stopHeliCam()
    state.activeCam = false
    RenderScriptCams(false, false, 0, true, false)
    DestroyCam(cam, false)
    cam = nil
    state.vision = 0
    SetNightvision(false)
    SetSeethrough(false)
end

--[[
    -- Type: Function
    -- Name: handleHeliCam
    -- Use: Processes helicam behaviour each frame
    -- Created: 06/06/2024
    -- By: VSSVSSN
--]]
local function handleHeliCam(ped, heli)
    if IsControlJustPressed(0, controls.helicam) then
        if state.activeCam then
            stopHeliCam()
        else
            startHeliCam(ped, heli)
        end
    end

    if not state.activeCam then return end

    DisableControlAction(0, 1, true)
    DisableControlAction(0, 2, true)
    hideHud()

    local zoom = (1.0 / (cfg.fovMax - cfg.fovMin)) * (state.fov - cfg.fovMin)
    checkInputRotation(cam, zoom)
    handleZoom(cam)

    if IsControlJustPressed(0, controls.vision) then
        changeVision()
    elseif IsControlJustPressed(0, controls.spotlight) then
        toggleSpotlight()
    end
end

RegisterNetEvent('heli:spotlight_update', function(serverId, enabled)
    local player = GetPlayerFromServerId(serverId)
    if NetworkIsPlayerActive(player) then
        local heli = GetVehiclePedIsIn(GetPlayerPed(player), false)
        SetVehicleSearchlight(heli, enabled, false)
    end
end)

--[[
    -- Type: Function
    -- Name: mainLoop
    -- Use: Entry point controlling all heli features
    -- Created: 06/06/2024
    -- By: VSSVSSN
--]]
CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        if isPlayerInPoliceHeli(ped) then
            sleep = 0
            local heli = GetVehiclePedIsIn(ped, false)

            if IsControlJustPressed(0, controls.rappel) and isHeliHighEnough(heli) then
                TaskRappelFromHeli(ped, 1)
            end

            handleHeliCam(ped, heli)
        else
            if state.activeCam then
                stopHeliCam()
            end
        end
        Wait(sleep)
    end
end)

