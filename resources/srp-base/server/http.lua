--[[
    -- Type: Module
    -- Name: http
    -- Use: Provides HTTP wrappers for inter-process communication
    -- Created: 2024-11-26
    -- By: VSSVSSN
--]]

local SRP = SRP or require('resources/srp-base/shared/srp.lua')
local JSON = json

local function _headers(extra)
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
    -- Created: 2024-11-26
    -- By: VSSVSSN
--]]
SRP.Http.requestAsync = function(method, url, body, cb)
    local fn = PerformHttpRequest
    if type(PerformHttpRequestInternal) == "function" then fn = PerformHttpRequestInternal end
    fn(url, function(status, resp, headers)
        cb(status, resp, headers or {})
    end, method, body or "", _headers())
end

--[[
    -- Type: Function
    -- Name: requestAwait
    -- Use: Performs synchronous HTTP requests
    -- Created: 2024-11-26
    -- By: VSSVSSN
--]]
SRP.Http.requestAwait = function(method, url, body)
    if type(PerformHttpRequestAwait) == "function" then
        local status, resp, headers = PerformHttpRequestAwait(url, method, body or "", _headers())
        return { status = status, body = resp, headers = headers or {} }
    end
    local p = promise.new()
    SRP.Http.requestAsync(method, url, body, function(st, b, h) p:resolve({ status = st, body = b, headers = h }) end)
    return Citizen.Await(p)
end

return SRP.Http
