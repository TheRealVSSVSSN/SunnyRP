RegisterNetEvent('carhud:sessionCheck')
AddEventHandler('carhud:sessionCheck', function(clientPlayerNumber, name, id)
    local serverPlayerNumber = #GetPlayers()
    if clientPlayerNumber < serverPlayerNumber and clientPlayerNumber == 1 then
        local reason = 'Auto-Kick session solo detected'
        local msg = string.format('%s KICKED, SERVER SEE: %d PLAYERS, CLIENT SEE: %d PLAYERS', name, serverPlayerNumber, clientPlayerNumber)
        print('AUTOKICK: ' .. msg)
        TriggerClientEvent('chatMessage', -1, 'Server', {0, 153, 255}, '^2'..name..' ^0(^4'..id..'^0) ^1was kicked: ^2'..reason)
        DropPlayer(id, reason)
    end
end)
