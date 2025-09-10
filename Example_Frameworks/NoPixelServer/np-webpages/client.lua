--[[
    -- Type: Function
    -- Name: openCalc
    -- Use: Displays the calculator NUI and focuses input
    -- Created: 2024-05-14
    -- By: VSSVSSN
--]]
local function openCalc()
    SendNUIMessage({ openSection = 'calculator' })
    SetNuiFocus(true, true)
end

--[[
    -- Type: Function
    -- Name: closeCalc
    -- Use: Hides the calculator NUI and releases focus
    -- Created: 2024-05-14
    -- By: VSSVSSN
--]]
local function closeCalc()
    SetNuiFocus(false, false)
    SendNUIMessage({ openSection = 'close' })
end

RegisterNUICallback('close', function(_, cb)
    closeCalc()
    if cb then cb('ok') end
end)

RegisterCommand('calculator', function()
    openCalc()
end, false)

RegisterNetEvent('openCalculator')
AddEventHandler('openCalculator', openCalc)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        SetNuiFocus(false, false)
    end
end)

