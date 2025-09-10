function fsn_SplitString(inputstr, sep)
    if not sep then sep = "%s" end
    local t, i = {}, 1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

AddEventHandler('chatMessage', function(source, auth, msg)
    local split = fsn_SplitString(string.lower(msg), ' ')
    if split[1] == '/inv' then
        TriggerClientEvent('fsn_inventory:gui:display', source)
    end
end)

RegisterNetEvent('fsn_inventory:sys:request', function(to, from)
    TriggerClientEvent('fsn_inventory:ply:request', to, from)
end)

RegisterNetEvent('fsn_inventory:sys:send', function(to, tbl)
    print(('got inventory from %s for %s'):format(source, to))
    TriggerClientEvent('fsn_inventory:ply:recieve', to, source, tbl)
end)

RegisterNetEvent('fsn_inventory:ply:update', function(to, tbl)
    TriggerClientEvent('fsn_inventory:me:update', to, tbl)
end)

RegisterNetEvent('fsn_inventory:ply:finished', function(ply)
    TriggerClientEvent('fsn_inventory:ply:done', ply)
end)

RegisterNetEvent('fsn_licenses:id:display', function(plytbl, name, job, dob, issue, id)
    for _, ply in pairs(plytbl) do
        TriggerClientEvent('chatMessage', ply, '', {0,0,0}, '^6*----------------------------------------------------------')
        TriggerClientEvent('chatMessage', ply, '', {0,0,0}, '^6| ID |^0 '..name..' | '..job..' | '..dob..'/dob | '..issue..'/issue')
        if id then
            TriggerClientEvent('chatMessage', ply, '', {0,0,0}, '^6| ID |^0 CharID: '..id..' | ServerID: '..source)
        else
            TriggerClientEvent('chatMessage', ply, '', {0,0,0}, '^6| ID |^0 ServerID: '..source)
            TriggerClientEvent('chatMessage', ply, '', {0,0,0}, '^6| ID |^0 This ID is invalid, get a new one from City Hall!')
        end
        TriggerClientEvent('chatMessage', ply, '', {0,0,0}, '^6*----------------------------------------------------------')
    end
end)

local function fsn_setDevWeapon(user, item)
    local charID = exports['fsn_main']:fsn_CharID(user)
    local character = exports['fsn_main']:fsn_GetCharacterInfo(charID)
    if item.customData and (item.index == 'weapon_stungun' or item.customData.ammotype ~= 'none') then
        local name = character.char_fname .. ' ' .. character.char_lname
        item.customData.Serial = 'DEV GUN'
        item.customData.Owner = 'DEV: ' .. name
    end
end

RegisterNetEvent('fsn_inventory:item:add', function(item, amt)
    local player = source
    amt = tonumber(amt) or 1
    if presetItems[item] then
        local insert = presetItems[item]
        insert.amt = amt
        if insert.customData and insert.customData.weapon == 'true' then
            fsn_setDevWeapon(player, insert)
        end
        TriggerClientEvent('fsn_inventory:items:add', player, insert)
    else
        TriggerClientEvent('mythic_notify:SendAlert', player, { type = 'error', text = ('Item preset %s seems to be missing'):format(item) })
    end
end)

