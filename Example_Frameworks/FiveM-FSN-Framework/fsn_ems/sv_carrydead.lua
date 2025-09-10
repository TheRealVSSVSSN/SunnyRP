local carryState = {}

RegisterNetEvent('fsn_ems:carry:start', function(target)
    if carryState[source] or carryState[target] then return end
    carryState[source] = true
    carryState[target] = true
    TriggerClientEvent('fsn_ems:carry:start', source, target)
    TriggerClientEvent('fsn_ems:carried:start', target, source)
end)

RegisterNetEvent('fsn_ems:carry:end', function(target)
    if not carryState[source] or not carryState[target] then return end
    carryState[source] = nil
    carryState[target] = nil
    TriggerClientEvent('fsn_ems:carry:end', source, target)
    TriggerClientEvent('fsn_ems:carried:end', target, source)
end)

