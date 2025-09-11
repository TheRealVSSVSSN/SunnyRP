--[[
    -- Type: Client Script
    -- Name: client.lua
    -- Use: Handles evidence locker interactions on the client
    -- Created: 2024-06-06
    -- By: VSSVSSN
]]

local menuEnabled = false
local lastClick = 0

--[[
    -- Type: Function
    -- Name: ToggleActionMenu
    -- Use: Toggles the evidence locker NUI
    -- Created: 2024-06-06
    -- By: VSSVSSN
]]
local function ToggleActionMenu()
    menuEnabled = not menuEnabled
    SetNuiFocus(menuEnabled, menuEnabled)
    SetNuiFocusKeepInput(menuEnabled)
    SendNUIMessage({
        showmenu = menuEnabled,
        hidemenu = not menuEnabled
    })
end

--[[
    -- Type: Function
    -- Name: KeyboardInput
    -- Use: Prompts player for text input via onscreen keyboard
    -- Created: 2024-06-06
    -- By: VSSVSSN
]]
local function KeyboardInput(prompt)
    AddTextEntry('FMMC_KEY_TIP1', prompt)
    DisplayOnscreenKeyboard(1, 'FMMC_KEY_TIP1', '', '', '', '', '', 200)
    while UpdateOnscreenKeyboard() == 0 do
        Wait(0)
    end
    local result = GetOnscreenKeyboardResult()
    if result and result ~= '' then
        return result
    end
    return nil
end

--[[
    -- Type: Callback
    -- Name: ButtonClick
    -- Use: Handles NUI button interactions
    -- Created: 2024-06-06
    -- By: VSSVSSN
]]
RegisterNUICallback('ButtonClick', function(data, cb)
    if GetGameTimer() - lastClick < 1000 then
        cb('wait')
        return
    end
    lastClick = GetGameTimer()

    if data == 'locker-deposit' then
        local evidence = KeyboardInput('Describe Evidence')
        if evidence then
            TriggerServerEvent('fsn_storagelockers:deposit', evidence)
        end
    elseif data == 'inventory' then
        TriggerServerEvent('fsn_storagelockers:request')
    elseif data == 'exit' then
        ToggleActionMenu()
    end
    cb('ok')
end)

--[[
    -- Type: Event
    -- Name: fsn_storagelockers:sendItems
    -- Use: Updates NUI with current locker contents
    -- Created: 2024-06-06
    -- By: VSSVSSN
]]
RegisterNetEvent('fsn_storagelockers:sendItems', function(items)
    SendNUIMessage({inventory = items})
end)

--[[
    -- Type: Command
    -- Name: locker
    -- Use: Opens the evidence locker menu
    -- Created: 2024-06-06
    -- By: VSSVSSN
]]
RegisterCommand('locker', function()
    ToggleActionMenu()
    TriggerServerEvent('fsn_storagelockers:request')
end, false)

