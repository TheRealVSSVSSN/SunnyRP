--[[
    -- Type: Module
    -- Name: base
    -- Use: Mirror handlers for account character endpoints during failover
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]

local SRP = SRP or require('resources/srp-base/shared/srp.lua')
local M = {}
local cache = {}
local nextId = 1

local function ensure(accountId)
    cache[accountId] = cache[accountId] or {}
    return cache[accountId]
end

function M.handle(envelope)
    if type(envelope) ~= 'table' then return { error = 'invalid_envelope' } end
    local action = envelope.type and envelope.type:match('srp%.base%.characters%.([^.]+)')
    local accountId = tonumber(envelope.subject)
    if not action or not accountId then return { error = 'invalid_request' } end

    if action == 'list' then
        return ensure(accountId)
    elseif action == 'create' then
        local data = envelope.data or {}
        local character = { id = nextId, firstName = data.firstName, lastName = data.lastName }
        nextId = nextId + 1
        local chars = ensure(accountId)
        chars[#chars+1] = character
        if SRP.Failover.active() then
            SRP.SQL.execute('INSERT INTO characters(account_id, first_name, last_name) VALUES(@aid,@fn,@ln)', { ['aid']=accountId, ['fn']=character.firstName, ['ln']=character.lastName })
        end
        return character
    elseif action == 'select' then
        local charId = tonumber(envelope.data and envelope.data.characterId)
        for _, c in ipairs(ensure(accountId)) do
            if c.id == charId then return { ok = true } end
        end
        return { error = 'not_found' }
    elseif action == 'delete' then
        local charId = tonumber(envelope.data and envelope.data.characterId)
        local chars = ensure(accountId)
        for i, c in ipairs(chars) do
            if c.id == charId then
                table.remove(chars, i)
                if SRP.Failover.active() then
                    SRP.SQL.execute('DELETE FROM characters WHERE id=@id', { ['id']=charId })
                end
                return { ok = true }
            end
        end
        return { ok = false }
    end
    return { error = 'not_implemented' }
end

return M
