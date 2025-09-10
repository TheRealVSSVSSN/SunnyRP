CreateThread(function()
    Wait(300000)
    local id = GetPlayerServerId(PlayerId())
    while true do
        Wait(60000)
        local playerNumber = #GetActivePlayers()
        local name = GetPlayerName(PlayerId())
        TriggerServerEvent('carhud:sessionCheck', playerNumber, name, id)
    end
end)
