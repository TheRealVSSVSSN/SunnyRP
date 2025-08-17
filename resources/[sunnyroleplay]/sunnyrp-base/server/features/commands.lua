-- srp_base: server/commands.lua
-- RegisterCommandEx(name, opts, handler)
-- opts = { description, scopes, anyScope, cooldownMs, argsHint, restricted=true }

local COMMANDS = {}
local COOLDOWN = {}  -- src -> name -> lastMs

local function now() return GetGameTimer() end

local function canUse(src, scopes, anyScope)
  if not scopes or #scopes == 0 then return true end
  if anyScope then
    for _,s in ipairs(scopes) do if SRP_Perms.hasScope(src, s) then return true end end
    return false
  else
    for _,s in ipairs(scopes) do if not SRP_Perms.hasScope(src, s) then return false end end
    return true
  end
end

local function checkCooldown(src, name, ms)
  if not ms or ms <= 0 then return true end
  COOLDOWN[src] = COOLDOWN[src] or {}
  local last = COOLDOWN[src][name] or 0
  local t = now()
  if (t - last) < ms then return false end
  COOLDOWN[src][name] = t
  return true
end

local function msg(src, text)
  if GetResourceState('chat') ~= 'missing' then
    TriggerClientEvent('chat:addMessage', src, { args = { '^3SRP', text } })
  else
    -- fallback
    print(('[SRP:CMD][%s] %s'):format(tostring(src), text))
  end
end

function RegisterCommandEx(name, opts, handler)
  if COMMANDS[name] then
    print(('[SRP:CMD] Command "%s" already registered; overwriting.'):format(name))
  end
  local cfg = {
    description = (opts and opts.description) or 'no description',
    scopes      = (opts and opts.scopes) or nil,
    anyScope    = (opts and opts.anyScope) or false,
    cooldownMs  = (opts and opts.cooldownMs) or 1000,
    argsHint    = (opts and opts.argsHint) or '',
    restricted  = (opts and opts.restricted) ~= false, -- FiveM suggestion
  }
  COMMANDS[name] = cfg

  RegisterCommand(name, function(src, args, raw)
    if not canUse(src, cfg.scopes, cfg.anyScope) then
      return msg(src, 'You do not have permission.')
    end
    if not checkCooldown(src, name, cfg.cooldownMs) then
      return msg(src, 'Slow down.')
    end

    local ok, err = pcall(handler, src, args, raw)
    if not ok then
      print(('[SRP:CMD] Error in "%s" by %s: %s'):format(name, tostring(src), tostring(err)))
      msg(src, 'Command error.')
    end
  end, cfg.restricted)

  -- Add chat suggestion if chat is running
  if GetResourceState('chat') ~= 'missing' then
    TriggerEvent('chat:addSuggestion', ('/%s'):format(name), cfg.description, (cfg.argsHint ~= '' and { { name = cfg.argsHint, help = '' } } or {}))
  end
end
exports('RegisterCommandEx', RegisterCommandEx)

-- Built-in /help
RegisterCommandEx('help', {
  description = 'List available commands',
  scopes = nil,
  cooldownMs = 1000,
  restricted = false,
}, function(src)
  msg(src, 'Available commands:')
  for name, cfg in pairs(COMMANDS) do
    if canUse(src, cfg.scopes, cfg.anyScope) then
      msg(src, ('/%s — %s'):format(name, cfg.description))
    end
  end
end)