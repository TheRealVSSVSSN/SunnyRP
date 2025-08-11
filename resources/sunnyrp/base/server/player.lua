-- Player module export: getModule('Player') NP-style, backed by Core-API
local Player = {}
local cache = {}  -- src -> { playerId, identifiers, verified, scopes, vars = {} }

local function collectIdentifiers(src)
  local ids = GetPlayerIdentifiers(src)
  local out = { ip = GetPlayerEndpoint(src) or '' }
  for _,v in ipairs(ids) do
    local k, val = v:match('([^:]+):(.*)')
    if k and val then
      if k == 'license' then out.license = val
      elseif k == 'steam' then out.steam = val
      elseif k == 'discord' then out.discord = val
      elseif k == 'fivem' then out.fivem = val
      else out[k] = val end
    end
  end
  return out
end

-- Link or create player in backend, cache minimal record
function Player.Link(src, displayName)
  local idents = collectIdentifiers(src)
  local res = SRP_HTTP.Fetch('POST', '/players/link', {
    name = displayName or ('player:%d'):format(src),
    identifiers = idents,
  }, { retries = 1, timeout = 8000 })
  if not res.ok then return nil, (res.message or res.error or 'link_failed') end

  local data = res.data or {}
  cache[src] = {
    playerId = data.playerId or data.id or data.player_id,
    identifiers = idents,
    verified = (data.verified == true),
    scopes = data.scopes or {},
    vars = {}
  }
  return cache[src]
end

function Player.RefreshPerms(src, playerId)
  SRP_Perms.refreshFor(src, playerId)
  local entry = cache[src]
  if entry then entry.scopes = (SRP_Perms.cache[src] and SRP_Perms.cache[src].scopes) or entry.scopes end
end

function Player.GetUser(src) return cache[src] end
function Player.GetIdentifiers(src) return (cache[src] and cache[src].identifiers) or collectIdentifiers(src) end
function Player.HasScope(src, scope) return exports['srp_base']:HasScope(src, scope) end

function Player.GetVar(src, key)
  local entry = cache[src] or {}
  local t = entry.vars or {}
  return t[key]
end
function Player.SetVar(src, key, value)
  cache[src] = cache[src] or { vars = {} }
  cache[src].vars = cache[src].vars or {}
  cache[src].vars[key] = value
end

-- cleanup
AddEventHandler('playerDropped', function()
  cache[source] = nil
end)

-- NP-style module export
local modules = { Player = Player }
exports('getModule', function(name) return modules[name] end)

-- Back-compat helpers
exports('GetPlayer', Player.GetUser)
exports('GetIdentifiers', Player.GetIdentifiers)