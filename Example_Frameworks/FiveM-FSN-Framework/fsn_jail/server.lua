--[[
    -- Type: Server Script
    -- Name: fsn_jail server
    -- Use: Handles jail related server events and database interaction
    -- Created: 2024-04-21
    -- By: VSSVSSN
--]]

local currentCharacters = {}

AddEventHandler('fsn_main:updateCharacters', function(tbl)
    currentCharacters = tbl
end)

RegisterNetEvent('fsn_jail:spawn', function(charId)
    local src = source
    MySQL.Async.fetchScalar('SELECT char_jailtime FROM fsn_characters WHERE char_id = @id', {['@id'] = charId}, function(time)
        time = tonumber(time) or 0
        print(('%s has %s left in jail'):format(charId, time))
        TriggerClientEvent('fsn_jail:spawn:receive', src, time)
    end)
end)

RegisterNetEvent('fsn_jail:sendsuspect', function(copId, targetId, time)
    local charId
    for _, v in pairs(currentCharacters) do
        if v.ply_id == targetId then
            charId = v.char_id
            break
        end
    end
    if not charId then return end
    MySQL.Async.execute('UPDATE fsn_characters SET char_jailtime = @time WHERE char_id = @char', {
        ['@time'] = time,
        ['@char'] = charId
    })
    TriggerClientEvent('pNotify:SendNotification', copId, {
        text = 'You jailed '..targetId..' for '..math.floor(time/60)..' mins.',
        layout = 'centerRight',
        timeout = 300,
        progressBar = true,
        type = 'success'
    })
    TriggerClientEvent('fsn_jail:spawn:receive', targetId, time)
end)

RegisterNetEvent('fsn_jail:update:database', function(time)
    local src = source
    local charId
    for _, v in pairs(currentCharacters) do
        if v.ply_id == src then
            charId = v.char_id
            break
        end
    end
    if not charId then return end
    MySQL.Async.execute('UPDATE fsn_characters SET char_jailtime = @time WHERE char_id = @char', {
        ['@time'] = time,
        ['@char'] = charId
    })
    TriggerClientEvent('pNotify:SendNotification', src, {
        text = 'Jailtime updated to '..time,
        layout = 'centerRight',
        timeout = 300,
        progressBar = true,
        type = 'success'
    })
end)

-- compatibility with old misspelled client event
RegisterNetEvent('fsn_jail:spawn:recieve', function(charId)
    TriggerEvent('fsn_jail:spawn', charId)
end)
