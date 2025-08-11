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

-- ===== HTTP wrapper (server) with replay/HMAC headers =====

local function httpPerform(url, method, body, headers)
  local p = promise.new()
  PerformHttpRequest(url, function(status, resp, respHeaders)
    p:resolve({ status = status, body = resp or '', headers = respHeaders or {} })
  end, method, body or '', headers or { ['Content-Type'] = 'application/json' })
  return Citizen.Await(p)
end

local function jitter(ms) return ms + math.random(25, 125) end

local function ensureHmac()
  if SRP and SRP.Utils and SRP.Utils.HmacSHA256Hex then return SRP.Utils.HmacSHA256Hex end
  error('[SRP.Fetch] Missing SRP.Utils.HmacSHA256Hex(key, data). Add it to shared/utils.lua.', 2)
end

local function mergeHeaders(base, extra)
  if not extra then return base end
  for k,v in pairs(extra) do base[k] = v end
  return base
end

SRP.Fetch = function(opts)
  -- opts: { path, method, body, timeoutMs, retries, headers, idempotencyKey }
  local method = (opts.method or 'GET'):upper()
  local path   = opts.path or '/'
  local url    = (SRP.Config.ApiUrl or '') .. path
  local retries = tonumber(opts.retries or SRP.Config.HttpRetries) or 0
  local bodyStr = opts.body and json.encode(opts.body) or ''

  -- --- Replay/HMAC headers ---
  local ts    = os.time()                                 -- seconds epoch
  local nonce = tostring(math.random(100000, 999999)) .. '-' .. tostring(GetGameTimer())
  local base  = string.format('%s\n%s\n%s\n%s\n%s', ts, nonce, method, path, bodyStr)
  local hmac  = ensureHmac()
  local sig   = hmac(SRP.Config.ApiToken or '', base)

  local headers = {
    ['Content-Type']  = 'application/json',
    ['X-API-Token']   = SRP.Config.ApiToken or '',
    ['X-Request-Id']  = SRP.GenerateUUID and SRP.GenerateUUID() or ('req-'..nonce),
    ['X-Nonce']       = nonce,
    ['X-Ts']          = tostring(ts),
    ['X-Sig']         = sig,
  }

  if opts.idempotencyKey then
    headers['X-Idempotency-Key'] = tostring(opts.idempotencyKey)
  end

  -- Allow callers to add/override headers safely
  headers = mergeHeaders(headers, opts.headers)

  local attempt, last = 0, nil
  repeat
    attempt = attempt + 1
    last = httpPerform(url, method, bodyStr, headers)
    if last and last.status and last.status < 500 then break end
    if attempt <= retries then Citizen.Wait(jitter(250 * attempt)) end
  until attempt > retries

  return last
end

-- Boot probe → /health
CreateThread(function()
  SRP.Info('Booting SRP Base...')
  local res = SRP.Fetch({ path = '/health' })
  if res and res.status == 200 then
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