-- sunnyrp-base/server/hudbridge.lua
-- Coalesced HUD patcher: batches small updates and flushes at an interval to reduce spam.

SRP_HUD = SRP_HUD or {
  pending = {},   -- src -> table (merged patches)
  timers  = {},   -- src -> bool running
}

local function convarOr(name, d)
  local v = GetConvar(name, '')
  if v == '' then return d end
  return v
end

local function intervalMs()
  return tonumber(convarOr('srp_hud_update_interval_ms', '750')) or 750
end

local function deepMerge(dst, src)
  for k,v in pairs(src or {}) do
    if type(v) == 'table' then
      dst[k] = dst[k] or {}
      deepMerge(dst[k], v)
    else
      dst[k] = v
    end
  end
  return dst
end

local function flush(src)
  local patch = SRP_HUD.pending[src]
  SRP_HUD.pending[src] = nil
  SRP_HUD.timers[src]  = nil
  if not patch then return end
  -- Forward to HUD resource (NUI glue) — keep event name stable
  TriggerClientEvent('srp:hud:patch', src, patch)
end

local function scheduleFlush(src)
  if SRP_HUD.timers[src] then return end
  SRP_HUD.timers[src] = true
  SetTimeout(intervalMs(), function()
    flush(src)
  end)
end

-- Public export: EmitHud(src, patchTable)
function SRP_HUD.Emit(src, patch)
  if type(patch) ~= 'table' then return end
  SRP_HUD.pending[src] = SRP_HUD.pending[src] or {}
  deepMerge(SRP_HUD.pending[src], patch)
  scheduleFlush(src)
end

-- Cleanup on drop
AddEventHandler('playerDropped', function()
  local src = source
  SRP_HUD.pending[src] = nil
  SRP_HUD.timers[src]  = nil
end)

exports('EmitHud', function(src, patch) SRP_HUD.Emit(src, patch) end)

-- Optional: event so other resources can fire without exports
RegisterNetEvent('srp:hud:emit', function(patch)
  local src = source
  SRP_HUD.Emit(src, patch)
end)