local vendingMachines = {
    {model = -742198632, price = 2, relief = 15, label = 'water'},
    {model = 690372739, price = 3, relief = 17, label = 'coffee'}
}

CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        for _, machine in ipairs(vendingMachines) do
            local obj = GetClosestObjectOfType(playerCoords, 1.0, machine.model, false, false, false)
            if obj ~= 0 then
                BeginTextCommandDisplayHelp('STRING')
                AddTextComponentSubstringPlayerName(('Press ~INPUT_PICKUP~ to drink ~b~%s~w~ ($%d)'):format(machine.label, machine.price))
                EndTextCommandDisplayHelp(0, false, true, -1)
                if IsControlJustPressed(0, 38) then
                    TriggerEvent('fsn_inventory:use:drink', machine.relief)
                    TriggerEvent('fsn_bank:change:walletMinus', machine.price)
                    Wait(1000)
                end
            end
        end
    end
end)

