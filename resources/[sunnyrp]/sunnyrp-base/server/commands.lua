local function hasScope(src, scope) return exports['srp_base']:HasScope(src, scope) end
local function guard(src, scope)
  if src <= 0 then return true end
  if not hasScope(src, scope) then
    TriggerClientEvent('chat:addMessage', src, { args = {'SRP', '^1No permission.'} })
    return false
  end
  return true
end

-- /srpflags set <A.B.C> <on|off>
RegisterCommand('srpflags', function(src, args)
  if not guard(src, SRP_CONST.SCOPES.ADMIN_FLAGS) then return end
  local action, path, onoff = args[1], args[2], args[3]
  if action ~= 'set' or not path or not onoff then
    TriggerClientEvent('chat:addMessage', src, { args={'SRP', 'Usage: /srpflags set <path> <on|off>'} })
    return
  end
  local value = (onoff == 'on')
  local patch = {}
  SRP_Utils.setByPath(patch, path, value)
  local ok = select(1, exports['srp_base']:ConfigPatch(patch))
  if ok then
    TriggerClientEvent('chat:addMessage', src, { args={'SRP', 'Live config updated.'} })
  else
    TriggerClientEvent('chat:addMessage', src, { args={'SRP', '^1Update failed.'} })
  end
end, false)

-- /bucket [id?] [loading|main|char|admin]
RegisterCommand('bucket', function(src, args)
  if not guard(src, SRP_CONST.SCOPES.ADMIN_BUCKET) then return end
  local target = tonumber(args[1]) or src
  local mode = (args[2] or 'main'):lower()
  if mode == 'loading' then
    exports['srp_base']:SetBucket(target, SRP_Config.Buckets.loading)
  elseif mode == 'char' then
    SRP_Buckets.AssignCharCreate(target)
  elseif mode == 'admin' then
    SRP_Buckets.AssignAdmin(target, 'manual')
  else
    SRP_Buckets.AssignMain(target)
  end
  TriggerClientEvent('chat:addMessage', src, { args={'SRP', ('Moved %s to %s'):format(target, mode)} })
end, false)

-- /time HH:MM
RegisterCommand('time', function(src, args)
  if not guard(src, SRP_CONST.SCOPES.ADMIN_WORLD) then return end
  local hhmm = args[1]
  if not hhmm or not hhmm:match('^%d%d?:%d%d$') then
    TriggerClientEvent('chat:addMessage', src, { args={'SRP', 'Usage: /time HH:MM'} })
    return
  end
  local res = SRP_HTTP.Fetch('POST', '/world/time', { override = hhmm }, { retries = 1 })
  if res.ok then
    TriggerClientEvent('chat:addMessage', src, { args={'SRP', 'Time override set.'} })
  else
    TriggerClientEvent('chat:addMessage', src, { args={'SRP', '^1Failed.'} })
  end
end, false)

-- /weather TYPE
RegisterCommand('weather', function(src, args)
  if not guard(src, SRP_CONST.SCOPES.ADMIN_WORLD) then return end
  local w = args[1] or 'CLEAR'
  local res = SRP_HTTP.Fetch('POST', '/world/weather', { type = w }, { retries = 1 })
  if res.ok then
    TriggerClientEvent('chat:addMessage', src, { args={'SRP', 'Weather set: '..w} })
  else
    TriggerClientEvent('chat:addMessage', src, { args={'SRP', '^1Failed.'} })
  end
end, false)