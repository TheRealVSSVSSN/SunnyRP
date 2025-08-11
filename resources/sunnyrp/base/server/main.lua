SRP = SRP or {}

-- Simple event bus
local _handlers = {}
function SRP.On(event, cb)
  _handlers[event] = _handlers[event] or {}
  table.insert(_handlers[event], cb)
end
function SRP.Emit(event, payload)
  local list = _handlers[event] or {}
  for _, cb in ipairs(list) do
    Citizen.CreateThread(function() cb(payload) end)
  end
end

-- Identifiers
function SRP.GetAllIdentifiers(src)
  local ids = {}
  for i = 0, GetNumPlayerIdentifiers(src) - 1 do
    local id = GetPlayerIdentifier(src, i)
    local t, v = id:match('([^:]+):(.*)')
    if t and v then ids[t] = v end
  end
  ids['ip'] = GetPlayerEndpoint(src) or ''
  return ids
end

function SRP.GetPrimaryIdentifier(src)
  local ids = SRP.GetAllIdentifiers(src)
  local key = SRP.Config.PrimaryIdentifier or 'license'
  return ids[key], ids
end

-- HTTP wrapper (server runtime)
local function httpPerform(url, method, body, headers, timeoutMs)
  local p = promise.new()
  PerformHttpRequest(url, function(status, resp, respHeaders)
    p:resolve({ status = status, body = resp or '', headers = respHeaders or {} })
  end, method, body or '', headers or { ['Content-Type'] = 'application/json' })
  local result = Citizen.Await(p)
  return result
end

local function jitter(ms)
  return ms + math.random(25, 125)
end

SRP.Fetch = function(opts)
  -- opts: { path, method, body, timeoutMs, retries }
  local method = (opts.method or 'GET'):upper()
  local url = SRP.Config.ApiUrl .. (opts.path or '/')
  local timeout = opts.timeoutMs or SRP.Config.HttpTimeoutMs
  local retries = tonumber(opts.retries or SRP.Config.HttpRetries) or 0
  local bodyStr = opts.body and json.encode(opts.body) or nil

  local headers = {
    ['Content-Type'] = 'application/json',
    ['X-API-Token'] = SRP.Config.ApiToken,
    ['X-Request-Id'] = SRP.GenerateUUID()
  }

  local attempt = 0
  local last
  repeat
    attempt = attempt + 1
    last = httpPerform(url, method, bodyStr, headers, timeout)
    if last and last.status and last.status < 500 then break end
    if attempt <= retries then Citizen.Wait(jitter(250 * attempt)) end
  until attempt > retries

  return last
end

-- Boot probe → /health
CreateThread(function()
  SRP.Info('Booting SRP Base...')
  local res = SRP.Fetch({ path = '/health' })
  local ok = res and res.status == 200
  if ok then
    SRP.Info('Core API health ok', { status = res.status })
  else
    SRP.Warn('Core API health failed', { status = res and res.status or 'nil' })
  end
end)

-- OnPlayerConnecting info (Phase A: log identifiers, prove pipeline)
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
  local src = source
  local primary, all = SRP.GetPrimaryIdentifier(src)
  SRP.Info(('Player connecting: %s'):format(name), { primary = primary, all = all })
end)