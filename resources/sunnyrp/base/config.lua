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

-- ConVar overrides at boot (backend may overwrite at runtime)
local function convarOr(default, name)
  local v = GetConvar(name, '')
  return (v ~= '' and v) or default
end

SRP_API = {
  url   = convarOr('http://127.0.0.1:3100', 'vss_api_url'),
  token = convarOr('CHANGE_ME', 'vss_api_token')
}

SRP_Config.Time.timezone = convarOr(SRP_Config.Time.timezone, 'srp_tz')
SRP_Config.Time.realistic = GetConvar('srp_time_mode', 'realistic') == 'realistic'
SRP_Config.Weather.mode   = convarOr(SRP_Config.Weather.mode, 'srp_weather_mode')