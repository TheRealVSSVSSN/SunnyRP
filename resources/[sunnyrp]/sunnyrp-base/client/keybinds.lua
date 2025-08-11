-- Keybind registry (client): RegisterKeyMapping + callback dispatch.
-- Persistence is handled server-side via backend; this file focuses on runtime behavior.

SRP_Binds = SRP_Binds or { map = {}, callbacks = {}, loaded = false }

local function commandName(name) return ('srp.bind.%s'):format(name) end

-- Internal: run bind callback
local function runBind(name)
  local cb = SRP_Binds.callbacks[name]
  if cb then
    local ok, err = pcall(cb)
    if not ok then
      -- bubble to error bus
      TriggerServerEvent('srp:error:client', 'keybind_cb', { name = name, error = tostring(err) })
    end
  end
end

-- Register a bind. Example:
-- exports['srp_base']:BindRegister('openPhone', 'keyboard', 'F1', 'Open Phone', function() ... end)
function SRP_Binds.register(name, device, defaultKey, description, cb)
  if SRP_Binds.map[name] then return end
  local cmd = commandName(name)
  RegisterCommand(cmd, function() runBind(name) end, false)
  RegisterKeyMapping(cmd, description or name, device or 'keyboard', defaultKey or 'NONE')
  SRP_Binds.callbacks[name] = cb
  SRP_Binds.map[name] = { device=device, key=defaultKey, desc=description }
end

-- Load saved binds from server (per-character if available)
RegisterNetEvent('srp:binds:apply')
AddEventHandler('srp:binds:apply', function(binds)
  -- binds: { { name, device, key, desc }, ... }
  -- Note: FiveM does not allow programmatic remap of RegisterKeyMapping at runtime;
  -- saved binds apply via the user's GTA keybind menu. We still show UI/notify here.
  SRP_Binds.loaded = true
  SendNUIMessage({ app='srp', action='bindsLoaded', payload = binds })
end)

-- API Exports
exports('BindRegister', function(name, device, defaultKey, description, cb)
  return SRP_Binds.register(name, device, defaultKey, description, cb)
end)