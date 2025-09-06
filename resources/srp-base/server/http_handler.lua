-- Updated: 2024-11-28
--[[
    -- Type: Module
    -- Name: http_handler
    -- Use: Multiplexes HTTP requests into SRP handlers
    -- Created: 2024-11-26
    -- By: VSSVSSN
    -- Updated: 2024-11-27
--]]

local SRP = SRP or require('resources/srp-base/shared/srp.lua')
local JSON = json

local function jsonResponse(req, res, status, body, headers)
    headers = headers or { ['Content-Type'] = 'application/json' }
    local reqId = req.headers['x-request-id'] or ('lua-' .. tostring(math.random(100000,999999)))
    headers['X-Request-Id'] = reqId
    res.writeHead(status, headers)
    res.send(JSON.encode(body))
end

SetHttpHandler(function(req, res)
    if req.method == 'GET' and req.path == '/v1/health' then
        return jsonResponse(req, res, 200, { status = 'ok', service = 'srp-base', time = os.date('!%Y-%m-%dT%H:%M:%SZ') })
    end
    if req.method == 'POST' and req.path == '/internal/srp/rpc' then
        local key = req.headers['x-srp-internal-key']
        if key ~= GetConvar('srp_internal_key', 'change_me') then
            return jsonResponse(req, res, 401, { error = 'unauthorized' })
        end
        local body = req.body and JSON.decode(req.body) or nil
        if not body then
            return jsonResponse(req, res, 400, { error = 'invalid_envelope' })
        end
        local result = SRP.RPC.handle(body)
        return jsonResponse(req, res, 200, { ok = true, result = result })
    end
    return jsonResponse(req, res, 404, { error = 'not_found' })
end)
