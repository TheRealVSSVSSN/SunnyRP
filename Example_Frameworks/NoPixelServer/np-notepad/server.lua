--[[
    -- Type: Server Script
    -- Name: np-notepad/server.lua
    -- Use: Manages notepad storage and distribution to clients
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]

local serverNotes = {}

RegisterNetEvent('server:destroyNote', function(id)
    if serverNotes[id] then
        table.remove(serverNotes, id)
        TriggerClientEvent('client:updateNotesRemove', -1, id)
    end
end)

RegisterNetEvent('server:newNote', function(text, x, y, z)
    if type(text) ~= 'string' then return end
    text = text:sub(1, 500)
    local note = { text = text, x = x, y = y, z = z }
    serverNotes[#serverNotes + 1] = note
    TriggerClientEvent('client:updateNotesAdd', -1, note)
end)

RegisterNetEvent('server:requestNotes', function()
    TriggerClientEvent('client:updateNotes', source, serverNotes)
end)

RegisterCommand('notepad', function(src)
    TriggerClientEvent('Notepad:open', src)
end)
