-- Config Bus: authoritative SRP_Config + subscriptions + patch helper
SRP_ConfigBus = { subs = {} }

-- Subscribe to a path like "Weather.mode" or "Features.police"
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

-- Apply a patch (deep-merge) and notify
function SRP_ConfigBus.apply(patch)
  if type(patch) ~= 'table' then return end
  SRP_Utils.deepMerge(SRP_Config, patch)
  TriggerEvent('srp:config:changed', patch)
  TriggerClientEvent('srp:config:changed', -1, patch)

  local function walk(prefix, tbl)
    for k, v in pairs(tbl) do
      local path = prefix ~= '' and (prefix .. '.' .. k) or k
      if type(v) == 'table' then walk(path, v) end
      local subs = SRP_ConfigBus.subs[path]
      if subs then
        for _, cb in pairs(subs) do SRP_Utils.try(cb, v, path) end
      end
    end
  end
  walk('', patch)
end

-- Read by path
function SRP_ConfigBus.get(path) return SRP_Utils.getByPath(SRP_Config, path) end

-- Persist via backend then apply locally
function SRP_ConfigBus.patch(patch)
  local res = SRP_HTTP.Fetch('PATCH', '/config/live', patch, { retries = 1 })
  if res.ok and res.data then
    SRP_ConfigBus.apply(res.data)
    return true, res.data
  end
  return false, res.error or 'update_failed'
end

-- Exports
exports('ConfigOn', function(path, cb) return SRP_ConfigBus.on(path, cb) end)
exports('ConfigOff', function(path, token) SRP_ConfigBus.off(path, token) end)
exports('ConfigGet', function(path) return SRP_ConfigBus.get(path) end)
exports('ConfigPatch', function(patch) return SRP_ConfigBus.patch(patch) end)

-- Keep world snapshots in sync on Time/Weather mutations
SRP_ConfigBus.on('Time', function() TriggerClientEvent('srp:world:time', -1, SRP_Config.Time) end)
SRP_ConfigBus.on('Weather', function() TriggerClientEvent('srp:world:weather', -1, SRP_Config.Weather) end)