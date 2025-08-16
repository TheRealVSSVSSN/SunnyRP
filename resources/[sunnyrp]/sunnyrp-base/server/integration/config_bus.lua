-- Config Bus: authoritative SRP_Config + subscriptions + versioned API (/v1/config/live)
-- Reads & writes through srp-base service; maintains legacy SRP_Config shape for game code.

SRP_Config = SRP_Config or {}
SRP_Config.Features = SRP_Config.Features or {}
SRP_Config.Settings = SRP_Config.Settings or {}

SRP_ConfigBus = SRP_ConfigBus or { subs = {} }

local json = json or {}

-- =========================
-- Subscription API
-- =========================
-- Subscribe to a path like "Weather.mode", "Features.police", or top-level "Time".
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

-- =========================
-- Utilities
-- =========================
local function clone(val)
  if type(val) ~= 'table' then return val end
  local t = {}
  for k,v in pairs(val) do t[k] = clone(v) end
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
  for k,_ in pairs(b) do
    if not seen[k] then return false end
  end
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

local function setAtPath(root, path, value)
  local cur = root
  local parts = splitPath(path)
  for i=1,#parts-1 do
    local seg = parts[i]
    if type(cur[seg]) ~= 'table' then cur[seg] = {} end
    cur = cur[seg]
  end
  cur[parts[#parts]] = value
end

local function eachSubscriber(path, fn)
  local map = SRP_ConfigBus.subs[path]
  if not map then return end
  for _,cb in pairs(map) do
    local ok, err = pcall(cb)
    if not ok then print(('[srp-base] config subscriber error @%s: %s'):format(path, err)) end
  end
end

-- Recursively trigger "A", "A.B", "A.B.C" paths for a changed subtree
local function triggerPathTree(prefix, tbl)
  eachSubscriber(prefix)
  if type(tbl) ~= 'table' then return end
  for k,v in pairs(tbl) do
    local child = (prefix ~= '' and (prefix .. '.' .. k) or k)
    triggerPathTree(child, v)
  end
end

-- =========================
-- Apply & Broadcast
-- =========================
-- live: { features = {..}, settings = {..} }
function SRP_ConfigBus.apply(live)
  if type(live) ~= 'table' then return false end

  local prev = {
    Features = clone(SRP_Config.Features),
    Settings = clone(SRP_Config.Settings),
    Time     = clone(SRP_Config.Time),
    Weather  = clone(SRP_Config.Weather),
  }

  local features = live.features or {}
  local settings = live.settings or {}

  -- Maintain historical shape for ease of access
  SRP_Config.Features = features
  SRP_Config.Settings = settings

  if settings.Time ~= nil then SRP_Config.Time = settings.Time end
  if settings.Weather ~= nil then SRP_Config.Weather = settings.Weather end

  -- Trigger subscribers for changed roots & subpaths
  if not deepEqual(prev.Features, SRP_Config.Features) then
    triggerPathTree('Features', SRP_Config.Features)
  end
  if not deepEqual(prev.Settings, SRP_Config.Settings) then
    triggerPathTree('Settings', SRP_Config.Settings)
  end
  if not deepEqual(prev.Time, SRP_Config.Time) then
    triggerPathTree('Time', SRP_Config.Time)
    -- World broadcast for back-compat:
    TriggerClientEvent('srp:world:time', -1, SRP_Config.Time)
  end
  if not deepEqual(prev.Weather, SRP_Config.Weather) then
    triggerPathTree('Weather', SRP_Config.Weather)
    -- World broadcast for back-compat:
    TriggerClientEvent('srp:world:weather', -1, SRP_Config.Weather)
  end

  return true
end

-- =========================
-- Fetch & Patch against /v1/config/live
-- =========================
local function fetchLive()
  if not SRP_HTTP or not SRP_HTTP.Fetch then return false, 'no_http' end
  local res = SRP_HTTP.Fetch('GET', '/v1/config/live', nil, { retries = 1, timeout = 6000 })
  if res and res.ok and type(res.data) == 'table' then
    SRP_ConfigBus.apply(res.data)
    return true, res.data
  end
  return false, (res and (res.message or res.error)) or 'request_failed'
end

-- Accepts either:
--   { features = {...}, settings = {...} }  (preferred)
-- or legacy: { Time = {...}, Weather = {...}, ... } which is treated as settings-patch
function SRP_ConfigBus.patch(patch, actorUserId)
  if not SRP_HTTP or not SRP_HTTP.Fetch then return false, 'no_http' end
  if type(patch) ~= 'table' then return false, 'invalid_patch' end

  -- Get current snapshot from service so we can merge server-side truth
  local okCur, cur = fetchLive()
  if not okCur then return false, 'fetch_failed' end

  local nextFeatures = clone(cur.features or {})
  local nextSettings = clone(cur.settings or {})

  if patch.features and type(patch.features) == 'table' then
    for k,v in pairs(patch.features) do nextFeatures[k] = v end
  end

  if patch.settings and type(patch.settings) == 'table' then
    for k,v in pairs(patch.settings) do nextSettings[k] = v end
  else
    -- Legacy convenience: treat top-level keys as settings patch
    for k,v in pairs(patch) do
      if k ~= 'features' and k ~= 'settings' and k ~= 'actorUserId' then
        nextSettings[k] = v
      end
    end
  end

  -- Write only what changed via POST /v1/config/live { key, value, actorUserId? }
  local changed = false

  if not deepEqual(cur.features or {}, nextFeatures) then
    local resF = SRP_HTTP.Fetch('POST', '/v1/config/live', { key = 'features', value = nextFeatures, actorUserId = actorUserId }, { retries = 0, timeout = 6000 })
    if not (resF and resF.ok) then
      return false, (resF and (resF.message or resF.error)) or 'update_features_failed'
    end
    changed = true
  end

  if not deepEqual(cur.settings or {}, nextSettings) then
    local resS = SRP_HTTP.Fetch('POST', '/v1/config/live', { key = 'settings', value = nextSettings, actorUserId = actorUserId }, { retries = 0, timeout = 6000 })
    if not (resS and resS.ok) then
      return false, (resS and (resS.message or resS.error)) or 'update_settings_failed'
    end
    changed = true
  end

  if changed then
    -- Apply the combined result locally
    SRP_ConfigBus.apply({ features = nextFeatures, settings = nextSettings })
  end

  return true, { features = nextFeatures, settings = nextSettings }
end

-- =========================
-- Public helpers
-- =========================
function SRP_ConfigBus.get(path)
  if not path or path == '' then
    return {
      Features = clone(SRP_Config.Features),
      Settings = clone(SRP_Config.Settings),
      Time     = clone(SRP_Config.Time),
      Weather  = clone(SRP_Config.Weather),
    }
  end
  return clone(getAtPath({ Features = SRP_Config.Features, Settings = SRP_Config.Settings, Time = SRP_Config.Time, Weather = SRP_Config.Weather }, path))
end

-- Exports
exports('ConfigOn', function(path, cb) return SRP_ConfigBus.on(path, cb) end)
exports('ConfigOff', function(path, token) SRP_ConfigBus.off(path, token) end)
exports('ConfigGet', function(path) return SRP_ConfigBus.get(path) end)
exports('ConfigPatch', function(patch, actorUserId) return SRP_ConfigBus.patch(patch, actorUserId) end)

-- =========================
-- Boot & Poll
-- =========================
local ENABLED = (GetConvar('srp_feature_config_sync_enabled', '1') == '1')
local POLL_MS = tonumber(GetConvar('srp_config_poll_ms', '10000')) or 10000

CreateThread(function()
  if not ENABLED then
    print('^3[srp-base] config bus sync disabled via srp_feature_config_sync_enabled^7')
    return
  end
  local ok, err = fetchLive()
  if not ok and err then
    print(('^3[srp-base] initial /v1/config/live failed: %s^7'):format(err))
  end
  while true do
    Wait(POLL_MS)
    fetchLive()
  end
end)

-- Manual refresh from server console
RegisterCommand('srp_config_refresh', function(src)
  if src ~= 0 then return end
  local ok, err = fetchLive()
  if ok then print('^2[srp-base] /v1/config/live refreshed.^7') else print(('^3[srp-base] Refresh failed: %s^7'):format(err or '?')) end
end, true)

-- Keep world snapshots in sync on Time/Weather mutations (back-compat listeners)
SRP_ConfigBus.on('Time', function() TriggerClientEvent('srp:world:time', -1, SRP_Config.Time) end)
SRP_ConfigBus.on('Weather', function() TriggerClientEvent('srp:world:weather', -1, SRP_Config.Weather) end)