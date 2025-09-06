--[[
    -- Type: Module
    -- Name: base
    -- Use: Mirror handlers for account character endpoints during failover
    -- Created: 2024-11-26
    -- By: VSSVSSN
    -- Updated: 2024-11-27
--]]

local M = {}
local accounts = {}
local nextId = 1

--[[
    -- Type: Function
    -- Name: handle
    -- Use: Processes base domain envelopes
    -- Created: 2024-11-26
    -- By: VSSVSSN
    -- Updated: 2024-11-27
--]]
function M.handle(envelope)
    if type(envelope) ~= 'table' then return { error = 'invalid_envelope' } end
    local action = envelope.type and envelope.type:match('srp%.base%.characters%.([^.]+)')
    local accountId = tonumber(envelope.subject) or (envelope.data and envelope.data.accountId)
    if not action or not accountId then return { error = 'invalid_request' } end

    if action == 'list' then
        return accounts[accountId] or {}
    elseif action == 'create' then
        local data = envelope.data or {}
        local character = { id = nextId, firstName = data.firstName, lastName = data.lastName }
        nextId = nextId + 1
        accounts[accountId] = accounts[accountId] or {}
        accounts[accountId][#accounts[accountId]+1] = character
        return character
    elseif action == 'select' then
        local charId = tonumber(envelope.data and envelope.data.characterId)
        for _, c in ipairs(accounts[accountId] or {}) do
            if c.id == charId then return { ok = true } end
        end
        return { error = 'not_found' }
    elseif action == 'delete' then
        local charId = tonumber(envelope.data and envelope.data.characterId)
        local chars = accounts[accountId] or {}
        for i, c in ipairs(chars) do
            if c.id == charId then
                table.remove(chars, i)
                return { ok = true }
            end
        end
        return { ok = false }
    end
    return { error = 'not_implemented' }
end

return M
