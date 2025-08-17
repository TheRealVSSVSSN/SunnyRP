-- sunnyrp-base/client/world.lua
-- Client enforcement of server-published world policy + time/weather.

local cfg = {
  time = { mode = 'realistic', freeze = true, h = 12, m = 0, s = 0 },
  weather = { mode = 'scripted', type = 'CLEAR' },
  policy = { disableRegen = true, disableAutoRespawn = true, hideMinimap = true, hideVanillaHud = true }
}

-- Apply regen/respawn policies (tick-based to defeat game/other scripts)
local function applyRegenPolicy()
  local pid = PlayerId()
  SetPlayerHealthRechargeMultiplier(pid, cfg.policy.disableRegen and 0.0 or 1.0)
  SetPlayerHealthRechargeLimit(pid, cfg.policy.disableRegen and 0.0 or 1.0)
  -- optional stamina regen if you choose:
  -- RestorePlayerStamina(pid, cfg.policy.disableRegen and 0.0 or 1.0)
end

local function ensureNoAutoRespawn()
  -- If spawnmanager exists, disable its autospawn
  if GetResourceState('spawnmanager') ~= 'missing' then
    -- protected call in case exports unavailable
    pcall(function() exports.spawnmanager:setAutoSpawn(false) end)
  end
end

-- HUD suppression loop (minimap & vanilla HUD components)
local HIDE_COMPONENTS = {
  1, 2, 3, 4, 6, 7, 9, 13, 22 -- wanted, weapon, cash, mp cash, vehicle, area, street, cash change, reticle
}
CreateThread(function()
  while true do
    Wait(0)
    if cfg.policy.hideVanillaHud then
      HideHudAndRadarThisFrame()
      for _,c in ipairs(HIDE_COMPONENTS) do HideHudComponentThisFrame(c) end
    else
      -- selectively hide minimap if requested
      if cfg.policy.hideMinimap then
        DisplayRadar(false)
      else
        DisplayRadar(true)
      end
    end
  end
end)

-- Regen/respawn policy tick
CreateThread(function()
  while true do
    applyRegenPolicy()
    ensureNoAutoRespawn()
    Wait(1000)
  end
end)

-- TIME OVERRIDE: Smoothly override to server’s target time
local lastSet = { h = -1, m = -1, s = -1 }
CreateThread(function()
  while true do
    Wait(250)
    if cfg.time.mode == 'realistic' and cfg.time.freeze then
      -- Force override every frame-ish so it never drifts
      NetworkOverrideClockTime(cfg.time.h, cfg.time.m, cfg.time.s)
      PauseClock(true)
      -- Manually advance seconds locally to keep smooth between server syncs
      cfg.time.s = cfg.time.s + 1
      if cfg.time.s >= 60 then cfg.time.s = 0; cfg.time.m = cfg.time.m + 1 end
      if cfg.time.m >= 60 then cfg.time.m = 0; cfg.time.h = (cfg.time.h + 1) % 24 end
    else
      PauseClock(false)
      -- In 'game' mode we don't override; leave GTA’s progression.
      if cfg.time.mode == 'game' and (cfg.time.h ~= lastSet.h or cfg.time.m ~= lastSet.m) then
        -- nudge occasionally if server asked; not frozen.
        NetworkOverrideClockTime(cfg.time.h, cfg.time.m, cfg.time.s)
        lastSet.h, lastSet.m, lastSet.s = cfg.time.h, cfg.time.m, cfg.time.s
      end
    end
  end
end)

-- WEATHER APPLY: gentle transitions
local currentWeather = nil
CreateThread(function()
  while true do
    Wait(1000)
    if currentWeather then
      -- keep override alive (FiveM needs repeated assert)
      SetOverrideWeatherType(currentWeather)
      SetWeatherTypePersist(currentWeather)
    end
  end
end)

-- Event: config pushed from server
RegisterNetEvent('srp:world:cfg', function(payload)
  if type(payload) ~= 'table' then return end
  cfg.policy = payload.policy or cfg.policy
  if payload.time then
    cfg.time.mode = payload.time.mode or cfg.time.mode
    cfg.time.freeze = (payload.time.freeze ~= nil) and payload.time.freeze or cfg.time.freeze
  end
  if payload.weather then
    cfg.weather.mode = payload.weather.mode or cfg.weather.mode
  end
end)

-- Event: set canonical time now (server will ping periodically)
RegisterNetEvent('srp:world:time:set', function(p)
  if type(p) ~= 'table' then return end
  cfg.time.h = tonumber(p.h) or cfg.time.h
  cfg.time.m = tonumber(p.m) or cfg.time.m
  cfg.time.s = tonumber(p.s) or cfg.time.s
  if p.freeze ~= nil then cfg.time.freeze = (p.freeze == true) end
end)

-- Event: set weather now
RegisterNetEvent('srp:world:weather:set', function(p)
  if type(p) ~= 'table' then return end
  local w = tostring(p.type or 'CLEAR')
  local transition = tonumber(p.transition or 10.0) or 10.0
  currentWeather = w
  ClearOverrideWeather()
  SetWeatherTypeOverTime(w, transition)
  Wait(math.floor(transition * 1000))
  SetOverrideWeatherType(w)
  SetWeatherTypePersist(w)
end)

-- Optional: server may broadcast simple toggles (future portal hooks)
RegisterNetEvent('srp:world:policy:set', function(p)
  if type(p) ~= 'table' then return end
  for k,v in pairs(p) do
    if cfg.policy[k] ~= nil then cfg.policy[k] = (v == true) end
  end
end)