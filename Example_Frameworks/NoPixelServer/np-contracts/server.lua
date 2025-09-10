--[[
    -- Type: Server Script
    -- Name: np-contracts server
    -- Use: Handles contract storage and transactions
    -- Created: 2024-01-21
    -- By: VSSVSSN
--]]

RegisterNetEvent('server:contractsend', function(targetId, amount, info)
    local src = source
    local sender = exports['np-base']:getModule('Player'):GetUser(src)
    local recipient = exports['np-base']:getModule('Player'):GetUser(targetId)

    if not sender or not recipient then
        TriggerClientEvent('DoLongHudText', src, 'Invalid citizen.', 2)
        return
    end

    local price = tonumber(amount)
    if not price then
        TriggerClientEvent('DoLongHudText', src, 'Invalid contract amount.', 2)
        return
    end

    local senderChar = sender:getCurrentCharacter()
    local recipientChar = recipient:getCurrentCharacter()

    TriggerClientEvent('contract:requestaccept', recipient.source, price, info, src)

    local insert = [[INSERT INTO contracts (sender, reciever, amount, info, paid) VALUES (?, ?, ?, ?, ?)]]
    MySQL.insert(insert, { senderChar.id, recipientChar.id, price, info, 0 })
end)

RegisterNetEvent('contract:accept', function(price, strg, targetId, accepted)
    local src = source
    local sender = exports['np-base']:getModule('Player'):GetUser(src)
    local target = exports['np-base']:getModule('Player'):GetUser(targetId)

    if not sender or not target then
        TriggerClientEvent('DoLongHudText', src, 'Invalid citizen.', 2)
        return
    end

    local amount = tonumber(price) or 0
    local senderChar = sender:getCurrentCharacter()
    local targetChar = target:getCurrentCharacter()

    if accepted then
        if sender:getCash() >= amount then
            sender:removeMoney(amount)
            target:addMoney(amount)
            TriggerClientEvent('DoLongHudText', target.source, ('The citizen accepted your contract and paid $%s.'):format(amount), 1)
            local update = [[UPDATE contracts SET paid = ? WHERE sender = ? AND reciever = ?]]
            MySQL.update(update, { true, senderChar.id, targetChar.id })
        else
            TriggerClientEvent('DoLongHudText', src, "You don't have enough money.", 2)
        end
    else
        TriggerClientEvent('DoLongHudText', target.source, 'The citizen denied your contract.', 2)
    end
end)

