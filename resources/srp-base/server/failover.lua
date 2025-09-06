--[[
    -- Type: Module
    -- Name: failover
    -- Use: Implements a simple circuit breaker with retry queue
    -- Created: 2024-11-26
    -- By: VSSVSSN
    -- Updated: 2024-11-27
--]]

local SRP = SRP or require('resources/srp-base/shared/srp.lua')

local state = 'CLOSED'
local nextTry = 0
local delay = 1000
local queue = {}

local function active()
    return state ~= 'CLOSED'
end

local function queueSize()
    return #queue
end

local function enqueue(fn)
    if state == 'OPEN' then
        queue[#queue+1] = fn
        return true
    end
    return false
end

local function recordFailure()
    state = 'OPEN'
    nextTry = GetGameTimer() + delay
end

Citizen.CreateThread(function()
    while true do
        if state == 'OPEN' and GetGameTimer() > nextTry then
            state = 'HALF_OPEN'
            local res = SRP.Http.requestAwait('GET', (GetConvar('srp_node_base_url', 'http://127.0.0.1:4000'))..'/v1/health')
            if res and res.status == 200 then
                state = 'CLOSED'
                for _, cb in ipairs(queue) do pcall(cb) end
                queue = {}
                delay = 1000
            else
                state = 'OPEN'
                delay = math.min(delay * 2, 30000)
                nextTry = GetGameTimer() + delay
            end
        end
        Citizen.Wait(1000)
    end
end)

SRP.Failover = {
    active = active,
    queueSize = queueSize,
    enqueue = enqueue,
    recordFailure = recordFailure
}

return SRP.Failover
