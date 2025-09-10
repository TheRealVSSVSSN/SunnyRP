local particleCounter = 0

--[[
    -- Type: Function
    -- Name: particleStart
    -- Use: Starts a particle effect for all clients and returns its id
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function particleStart(x, y, z, particle, rX, rY, rZ)
    particleCounter = particleCounter + 1
    TriggerClientEvent('particle:StartClientParticle', -1, x, y, z, particle, particleCounter, rX or 0.0, rY or 0.0, rZ or 0.0)
    return particleCounter
end
exports('particleStart', particleStart)

--[[
    -- Type: Function
    -- Name: particleStop
    -- Use: Stops a running particle effect by id
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function particleStop(id)
    TriggerClientEvent('particle:StopParticleClient', -1, id)
end
exports('particleStop', particleStop)

RegisterNetEvent('particle:StartParticleAtLocation')
AddEventHandler('particle:StartParticleAtLocation', function(x, y, z, particle, id, rX, rY, rZ)
    TriggerClientEvent('particle:StartClientParticle', -1, x, y, z, particle, id, rX or 0.0, rY or 0.0, rZ or 0.0)
end)

RegisterNetEvent('particle:StopParticle')
AddEventHandler('particle:StopParticle', function(id)
    particleStop(id)
end)
