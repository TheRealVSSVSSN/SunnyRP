--[[
    -- Type: Module
    -- Name: RPC Dispatcher
    -- Use: Routes envelopes to modules
    -- Created: 2024-06-02
    -- By: VSSVSSN
--]]

SRP.RPC = {}
SRP.Modules = {}

SRP.Modules.base = require('server/modules/base')
SRP.Modules.sessions = require('server/modules/sessions')
SRP.Modules.voice = require('server/modules/voice')
SRP.Modules.ux = require('server/modules/ux')
SRP.Modules.world = require('server/modules/world')
SRP.Modules.jobs = require('server/modules/jobs')

--[[
    -- Type: Function
    -- Name: handle
    -- Use: Dispatches envelope to appropriate handler
    -- Created: 2024-06-02
    -- By: VSSVSSN
--]]
function SRP.RPC.handle(envelope)
    local typ = envelope.type or ''
    local domain, action = typ:match('srp%.([^.]+)%.(.+)')
    local mod = domain and SRP.Modules[domain] or nil
    if mod and mod[action] then
        local ok, result = pcall(mod[action], envelope)
        if ok then
            return { ok = true, result = result }
        else
            return { ok = false, error = result }
        end
    end
    return { ok = false, error = 'unknown_action' }
end
