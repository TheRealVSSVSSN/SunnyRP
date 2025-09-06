--[[
    -- Type: Module
    -- Name: rpc
    -- Use: Dispatches RPC envelopes to domain modules
    -- Created: 2025-09-06
    -- By: VSSVSSN
--]]

local SRP = SRP or require('resources/srp-base/shared/srp.lua')

SRP.RPC = SRP.RPC or {}

local handlers = {
    sessions   = require('resources/srp-base/server/modules/sessions'),
    queue      = require('resources/srp-base/server/modules/queue'),
    voice      = require('resources/srp-base/server/modules/voice'),
    telemetry  = require('resources/srp-base/server/modules/telemetry'),
    ux         = require('resources/srp-base/server/modules/ux'),
    world      = require('resources/srp-base/server/modules/world'),
    jobs       = require('resources/srp-base/server/modules/jobs')
}

--[[
    -- Type: Function
    -- Name: SRP.RPC.handle
    -- Use: Routes payload based on type field
    -- Created: 2025-09-06
    -- By: VSSVSSN
--]]
function SRP.RPC.handle(payload)
    if type(payload) ~= "table" or type(payload.type) ~= "string" then
        return nil, "invalid_payload"
    end
    local domain = payload.type:match("^srp%.([^.]+)")
    if not domain then
        return nil, "unknown_domain"
    end
    local mod = handlers[domain]
    if not mod or type(mod.handle) ~= "function" then
        return nil, "no_handler"
    end
    return mod.handle(payload)
end

return SRP.RPC
