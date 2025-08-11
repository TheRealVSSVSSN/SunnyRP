-- Live config defaults (backend can override later via /config/live)
SRP_Config = {
  Features = {
    police = false,
    ems = false,
    doc = false,
    illness = false,
    disabilities = false
  },
  Death = {
    autoRespawn = false,
    allowPlayerChoice = true,
    minBleedoutSec = 300,
    maxBleedoutSec = 900
  },
  Time = {
    realistic = true,
    timezone = 'America/Phoenix',
    syncHz = 1
  },
  Weather = {
    mode = 'scripted',           -- 'scripted' | 'provider'
    syncIntervalSec = 60,
    current = { type = 'CLEAR', wind = 0.0 }
  },
  Buckets = {
    loading = 1,
    main = 2,
    charStart = 10001,
    charCount = 1000,
    adminStart = 50001
  },
  QoL = {
    holdToSpeak = true,
    showCompass = true,
    streetDisplay = 'name',      -- 'none' | 'name' | 'name+zone'
    hudRateHz = 6,
    densityScale = 0.8
  },
  AntiCheat = {
    maxSpeedKmh = 280,
    maxTeleportMeters = 120
  },
  Dev = {
    fakeBackend = false,
    debug = false
  }
}

-- ConVar helper (reads server.cfg convars)
local function convarOr(default, name)
  local v = GetConvar(name, '')
  return (v ~= '' and v) or default
end

-- Prefer srp_* convars; fall back to vss_* if present; final default points at 3301
local apiUrl =
  GetConvar('srp_api_url', '') ~= '' and GetConvar('srp_api_url', '') or
  GetConvar('vss_api_url', '') ~= '' and GetConvar('vss_api_url', '') or
  'http://127.0.0.1:3301'

local apiToken =
  GetConvar('srp_api_token', '') ~= '' and GetConvar('srp_api_token', '') or
  GetConvar('vss_api_token', '') ~= '' and GetConvar('vss_api_token', '') or
  'CHANGE_ME'

SRP_API = {
  url   = apiUrl,
  token = apiToken
}

-- Optional overrides at boot (backend may overwrite at runtime)
SRP_Config.Time.timezone = convarOr(SRP_Config.Time.timezone, 'srp_tz')

-- Time mode: 'realistic' | 'scripted'
do
  local tm = GetConvar('srp_time_mode', '')
  if tm ~= '' then SRP_Config.Time.realistic = (tm == 'realistic') end
end

-- Weather mode: 'scripted' | 'provider'
do
  local wm = GetConvar('srp_weather_mode', '')
  if wm ~= '' then SRP_Config.Weather.mode = wm end
end