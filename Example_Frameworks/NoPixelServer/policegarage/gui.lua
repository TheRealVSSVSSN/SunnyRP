-- Credit : Ideo
-- Credit : Ideo

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}



local Menu = {
    GUI = {},
    buttonCount = 0,
    selection = 0,
    hidden = true,
    title = "Menu"
}

local function menuCallFunction(fnc, arg)
    if fnc and _G[fnc] then
        _G[fnc](arg)
    end
end

function Menu.addButton(name, func, args)
    local yoffset, xoffset = 0.3, 0.0
    local xmin, xmax = 0.0, 0.2
    local ymin, ymax = 0.05, 0.05

    Menu.GUI[Menu.buttonCount + 1] = {
        name = name,
        func = func,
        args = args,
        active = false,
        xmin = xmin + xoffset,
        ymin = ymin * (Menu.buttonCount + 0.01) + yoffset,
        xmax = xmax,
        ymax = ymax
    }
    Menu.buttonCount = Menu.buttonCount + 1
end


function Menu.updateSelection()
    if IsControlJustPressed(1, Keys["DOWN"]) then
        if Menu.selection < Menu.buttonCount - 1 then
            Menu.selection = Menu.selection + 1
        else
            Menu.selection = 0
        end
    elseif IsControlJustPressed(1, Keys["TOP"]) then
        if Menu.selection > 0 then
            Menu.selection = Menu.selection - 1
        else
            Menu.selection = Menu.buttonCount - 1
        end
    elseif IsControlJustPressed(1, Keys["NENTER"]) then
        menuCallFunction(Menu.GUI[Menu.selection + 1].func, Menu.GUI[Menu.selection + 1].args)
    end

    for index = 1, Menu.buttonCount do
        Menu.GUI[index].active = index - 1 == Menu.selection
    end
end

function Menu.renderGUI()
    if not Menu.hidden then
        Menu.renderButtons()
        Menu.updateSelection()
    end
end

function Menu.renderBox(xMin, xMax, yMin, yMax, color1, color2, color3, color4)
    DrawRect(xMin, yMin, xMax, yMax, color1, color2, color3, color4)
end

function Menu.renderButtons()
    local yoffset, xoffset = 0.3, 0.0

    SetTextFont(0)
    SetTextScale(0.0, 0.35)
    SetTextColour(135, 206, 250, 255)
    SetTextCentre(true)
    SetTextDropShadow(0, 0, 0, 0, 0)
    SetTextEdge(0, 0, 0, 0, 0)
    SetTextEntry("STRING")
    AddTextComponentString(string.upper(Menu.title))
    DrawText((xoffset + 0.05), (yoffset - 0.05 - 0.0125))
    Menu.renderBox(xoffset, 0.2, (yoffset - 0.05), 0.05, 0, 0, 0, 215)

    for _, settings in ipairs(Menu.GUI) do
        local boxColor = {0, 0, 0, 150}
        if settings.active then
            boxColor = {135, 206, 250, 200}
        end
        SetTextFont(0)
        SetTextScale(0.0, 0.35)
        SetTextColour(255, 255, 255, 255)
        SetTextCentre(true)
        SetTextDropShadow(0, 0, 0, 0, 0)
        SetTextEdge(0, 0, 0, 0, 0)
        SetTextEntry("STRING")
        AddTextComponentString(settings.name)
        DrawText(settings.xmin + 0.05, settings.ymin - 0.0125)
        Menu.renderBox(settings.xmin, settings.xmax, settings.ymin, settings.ymax, boxColor[1], boxColor[2], boxColor[3], boxColor[4])
    end
end


--------------------------------------------------------------------------------------------------------------------

function ClearMenu()
    Menu.GUI = {}
    Menu.buttonCount = 0
    Menu.selection = 0
end

--------------------------------------------------------------------------------------------------------------------
