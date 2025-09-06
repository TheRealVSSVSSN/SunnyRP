--[[
    -- Type: Module
    -- Name: HTTP Handler
    -- Use: Handles incoming HTTP requests from Node
    -- Created: 2024-06-02
    -- By: VSSVSSN
--]]

SetHttpHandler(function(req, res)
    if req.path == '/srp-base/v1/health' and req.method == 'GET' then
        res.writeHead(200, { ['Content-Type'] = 'application/json' })
        res.send(json.encode({ status = 'ok', service = 'srp-base', time = os.date('!%Y-%m-%dT%H:%M:%SZ') }))
        return
    end

    if req.path == '/srp-base/internal/srp/rpc' and req.method == 'POST' then
        local key = req.headers['x-srp-internal-key']
        if key ~= GetConvar('srp_internal_key', 'change_me') then
            res.writeHead(401, {})
            res.send('')
            return
        end
        local ok, body = pcall(json.decode, req.body or '{}')
        if not ok then
            res.writeHead(400, {})
            res.send('')
            return
        end
        local result = SRP.RPC.handle(body)
        res.writeHead(200, { ['Content-Type'] = 'application/json' })
        res.send(json.encode(result))
        return
    end

    res.writeHead(404, {})
    res.send('')
end)
