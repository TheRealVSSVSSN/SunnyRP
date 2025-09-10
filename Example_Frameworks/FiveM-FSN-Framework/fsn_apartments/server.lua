local apartments = {
    [1] = {occupied=false, inst=0},
    [2] = {occupied=false, inst=0},
    [3] = {occupied=false, inst=0},
    [4] = {occupied=false, inst=0},
    [5] = {occupied=false, inst=0},
    [6] = {occupied=false, inst=0},
    [7] = {occupied=false, inst=0},
    [8] = {occupied=false, inst=0},
    [9] = {occupied=false, inst=0},
    [10] = {occupied=false, inst=0},
    [11] = {occupied=false, inst=0},
    [12] = {occupied=false, inst=0},
    [13] = {occupied=false, inst=0},
    [14] = {occupied=false, inst=0},
    [15] = {occupied=false, inst=0},
    [16] = {occupied=false, inst=0},
    [17] = {occupied=false, inst=0},
    [18] = {occupied=false, inst=0},
    [19] = {occupied=false, inst=0},
    [20] = {occupied=false, inst=0},
    [21] = {occupied=false, inst=0},
    [22] = {occupied=false, inst=0},
    [23] = {occupied=false, inst=0},
    [24] = {occupied=false, inst=0},
    [25] = {occupied=false, inst=0},
    [26] = {occupied=false, inst=0},
    [27] = {occupied=false, inst=0},
    [28] = {occupied=false, inst=0},
    [29] = {occupied=false, inst=0},
    [30] = {occupied=false, inst=0},
    [31] = {occupied=false, inst=0},
    [32] = {occupied=false, inst=0},
    [33] = {occupied=false, inst=0},
    [34] = {occupied=false, inst=0},
    [35] = {occupied=false, inst=0},
    [36] = {occupied=false, inst=0},
    [37] = {occupied=false, inst=0},
    [38] = {occupied=false, inst=0},
    [39] = {occupied=false, inst=0},
    [40] = {occupied=false, inst=0},
    [41] = {occupied=false, inst=0},
    [42] = {occupied=false, inst=0},
    [43] = {occupied=false, inst=0},
    [44] = {occupied=false, inst=0},
    [45] = {occupied=false, inst=0},
    [46] = {occupied=false, inst=0},
    [47] = {occupied=false, inst=0},
    [48] = {occupied=false, inst=0},
    [49] = {occupied=false, inst=0},
    [50] = {occupied=false, inst=0},
    [51] = {occupied=false, inst=0}
}

local function getAvailableAppt(src)
    for k, v in pairs(apartments) do
        if not v.occupied then
            print(k..' is not owned, giving to '..src)
            v.occupied = true
            v.owner = src
            return k
        elseif v.owner == src then
            print(src..' already owns '..k)
            return k
        end
    end
end

RegisterNetEvent('fsn_apartments:getApartment')
AddEventHandler('fsn_apartments:getApartment', function(char_id)
    local src = source
    MySQL.Async.fetchAll('SELECT * FROM `fsn_apartments` WHERE `apt_owner` = @owner', {
        ['@owner'] = char_id
    }, function(appt)
        if appt[1] then
            local mynum = getAvailableAppt(src)
            local sendappt = {
                number = mynum,
                apptinfo = appt[1]
            }
            TriggerClientEvent('fsn_apartments:sendApartment', src, sendappt)
        else
            TriggerClientEvent('fsn_apartments:characterCreation', src)
        end
    end)
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    for k, v in pairs(apartments) do
        if v.owner == src then
            print(src..' disconnected('..reason..') setting appt '..k..' to unoccupied')
            v.occupied = false
            v.owner = nil
        end
    end
end)

RegisterNetEvent('fsn_apartments:createApartment')
AddEventHandler('fsn_apartments:createApartment', function(char_id)
    local src = source
    print('creating new appt for '..char_id)
    MySQL.Async.execute('INSERT INTO `fsn_apartments` (`apt_owner`, `apt_inventory`, `apt_cash`, `apt_outfits`, `apt_utils`) VALUES (@owner, @inv, @cash, @outfits, @utils)', {
        ['@owner'] = char_id,
        ['@inv'] = '{}',
        ['@cash'] = 0,
        ['@outfits'] = '{}',
        ['@utils'] = '{}'
    }, function()
        MySQL.Async.fetchAll('SELECT * FROM `fsn_apartments` WHERE `apt_owner` = @owner', {
            ['@owner'] = char_id
        }, function(appt)
            if appt[1] then
                local mynum = getAvailableAppt(src)
                local myappt = appt[1]
                local sendappt = {
                    number = mynum,
                    apptinfo = {
                        apt_id = myappt.apt_id,
                        apt_inventory = myappt.apt_inventory,
                        apt_cash = myappt.apt_cash,
                        apt_outfits = myappt.apt_outfits,
                        apt_utils = myappt.apt_utils
                    }
                }
                TriggerClientEvent('fsn_apartments:sendApartment', src, sendappt)
                print('sending appt '..myappt.apt_id..' to '..char_id)
            end
        end)
    end)
end)

RegisterNetEvent('fsn_apartments:saveApartment')
AddEventHandler('fsn_apartments:saveApartment', function(appt)
    MySQL.Async.execute('UPDATE `fsn_apartments` SET `apt_inventory` = @inv, `apt_cash` = @cash, `apt_outfits` = @outfits, `apt_utils` = @utils WHERE `apt_id` = @id', {
        ['@id'] = appt.apt_id,
        ['@inv'] = json.encode(appt.apt_inventory),
        ['@cash'] = tonumber(appt.apt_cash),
        ['@outfits'] = json.encode(appt.apt_outfits),
        ['@utils'] = json.encode(appt.apt_utils)
    })
end)

-- Commands
RegisterCommand('stash', function(source, args)
    local action = args[1]
    local amount = tonumber(args[2])
    if action == 'add' and amount then
        TriggerClientEvent('fsn_apartments:stash:add', source, amount)
    elseif action == 'take' and amount then
        TriggerClientEvent('fsn_apartments:stash:take', source, amount)
    else
        TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^*:FSN:^0^r Usage: /stash {add|take} amount')
    end
end, false)

RegisterCommand('outfit', function(source, args)
    local action = args[1]
    local key = args[2]
    if action == 'add' and key then
        TriggerClientEvent('fsn_apartments:outfit:add', source, key)
    elseif action == 'use' and key then
        TriggerClientEvent('fsn_apartments:outfit:use', source, key)
    elseif action == 'remove' and key then
        TriggerClientEvent('fsn_apartments:outfit:remove', source, key)
    elseif action == 'list' then
        TriggerClientEvent('fsn_apartments:outfit:list', source)
    else
        TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1^*:FSN:^0^r Usage: /outfit {add|use|remove|list} name')
    end
end, false)

