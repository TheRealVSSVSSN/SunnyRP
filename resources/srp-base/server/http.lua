--[[
    -- Type: Module
    -- Name: http
    -- Use: Provides HTTP wrappers for inter-process communication
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]

local SRP = SRP or require('resources/srp-base/shared/srp.lua')
local JSON = json

local function _headers(extra)
    extra = extra or {}
    extra["Content-Type"] = extra["Content-Type"] or "application/json"
    extra["X-SRP-Internal-Key"] = GetConvar("srp_internal_key", "change_me")
    extra["X-Request-Id"] = extra["X-Request-Id"] or tostring(math.random(1, 1e9))
    return extra
end

SRP.Http = SRP.Http or {}

SRP.Http.requestAsync = function(method, url, body, cb, headers)
    local fn = PerformHttpRequest
    if type(PerformHttpRequestInternal) == "function" then fn = PerformHttpRequestInternal end
    fn(url, function(status, resp, respHeaders)
        cb(status, resp, respHeaders or {})
    end, method, body or "", _headers(headers))
end

SRP.Http.requestAwait = function(method, url, body, headers)
    if type(PerformHttpRequestAwait) == "function" then
        local status, resp, respHeaders = PerformHttpRequestAwait(url, method, body or "", _headers(headers))
        return { status = status, body = resp, headers = respHeaders or {} }
    end
    local p = promise.new()
    SRP.Http.requestAsync(method, url, body, function(st, b, h) p:resolve({ status = st, body = b, headers = h }) end, headers)
    return Citizen.Await(p)
end

SRP.Http.get = function(url, headers)
    return SRP.Http.requestAwait('GET', url, nil, headers)
end

SRP.Http.post = function(url, body, headers)
    return SRP.Http.requestAwait('POST', url, JSON.encode(body or {}), headers)
end

SRP.Http.requestExSync = function(opts)
    return SRP.Http.requestAwait(opts.method or 'GET', opts.url, opts.body or '', opts.headers)
end

return SRP.Http
