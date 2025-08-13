-- sunnyrp-base/server/presence.lua
-- Presence manager: client sends samples; server validates & updates statebags.
-- Also (optionally) posts to Core-API /map/position at a safe cadence.

local Keys = (SRP_State and SRP_State.Keys) or {}
local Guard = exports['sunnyrp-base'].GuardNetEvent

local function convarOr(name, def)
  local v = GetConvar(name, '')
  if v == '' then return def end
  return v
end

local PRESENCE_ENABLED   = (convarOr('srp_map_telemetry', 'true') == 'true')
local SAMPLE_MS          = tonumber(convarOr('srp_map_telemetry_interval_ms', '1500')) or 1500
local MIN_MOVE_M         = tonumber(convarOr('srp_map_telemetry_min_move', '0.7')) or 0.7

-- (We borrow telemetry thresholds for sanity checks; anticheat module can tighten/alert)
local TP_THRESH_M        = tonumber(convarOr('srp_tel_tp_threshold_m', '180.0')) or 180.0
local SPEED_FOOT_MPS     = tonumber(convarOr('srp_tel_speed_foot_mps', '12.0')) or 12.0
local SPEED_VEH_MPS      = tonumber(convarOr('srp_tel_speed_vehicle_mps', '120.0')) or 120.0

-- Server-side cadence to post to API (if enabled)
local POST_RATE_MS       = tonumber(convarOr('srp_presence_post_ms', '5000')) or 5000

local Presence = {
  bySrc = {}, -- src -> { last = {x,y,z,h, t}, zone, street, lastPost = ts, speed = mps }
}

local function vdist2(a, b)
  local dx,dy,dz = (a.x-b.x), (a.y-b.y), (a.z-b.z)
  return (dx*dx + dy*dy + dz*dz)
end

local function sqrt(n) return math.sqrt(n) end

local function nowMs() return GetGameTimer() end

local function goodVector(v)
  return type(v) == 'table' and type(v.x)=='number' and type(v.y)=='number' and type(v.z)=='number'
end

local function clampSpeed(mps, onFoot)
  local cap = onFoot and SPEED_FOOT_MPS or SPEED_VEH_MPS
  if mps > cap*5 then return cap*5 end
  return mps
end

local function shouldPost(ent)
  local t = nowMs()
  if (ent.lastPost or 0) + POST_RATE_MS > t then return false end
  ent.lastPost = t
  return true
end

-- Update statebag fields only when changed (avoid spam)
local function updatePresenceState(src, ent, payload)
  local ped = GetPlayerPed(src)
  if not ped or ped == 0 then return end

  local changed = {}
  -- zone
  if payload.zone and payload.zone ~= ent.zone then
    ent.zone = payload.zone
    changed[Keys.zone] = ent.zone
    TriggerEvent('srp:presence:zoneChanged', src, ent.zone)
  end
  -- street
  if payload.street and payload.street ~= ent.street then
    ent.street = payload.street
    changed[Keys.street] = ent.street
  end
  -- talking flag (lightweight)
  if type(payload.talking) == 'boolean' then
    changed[Keys.talking] = payload.talking
  end
  -- optional voiceMode/radio if provided by client integrations (trusted via server policy)
  if payload.voiceMode and type(payload.voiceMode) == 'string' then
    changed[Keys.voiceMode] = payload.voiceMode
  end
  if payload.radio ~= nil then
    changed[Keys.radio] = tonumber(payload.radio)
  end

  if next(changed) ~= nil then
    SRP_State.SetMany(src, changed, true)
  end
end

-- Validate payload shape/physics
local function validateSample(src, p)
  if type(p) ~= 'table' then return false, 'payload_not_table' end
  if not goodVector(p.pos) then return false, 'bad_pos' end
  if p.heading and type(p.heading) ~= 'number' then return false, 'bad_heading' end
  if p.zone and type(p.zone) ~= 'string' then return false, 'bad_zone' end
  if p.street and type(p.street) ~= 'string' then return false, 'bad_street' end
  if p.onFoot ~= nil and type(p.onFoot) ~= 'boolean' then return false, 'bad_onfoot' end
  if p.talking ~= nil and type(p.talking) ~= 'boolean' then return false, 'bad_talking' end

  -- Teleport sanity check vs last
  local ent = Presence.bySrc[src]
  if ent and ent.last then
    local dt = math.max(1, (p.t or nowMs()) - ent.last.t) / 1000.0
    local d2 = vdist2(p.pos, ent.last)
    local d  = sqrt(d2)
    if d > TP_THRESH_M then
      -- We don't kick here; telemetry module can alert. For presence, we accept but clamp speed reading.
      -- return false, 'teleport?'
    end
    -- Speed sanity
    local mps = d / dt
    local maxCap = p.onFoot and SPEED_FOOT_MPS or SPEED_VEH_MPS
    if mps > maxCap * 8 then
      -- absurd; likely spoof — ignore this sample
      return false, 'absurd_speed'
    end
  end

  return true
end

-- Guarded net event: client presence samples
Guard('srp:presence:sample', {
  scopes = nil,                 -- any player may send presence
  cooldownMs = SAMPLE_MS - 10,  -- minor cooldown close to tick
  bucket = { capacity = 4, refill = 4, perMs = 2000 },
  validate = validateSample,
  logName = 'presence.sample',
}, function(src, p)
  local ent = Presence.bySrc[src] or {}
  local tNow = p.t or nowMs()

  -- Distance threshold to avoid noise
  if ent.last then
    local d2 = vdist2(p.pos, ent.last)
    if d2 < (MIN_MOVE_M * MIN_MOVE_M) and (p.talking == ent.talking) and (p.zone == ent.zone) and (p.street == ent.street) then
      -- entirely unchanged — no updates
      return
    end
  end

  -- Compute derived speed (server-side)
  local mps = 0.0
  if ent.last then
    local dt = math.max(1, tNow - ent.last.t) / 1000.0
    mps = sqrt(vdist2(p.pos, ent.last)) / dt
  end
  mps = clampSpeed(mps, p.onFoot == true)
  ent.speed = mps

  -- Update last sample
  ent.last = { x = p.pos.x, y = p.pos.y, z = p.pos.z, h = p.heading or 0.0, t = tNow }
  ent.talking = (p.talking == true)
  Presence.bySrc[src] = ent

  -- Reflect interesting bits to state bags
  updatePresenceState(src, ent, p)

  -- Optionally post to backend
  if PRESENCE_ENABLED and shouldPost(ent) then
    local P = exports['sunnyrp-base']:getModule('Player')
    local u = P.GetUser(src) or {}
    local char = u.char or {}
    local payload = {
      playerId = u.playerId,
      characterId = char.id,
      pos = { x = ent.last.x, y = ent.last.y, z = ent.last.z, h = ent.last.h },
      zone = ent.zone,
      street = ent.street,
      speed = ent.speed,
      bucket = Entity(GetPlayerPed(src)).state[Keys.bucket] or 0,
      ts = os.time(),
    }
    -- fire and forget; ignore response
    SRP_HTTP.Fetch('POST', '/map/position', payload, { retries = 0, timeout = 2500 })
  end

  -- Notify listeners inside game
  TriggerEvent('srp:presence:updated', src, {
    pos = ent.last, zone = ent.zone, street = ent.street, speed = ent.speed
  })
end)

-- Cleanup
AddEventHandler('playerDropped', function()
  Presence.bySrc[source] = nil
end)

-- Export for other resources
exports('GetPresence', function(src)
  local ent = Presence.bySrc[src]
  if not ent then return nil end
  return {
    pos = ent.last and { x=ent.last.x, y=ent.last.y, z=ent.last.z, h=ent.last.h } or nil,
    zone = ent.zone, street = ent.street, speed = ent.speed
  }
end)