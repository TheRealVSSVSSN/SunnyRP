SRP = SRP or {}
SRP.Http = {}

--[[
    -- Type: Function
    -- Name: baseHeaders
    -- Use: Prepares default headers for HTTP requests
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
local function baseHeaders(headers)
  headers = headers or {}
  headers["Content-Type"] = "application/json"
  headers["X-SRP-Internal-Key"] = GetConvar("srp_internal_key", "change_me")
  headers["X-Request-Id"] = tostring(math.random(0, 1e9))
  return headers
end

--[[
    -- Type: Function
    -- Name: SRP.Http.requestExSync
    -- Use: Perform HTTP request synchronously
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
function SRP.Http.requestExSync(opts)
  local url = opts.url
  local method = opts.method or "GET"
  local body = opts.body or ""
  local headers = baseHeaders(opts.headers)
  if PerformHttpRequestAwait then
    local status, respBody, respHeaders = PerformHttpRequestAwait(url, method, body, headers)
    return { status = status, body = respBody, headers = respHeaders }
  else
    local p = promise.new()
    PerformHttpRequest(url, function(status, respBody, respHeaders)
      p:resolve({ status = status, body = respBody, headers = respHeaders })
    end, method, body, headers)
    return Citizen.Await(p)
  end
end

--[[
    -- Type: Function
    -- Name: SRP.Http.get
    -- Use: Issue a GET request
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
function SRP.Http.get(url, headers)
  return SRP.Http.requestExSync({ url = url, method = "GET", headers = headers })
end

--[[
    -- Type: Function
    -- Name: SRP.Http.post
    -- Use: Issue a POST request
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
function SRP.Http.post(url, body, headers)
  return SRP.Http.requestExSync({ url = url, method = "POST", body = json.encode(body or {}), headers = headers })
end
