-- resources/sunnyrp/hud/client/main.lua
SRP = SRP or {}
SRP.HUD = SRP.HUD or {}
local flushMs = tonumber(GetConvar('srp_hud_update_interval_ms', '750')) or 750

local cache = {
  vitals = { health = 100, armor = 0 },
  voice  = { talking = false, mode = 'normal' },
  visibility = { vitals=true, status=true, identity=true, voice=true }
}
local pending = {}   -- coalesced outbound to NUI
local lastFlush = 0

local function deepMerge(dst, src)
  for k,v in pairs(src) do
    if type(v) == 'table' and type(dst[k]) == 'table' then deepMerge(dst[k], v) else dst[k] = v end
  end
end

local function queue(payload)
  for k,v in pairs(payload) do pending[k] = v end
end

local function flush()
  SendNUIMessage({ action = 'hud:update', payload = pending })
  pending = {}
end

-- Receive server → client NUI ops
RegisterNetEvent('srp:hud:nui', function(action, data)
  if action == 'hud:update' then
    deepMerge(cache, data or {})
    queue(data or {})
  elseif action == 'visible:init' then
    cache.visibility = data or cache.visibility
    SendNUIMessage({ action = 'visible:init', payload = cache.visibility })
  elseif action == 'visible:all' then
    cache.visibility.__all = data and true or false
    SendNUIMessage({ action = 'visible:all', payload = cache.visibility.__all })
  elseif action == 'visible:group' then
    cache.visibility[data.group] = data.show and true or false
    SendNUIMessage({ action = 'visible:group', payload = data })
  elseif action == 'visible:item' then
    SendNUIMessage({ action = 'visible:item', payload = data })
  elseif action == 'voice:mode' then
    cache.voice.mode = tostring(data.mode or 'normal')
    SendNUIMessage({ action = 'voice:mode', payload = cache.voice.mode })
  end
end)

-- Local vitals/voice loop (client side only)
CreateThread(function()
  while true do
    local ped = PlayerPedId()
    local h = GetEntityHealth(ped)
    local a = GetPedArmour(ped)
    local talking = NetworkIsPlayerTalking(PlayerId()) == 1

    local changed = false
    if cache.vitals.health ~= h then cache.vitals.health = h; changed = true end
    if cache.vitals.armor  ~= a then cache.vitals.armor  = a; changed = true end
    if cache.voice.talking ~= talking then cache.voice.talking = talking; changed = true end

    if changed then
      queue({ vitals = { health = cache.vitals.health, armor = cache.vitals.armor }, voice = { talking = cache.voice.talking } })
    end

    local now = GetGameTimer()
    if (now - lastFlush) >= flushMs and next(pending) ~= nil then
      flush(); lastFlush = now
    end
    Wait(200) -- sample vitals at 5Hz; coalesced to NUI per flushMs
  end
end)

-- Optional: test cycling voice mode (until real voice system wires in)
RegisterCommand('voice_cycle', function()
  local order = { 'whisper', 'normal', 'shout' }
  local idx = 2
  for i, m in ipairs(order) do if cache.voice.mode == m then idx = i break end end
  idx = idx + 1; if idx > #order then idx = 1 end
  cache.voice.mode = order[idx]
  SendNUIMessage({ action = 'voice:mode', payload = cache.voice.mode })
end, false)
RegisterKeyMapping('voice_cycle', 'Cycle voice mode (placeholder)', 'keyboard', 'F11')