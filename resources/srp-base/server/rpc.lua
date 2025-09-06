-- Updated: 2024-11-28
--[[
    -- Type: Module
    -- Name: rpc
    -- Use: Dispatches RPC envelopes to domain modules
    -- Created: 2024-11-26
    -- By: VSSVSSN
    -- Updated: 2024-11-27
--]]

local SRP = SRP or require('resources/srp-base/shared/srp.lua')

local modules = {
    base = require('resources/srp-base/server/modules/base.lua'),
    sessions = require('resources/srp-base/server/modules/sessions.lua'),
    voice = require('resources/srp-base/server/modules/voice.lua'),
    ux = require('resources/srp-base/server/modules/ux.lua'),
    world = require('resources/srp-base/server/modules/world.lua'),
    jobs = require('resources/srp-base/server/modules/jobs.lua')
}

SRP.RPC = {}

--[[
    -- Type: Function
    -- Name: handle
    -- Use: Routes envelopes based on type field
    -- Created: 2024-11-26
    -- By: VSSVSSN
    -- Updated: 2024-11-27
--]]
function SRP.RPC.handle(envelope)
    if type(envelope) ~= 'table' or type(envelope.type) ~= 'string' then
        return { error = 'invalid_envelope' }
    end
    local domain = envelope.type:match('^srp%.([^.]+)%.')
    local mod = modules[domain]
    if not mod or type(mod.handle) ~= 'function' then
        return { error = 'not_implemented' }
    end
    local ok, result = pcall(mod.handle, envelope)
    if not ok then
        return { error = 'handler_error' }
    end
    return { result = result }
end

return SRP.RPC
