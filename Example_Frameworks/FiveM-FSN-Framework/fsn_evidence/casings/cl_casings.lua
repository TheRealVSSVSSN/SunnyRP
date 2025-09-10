local currentWeapon

--[[
    -- Type: Event Handler
    -- Name: fsn_evidence:weaponInfo
    -- Use: Stores weapon information for casing drops
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_evidence:weaponInfo', function(weapon)
    if weapon then
        currentWeapon = weapon
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        if IsPedShooting(PlayerPedId()) and exports['fsn_criminalmisc']:HoldingWeapon() and not exports['fsn_police']:fsn_PDDuty() then
            local pos = GetEntityCoords(PlayerPedId())
            if currentWeapon then
                TriggerServerEvent('fsn_evidence:drop:casing', currentWeapon, pos)
            end
            Wait(currentWeapon and currentWeapon.isAuto and 500 or 1000)
        end
    end
end)

