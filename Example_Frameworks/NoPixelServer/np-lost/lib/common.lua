
exports('EnableIpl', function(ipl, activate)
    EnableIpl(ipl, activate)
end)

exports('GetPedheadshotTexture', function(ped)
    return GetPedheadshotTexture(ped)
end)

--[[
    -- Type: Function
    -- Name: EnableIpl
    -- Use: Loads or removes interior IPLs based on activation flag
    -- Created: 2023-09-10
    -- By: VSSVSSN
--]]
function EnableIpl(ipl, activate)
    if IsTable(ipl) then
        for key, value in pairs(ipl) do
            EnableIpl(value, activate)
        end
    else
        if activate then
            if not IsIplActive(ipl) then RequestIpl(ipl) end
        else
            if IsIplActive(ipl) then RemoveIpl(ipl) end
        end
    end
end

--[[
    -- Type: Function
    -- Name: SetIplPropState
    -- Use: Toggles props inside an interior and optionally refreshes it
    -- Created: 2023-09-10
    -- By: VSSVSSN
--]]
function SetIplPropState(interiorId, props, state, refresh)
    if refresh == nil then refresh = false end
    if IsTable(interiorId) then
        for key, value in pairs(interiorId) do
            SetIplPropState(value, props, state, refresh)
        end
    else
        if IsTable(props) then
            for key, value in pairs(props) do
                SetIplPropState(interiorId, value, state, refresh)
            end
        else
            if state then
                if not IsInteriorPropEnabled(interiorId, props) then EnableInteriorProp(interiorId, props) end
            else
                if IsInteriorPropEnabled(interiorId, props) then DisableInteriorProp(interiorId, props) end
            end
        end
        if refresh == true then RefreshInterior(interiorId) end
    end
end

--[[
    -- Type: Function
    -- Name: CreateNamedRenderTargetForModel
    -- Use: Links a render target to a model and returns its handle
    -- Created: 2023-09-10
    -- By: VSSVSSN
--]]
function CreateNamedRenderTargetForModel(name, model)
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
    -- Use: Renders a transparent rectangle on a model's render target
    -- Created: 2023-09-10
    -- By: VSSVSSN
--]]
function DrawEmptyRect(name, model)
    local step = 250
    local timeout = 5 * 1000
    local currentTime = 0
    local renderId = CreateNamedRenderTargetForModel(name, model)

    while (not IsNamedRendertargetRegistered(name)) do
        Wait(step)
        currentTime = currentTime + step
        if (currentTime >= timeout) then return false end
    end
    if (IsNamedRendertargetRegistered(name)) then
        SetTextRenderId(renderId)
        SetUiLayer(4)
        DrawRect(0.5, 0.5, 1.0, 1.0, 0, 0, 0, 0)
        SetTextRenderId(GetDefaultScriptRendertargetRenderId())

        ReleaseNamedRendertarget(0, name)
    end

    return true
end

--[[
    TO REMOVE
]]--
--[[
    -- Type: Function
    -- Name: LoadEmptyScaleform
    -- Use: Deprecated helper for initializing empty scaleforms
    -- Created: 2023-09-10
    -- By: VSSVSSN
--]]
function LoadEmptyScaleform(renderTarget, prop, scaleform, sfFunction)
    local renderId = CreateNamedRenderTargetForModel(renderTarget, prop)
    local gfxHandle = -1

    SetTextRenderId(renderId)
    SetTextRenderId(GetDefaultScriptRendertargetRenderId())

    if (scaleform ~= nil) then
        gfxHandle = RequestScaleformMovie(scaleform)
    end

    if (sfFunction ~= nil) then
        BeginScaleformMovieMethod(gfxHandle, sfFunction)
        PushScaleformMovieMethodParameterInt(-1)
        EndScaleformMovieMethod()
    end
end

--[[
    -- Type: Function
    -- Name: SetupScaleform
    -- Use: Builds a scaleform movie with supplied parameters
    -- Created: 2023-09-10
    -- By: VSSVSSN
--]]
function SetupScaleform(movieId, scaleformFunction, parameters)
    BeginScaleformMovieMethod(movieId, scaleformFunction)
    if (IsTable(parameters)) then
        for i = 0, Tablelength(parameters) - 1 do
            local p = parameters["p" .. tostring(i)]
            if (p.type == "bool") then
                PushScaleformMovieMethodParameterBool(p.value)
            elseif (p.type == "int") then
                PushScaleformMovieMethodParameterInt(p.value)
            elseif (p.type == "float") then
                PushScaleformMovieMethodParameterFloat(p.value)
            elseif (p.type == "string") then
                PushScaleformMovieMethodParameterString(p.value)
            elseif (p.type == "buttonName") then
                PushScaleformMovieMethodParameterButtonName(p.value)
            end
        end
    end
    EndScaleformMovieMethod()
    N_0x32f34ff7f617643b(movieId, 1)
end

--[[
    -- Type: Function
    -- Name: LoadStreamedTextureDict
    -- Use: Requests and waits for a texture dictionary to load
    -- Created: 2023-09-10
    -- By: VSSVSSN
--]]
function LoadStreamedTextureDict(texturesDict)
    local step = 1000
    local timeout = 5 * 1000
    local currentTime = 0

    RequestStreamedTextureDict(texturesDict, 0)
    while not HasStreamedTextureDictLoaded(texturesDict) do
        Wait(step)
        currentTime = currentTime + step
        if (currentTime >= timeout) then return false end
    end
    return true
end

--[[
    -- Type: Function
    -- Name: LoadScaleform
    -- Use: Loads a scaleform movie and returns its handle
    -- Created: 2023-09-10
    -- By: VSSVSSN
--]]
function LoadScaleform(scaleform)
    local step = 1000
    local timeout = 5 * 1000
    local currentTime = 0
    local handle = RequestScaleformMovie(scaleform)

    while (not HasScaleformMovieLoaded(handle)) do
        Wait(step)
        currentTime = currentTime + step
        if (currentTime >= timeout) then return -1 end
    end

    return handle
end

--[[
    -- Type: Function
    -- Name: GetPedheadshot
    -- Use: Creates a headshot for a ped and waits until ready
    -- Created: 2023-09-10
    -- By: VSSVSSN
--]]
function GetPedheadshot(ped)
    local step = 1000
    local timeout = 5 * 1000
    local currentTime = 0
    local pedheadshot = RegisterPedheadshot(ped)

    while not IsPedheadshotReady(pedheadshot) do
        Wait(step)
        currentTime = currentTime + step
        if (currentTime >= timeout) then return -1 end
    end

    return pedheadshot
end

--[[
    -- Type: Function
    -- Name: GetPedheadshotTexture
    -- Use: Returns the texture dictionary for a ped headshot
    -- Created: 2023-09-10
    -- By: VSSVSSN
--]]
function GetPedheadshotTexture(ped)
    local textureDict = nil
    local pedheadshot = GetPedheadshot(ped)

    if (pedheadshot ~= -1) then
        textureDict = GetPedheadshotTxdString(pedheadshot)
        local IsTextureDictLoaded = LoadStreamedTextureDict(textureDict)
        if (not IsTextureDictLoaded) then
            print("ERROR: BikerClubhouseDrawMembers - Textures dictionary \"" .. tostring(textureDict) .. "\" cannot be loaded.")
        end
    else
        print("ERROR: BikerClubhouseDrawMembers - PedHeadShot not ready.")
    end

    return textureDict
end

--[[ 
    -- Type: Function
    -- Name: IsTable
    -- Use: Checks if the provided value is a table
    -- Created: 2023-09-10
    -- By: VSSVSSN
--]]
function IsTable(T)
    return type(T) == 'table'
end
--[[ 
    -- Type: Function
    -- Name: Tablelength
    -- Use: Counts the number of elements in a table
    -- Created: 2023-09-10
    -- By: VSSVSSN
--]]
function Tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

