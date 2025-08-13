-- sunnyrp-base/server/world.lua
-- Authoritative World/Time/Weather + HUD policy (server).
-- Realistic time (1:1 real day) & scripted weather with live toggles.

local Guard = exports['sunnyrp-base'].GuardNetEvent

local function convarOr(name, def)
  local v = GetConvar(name, '')
  if v == '' then return def end
  return v
end

local World = {
  time = {
    mode = convarOr('srp_time_mode', 'realistic'),        -- 'realistic' | 'game'
    tz = convarOr('srp_time_timezone', 'America/Phoenix'),
    offsetMin = tonumber(convarOr('srp_tz_offset_min', '-420')) or -420,  -- fallback offset minutes
    syncMs = tonumber(convarOr('srp_time_sync_ms', '30000')) or 30000,
    freeze = (convarOr('srp_time_freeze', 'true') == 'true'),            -- keep clients overriding clock
  },
  weather = {
    mode = convarOr('srp_weather_mode', 'scripted'),      -- 'scripted' | 'provider' | 'static'
    staticType = convarOr('srp_weather_static', 'EXTRASUNNY'),
    syncMs = tonumber(convarOr('srp_weather_sync_ms', '60000')) or 60000,
    loc = {
      lat = tonumber(convarOr('srp_weather_lat', '33.4484')) or 33.4484, -- Phoenix by default
      lon = tonumber(convarOr('srp_weather_lon', '-112.0740')) or -112.0740,
    },
  },
  policy = {
    disableRegen = (convarOr('srp_disable_regen', 'true') == 'true'),
    disableAutoRespawn = (convarOr('srp_disable_autorespawn', 'true') == 'true'),
    hideMinimap = (convarOr('srp_hide_minimap', 'true') == 'true'),
    hideVanillaHud = (convarOr('srp_hide_vanilla_hud', 'true') == 'true'),
  }
}

-- Broadcast current world config to one or all clients
local function pushWorldCfg(target)
  local payload = {
    time = { mode = World.time.mode, tz = World.time.tz, offsetMin = World.time.offsetMin, freeze = World.time.freeze },
    weather = { mode = World.weather.mode, staticType = World.weather.staticType, loc = World.weather.loc },
    policy = World.policy
  }
  if target then
    TriggerClientEvent('srp:world:cfg', target, payload)
  else
    TriggerClientEvent('srp:world:cfg', -1, payload)
  end
end

-- Compute real-world local time (H:M:S) using offsetMin; tz string is informative unless a provider is used.
local function realLocalHMS()
  -- We use UTC (os.time with '!' table) then add offset
  local utc = os.date('!*t') -- t in UTC
  local seconds = utc.hour * 3600 + utc.min * 60 + utc.sec + (World.time.offsetMin * 60)
  -- wrap 24h
  seconds = ((seconds % 86400) + 86400) % 86400
  local h = math.floor(seconds / 3600)
  local m = math.floor((seconds % 3600) / 60)
  local s = seconds % 60
  return h, m, s
end

-- TIME LOOP: periodically broadcast the canonical time (clients smoothly override each frame)
local timeTimer = nil
local function timeTick()
  if World.time.mode == 'realistic' then
    local h, m, s = realLocalHMS()
    TriggerClientEvent('srp:world:time:set', -1, { h = h, m = m, s = s, freeze = World.time.freeze })
  else
    -- game mode: let game tick; we occasionally nudge (optional)
    local hour = GetClockHours()
    local minute = GetClockMinutes()
    local second = GetClockSeconds and GetClockSeconds() or 0
    TriggerClientEvent('srp:world:time:set', -1, { h = hour, m = minute, s = second, freeze = false })
  end
  timeTimer = SetTimeout(World.time.syncMs, timeTick)
end

-- WEATHER SCRIPT: simple, tasteful cycle; can be replaced by provider later
local cycle = {
  { type = 'EXTRASUNNY', dur = 16 * 60 }, -- minutes IRL (we use seconds below)
  { type = 'CLEAR',      dur = 10 * 60 },
  { type = 'CLOUDS',     dur = 6  * 60 },
  { type = 'OVERCAST',   dur = 6  * 60 },
  { type = 'RAIN',       dur = 5  * 60 },
  { type = 'CLEARING',   dur = 5  * 60 },
}
local cycleIdx, cycleLeft = 1, cycle[1].dur

local function pickNextWeather()
  cycleIdx = cycleIdx % #cycle + 1
  cycleLeft = cycle[cycleIdx].dur
  return cycle[cycleIdx].type
end

local function currentWeather()
  return cycle[cycleIdx].type
end

local weatherTimer = nil
local function weatherTick()
  if World.weather.mode == 'static' then
    TriggerClientEvent('srp:world:weather:set', -1, { type = World.weather.staticType, transition = 5.0 })
  elseif World.weather.mode == 'scripted' then
    -- decrement remaining and switch when time hits 0; push current type each sync
    cycleLeft = math.max(0, cycleLeft - (World.weather.syncMs / 1000))
    local w = currentWeather()
    if cycleLeft <= 0 then
      w = pickNextWeather()
    end
    TriggerClientEvent('srp:world:weather:set', -1, { type = w, transition = 10.0 })
  else
    -- provider mode (future): ask Core-API to resolve weather type by lat/lon then push.
    -- For now, fallback to scripted logic.
    TriggerClientEvent('srp:world:weather:set', -1, { type = currentWeather(), transition = 10.0 })
  end

  weatherTimer = SetTimeout(World.weather.syncMs, weatherTick)
end

-- Live config updates (admin-scoped)
Guard('srp:world:config:update', {
  scopes = { 'admin.world' },
  cooldownMs = 500,
  bucket = { capacity = 4, refill = 4, perMs = 2000 },
  validate = function(_, p) return type(p) == 'table', 'bad_payload' end,
  logName = 'world.config.update',
}, function(_, p)
  -- Merge partials
  if p.time then
    if p.time.mode then World.time.mode = p.time.mode end
    if p.time.tz then World.time.tz = p.time.tz end
    if p.time.offsetMin then World.time.offsetMin = tonumber(p.time.offsetMin) or World.time.offsetMin end
    if p.time.freeze ~= nil then World.time.freeze = (p.time.freeze == true) end
    -- resync immediately
    timeTick()
  end
  if p.weather then
    if p.weather.mode then World.weather.mode = p.weather.mode end
    if p.weather.staticType then World.weather.staticType = p.weather.staticType end
    if p.weather.loc and p.weather.loc.lat and p.weather.loc.lon then
      World.weather.loc.lat = tonumber(p.weather.loc.lat) or World.weather.loc.lat
      World.weather.loc.lon = tonumber(p.weather.loc.lon) or World.weather.loc.lon
    end
    weatherTick()
  end
  if p.policy then
    if p.policy.disableRegen ~= nil then World.policy.disableRegen = (p.policy.disableRegen == true) end
    if p.policy.disableAutoRespawn ~= nil then World.policy.disableAutoRespawn = (p.policy.disableAutoRespawn == true) end
    if p.policy.hideMinimap ~= nil then World.policy.hideMinimap = (p.policy.hideMinimap == true) end
    if p.policy.hideVanillaHud ~= nil then World.policy.hideVanillaHud = (p.policy.hideVanillaHud == true) end
  end
  pushWorldCfg(nil)
end)

-- Simple admin convenience toggles (optional, use portal later)
local RegisterCommandEx = exports['sunnyrp-base'].RegisterCommandEx
RegisterCommandEx('worldtime', {
  description = 'Set time mode (realistic|game)',
  scopes = { 'admin.world' }, argsHint = 'mode', cooldownMs = 500
}, function(_, args)
  local m = (args[1] or 'realistic'):lower()
  if m ~= 'realistic' and m ~= 'game' then return end
  World.time.mode = m
  timeTick(); pushWorldCfg(nil)
end)

RegisterCommandEx('worldweather', {
  description = 'Set weather mode (scripted|static|provider) or static type',
  scopes = { 'admin.world' }, argsHint = 'modeOrType', cooldownMs = 500
}, function(_, args)
  local a = (args[1] or ''):upper()
  if a == 'SCRIPTED' or a == 'STATIC' or a == 'PROVIDER' then
    World.weather.mode = a:lower()
  elseif a ~= '' then
    World.weather.mode = 'static'
    World.weather.staticType = a
  end
  weatherTick(); pushWorldCfg(nil)
end)

-- Push current world config to joining players
AddEventHandler('playerJoining', function()
  pushWorldCfg(source)
  -- time immediate ping
  timeTick()
end)

-- Start loops
CreateThread(function()
  timeTick()
  weatherTick()
end)

-- Export a tiny helper so other resources can fetch policy
exports('GetWorldPolicy', function()
  return {
    disableRegen = World.policy.disableRegen,
    disableAutoRespawn = World.policy.disableAutoRespawn,
    hideMinimap = World.policy.hideMinimap,
    hideVanillaHud = World.policy.hideVanillaHud,
  }
end)