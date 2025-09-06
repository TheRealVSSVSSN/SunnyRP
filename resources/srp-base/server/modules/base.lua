--[[
    -- Type: Module
    -- Name: Base Failover Handlers
    -- Use: Mirror for account and character actions
    -- Created: 2024-06-02
    -- By: VSSVSSN
--]]

local Base = {}
local characters = {}

Base['characters:list'] = function(envelope)
    local account = envelope.subject or envelope.data.accountId
    return characters[account] or {}
end

Base['characters:create'] = function(envelope)
    local account = envelope.subject or envelope.data.accountId
    local name = envelope.data.name
    characters[account] = characters[account] or {}
    local id = tostring(#characters[account] + 1)
    local char = { id = id, name = name }
    table.insert(characters[account], char)
    if SRP.Failover.active() then
        SRP.SQL.execute('INSERT INTO srp_characters (id, account_id, name) VALUES (?, ?, ?)', { id, account, name })
    end
    return char
end

Base['characters:select'] = function(envelope)
    return { selected = envelope.data.characterId }
end

Base['characters:delete'] = function(envelope)
    local account = envelope.subject or envelope.data.accountId
    local id = envelope.data.characterId
    local list = characters[account] or {}
    for i, v in ipairs(list) do
        if v.id == id then
            table.remove(list, i)
            break
        end
    end
    if SRP.Failover.active() then
        SRP.SQL.execute('DELETE FROM srp_characters WHERE id = ?', { id })
    end
    return { deleted = true }
end

return Base
