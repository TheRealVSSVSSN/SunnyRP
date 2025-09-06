--[[
    -- Type: Module
    -- Name: http_handler
    -- Use: Exposes HTTP endpoints for internal and health requests
    -- Created: 2025-09-06
    -- By: VSSVSSN
--]]

local SRP = SRP or require('resources/srp-base/shared/srp.lua')

local routes = {}

--[[
    -- Type: Function
    -- Name: routes["POST /internal/srp/rpc"]
    -- Use: Handles RPC callbacks from Node.js
    -- Created: 2025-09-06
    -- By: VSSVSSN
--]]
routes["POST /internal/srp/rpc"] = function(req, res, body)
    if req.headers["x-srp-internal-key"] ~= GetConvar("srp_internal_key", "change_me") then
        res.writeHead(401, { ["Content-Type"] = "application/json" })
        res.send('{"error":"unauthorized"}')
        return
    end
    local ok, payload = pcall(json.decode, body or "{}")
    if not ok then
        res.writeHead(400, { ["Content-Type"] = "application/json" })
        res.send('{"error":"bad_json"}')
        return
    end
    if not SRP.RPC or not SRP.RPC.handle then
        res.writeHead(500, { ["Content-Type"] = "application/json" })
        res.send('{"error":"rpc_handler_missing"}')
        return
    end
    local result, err = SRP.RPC.handle(payload)
    if err then
        res.writeHead(400, { ["Content-Type"] = "application/json" })
        res.send(json.encode({ error = err }))
        return
    end
    res.writeHead(200, { ["Content-Type"] = "application/json" })
    res.send(json.encode({ ok = true, result = result }))
end

--[[
    -- Type: Function
    -- Name: routes["GET /v1/health"]
    -- Use: Provides basic health information
    -- Created: 2025-09-06
    -- By: VSSVSSN
--]]
routes["GET /v1/health"] = function(_, res)
    res.writeHead(200, { ["Content-Type"] = "application/json" })
    res.send('{"status":"ok","service":"srp-base","time":"' .. os.date('!%Y-%m-%dT%H:%M:%SZ') .. '"}')
end

--[[
    -- Type: Function
    -- Name: dispatch
    -- Use: Dispatches requests to route handlers
    -- Created: 2025-09-06
    -- By: VSSVSSN
--]]
local function dispatch(req, res)
    local key = string.upper(req.method) .. " " .. (req.path or "/")
    local handler = routes[key]
    if handler then
        local chunks = {}
        req.setDataHandler(function(d) chunks[#chunks + 1] = d end)
        req.setCompletedHandler(function()
            local body = table.concat(chunks)
            handler(req, res, body)
        end)
    else
        res.writeHead(404, { ["Content-Type"] = "text/plain" })
        res.send("Not Found")
    end
end

--[[
    -- Type: Function
    -- Name: SRP.Http.setHandler
    -- Use: Registers the HTTP handler with FiveM
    -- Created: 2025-09-06
    -- By: VSSVSSN
--]]
function SRP.Http.setHandler()
    SetHttpHandler(dispatch)
end

SRP.Export('SetHttpHandler', SRP.Http.setHandler)

return dispatch
