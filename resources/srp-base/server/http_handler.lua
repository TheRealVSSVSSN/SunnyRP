--[[
    -- Type: Module
    -- Name: http_handler
    -- Use: Multiplexes HTTP requests into SRP handlers
    -- Created: 2024-11-26
    -- By: VSSVSSN
--]]

local SRP = SRP or require('resources/srp-base/shared/srp.lua')
local JSON = json

local function jsonResponse(res, status, body, headers)
    headers = headers or { ['Content-Type'] = 'application/json' }
    res.writeHead(status, headers)
    res.send(JSON.encode(body))
end

SetHttpHandler(function(req, res)
    if req.method == 'GET' and req.path == '/v1/health' then
        return jsonResponse(res, 200, { status = 'ok', service = 'srp-base', time = os.date('!%Y-%m-%dT%H:%M:%SZ') })
    end
    if req.method == 'POST' and req.path == '/internal/srp/rpc' then
        local key = req.headers['x-srp-internal-key']
        if key ~= GetConvar('srp_internal_key', 'change_me') then
            return jsonResponse(res, 401, { error = 'unauthorized' })
        end
        local body = req.body and JSON.decode(req.body) or nil
        if not body then
            return jsonResponse(res, 400, { error = 'invalid_envelope' })
        end
        local result = SRP.RPC.handle(body)
        return jsonResponse(res, 200, { ok = true, result = result })
    end
    return jsonResponse(res, 404, { error = 'not_found' })
end)
