SRP_Perms = { cache = {} }

function SRP_Perms.refreshFor(src, playerId)
  local res = SRP_HTTP.Fetch('GET', ('/permissions/%s'):format(playerId), nil, { retries = 1 })
  if res.ok then
    SRP_Perms.cache[src] = res.data or {}
  else
    print(('^1[SRP][PERMS]^7 failed to fetch: %s'):format(res.error or 'unknown'))
    SRP_Perms.cache[src] = {}
  end
end

local function has(scopeList, wanted)
  if not scopeList then return false end
  local prefix = wanted:gsub('%*$', '')
  for _, s in ipairs(scopeList) do
    if s == wanted then return true end
    if wanted:sub(-1) == '*' and s:sub(1, #prefix) == prefix then return true end
    local sp = s:gsub('%*$', '')
    if s:sub(-1) == '*' and wanted:sub(1, #sp) == sp then return true end
  end
  return false
end

function SRP_Perms.hasScope(src, wanted)
  local entry = SRP_Perms.cache[src]
  if not entry then return false end
  return has(entry.scopes or {}, wanted)
end

AddEventHandler('playerDropped', function()
  local src = source
  SRP_Perms.cache[src] = nil
end)

exports('HasScope', SRP_Perms.hasScope)