-- sunnyrp-base/shared/utils.lua
-- Shared helpers (client/server safe), including HTTP wrapper with retries.

SRP_HTTP = SRP_HTTP or {}
SRP_Util = SRP_Util or {}

local function convarOr(name, d)
  local v = GetConvar(name, '')
  if v == '' then return d end
  return v
end

-- API target (from config.lua or ConVars)
local API_URL   = convarOr('srp_api_url', 'http://127.0.0.1:3301')
local API_TOKEN = convarOr('srp_api_token', 'changeme_please')

-- Simple UUID-ish (idempotency key / request-id)
local function randhex(n)
  local t = {}
  for i=1,n do t[i] = string.format('%x', math.random(0,15)) end
  return table.concat(t)
end
math.randomseed((os.time() % 100000) + GetGameTimer())

function SRP_Util.newId()
  return string.format('%s-%s-%s-%s-%s',
    randhex(8), randhex(4), randhex(4), randhex(4), randhex(12))
end

local function joinUrl(base, path)
  if path:sub(1,1) == '/' then
    return base .. path
  else
    return base .. '/' .. path
  end
end

-- Core HTTP (server-only native). If called on client by mistake, it will error.
-- opts = { timeout=ms, retries=n, idempotencyKey=string, headers=table }
function SRP_HTTP.Fetch(method, path, body, opts)
  opts = opts or {}
  local url = joinUrl(API_URL, path)
  local timeout = tonumber(opts.timeout or convarOr('srp_http_timeout_ms','5000')) or 5000
  local retries = tonumber(opts.retries or convarOr('srp_http_retries','2')) or 2
  local idemKey = opts.idempotencyKey or SRP_Util.newId()

  local headers = {
    ['Content-Type']    = 'application/json',
    ['Accept']          = 'application/json',
    ['X-API-Token']     = API_TOKEN,
    ['X-Request-Id']    = idemKey,
    ['X-Idempotency-Key']= idemKey,
    ['X-Nonce']         = randhex(16),
    ['X-Ts']            = tostring(os.time()),
    -- ['X-Sig']        = 'TODO-HMAC', -- When we enable HMAC, we’ll compute and set this.
  }
  for k,v in pairs(opts.headers or {}) do headers[k] = v end

  local payload = body and json.encode(body) or ''
  local backoff = 200

  for attempt=0,retries do
    local p = promise.new()
    -- FiveM timeout is not per-request; we emulate with a watchdog.
    local timedOut = false
    local timer = SetTimeout(timeout, function()
      timedOut = true
      p:resolve({ status = 0, data = nil, headers = nil, err = 'timeout' })
    end)

    PerformHttpRequest(url, function(status, data, respHeaders)
      if timedOut then return end
      if timer then
        pcall(function() ClearTimeout(timer) end)
      end
      p:resolve({ status = status, data = data, headers = respHeaders })
    end, method, payload, headers)

    local res = Citizen.Await(p)
    local ok = (res.status >= 200 and res.status < 300)
    local decoded = nil

    if type(res.data) == 'string' and #res.data > 0 then
      local okd, val = pcall(json.decode, res.data)
      if okd then decoded = val end
    end

    if ok then
      return { ok = true, status = res.status, data = decoded, raw = res.data, headers = res.headers }
    end

    -- retry on 0 (timeout) or 5xx
    if attempt < retries and (res.status == 0 or (res.status >= 500 and res.status <= 599)) then
      Citizen.Wait(backoff)
      backoff = math.min(backoff * 2, 1500)
    else
      local msg = (decoded and decoded.error and decoded.error.message) or res.err or ('HTTP ' .. tostring(res.status))
      return { ok = false, status = res.status, data = decoded, error = msg, message = msg }
    end
  end

  return { ok = false, status = 0, error = 'exhausted', message = 'retries_exhausted' }
end