--[[
    -- Type: Module
    -- Name: failover
    -- Use: Implements circuit breaker and request queue for Node failover
    -- Created: 2025-09-06
    -- By: VSSVSSN
--]]

local SRP = SRP or require('resources/srp-base/shared/srp.lua')
SRP.Failover = SRP.Failover or { state = "CLOSED", q = {}, retryAt = 0, backoff = 1000 }

local NODE_URL = GetConvar("srp_node_base_url", "http://127.0.0.1:4000")
local HEALTH    = NODE_URL .. "/v1/health"

--[[
    -- Type: Function
    -- Name: nowMs
    -- Use: Provides current game time in milliseconds
    -- Created: 2025-09-06
    -- By: VSSVSSN
--]]
local function nowMs() return GetGameTimer() end

--[[
    -- Type: Function
    -- Name: enqueue
    -- Use: Adds tasks to the failover queue
    -- Created: 2025-09-06
    -- By: VSSVSSN
--]]
local function enqueue(task) SRP.Failover.q[#SRP.Failover.q + 1] = task end

--[[
    -- Type: Function
    -- Name: healthcheck
    -- Use: Checks Node server health
    -- Created: 2025-09-06
    -- By: VSSVSSN
--]]
local function healthcheck()
    local res = SRP.Http.requestExSync({ url = HEALTH, method = "GET", timeout = 1500 })
    return res and res.status == 200
end

--[[
    -- Type: Function
    -- Name: setState
    -- Use: Updates circuit breaker state
    -- Created: 2025-09-06
    -- By: VSSVSSN
--]]
local function setState(s) SRP.Failover.state = s end

--[[
    -- Type: Thread
    -- Name: CircuitBreaker
    -- Use: Manages circuit state transitions based on health checks
    -- Created: 2025-09-06
    -- By: VSSVSSN
--]]
Citizen.CreateThread(function()
    while true do
        if SRP.Failover.state == "CLOSED" then
            if not healthcheck() then setState("OPEN"); SRP.Failover.retryAt = nowMs() + SRP.Failover.backoff end
        elseif SRP.Failover.state == "OPEN" then
            if nowMs() >= SRP.Failover.retryAt then setState("HALF_OPEN") end
        elseif SRP.Failover.state == "HALF_OPEN" then
            if healthcheck() then
                setState("CLOSED"); SRP.Failover.backoff = 1000
            else
                setState("OPEN")
                SRP.Failover.backoff = math.min(SRP.Failover.backoff * 2, 30000)
                SRP.Failover.retryAt = nowMs() + SRP.Failover.backoff
            end
        end
        Citizen.Wait(1000)
    end
end)

--[[
    -- Type: Function
    -- Name: SRP.Failover.proxy
    -- Use: Proxies requests to Node or queues them on failure
    -- Created: 2025-09-06
    -- By: VSSVSSN
--]]
function SRP.Failover.proxy(method, path, payload, headers, mirrorFn)
    if SRP.Failover.state ~= "CLOSED" then
        if method == "GET" and mirrorFn then return mirrorFn(payload) end
        enqueue({ method = method, path = path, payload = payload, headers = headers, mirror = mirrorFn })
        return { status = 202, body = '{"queued":true}' }
    end
    return SRP.Http.requestExSync({ url = NODE_URL .. path, method = method, body = payload and json.encode(payload) or "", headers = headers or {} })
end

--[[
    -- Type: Function
    -- Name: SRP.Failover.active
    -- Use: Indicates if failover is active
    -- Created: 2025-09-06
    -- By: VSSVSSN
--]]
SRP.Failover.active    = function() return SRP.Failover.state ~= "CLOSED" end

--[[
    -- Type: Function
    -- Name: SRP.Failover.queueSize
    -- Use: Returns queued task count
    -- Created: 2025-09-06
    -- By: VSSVSSN
--]]
SRP.Failover.queueSize = function() return #SRP.Failover.q end

SRP.Export('FailoverActive', SRP.Failover.active)

return SRP.Failover
