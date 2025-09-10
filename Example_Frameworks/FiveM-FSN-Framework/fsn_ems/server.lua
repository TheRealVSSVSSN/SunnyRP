local ondutyEMS = {}

RegisterNetEvent('fsn_ems:onDuty', function(level)
    if level > 2 then
        table.insert(ondutyEMS, {ply_id = source, ply_lvl = level})
        TriggerClientEvent('fsn_ems:update', -1, ondutyEMS)
        TriggerEvent('fsn_ems:update', ondutyEMS)
        print((':fsn_ems: %s has clocked on duty at level %s'):format(source, level))
    else
        print((':fsn_ems: %s has clocked in as police, but is not high enough level to contribute.'):format(source))
    end
end)

RegisterNetEvent('fsn_ems:offDuty', function()
    for k, v in pairs(ondutyEMS) do
        if v.ply_id == source then
            table.remove(ondutyEMS, k)
            print((':fsn_ems: %s has clocked out.'):format(source))
            break
        end
    end
    TriggerClientEvent('fsn_ems:update', -1, ondutyEMS)
    TriggerEvent('fsn_ems:update', ondutyEMS)
end)

AddEventHandler('playerDropped', function()
    for k, v in pairs(ondutyEMS) do
        if v.ply_id == source then
            table.remove(ondutyEMS, k)
            print((':fsn_ems: %s has clocked out and disconnected.'):format(source))
            break
        end
    end
    TriggerClientEvent('fsn_ems:update', -1, ondutyEMS)
end)

RegisterNetEvent('fsn_ems:requestUpdate', function()
    TriggerClientEvent('fsn_ems:update', source, ondutyEMS)
end)

