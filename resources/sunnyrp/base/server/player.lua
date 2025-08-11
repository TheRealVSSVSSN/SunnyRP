-- srp_base: server/player.lua
-- Player module export: getModule('Player') NP-style, backed by Core-API (expanded)

local Player = {}
local cache = {}  -- src -> { playerId, identifiers, verified, scopes, vars = {}, char = {...}, accounts = {...}, job = {...} }
local TTL = { accounts = 10000, job = 10000 } -- ms

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
  cache[src] = cache[src] or { vars = {} }
  cache[src].identifiers = collectIdentifiers(src)

  local res = SRP_HTTP.Fetch('POST', '/players/link', {
    name = displayName or ('player:%d'):format(src),
    identifiers = cache[src].identifiers,
  }, { retries = 1, timeout = 8000 })

  if not res.ok then
    return nil, (res.message or res.error or 'link_failed')
  end

  local data = res.data or {}
  cache[src].playerId = data.playerId or data.id or data.player_id
  cache[src].verified = (data.verified == true)
  cache[src].scopes = data.scopes or cache[src].scopes or {}
  return cache[src]
end

function Player.RefreshPerms(src, playerId)
  SRP_Perms.refreshFor(src, playerId)
  local entry = cache[src]
  if entry then
    entry.scopes = (SRP_Perms.cache[src] and SRP_Perms.cache[src].scopes) or entry.scopes or {}
  end
end

-- Characters: Base does not own selection; expose setters so Characters resource can update us
function Player.SetCurrentCharacter(src, char)
  cache[src] = cache[src] or { vars = {} }
  cache[src].char = char -- expect { id, firstName, lastName, gender, dob, ... }
  Player._touchAccounts(src, true)
  Player._touchJob(src, true)
end

-- Read-through caches ---------------------------------------------------------
function Player._touchAccounts(src, force)
  local c = cache[src]; if not c or not (c.char and c.char.id) then return end
  c._accT = c._accT or 0
  if not force and (GetGameTimer() - c._accT) < TTL.accounts then return end
  local res = SRP_HTTP.Fetch('GET', ('/inventory/%s'):format(c.char.id), nil, { retries = 1, timeout = 6000 })
  local acct = { cash = 0, bank = 0 }
  if res.ok and res.data and res.data.accounts then
    acct.cash = tonumber(res.data.accounts.cash or 0) or 0
    acct.bank = tonumber(res.data.accounts.bank or 0) or 0
  end
  c.accounts = acct
  c._accT = GetGameTimer()
end

function Player._touchJob(src, force)
  local c = cache[src]; if not c or not (c.char and c.char.id) then return end
  c._jobT = c._jobT or 0
  if not force and (GetGameTimer() - c._jobT) < TTL.job then return end
  local res = SRP_HTTP.Fetch('GET', ('/jobs/%s'):format(c.char.id), nil, { retries = 1, timeout = 6000 })
  local job = { name = 'unemployed', grade = 0, duty = false }
  if res.ok and res.data and res.data.job then
    job.name = res.data.job.name or job.name
    job.grade = res.data.job.grade or job.grade
    job.duty = res.data.job.duty == true
  end
  c.job = job
  c._jobT = GetGameTimer()
end

-- Public getters --------------------------------------------------------------
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

function Player.getCurrentCharacter(src) return cache[src] and cache[src].char or nil end
function Player.getCash(src) Player._touchAccounts(src, false); return (cache[src] and cache[src].accounts and cache[src].accounts.cash) or 0 end
function Player.getBank(src) Player._touchAccounts(src, false); return (cache[src] and cache[src].accounts and cache[src].accounts.bank) or 0 end
function Player.getJob(src)  Player._touchJob(src, false); return (cache[src] and cache[src].job) or { name='unemployed', grade=0, duty=false } end
function Player.getDuty(src) local j = Player.getJob(src); return j and j.duty or false end

-- cleanup
AddEventHandler('playerDropped', function() cache[source] = nil end)

-- NP-style module export
local modules = { Player = Player }
exports('getModule', function(name) return modules[name] end)

-- Back-compat helpers
exports('GetPlayer', Player.GetUser)
exports('GetIdentifiers', Player.GetIdentifiers)
exports('SetCurrentCharacter', Player.SetCurrentCharacter)
exports('GetCash', Player.getCash)
exports('GetBank', Player.getBank)
exports('GetJob', Player.getJob)
exports('GetDuty', Player.getDuty)