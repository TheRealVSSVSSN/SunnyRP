--[[
    -- Type: Module
    -- Name: http_handler
    -- Use: Multiplexes HTTP requests under /srp-base
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]

local SRP = SRP or require('resources/srp-base/shared/srp.lua')
local JSON = json

local function respond(req, res, status, body, headers)
    headers = headers or { ['Content-Type'] = 'application/json' }
    local reqId = req.headers['x-request-id'] or ('lua-' .. tostring(math.random(100000,999999)))
    headers['X-Request-Id'] = reqId
    res.writeHead(status, headers)
    res.send(JSON.encode(body))
end

SetHttpHandler(function(req, res)
    if not req.path:find('^/srp%-base') then
        return res.writeHead(404, { ['Content-Type'] = 'text/plain' }) and res.send('not_found')
    end
    local sub = req.path:sub(10)
    if req.method == 'GET' and sub == '/v1/health' then
        return respond(req, res, 200, { status = 'ok', service = 'srp-base', time = os.date('!%Y-%m-%dT%H:%M:%SZ') })
    end
    if req.method == 'POST' and sub == '/internal/srp/rpc' then
        local key = req.headers['x-srp-internal-key']
        if key ~= GetConvar('srp_internal_key', 'change_me') then
            return respond(req, res, 401, { error = 'unauthorized' })
        end
        local body = req.body and JSON.decode(req.body) or nil
        if not body then
            return respond(req, res, 400, { error = 'invalid_envelope' })
        end
        local result = SRP.RPC.handle(body)
        return respond(req, res, 200, { ok = true, result = result })
    end
    return respond(req, res, 404, { error = 'not_found' })
end)
