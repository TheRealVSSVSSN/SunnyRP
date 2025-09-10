--[[
    -- Type: GUI Handler
    -- Name: ToggleActionMenu
    -- Use: Handles opening and closing of the tattoo NUI
    -- Created: 2024-04-22
    -- By: VSSVSSN
--]]

local menuEnabled = false

function ToggleActionMenu()
    menuEnabled = not menuEnabled
    if menuEnabled then
        SetNuiFocus(true, true)
        SendNUIMessage({ showmenu = true })
    else
        SetNuiFocus(false, false)
        SendNUIMessage({ hidemenu = true })
    end
end

local function splitString(inputstr, sep)
    sep = sep or "%s"
    local t, i = {}, 1
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

RegisterNUICallback("ButtonClick", function(data, cb)
    if data == "exit" then
        ToggleActionMenu()
        ExitTattooStore()
    else
        local split = splitString(data, '-')
        if split[1] == 'tattoos' then
            if split[2] == 'cat' then
                if split[3] == 'next' then
                    NextCategory()
                elseif split[3] == 'back' then
                    BackCategory()
                end
            elseif split[2] == 'tat' then
                if split[3] == 'back' then
                    PreviousTattoo()
                elseif split[3] == 'buy' then
                    PurchaseTattoo()
                    ToggleActionMenu()
                    ExitTattooStore()
                elseif split[3] == 'next' then
                    NextTattoo()
                end
            end
        end
    end
    cb('ok')
end)
