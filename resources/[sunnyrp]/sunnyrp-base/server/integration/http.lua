-- Signed HTTP with HMAC + retries + circuit breaker + typed results
SRP_HTTP = {}
local json = json or {}

-- bit ops
local bit = bit32
local band, bor, bxor, bnot, rshift, rrotate =
  bit.band, bit.bor, bit.bxor, bit.bnot, bit.rshift, bit.rrotate

-- ==== SHA-256 (compact pure Lua) ====
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
local function tobytes32(x)
  return string.char(rshift(x,24)%256, rshift(x,16)%256, rshift(x,8)%256, x%256)
end
local function str2w(s, i)
  local a,b,c,d = s:byte(i, i+3)
  return ((a*256 + b)*256 + c)*256 + d
end
local function sha256(msg)
  local h0,h1,h2,h3,h4,h5,h6,h7 =
    0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19
  local ml = #msg
  msg = msg .. '\128' .. string.rep('\0', (56 - (ml + 1) % 64) % 64) ..
        string.char(0,0,0,0, (ml*8 >> 24) & 255, (ml*8 >> 16) & 255, (ml*8 >> 8) & 255, (ml*8) & 255)
  for i=1,#msg,64 do
    local w = {}
    for j=0,15 do w[j] = str2w(msg, i + j*4) end
    for j=16,63 do
      local s0 = bxor(rrotate(w[j-15],7), rrotate(w[j-15],18), rshift(w[j-15],3))
      local s1 = bxor(rrotate(w[j-2],17), rrotate(w[j-2],19), rshift(w[j-2],10))
      w[j] = (w[j-16] + s0 + w[j-7] + s1) % 0x100000000
    end
    local a,b,c,d,e,f,g,h = h0,h1,h2,h3,h4,h5,h6,h7
    for j=0,63 do
      local S1 = bxor(rrotate(e,6), rrotate(e,11), rrotate(e,25))
      local ch = bxor(band(e,f), band(bnot(e), g))
      local t1 = (h + S1 + ch + K[j+1] + w[j]) % 0x100000000
      local S0 = bxor(rrotate(a,2), rrotate(a,13), rrotate(a,22))
      local maj = bxor(band(a,b), band(a,c), band(b,c))
      local t2 = (S0 + maj) % 0x100000000
      h = g; g = f; f = e; e = (d + t1) % 0x100000000
      d = c; c = b; b = a; a = (t1 + t2) % 0x100000000
    end
    h0 = (h0 + a) % 0x100000000
    h1 = (h1 + b) % 0x100000000
    h2 = (h2 + c) % 0x100000000
    h3 = (h3 + d) % 0x100000000
    h4 = (h4 + e) % 0x100000000
    h5 = (h5 + f) % 0x100000000
    h6 = (h6 + g) % 0x100000000
    h7 = (h7 + h) % 0x100000000
  end
  return tobytes32(h0)..tobytes32(h1)..tobytes32(h2)..tobytes32(h3)..
         tobytes32(h4)..tobytes32(h5)..tobytes32(h6)..tobytes32(h7)
end
local function hmac_sha256(key, msg)
  local block = 64
  if #key > block then key = sha256(key) end
  if #key < block then key = key .. string.rep('\0', block - #key) end
  local o, i = {}, {}
  for idx=1,#key do
    local kb = key:byte(idx)
    o[idx] = string.char(bxor(kb, 0x5c))
    i[idx] = string.char(bxor(kb, 0x36))
  end
  return sha256(table.concat(o) .. sha256(table.concat(i) .. msg))
end
local function sign(method, path, ts, nonce, body)
  local raw = table.concat({method, path, ts, nonce, body or ''}, '\n')
  local mac = hmac_sha256(SRP_API.token or 'CHANGE_ME', raw)
  local out = {}
  for i=1,#mac do out[i] = string.format('%02x', mac:byte(i)) end
  return table.concat(out)
end

-- Circuit breaker
local CB = { failures = 0, openUntil = 0 }
local function cbOpen(ms) CB.openUntil = GetGameTimer() + ms end
local function cbClosed() return GetGameTimer() > CB.openUntil end
local function cbOnResult(ok)
  if ok then CB.failures = 0; CB.openUntil = 0
  else
    CB.failures = CB.failures + 1
    if CB.failures >= 4 then cbOpen(8000) end
  end
end

local function httpRequest(method, path, bodyTbl, opts)
  opts = opts or {}
  local url = SRP_API.url .. path
  local body = bodyTbl and json.encode(bodyTbl) or ''
  local ts = tostring(os.time())
  local nonce = ('%06d-%s-%06d'):format(math.random(0,999999), ts, math.random(0,999999))
  local sig = sign(method, path, ts, nonce, body)

  if not cbClosed() then
    return { ok=false, status=0, error='circuit_open', message='Backend temporarily unavailable' }
  end

  local headers = {
    ['Content-Type'] = 'application/json',
    ['X-API-Token']  = SRP_API.token,
    ['X-Ts']         = ts,
    ['X-Nonce']      = nonce,
    ['X-Sig']        = sig
  }
  if opts.idempotencyKey then headers['Idempotency-Key'] = opts.idempotencyKey end

  local tries = opts.retries or 2
  local timeout = opts.timeout or 10000
  local result = { ok=false, status=0, data=nil, error=nil, message=nil }

  for attempt = 1, tries + 1 do
    local done = false
    PerformHttpRequest(url, function(statusCode, respBody)
      result.status = statusCode or 0
      if statusCode and statusCode >= 200 and statusCode < 300 then
        local ok, data = pcall(function()
          return (respBody and #respBody > 0) and json.decode(respBody) or {}
        end)
        result.ok = true
        result.data = ok and data or {}
      else
        result.ok = false
        result.error = 'http_error'
        result.message = ('HTTP %s'):format(statusCode or '0')
        result.data = SRP_Utils.safeJsonDecode(respBody)
      end
      done = true
    end, method, body, headers)

    local t0 = GetGameTimer()
    while not done and GetGameTimer() - t0 < timeout do Wait(0) end

    if result.ok then
      cbOnResult(true)
      return result
    else
      cbOnResult(false)
      if attempt <= tries then Citizen.Wait((attempt * 500) + math.random(0, 250)) end
    end
  end
  return result
end

function SRP_HTTP.Fetch(method, path, bodyTbl, opts)
  return httpRequest(string.upper(method), path, bodyTbl, opts)
end

function SRP_HTTP.Emit(typeName, subject, data)
  return httpRequest('POST', '/events/emit', {
    type = typeName, subject = subject, data = data or {}, time = os.time()
  }, { retries = 1, timeout = 7000 })
end

exports('Fetch', SRP_HTTP.Fetch)
exports('Emit', SRP_HTTP.Emit)