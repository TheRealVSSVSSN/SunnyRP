--[[
    -- Type: Module
    -- Name: http
    -- Use: Provides HTTP wrappers for inter-process communication
    -- Created: 2025-09-06
    -- By: VSSVSSN
--]]

local SRP = SRP or require('resources/srp-base/shared/srp.lua')
local JSON = json

--[[
    -- Type: Function
    -- Name: _mkHeaders
    -- Use: Builds default headers for HTTP requests
    -- Created: 2025-09-06
    -- By: VSSVSSN
--]]
local function _mkHeaders(extra)
    extra = extra or {}
    extra["Content-Type"] = extra["Content-Type"] or "application/json"
    extra["X-SRP-Internal-Key"] = GetConvar("srp_internal_key", "change_me")
    return extra
end

SRP.Http = SRP.Http or {}

--[[
    -- Type: Function
    -- Name: requestAsync
    -- Use: Performs asynchronous HTTP requests
    -- Created: 2025-09-06
    -- By: VSSVSSN
--]]
SRP.Http.requestAsync = function(method, url, body, headers, cb)
    local fn = PerformHttpRequest
    if type(PerformHttpRequestInternal) == "function" then fn = PerformHttpRequestInternal end
    fn(url, function(status, resp, respHeaders)
        cb(status, resp, respHeaders or {})
    end, method, body or "", _mkHeaders(headers))
end

--[[
    -- Type: Function
    -- Name: requestExAsync
    -- Use: Performs asynchronous HTTP requests with extended options
    -- Created: 2025-09-06
    -- By: VSSVSSN
--]]
SRP.Http.requestExAsync = function(opts, cb)
    local fn = (type(PerformHttpRequestInternalEx) == "function") and PerformHttpRequestInternalEx
            or (type(PerformHttpRequestInternal) == "function") and PerformHttpRequestInternal
            or PerformHttpRequest
    fn(opts.url, function(status, resp, respHeaders)
        cb(status, resp, respHeaders or {})
    end, opts.method or "GET", opts.body or "", _mkHeaders(opts.headers), opts.timeout or 15000)
end

--[[
    -- Type: Function
    -- Name: httpAwait
    -- Use: Performs synchronous HTTP requests when await is supported
    -- Created: 2025-09-06
    -- By: VSSVSSN
--]]
local function httpAwait(method, url, body, headers)
    if type(PerformHttpRequestAwait) == "function" then
        local status, resp, respHeaders = PerformHttpRequestAwait(url, method, body or "", _mkHeaders(headers))
        return { status = status, body = resp, headers = respHeaders or {} }
    end
    local p = promise.new()
    SRP.Http.requestAsync(method, url, body, headers, function(st, r, h) p:resolve({status=st, body=r, headers=h}) end)
    return Citizen.Await(p)
end

--[[
    -- Type: Function
    -- Name: httpExAwait
    -- Use: Performs synchronous HTTP requests with extended options
    -- Created: 2025-09-06
    -- By: VSSVSSN
--]]
local function httpExAwait(opts)
    if type(PerformHttpRequestAwait) == "function" and not opts.timeout then
        local status, resp, respHeaders = PerformHttpRequestAwait(opts.url, opts.method or "GET", opts.body or "", _mkHeaders(opts.headers))
        return { status = status, body = resp, headers = respHeaders or {} }
    end
    local p = promise.new()
    SRP.Http.requestExAsync(opts, function(st, r, h) p:resolve({status=st, body=r, headers=h}) end)
    return Citizen.Await(p)
end

--[[
    -- Type: Function
    -- Name: requestSync
    -- Use: Public synchronous HTTP request wrapper
    -- Created: 2025-09-06
    -- By: VSSVSSN
--]]
SRP.Http.requestSync   = function(method, url, body, headers) return httpAwait(method, url, body, headers) end

--[[
    -- Type: Function
    -- Name: requestExSync
    -- Use: Public synchronous extended HTTP request wrapper
    -- Created: 2025-09-06
    -- By: VSSVSSN
--]]
SRP.Http.requestExSync = function(opts) return httpExAwait(opts) end

SRP.Export('HttpRequest',      SRP.Http.requestSync)
SRP.Export('HttpRequestAsync', SRP.Http.requestAsync)

return SRP.Http
