SRP = SRP or {}
SRP.Failover = {}

local state = 'CLOSED'
local failures = 0
local queue = {}

local function setState(s)
  state = s
  if s == 'CLOSED' then failures = 0 end
end

function SRP.Failover.active()
  return state ~= 'CLOSED'
end

function SRP.Failover.queueSize()
  return #queue
end

function SRP.Failover.metrics()
  return { state = state, failures = failures, queue = #queue }
end

function SRP.Failover.enqueue(fn)
  queue[#queue + 1] = fn
end

local function checkNode()
  local port = GetConvar('srp_node_port', '4000')
  local url = ('http://127.0.0.1:%s/v1/ready'):format(port)
  local res = SRP.Http.get(url)
  if res.status == 200 then
    failures = 0
    local overloaded = res.headers['x-srp-node-overloaded'] == 'true'
    if overloaded and state == 'CLOSED' then
      setState('OPEN')
    elseif not overloaded and state ~= 'CLOSED' then
      setState('HALF_OPEN')
    end
  else
    failures = failures + 1
    if failures >= 3 then setState('OPEN') end
  end
end

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
    Wait(5000)
  end
end)
