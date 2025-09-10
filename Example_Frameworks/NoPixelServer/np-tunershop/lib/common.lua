--[[
    -- Type: Module
    -- Name: common.lua
    -- Use: Shared utilities for IPL, rendering and texture handling
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

TunerLib = {}

--[[
    -- Type: Function
    -- Name: EnableIpl
    -- Use: Loads or removes IPLs
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function isTable(value)
    return type(value) == 'table'
end

function TunerLib.EnableIpl(ipl, activate)
    if isTable(ipl) then
        for _, value in pairs(ipl) do
            TunerLib.EnableIpl(value, activate)
        end
    else
        if activate then
            if not IsIplActive(ipl) then
                RequestIpl(ipl)
            end
        else
            if IsIplActive(ipl) then
                RemoveIpl(ipl)
            end
        end
    end
end
exports('EnableIpl', TunerLib.EnableIpl)

--[[
    -- Type: Function
    -- Name: SetIplPropState
    -- Use: Toggles interior props on an interior
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function TunerLib.SetIplPropState(interiorId, props, state, refresh)
    refresh = refresh or false
    if isTable(interiorId) then
        for _, id in pairs(interiorId) do
            TunerLib.SetIplPropState(id, props, state, refresh)
        end
    else
        if isTable(props) then
            for _, prop in pairs(props) do
                TunerLib.SetIplPropState(interiorId, prop, state, refresh)
            end
        else
            if state then
                if not IsInteriorPropEnabled(interiorId, props) then
                    EnableInteriorProp(interiorId, props)
                end
            else
                if IsInteriorPropEnabled(interiorId, props) then
                    DisableInteriorProp(interiorId, props)
                end
            end
        end
        if refresh then
            RefreshInterior(interiorId)
        end
    end
end

--[[
    -- Type: Function
    -- Name: CreateNamedRenderTargetForModel
    -- Use: Creates render target and links to a model
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function TunerLib.CreateNamedRenderTargetForModel(name, model)
    local handle = 0
    if not IsNamedRendertargetRegistered(name) then
        RegisterNamedRendertarget(name, false)
    end
    if not IsNamedRendertargetLinked(model) then
        LinkNamedRendertarget(model)
    end
    if IsNamedRendertargetRegistered(name) then
        handle = GetNamedRendertargetRenderId(name)
    end
    return handle
end

--[[
    -- Type: Function
    -- Name: DrawEmptyRect
    -- Use: Draws an empty rectangle on a render target
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function TunerLib.DrawEmptyRect(name, model)
    local step = 250
    local timeout = 5 * 1000
    local currentTime = 0
    local renderId = TunerLib.CreateNamedRenderTargetForModel(name, model)

    while not IsNamedRendertargetRegistered(name) do
        Wait(step)
        currentTime = currentTime + step
        if currentTime >= timeout then return false end
    end

    if IsNamedRendertargetRegistered(name) then
        SetTextRenderId(renderId)
        SetUiLayer(4)
        DrawRect(0.5, 0.5, 1.0, 1.0, 0, 0, 0, 0)
        SetTextRenderId(GetDefaultScriptRendertargetRenderId())
        ReleaseNamedRendertarget(0, name)
    end

    return true
end

--[[
    -- Type: Function
    -- Name: LoadStreamedTextureDict
    -- Use: Loads texture dictionary with timeout safety
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function TunerLib.LoadStreamedTextureDict(texturesDict)
    local step = 1000
    local timeout = 5 * 1000
    local currentTime = 0

    RequestStreamedTextureDict(texturesDict, 0)
    while not HasStreamedTextureDictLoaded(texturesDict) do
        Wait(step)
        currentTime = currentTime + step
        if currentTime >= timeout then return false end
    end
    return true
end

--[[
    -- Type: Function
    -- Name: LoadScaleform
    -- Use: Requests a scaleform movie with timeout safety
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function TunerLib.LoadScaleform(scaleform)
    local step = 1000
    local timeout = 5 * 1000
    local currentTime = 0
    local handle = RequestScaleformMovie(scaleform)

    while not HasScaleformMovieLoaded(handle) do
        Wait(step)
        currentTime = currentTime + step
        if currentTime >= timeout then return -1 end
    end

    return handle
end

--[[
    -- Type: Function
    -- Name: GetPedheadshot
    -- Use: Registers ped headshot and waits until ready
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function TunerLib.GetPedheadshot(ped)
    local step = 1000
    local timeout = 5 * 1000
    local currentTime = 0
    local pedheadshot = RegisterPedheadshot(ped)

    while not IsPedheadshotReady(pedheadshot) do
        Wait(step)
        currentTime = currentTime + step
        if currentTime >= timeout then return -1 end
    end

    return pedheadshot
end

--[[
    -- Type: Function
    -- Name: GetPedheadshotTexture
    -- Use: Retrieves texture dictionary name for a ped headshot
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function TunerLib.GetPedheadshotTexture(ped)
    local textureDict = nil
    local pedheadshot = TunerLib.GetPedheadshot(ped)

    if pedheadshot ~= -1 then
        textureDict = GetPedheadshotTxdString(pedheadshot)
        local loaded = TunerLib.LoadStreamedTextureDict(textureDict)
        if not loaded then
            print(string.format('ERROR: Texture dictionary "%s" failed to load.', tostring(textureDict)))
        end
    else
        print('ERROR: Ped headshot not ready.')
    end

    return textureDict
end
exports('GetPedheadshotTexture', TunerLib.GetPedheadshotTexture)

