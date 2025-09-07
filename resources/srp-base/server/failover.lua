SRP = SRP or {}
SRP.Failover = {}

local state = 'CLOSED'
local failures = 0
local queue = {}
local backoff = 5000
local nextTry = 0

local function setState(s)
  state = s
  if s == 'CLOSED' then
    failures = 0
    backoff = 5000
    nextTry = 0
  elseif s == 'OPEN' then
    nextTry = GetGameTimer() + backoff
    backoff = math.min(backoff * 2, 30000)
  end
end

--[[
    -- Type: Function
    -- Name: SRP.Failover.active
    -- Use: Whether circuit breaker is active
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
function SRP.Failover.active()
  return state ~= 'CLOSED'
end

--[[
    -- Type: Function
    -- Name: SRP.Failover.queueSize
    -- Use: Size of queued mutations
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
function SRP.Failover.queueSize()
  return #queue
end

--[[
    -- Type: Function
    -- Name: SRP.Failover.metrics
    -- Use: Returns current circuit metrics
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
function SRP.Failover.metrics()
  return { state = state, failures = failures, queue = #queue }
end

--[[
    -- Type: Function
    -- Name: SRP.Failover.enqueue
    -- Use: Queue a function for later replay
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
function SRP.Failover.enqueue(fn)
  queue[#queue + 1] = fn
end

--[[
    -- Type: Function
    -- Name: checkNode
    -- Use: Poll Node service readiness
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
local function checkNode()
  local now = GetGameTimer()
  if state == 'OPEN' and now < nextTry then return end
  local port = GetConvar('srp_node_port', '4000')
  local url = ('http://127.0.0.1:%s/v1/ready'):format(port)
  local res = SRP.Http.get(url)
  if res.status == 200 then
    failures = 0
    local overloaded = res.headers['x-srp-node-overloaded'] == 'true'
    if overloaded then
      setState('OPEN')
    elseif state ~= 'CLOSED' then
      setState('HALF_OPEN')
    end
  elseif res.status == 429 or res.status == 503 then
    setState('OPEN')
  else
    failures = failures + 1
    if failures >= 3 then setState('OPEN') end
  end
end

--[[
    -- Type: Function
    -- Name: flushQueue
    -- Use: Replay queued mutations
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
local function flushQueue()
  if #queue == 0 then return end
  local success, total = 0, #queue
  for i = 1, #queue do
    local ok = queue[i]()
    if ok then success = success + 1 end
  end
  queue = {}
  if state == 'HALF_OPEN' then
    if success / total >= 0.9 then
      setState('CLOSED')
    else
      setState('OPEN')
    end
  end
end

CreateThread(function()
  while true do
    checkNode()
    if state == 'HALF_OPEN' then
      flushQueue()
    end
    local wait = state == 'OPEN' and math.max(1000, nextTry - GetGameTimer()) or 5000
    Wait(wait)
  end
end)
