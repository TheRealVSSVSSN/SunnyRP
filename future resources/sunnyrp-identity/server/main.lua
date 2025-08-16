SRP = SRP or {}
SRP.Identity = SRP.Identity or { cacheBySrc = {}, cacheByUser = {} }
SRP.ACL = SRP.ACL or {}

local function setCache(src, payload)
  SRP.Identity.cacheBySrc[src] = payload
  if payload and payload.user and payload.user.id then
    SRP.Identity.cacheByUser[payload.user.id] = src
  end
end

local function clearCache(src)
  local data = SRP.Identity.cacheBySrc[src]
  if data and data.user and data.user.id then
    SRP.Identity.cacheByUser[data.user.id] = nil
  end
  SRP.Identity.cacheBySrc[src] = nil
end

AddEventHandler('playerDropped', function()
  clearCache(source)
end)

-- ACL helpers
SRP.ACL.HasScope = function(src, scope)
  local data = SRP.Identity.cacheBySrc[src]
  if not data then return false end
  local deny = data.overrides and data.overrides.deny or {}
  for _, s in ipairs(deny) do if s == scope or s == 'srp.*' then return false end end

  local allow = {}
  for _, s in ipairs(data.scopes or {}) do allow[s] = true end
  if data.overrides and data.overrides.allow then
    for _, s in ipairs(data.overrides.allow) do allow[s] = true end
  end

  if allow['srp.*'] then return true end
  if allow[scope] then return true end

  -- wildcard check like srp.admin.* etc.
  local parts = {}
  for p in string.gmatch(scope, '([^.]+)') do table.insert(parts, p) end
  while #parts > 0 do
    local candidate = table.concat(parts, '.') .. '.*'
    if allow[candidate] then return true end
    table.remove(parts) -- pop
  end
  return false
end

SRP.ACL.Enforce = function(src, scope)
  local ok = SRP.ACL.HasScope(src, scope)
  if not ok then
    DropPlayer(src, ('Insufficient permissions (%s)'):format(scope))
  end
  return ok
end

-- Link on connect with deferrals and ban check
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
  local src = source
  deferrals.defer()
  Wait(0)
  deferrals.update('Sunny Roleplay: verifying your identity...')

  local primary, all = SRP.GetPrimaryIdentifier(src)
  local ip = GetPlayerEndpoint(src) or ''
  all['ip'] = ip

  local res = SRP.Fetch({
    path = '/players/link',
    method = 'POST',
    body = { primary = SRP.Config.PrimaryIdentifier, ip = ip, identifiers = all }
  })

  if not res or res.status ~= 200 then
    deferrals.update('Core API unreachable. Please retry.')
    Citizen.Wait(300)
    return deferrals.done('Service unavailable (identity link failed).')
  end

  local ok, parsed = pcall(function() return json.decode(res.body or '{}') end)
  if not ok or not parsed or not parsed.ok then
    return deferrals.done('Identity service error.')
  end

  local data = parsed.data
  if data.banned then
    local untilStr = data.banned.expires_at and (' until ' .. tostring(data.banned.expires_at)) or ' (permanent)'
    return deferrals.done('You are banned: ' .. tostring(data.banned.reason) .. untilStr)
  end

  -- Fetch effective permissions to cache overrides (allow/deny)
  local perms = SRP.Fetch({ path = '/permissions/' .. tostring(data.user.id), method = 'GET' })
  local overrides = { allow = {}, deny = {} }
  if perms and perms.status == 200 then
    local pOk, pObj = pcall(function() return json.decode(perms.body or '{}') end)
    if pOk and pObj and pObj.ok then
      overrides = pObj.data.overrides or overrides
      data.scopes = pObj.data.scopes or data.scopes or {}
      data.roles  = pObj.data.roles or data.roles or {}
      data.overrides = overrides
    end
  end

  setCache(src, data)
  deferrals.done()
end)

-- Example server-side ACL check (sample)
RegisterNetEvent('srp:sample:restricted', function()
  local src = source
  if not SRP.ACL.Enforce(src, 'srp.sample.use') then return end
  -- perform restricted action here
end)