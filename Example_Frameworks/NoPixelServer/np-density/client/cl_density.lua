DecorRegister('ScriptedPed', 2)

--[[
    -- Type: Variable
    -- Name: defaultDensity
    -- Use: Controls spawn density for vehicles/peds
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
local defaultDensity = 0.8
local density = defaultDensity
local markedPeds = {}
local requiredChecks = 4

--[[
    -- Type: Function
    -- Name: setDensity
    -- Use: Updates density multiplier at runtime
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
local function setDensity(mult)
    density = mult
end
RegisterNetEvent('np:peds:setDensity', function(mult)
    if type(mult) == 'number' then
        setDensity(mult)
    end
end)

--[[
    -- Type: Function
    -- Name: isModelValid
    -- Use: Ensures ped model isn't player or animal etc.
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
local function isModelValid(ped)
    local eType = GetPedType(ped)
    return eType ~= 0 and eType ~= 1 and eType ~= 3 and eType ~= 28 and not IsPedAPlayer(ped)
end

--[[
    -- Type: Function
    -- Name: isPedValid
    -- Use: Determines whether ped is candidate for deletion
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
local function isPedValid(ped)
    return not DecorExistOn(ped, 'ScriptedPed')
        and isModelValid(ped)
        and not IsEntityAMissionEntity(ped)
        and NetworkGetEntityIsNetworked(ped)
        and not IsPedDeadOrDying(ped, true)
        and IsPedStill(ped)
        and IsEntityStatic(ped)
        and not IsPedInAnyVehicle(ped)
        and not IsPedUsingAnyScenario(ped)
end

--[[
    -- Type: Function
    -- Name: deleteRoguePed
    -- Use: Deletes ped locally or returns info for server deletion
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
local function deleteRoguePed(pPed)
    local owner = NetworkGetEntityOwner(pPed)
    if owner == -1 or owner == PlayerId() then
        DeleteEntity(pPed)
    else
        return {
            netId = NetworkGetNetworkIdFromEntity(pPed),
            owner = GetPlayerServerId(owner)
        }
    end
end

--[[
    -- Type: Function
    -- Name: EnumeratePeds
    -- Use: Provides iterator over all peds
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
local function EnumeratePeds()
    return coroutine.wrap(function()
        local handle, ped = FindFirstPed()
        if handle ~= -1 then
            local success = true
            repeat
                coroutine.yield(ped)
                success, ped = FindNextPed(handle)
            until not success
            EndFindPed(handle)
        end
    end)
end

--[[
    -- Type: Thread
    -- Name: DensityThread
    -- Use: Applies density multipliers each frame
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
CreateThread(function()
    while true do
        SetParkedVehicleDensityMultiplierThisFrame(density)
        SetVehicleDensityMultiplierThisFrame(density)
        SetRandomVehicleDensityMultiplierThisFrame(density)
        SetPedDensityMultiplierThisFrame(density)
        SetScenarioPedDensityMultiplierThisFrame(density, density)
        Wait(0)
    end
end)

--[[
    -- Type: Thread
    -- Name: PedMarkThread
    -- Use: Periodically marks world peds for cleanup
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
CreateThread(function()
    while true do
        for ped in EnumeratePeds() do
            if isPedValid(ped) and not markedPeds[ped] then
                markedPeds[ped] = 1
            end
        end
        Wait(2000)
    end
end)

--[[
    -- Type: Thread
    -- Name: CleanupThread
    -- Use: Deletes rogue peds near player and informs server
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())
        local toDelete = {}

        for ped, count in pairs(markedPeds) do
            if ped and DoesEntityExist(ped) and isPedValid(ped) then
                if count >= requiredChecks and #(GetEntityCoords(ped) - playerCoords) <= 100.0 then
                    local info = deleteRoguePed(ped)
                    if info then
                        toDelete[#toDelete + 1] = info
                    end
                end
                markedPeds[ped] = count + 1
            else
                markedPeds[ped] = nil
            end
        end

        if #toDelete > 0 then
            TriggerServerEvent('np:peds:rogue', toDelete)
        end

        Wait(3000)
    end
end)

--[[
    -- Type: Event
    -- Name: np:peds:rogue:delete
    -- Use: Deletes peds by network ID
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
RegisterNetEvent('np:peds:rogue:delete', function(pNetId)
    local entity = NetworkGetEntityFromNetworkId(pNetId)
    if DoesEntityExist(entity) then
        DeleteEntity(entity)
    end
end)

--[[
    -- Type: Event
    -- Name: np:peds:decor:set
    -- Use: Applies Decor values to entities
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
RegisterNetEvent('np:peds:decor:set', function(pNetId, pType, pProperty, pValue)
    local entity = NetworkGetEntityFromNetworkId(pNetId)
    if DoesEntityExist(entity) then
        if pType == 1 then
            DecorSetFloat(entity, pProperty, pValue)
        elseif pType == 2 then
            DecorSetBool(entity, pProperty, pValue)
        elseif pType == 3 then
            DecorSetInt(entity, pProperty, pValue)
        end
    end
end)
