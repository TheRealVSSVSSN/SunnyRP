-- srp_base: server/permissions.lua
-- Scope cache + helpers (server-authoritative). Populated on connect / refresh.

SRP_Perms = SRP_Perms or { cache = {} }

-- Refresh from backend
function SRP_Perms.refreshFor(src, playerId)
  if not playerId then
    local P = exports['srp_base']:getModule('Player').GetUser(src)
    playerId = P and P.playerId
  end
  if not playerId then return end

  local res = SRP_HTTP.Fetch('GET', ('/permissions/%s'):format(playerId), nil, { retries = 1, timeout = 6000 })
  if res.ok and res.data and type(res.data.scopes) == 'table' then
    SRP_Perms.cache[src] = { playerId = playerId, scopes = res.data.scopes, ts = GetGameTimer() }
  end
end

-- Check helper
local function has(scopeList, scope)
  if not scope or scope == '' then return false end
  for _,s in ipairs(scopeList or {}) do
    if s == scope then return true end
  end
  return false
end

function SRP_Perms.hasScope(src, scope)
  local e = SRP_Perms.cache[src]
  if not e or not e.scopes then return false end
  return has(e.scopes, scope)
end

-- Exports
exports('HasScope', SRP_Perms.hasScope)
exports('RefreshPerms', SRP_Perms.refreshFor)

-- Cleanup
AddEventHandler('playerDropped', function() SRP_Perms.cache[source] = nil end)