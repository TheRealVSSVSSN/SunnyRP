-- server/integration/http.lua
-- Unified HTTP client for SRP services with HMAC, retries, and envelope unwrapping.
-- Signature format (matches backend replayGuard): method|path|rawBody|ts|nonce

SRP_HTTP = SRP_HTTP or {}
local json = json or {}

-- ==== utilities ====
local function uuid4()
  local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  return (template:gsub('[xy]', function(c)
    local v = math.random(0,15)
    if c == 'y' then v = (v % 4) + 8 end
    return string.format('%x', v)
  end))
end

local function now_unix_seconds()
  return os.time() -- seconds (server expects seconds skew window)
end

local function tohex(bin)
  return (bin:gsub('.', function(c) return string.format('%02x', string.byte(c)) end))
end

-- ==== SHA-256 + HMAC (compact pure Lua) ====
local bit = bit32
local band, bor, bxor, rshift, lshift = bit.band, bit.bor, bit.bxor, bit.rshift, bit.lshift
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
  local o_key_pad = key:gsub('.', function(c) return string.char(bit.bxor(string.byte(c), 0x5c)) end)
  local i_key_pad = key:gsub('.', function(c) return string.char(bit.bxor(string.byte(c), 0x36)) end)
  return sha256(o_key_pad .. sha256(i_key_pad .. msg))
end

local function sign(method, path, rawBody, ts, nonce)
  local signing = string.format('%s|%s|%s|%s|%s', method, path, rawBody or '', ts, nonce)
  return tohex(hmac_sha256(SRP_API.token or 'CHANGE_ME', signing))
end

-- ==== core HTTP ====
local function normalizeHeaders(h)
  local out = {}
  for k,v in pairs(h or {}) do out[string.lower(k)] = v end
  return out
end

local function decodeJson(body)
  if not body or body == '' then return nil end
  local ok, val = pcall(json.decode, body)
  return ok and val or nil
end

local function unwrapEnvelope(status, bodyTbl)
  -- Expected: { ok:boolean, data:?, error:{ code, message }, requestId?, traceId? }
  if type(bodyTbl) == 'table' and bodyTbl.ok ~= nil then
    local okb = bodyTbl.ok == true
    return {
      ok = okb,
      status = status or (okb and 200 or 500),
      data = okb and bodyTbl.data or nil,
      error = (not okb and bodyTbl.error and (bodyTbl.error.code or 'INTERNAL_ERROR')) or nil,
      message = (not okb and bodyTbl.error and bodyTbl.error.message) or nil,
      requestId = bodyTbl.requestId,
      traceId = bodyTbl.traceId
    }
  end
  -- Fallback: treat 2xx as ok and pass through
  return { ok = (status and status >= 200 and status < 300) or false, status = status or 0, data = bodyTbl }
end

local function doRequest(method, path, bodyTbl, opts)
  opts = opts or {}
  local url = (SRP_API.url or 'http://127.0.0.1:3301') .. path
  local raw = bodyTbl and json.encode(bodyTbl) or ''
  local ts = tostring(now_unix_seconds())
  local nonce = uuid4()
  local sig = sign(method, path, raw, ts, nonce)

  local headers = {
    ['Content-Type'] = 'application/json',
    ['Accept']       = 'application/json',
    ['X-API-Token']  = SRP_API.token or 'CHANGE_ME',
    ['X-Ts']         = ts,
    ['X-Nonce']      = nonce,
    ['X-Sig']        = sig,
    ['x-request-id'] = uuid4(),
  }

  if (method == 'POST' or method == 'PUT' or method == 'PATCH') then
    headers['Idempotency-Key'] = (opts.idempotencyKey) or uuid4()
  end

  local retries = opts.retries or 1
  local timeout = opts.timeout or 10000
  local attempt = 0
  local last = { ok=false, status=0, data=nil, error=nil, message=nil }

  repeat
    attempt = attempt + 1
    local p = promise.new()
    PerformHttpRequest(url, function(status, respBody, respHeaders)
      local bodyTbl = decodeJson(respBody)
      local norm = unwrapEnvelope(status or 0, bodyTbl)
      norm.headers = normalizeHeaders(respHeaders)
      p:resolve(norm)
    end, method, raw, headers)

    local t0 = GetGameTimer()
    local res
    while true do
      res = Citizen.Await(p)
      if res then break end
      if GetGameTimer() - t0 > timeout then
        res = { ok=false, status=0, error='TIMEOUT', message='Request timed out' }
        break
      end
      Wait(0)
    end

    last = res
    -- retry only safe/idempotent reads or 5xx on GET/HEAD/DELETE
    local shouldRetry = (not last.ok) and (last.status == 0 or (last.status >= 500 and (method == 'GET' or method == 'HEAD' or method == 'DELETE')))
    if shouldRetry and attempt <= retries then Citizen.Wait(150 * attempt) else break end
  until attempt > retries

  return last
end

function SRP_HTTP.Fetch(method, path, bodyTbl, opts)
  return doRequest(string.upper(method), path, bodyTbl, opts)
end

exports('Fetch', SRP_HTTP.Fetch)