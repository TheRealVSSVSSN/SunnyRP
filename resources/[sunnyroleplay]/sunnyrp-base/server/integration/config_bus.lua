-- resources/[sunnyrp]/sunnyrp-base/server/integration/config_bus.lua
-- Versioned config bus using /v1/config/live

SRP_Config = SRP_Config or {}
SRP_Config.Features = SRP_Config.Features or {}
SRP_Config.Settings = SRP_Config.Settings or {}

SRP_ConfigBus = SRP_ConfigBus or { subs = {} }

local function clone(v)
  if type(v) ~= 'table' then return v end
  local t = {}
  for k,x in pairs(v) do t[k] = clone(x) end
  return t
end

local function deepEqual(a, b)
  if a == b then return true end
  if type(a) ~= type(b) then return false end
  if type(a) ~= 'table' then return false end
  local seen = {}
  for k,v in pairs(a) do
    if not deepEqual(v, b[k]) then return false end
    seen[k] = true
  end
  for k,_ in pairs(b) do if not seen[k] then return false end end
  return true
end

local function splitPath(p)
  local out = {}
  for seg in string.gmatch(p or '', '([^%.]+)') do table.insert(out, seg) end
  return out
end

local function getAtPath(root, path)
  if not path or path == '' then return root end
  local cur = root
  for _,seg in ipairs(splitPath(path)) do
    if type(cur) ~= 'table' then return nil end
    cur = cur[seg]
  end
  return cur
end

local function eachSubscriber(path, fn)
  local map = SRP_ConfigBus.subs[path]
  if not map then return end
  for _,cb in pairs(map) do
    local ok, err = pcall(cb)
    if not ok then print(('[srp-config] subscriber error @%s: %s'):format(path, err)) end
  end
end

local function triggerTree(prefix, tbl)
  eachSubscriber(prefix)
  if type(tbl) ~= 'table' then return end
  for k,v in pairs(tbl) do
    local child = (prefix ~= '' and (prefix .. '.' .. k) or k)
    triggerTree(child, v)
  end
end

function SRP_ConfigBus.on(path, cb)
  if type(path) ~= 'string' or type(cb) ~= 'function' then return nil end
  SRP_ConfigBus.subs[path] = SRP_ConfigBus.subs[path] or {}
  local token = math.random(100000, 999999)
  SRP_ConfigBus.subs[path][token] = cb
  return token
end

function SRP_ConfigBus.off(path, token)
  if SRP_ConfigBus.subs[path] then SRP_ConfigBus.subs[path][token] = nil end
end

function SRP_ConfigBus.apply(live)
  if type(live) ~= 'table' then return false end
  local prevF = clone(SRP_Config.Features)
  local prevS = clone(SRP_Config.Settings)

  SRP_Config.Features = live.features or {}
  SRP_Config.Settings = live.settings or {}

  if not deepEqual(prevF, SRP_Config.Features) then
    triggerTree('Features', SRP_Config.Features)
  end
  if not deepEqual(prevS, SRP_Config.Settings) then
    triggerTree('Settings', SRP_Config.Settings)
    if SRP_Config.Settings.Time then
      TriggerClientEvent('srp:world:time', -1, SRP_Config.Settings.Time)
    end
    if SRP_Config.Settings.Weather then
      TriggerClientEvent('srp:world:weather', -1, SRP_Config.Settings.Weather)
    end
  end
  return true
end

local function fetchLive()
  if not SRP_HTTP or not SRP_HTTP.Fetch then return false, 'no_http' end
  local res = SRP_HTTP.Fetch('GET', '/v1/config/live', nil, { retries = 1 })
  if res and res.ok and type(res.data) == 'table' then
    SRP_ConfigBus.apply(res.data)
    return true
  end
  return false, (res and (res.message or res.error)) or 'request_failed'
end

-- boot & poll
CreateThread(function()
  local enabled = (SRP_CONFIG and SRP_CONFIG.poll and SRP_CONFIG.poll.enabled)
  local interval = (SRP_CONFIG and SRP_CONFIG.poll and SRP_CONFIG.poll.intervalMs) or 10000
  if not enabled then
    print('^3[srp-config] polling disabled^7')
    return
  end

  local ok, err = fetchLive()
  if not ok and err then print(('^3[srp-config] initial fetch failed: %s^7'):format(err)) end

  while true do
    Wait(interval)
    fetchLive()
  end
end)

RegisterCommand('srp_config_refresh', function(src)
  if src ~= 0 then return end
  local ok, err = fetchLive()
  if ok then print('^2[srp-config] refreshed^7') else print(('^3[srp-config] failed: %s^7'):format(err or '?')) end
end, true)

-- Exports for other resources
exports('ConfigOn', function(path, cb) return SRP_ConfigBus.on(path, cb) end)
exports('ConfigOff', function(path, token) SRP_ConfigBus.off(path, token) end)
exports('ConfigGet', function(path)
  return getAtPath({ Features = SRP_Config.Features, Settings = SRP_Config.Settings }, path)
end)