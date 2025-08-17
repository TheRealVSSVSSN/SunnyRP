-- resources/[sunnyrp]/sunnyrp-base/server/security/permissions.lua
-- Fetches scopes for a player from the backend (authoritative), with a small cache.

SRP_PERMS = SRP_PERMS or {}
local CACHE = {}
local TTL_MS = 10 * 1000

local function now() return GetGameTimer() end

local function fetchScopes(playerId)
  local res = SRP_HTTP.Fetch('GET', '/v1/permissions/' .. tostring(playerId), nil, { retries = 0, timeout = 5000 })
  if res and res.ok and res.data and res.data.scopes then
    return res.data.scopes
  end
  return { 'player' }
end

function SRP_PERMS.GetScopes(playerId)
  local key = tostring(playerId)
  local entry = CACHE[key]
  if entry and (now() - entry.t) < TTL_MS then
    return entry.v
  end
  local scopes = fetchScopes(playerId)
  CACHE[key] = { v = scopes, t = now() }
  return scopes
end

function SRP_PERMS.HasScope(playerId, scope)
  local scopes = SRP_PERMS.GetScopes(playerId)
  if not scopes or type(scopes) ~= 'table' then return false end
  if scope == 'player' then return true end
  for _,s in ipairs(scopes) do if s == 'admin' or s == scope then return true end end
  return false
end

exports('GetScopes', SRP_PERMS.GetScopes)
exports('HasScope', SRP_PERMS.HasScope)