--[[
    -- Type: Module
    -- Name: Failover Circuit Breaker
    -- Use: Handles Node overload and queueing
    -- Created: 2024-06-02
    -- By: VSSVSSN
--]]

SRP.Failover = { state = 'CLOSED', failures = 0, queue = {}, backoff = 1000, nextRetry = 0 }

local function setState(new)
    SRP.Failover.state = new
    SRP.Failover.failures = 0
    if new == 'OPEN' then
        SRP.Failover.nextRetry = GetGameTimer() + SRP.Failover.backoff
        SRP.Failover.backoff = math.min(SRP.Failover.backoff * 2, 30000)
    elseif new == 'CLOSED' then
        SRP.Failover.backoff = 1000
        SRP.Failover.queue = {}
    end
end

--[[
    -- Type: Function
    -- Name: active
    -- Use: Returns true when circuit is not CLOSED
    -- Created: 2024-06-02
    -- By: VSSVSSN
--]]
function SRP.Failover.active()
    return SRP.Failover.state ~= 'CLOSED'
end

--[[
    -- Type: Function
    -- Name: queueSize
    -- Use: Returns queued mutation count
    -- Created: 2024-06-02
    -- By: VSSVSSN
--]]
function SRP.Failover.queueSize()
    return #SRP.Failover.queue
end

--[[
    -- Type: Function
    -- Name: metrics
    -- Use: Provides failover stats
    -- Created: 2024-06-02
    -- By: VSSVSSN
--]]
function SRP.Failover.metrics()
    return { state = SRP.Failover.state, failures = SRP.Failover.failures, queued = #SRP.Failover.queue }
end

function SRP.Failover.enqueue(evt)
    table.insert(SRP.Failover.queue, evt)
end

function SRP.Failover.recordFailure(code)
    SRP.Failover.failures = SRP.Failover.failures + 1
    if code == 429 or code == 503 or SRP.Failover.failures >= 3 then
        setState('OPEN')
    end
end

function SRP.Failover.recordSuccess()
    SRP.Failover.failures = 0
    if SRP.Failover.state == 'HALF_OPEN' then
        setState('CLOSED')
    end
end

local function pollNode()
    local url = GetConvar('srp_node_base_url', 'http://127.0.0.1:4000')
    local status, _, headers = SRP.Http.get(url .. '/v1/ready')
    if headers and headers['x-srp-node-overloaded'] == 'true' then
        SRP.Failover.recordFailure(503)
        return
    end
    if status ~= 200 then
        SRP.Failover.recordFailure(status)
    else
        SRP.Failover.recordSuccess()
    end
end

Citizen.CreateThread(function()
    while true do
        pollNode()
        Wait(5000)
    end
end)

local function replayQueue()
    if SRP.Failover.state ~= 'HALF_OPEN' and SRP.Failover.state ~= 'CLOSED' then return end
    local url = GetConvar('srp_node_base_url', 'http://127.0.0.1:4000')
    local total = #SRP.Failover.queue
    for i = 1, total do
        local evt = table.remove(SRP.Failover.queue, 1)
        local status = SRP.Http.post(url .. '/internal/srp/rpc', evt.body, evt.headers)
        if status ~= 200 then
            SRP.Failover.recordFailure(status)
            table.insert(SRP.Failover.queue, 1, evt)
            break
        else
            SRP.Failover.recordSuccess()
        end
        Wait(100)
    end
end

Citizen.CreateThread(function()
    while true do
        if SRP.Failover.state == 'OPEN' and GetGameTimer() >= SRP.Failover.nextRetry then
            setState('HALF_OPEN')
        end
        replayQueue()
        Wait(1000)
    end
end)
