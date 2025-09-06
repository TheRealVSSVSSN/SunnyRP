--[[
    -- Type: Module
    -- Name: HTTP Wrapper
    -- Use: Provides HTTP client helpers
    -- Created: 2024-06-02
    -- By: VSSVSSN
--]]

SRP.Http = {}

local function doRequest(method, url, body, headers)
    headers = headers or {}
    headers["Content-Type"] = "application/json"
    headers["X-SRP-Internal-Key"] = GetConvar("srp_internal_key", "change_me")
    headers["X-Request-Id"] = tostring(math.random(1, 1000000000))
    local data = body and json.encode(body) or ""
    local status, resBody, resHeaders
    if PerformHttpRequestAwait then
        status, resBody, resHeaders = PerformHttpRequestAwait(url, method, data, headers)
    elseif promise and promise.new then
        local p = promise.new()
        PerformHttpRequest(url, function(c, b, h)
            p:resolve({code = c, body = b, headers = h})
        end, method, data, headers)
        local r = Citizen.Await(p)
        status, resBody, resHeaders = r.code, r.body, r.headers
    else
        local done = false
        PerformHttpRequest(url, function(c, b, h)
            status, resBody, resHeaders = c, b, h
            done = true
        end, method, data, headers)
        while not done do Wait(0) end
    end
    return status, resBody, resHeaders
end

function SRP.Http.get(url, headers)
    return doRequest("GET", url, nil, headers)
end

function SRP.Http.post(url, body, headers)
    return doRequest("POST", url, body, headers)
end

function SRP.Http.requestExSync(opts)
    return doRequest(opts.method or "GET", opts.url, opts.body, opts.headers)
end
