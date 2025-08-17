-- resources/[sunnyrp]/sunnyrp-base/server/integration/http.lua
-- Unified HTTP client for calling the authoritative srp-base backend.
-- - Adds X-API-Token and optional HMAC (X-Ts, X-Nonce, X-Sig)
-- - Retries idempotent requests on 5xx
-- - Unwraps the standard envelope: { ok, data } or { ok:false, error:{ code, message } }

SRP_HTTP = SRP_HTTP or {}

local json = json or {}
local function log(level, msg)
  level = level or 'info'
  local cur = (SRP_CONFIG and SRP_CONFIG.logLevel) or 'info'
  local priority = { debug=1, info=2, warn=3, error=4 }
  if (priority[level] or 2) < (priority[cur] or 2) then return end
  print(('[srp-http][%s] %s'):format(level, msg))
end

-- ===== helpers =====
local function uuid4()
  local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  return (template:gsub('[xy]', function(c)
    local v = math.random(0,15)
    if c == 'y' then v = (v % 4) + 8 end
    return string.format('%x', v)
  end))
end

local function tohex(bin)
  return (bin:gsub('.', function(c) return string.format('%02x', string.byte(c)) end))
end

-- ===== SHA256 + HMAC (pure Lua) =====
local bit = bit32 or bit
local band, bor, bxor, rshift, lshift, bnot =
  bit.band, bit.bor, bit.bxor, bit.rshift, bit.lshift, bit.bnot

local function rotr(x,n) return bor(rshift(x,n), lshift(x,32-n)) end

local function sha256(msg)
  local K = {
    0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
    0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
    0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
    0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
    0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
    0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
    0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
    0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2
  }
  local function preproc(s)
    local l = #s * 8
    s = s .. '\128' .. string.rep('\0', ((56 - (#s + 1) % 64) % 64))
    return s .. string.pack('>I8', l)
  end
  local H = {0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19}
  local s = preproc(msg)
  for i=1,#s,64 do
    local W = {}
    local chunk = s:sub(i,i+63)
    for j=1,16 do W[j] = string.unpack('>I4', chunk, (j-1)*4+1) end
    for j=17,64 do
      local a = W[j-15]; local b = W[j-2]
      local s0 = bxor(rotr(a,7), rotr(a,18), rshift(a,3))
      local s1 = bxor(rotr(b,17), rotr(b,19), rshift(b,10))
      W[j] = (W[j-16] + s0 + W[j-7] + s1) % 2^32
    end
    local a,b,c,d,e,f,g,h = table.unpack(H)
    for j=1,64 do
      local S1 = bxor(rotr(e,6), rotr(e,11), rotr(e,25))
      local ch = bxor(band(e,f), band(bnot(e or 0), g or 0))
      local t1 = (h + S1 + ch + K[j] + W[j]) % 2^32
      local S0 = bxor(rotr(a,2), rotr(a,13), rotr(a,22))
      local maj = bxor(band(a,b), band(a,c), band(b,c))
      local t2 = (S0 + maj) % 2^32
      h,g,f,e,d,c,b,a = g,f,e,(d + t1) % 2^32,c,b,a,(t1 + t2) % 2^32
    end
    H = { (H[1]+a)%2^32,(H[2]+b)%2^32,(H[3]+c)%2^32,(H[4]+d)%2^32,(H[5]+e)%2^32,(H[6]+f)%2^32,(H[7]+g)%2^32,(H[8]+h)%2^32 }
  end
  return string.pack('>I4I4I4I4I4I4I4I4', table.unpack(H))
end

local function hmac_sha256(key, msg)
  if #key > 64 then key = sha256(key) end
  if #key < 64 then key = key .. string.rep('\0', 64 - #key) end
  local o_key_pad = key:gsub('.', function(c) return string.char(bxor(string.byte(c), 0x5c)) end)
  local i_key_pad = key:gsub('.', function(c) return string.char(bxor(string.byte(c), 0x36)) end)
  return sha256(o_key_pad .. sha256(i_key_pad .. msg))
end

local function canonical(style, method, path, rawBody, ts, nonce)
  method = string.upper(method or '')
  path = path or ''
  rawBody = rawBody or ''
  ts = ts or ''
  nonce = nonce or ''
  if style == 'pipe' then
    return string.format('%s|%s|%s|%s|%s', method, path, rawBody, ts, nonce)
  else -- default: newline
    return string.format('%s\n%s\n%s\n%s\n%s', ts, nonce, method, path, rawBody)
  end
end

local function computeSig(secret, method, path, rawBody, ts, nonce)
  local style = (SRP_CONFIG and SRP_CONFIG.api and SRP_CONFIG.api.hmac and SRP_CONFIG.api.hmac.style) or 'newline'
  local signStr = canonical(style, method, path, rawBody, ts, nonce)
  return tohex(hmac_sha256(secret or '', signStr))
end

-- ===== core request =====
local function unwrap(status, body)
  if type(body) == 'table' and body.ok ~= nil then
    return {
      ok = body.ok == true,
      status = status or (body.ok and 200 or 500),
      data = body.ok and body.data or nil,
      error = (not body.ok and body.error and body.error.code) or nil,
      message = (not body.ok and body.error and body.error.message) or nil,
      requestId = body.requestId,
      traceId = body.traceId
    }
  end
  return { ok = status and status >= 200 and status < 300, status = status or 0, data = body }
end

local function doRequest(method, path, payload, opts)
  local cfg = SRP_CONFIG and SRP_CONFIG.api or {}
  local url = (cfg.baseUrl or '') .. path
  local raw = payload and json.encode(payload) or ''
  local headers = {
    ['Content-Type'] = 'application/json',
    ['Accept']       = 'application/json',
    ['X-API-Token']  = cfg.token or '',
    ['x-request-id'] = uuid4(),
  }

  -- Optional HMAC
  if cfg.hmac and cfg.hmac.enabled and cfg.hmac.secret and cfg.hmac.secret ~= '' then
    local ts = tostring(os.time())
    local nonce = uuid4()
    headers['X-Ts'] = ts
    headers['X-Nonce'] = nonce
    headers['X-Sig'] = computeSig(cfg.hmac.secret, method, path, raw, ts, nonce)
  end

  -- Idempotency for mutating ops
  if (method == 'POST' or method == 'PUT' or method == 'PATCH') then
    headers['Idempotency-Key'] = (opts and opts.idempotencyKey) or uuid4()
  end

  local retries = (opts and opts.retries) or cfg.retries or 0
  local timeout = (opts and opts.timeout) or cfg.timeoutMs or 5000
  local attempt = 0
  local last

  repeat
    attempt = attempt + 1
    local p = promise.new()
    local done = false

    Citizen.CreateThread(function()
      PerformHttpRequest(url, function(status, bodyText, respHeaders)
        local parsed
        if bodyText and bodyText ~= '' then
          local ok, val = pcall(json.decode, bodyText)
          parsed = ok and val or nil
        end
        local res = unwrap(status or 0, parsed)
        res.headers = respHeaders or {}
        p:resolve(res)
        done = true
      end, method, raw, headers)
    end)

    local started = GetGameTimer()
    while not done do
      Citizen.Wait(0)
      if GetGameTimer() - started > timeout then
        last = { ok=false, status=0, error='TIMEOUT', message='Request timed out' }
        break
      end
    end
    if done then last = Citizen.Await(p) end

    local canRetry = (not last.ok) and (last.status == 0 or last.status >= 500)
    if canRetry and attempt <= retries then
      local backoff = 150 * attempt
      log('warn', ('retrying %s %s (attempt %d)'):format(method, path, attempt))
      Citizen.Wait(backoff)
    else
      break
    end
  until attempt > retries

  return last
end

function SRP_HTTP.Fetch(method, path, payload, opts)
  if not path or path == '' then
    return { ok=false, status=0, error='INVALID_PATH', message='Missing path' }
  end
  if string.sub(path, 1, 1) ~= '/' then
    path = '/' .. path
  end
  method = string.upper(method or 'GET')
  return doRequest(method, path, payload, opts or {})
end

exports('Fetch', SRP_HTTP.Fetch)