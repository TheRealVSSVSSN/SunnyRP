-- resources/[sunnyrp]/sunnyrp-base/server/integration/http.lua
-- Single HTTP helper for all FiveM -> Node calls.
-- Adds X-API-Token always; optional HMAC when enabled via convars.

local Http = {}

-- Support both naming schemes to avoid breakage:
local function getBaseUrl()
  local v = GetConvar('srp_api_base_url', '')
  if v and v ~= '' then return v end
  v = GetConvar('srp_api_url', '')
  if v and v ~= '' then return v end
  return 'http://127.0.0.1:3010'
end

local function getTimeoutMs()
  local v = GetConvar('srp_api_timeout_ms', '')
  if v ~= '' then return tonumber(v) or 500 end
  v = GetConvar('srp_http_timeout_ms', '')
  if v ~= '' then return tonumber(v) or 500 end
  return 500
end

local function getRetries()
  local v = GetConvar('srp_api_retries', '')
  if v ~= '' then return tonumber(v) or 1 end
  v = GetConvar('srp_http_retries', '')
  if v ~= '' then return tonumber(v) or 1 end
  return 1
end

local BASE_URL     = getBaseUrl()
local API_TOKEN    = GetConvar('srp_api_token', '')
local TIMEOUT_MS   = getTimeoutMs()
local RETRIES      = getRetries()

-- Optional HMAC (server-side flags may live in .env; client flags can be mirrored via convars if desired)
local HMAC_ENABLE  = GetConvarInt('srp_api_hmac_enabled', 0) == 1
local HMAC_SECRET  = GetConvar('srp_api_hmac_secret', '')
local HMAC_STYLE   = GetConvar('srp_api_hmac_style', 'newline') -- 'newline'|'pipe'

-- Fallback HMAC if ox_lib not present
local function hmac_sha256(key, data)
  if lib and lib.crypto and lib.crypto.hmac then
    return lib.crypto.hmac('sha256', data, key)
  end
  -- Minimal pure-Lua HMAC-SHA256 is non-trivial; if ox_lib missing, we send empty sig.
  -- Backend will reject when HMAC is enabled. This keeps compatibility when disabled.
  return ''
end

local function canonical(method, path, ts, nonce, body)
  if HMAC_STYLE == 'pipe' then
    return string.format('%s|%s|%s|%s|%s', method, path, body, ts, nonce)
  else
    -- default newline
    return string.format('%s\n%s\n%s\n%s\n%s', method, path, ts, nonce, body)
  end
end

-- Perform a single HTTP request with retries and exponential backoff
function Http.request(method, path, body, opts)
  opts = opts or {}
  method = string.upper(method or 'GET')
  local url = string.format('%s%s', BASE_URL, path)
  local payload = body and json.encode(body) or ''

  local headers = {
    ['Content-Type'] = 'application/json',
    ['X-API-Token']  = API_TOKEN,
  }

  if HMAC_ENABLE then
    local ts = tostring(os.time())
    local nonce = ('%08x%08x'):format(math.random(0, 0xffffffff), math.random(0, 0xffffffff))
    local canon = canonical(method, path, ts, nonce, payload)
    local sig = hmac_sha256(HMAC_SECRET, canon)
    headers['X-Ts'] = ts
    headers['X-Nonce'] = nonce
    headers['X-Sig'] = sig
  end

  local tries = opts.tries or RETRIES
  local backoff = TIMEOUT_MS
  local code, resp

  for i = 1, math.max(1, tries) do
    local done = false
    PerformHttpRequest(url, function(status, bodyText, _h)
      code = status
      resp = bodyText
      done = true
    end, method, payload, headers)

    local waited = 0
    while not done and waited < (TIMEOUT_MS + 2000) do
      Wait(10)
      waited = waited + 10
    end

    if code and code >= 200 and code < 500 then
      break
    end

    Wait(backoff)
    backoff = math.min(backoff * 2, 2000)
  end

  return resp, code
end

return Http