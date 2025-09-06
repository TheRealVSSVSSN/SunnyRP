--[[
    -- Type: Module
    -- Name: failover
    -- Use: Circuit breaker and mutation queue for Node overload
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]

local SRP = SRP or require('resources/srp-base/shared/srp.lua')
local state = 'CLOSED'
local failures = 0
local nextTry = 0
local backoff = 1000
local queue = {}

local function metrics()
    return { state = state, failures = failures, nextTry = nextTry, queue = #queue }
end

local function active()
    return state ~= 'CLOSED'
end

local function queueSize()
    return #queue
end

local function enqueue(envelope)
    queue[#queue+1] = envelope
end

local function open()
    state = 'OPEN'
    nextTry = GetGameTimer() + backoff
end

local function recordFailure()
    failures = failures + 1
    if failures >= 3 then
        open()
    end
end

Citizen.CreateThread(function()
    while true do
        if state == 'CLOSED' then
            local res = SRP.Http.get((GetConvar('srp_node_base_url', 'http://127.0.0.1:4000'))..'/v1/ready')
            if not res or res.status ~= 200 or res.headers['x-srp-node-overloaded'] == 'true' then
                failures = 3
                open()
            end
        elseif state == 'OPEN' and GetGameTimer() >= nextTry then
            state = 'HALF_OPEN'
            local res = SRP.Http.get((GetConvar('srp_node_base_url', 'http://127.0.0.1:4000'))..'/v1/ready')
            if res and res.status == 200 and res.headers['x-srp-node-overloaded'] ~= 'true' then
                for _, env in ipairs(queue) do
                    SRP.Http.post((GetConvar('srp_node_base_url', 'http://127.0.0.1:4000'))..'/internal/srp/rpc', env)
                    Citizen.Wait(50)
                end
                queue = {}
                failures = 0
                backoff = 1000
                state = 'CLOSED'
            else
                state = 'OPEN'
                backoff = math.min(backoff * 2, 30000)
                nextTry = GetGameTimer() + backoff
            end
        end
        Citizen.Wait(5000)
    end
end)

SRP.Failover = {
    active = active,
    queueSize = queueSize,
    enqueue = enqueue,
    recordFailure = recordFailure,
    metrics = metrics
}

return SRP.Failover
