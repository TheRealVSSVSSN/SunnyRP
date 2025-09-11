--[[
    -- Type: Module
    -- Name: fsn_criminalmisc client utilities
    -- Use: Common helpers for criminal miscellaneous features
    -- Created: 2025-02-15
    -- By: VSSVSSN
--]]

function HasHandcuffs()
    return exports.fsn_inventory:fsn_HasItem('zipties')
end

function drawTxt(text, font, centre, x, y, scale, r, g, b, a)
    SetTextFont(font)
    SetTextProportional(false)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(centre)
    SetTextEntry('STRING')
    AddTextComponentString(text)
    DrawText(x, y)
end

function fsn_drawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.3, 0.3)
        SetTextFont(0)
        SetTextProportional(true)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry('STRING')
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

function showLoadingPrompt(showText, showTime, showType)
    CreateThread(function()
        Wait(0)
        BeginTextCommandBusyString('STRING')
        AddTextComponentSubstringPlayerName(showText)
        EndTextCommandBusyString(showType)
        Wait(showTime)
        RemoveLoadingPrompt()
    end)
end

myTime = 0
CreateThread(function()
    while true do
        Wait(1000)
        myTime = myTime + 1
    end
end)
