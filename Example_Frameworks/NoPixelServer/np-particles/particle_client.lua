local activeEffects = {}

local particleList = {
    ["vehExhaust"] = { dic = "core", name = "veh_exhaust_truck_rig", loopAmount = 25, timeCheck = 12000 },
    ["lavaPour"]   = { dic = "core", name = "ent_amb_foundry_molten_pour", loopAmount = 1,  timeCheck = 12000 },
    ["lavaSteam"]  = { dic = "core", name = "ent_amb_steam_pipe_hvy",       loopAmount = 1,  timeCheck = 12000 },
    ["spark"]      = { dic = "core", name = "ent_amb_sparking_wires",       loopAmount = 1,  timeCheck = 12000 },
    ["smoke"]      = { dic = "core", name = "exp_grd_grenade_smoke",        loopAmount = 1,  timeCheck = 12000 },
    ["test"]       = { dic = "core", name = "ent_amb_steam_pipe_hvy",       loopAmount = 1,  timeCheck = 12000 }
}

--[[
    -- Type: Event
    -- Name: particle:StartClientParticle
    -- Use: Starts a particle effect on the client when triggered by the server
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent("particle:StartClientParticle", function(x, y, z, particleId, allocatedID, rX, rY, rZ)
    local data = particleList[particleId]
    if not data then return end

    local playerCoords = GetEntityCoords(PlayerPedId())
    if #(playerCoords - vector3(x, y, z)) > 100.0 then return end

    if not HasNamedPtfxAssetLoaded(data.dic) then
        RequestNamedPtfxAsset(data.dic)
        while not HasNamedPtfxAssetLoaded(data.dic) do
            Wait(0)
        end
    end

    UseParticleFxAssetNextCall(data.dic)
    activeEffects[allocatedID] = activeEffects[allocatedID] or {}

    for _ = 1, data.loopAmount do
        local particle = StartParticleFxLoopedAtCoord(data.name, x, y, z, rX or 0.0, rY or 0.0, rZ or 0.0, 1.0, false, false, false, false)
        table.insert(activeEffects[allocatedID], particle)
        Wait(0)
    end

    if data.timeCheck and data.timeCheck > 0 then
        SetTimeout(data.timeCheck, function()
            TriggerEvent("particle:StopParticleClient", allocatedID)
            TriggerServerEvent("particle:StopParticle", allocatedID)
        end)
    end
end)

--[[
    -- Type: Event
    -- Name: particle:StopParticleClient
    -- Use: Stops a running particle effect on the client
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent("particle:StopParticleClient", function(allocatedID)
    local effects = activeEffects[allocatedID]
    if not effects then return end

    for _, particle in ipairs(effects) do
        StopParticleFxLooped(particle, true)
    end
    activeEffects[allocatedID] = nil
end)
