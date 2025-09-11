local instances = {}

RegisterNetEvent('fsn_apartments:instance:leave')
RegisterNetEvent('fsn_apartments:instance:new')
RegisterNetEvent('fsn_apartments:instance:join')

AddEventHandler('fsn_apartments:instance:leave', function()
    local src = source
    for k, v in pairs(instances) do
        for key, value in pairs(v.players) do
            if value == src then
                instances[k].players[key] = nil
                TriggerClientEvent('fsn_apartments:instance:leave', src)
                print(src..' has left instance '..k)
                for _, pl in pairs(v.players) do
                    TriggerClientEvent('fsn_apartments:instance:update', pl, instances[k])
                end
                if #instances[k].players == 0 then
                    instances[k] = nil
                end
            end
        end
    end
end)

AddEventHandler('fsn_apartments:instance:new', function()
    local src = source
    print(src..' is creating a new instance')
    for _, v in pairs(instances) do
        if table.contains(v.players, src) then
            TriggerClientEvent('chatMessage', src, '', {255,255,255}, '^1^*:fsn_apartments:^0^r You are already in an instance.')
            return
        end
    end
    local ins_id = #instances + 1
    instances[ins_id] = {
        id = ins_id,
        players = {src},
        created = os.time()
    }
    TriggerClientEvent('fsn_apartments:instance:join', src, instances[ins_id])
end)

AddEventHandler('fsn_apartments:instance:join', function(id)
    local src = source
    for _, v in pairs(instances) do
        if table.contains(v.players, src) then
            TriggerClientEvent('chatMessage', src, '', {255,255,255}, '^1^*:fsn_apartments:^0^r You are already in an instance.')
            return
        end
    end

    if instances[id] then
        table.insert(instances[id].players, src)
        for _, pl in pairs(instances[id].players) do
            TriggerClientEvent('fsn_apartments:instance:update', pl, instances[id])
        end
        TriggerClientEvent('fsn_apartments:instance:join', src, instances[id])
    else
        TriggerClientEvent('chatMessage', src, '', {255,255,255}, '^1^*:fsn_apartments:^0^r This instance does not exist.')
    end
end)

function table.contains(tbl, element)
    for _, value in pairs(tbl) do
        if value == element then
            return true
        end
    end
    return false
end

