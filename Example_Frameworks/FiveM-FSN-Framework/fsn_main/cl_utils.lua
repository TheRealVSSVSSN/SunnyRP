local Util = {}
_G.Util = Util

local function dump(v)
    if type(v) == 'table' then
        return json.encode(v)
    end
    return tostring(v)
end

function Util.Tick(f, ms)
    CreateThread(function()
        while true do
            f()
            Wait(ms or 0)
        end
    end)
end

function Util.Repeat(f, s)
    CreateThread(function()
        local start = GetGameTimer()
        local ms = s * 1000
        while true do
            Wait(0)
            if start + ms <= GetGameTimer() then
                f()
            else
                break
            end
        end
    end)
end

function Util.CreateBlip(name, sprite, color, xyz, range)
    local blip = AddBlipForCoord(xyz[1], xyz[2], xyz[3])
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, range)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
    return blip
end

Color = {}
Color.White = {255,255,255,255}

function Util.SpawnVehicle(hash, xyzh)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end
    local veh = CreateVehicle(hash, xyzh[1], xyzh[2], xyzh[3], xyzh[4], true, false)
    SetModelAsNoLongerNeeded(hash)
    return veh
end

function Util.DrawText(text, font, center, x, y, scale, col)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextColour(col[1], col[2], col[3], col[4])
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(center)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function Util.DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if not onScreen then return end
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = string.len(text) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end

function Util.FormatMoneyString(amt)
    if exports["fsn_main"]:fsn_CanAfford(amt) then
        return '(~g~$' .. amt .. '~w~)'
    else
        return '(~r~$' .. amt .. '~w~)'
    end
end

function Util.GetPlayers()
    local players = {}
    for i = 0, 256 do
        if NetworkIsPlayerActive(i) then
            players[#players+1] = i
        end
    end
    return players
end

function Util.PrependTable(t, v)
    if type(t) ~= 'table' or v == nil then return end
    local newt = {v}
    for i = 1, #t do
        newt[i+1] = t[i]
    end
    return newt
end

function Util.PrintTable(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. '['..k..'] = ' .. dump(v) .. ','
        end
        return s .. '} '
    end
    return tostring(o)
end

function Util.TableHasValue(tbl, element)
    for _, value in pairs(tbl) do
        if value == element then
            return true
        end
    end
    return false
end

function Util.GetVecDist(v1, v2)
    if not v1 or not v2 then return 0 end
    return #(vector3(v1.x or 0, v1.y or 0, v1.z or 0) - vector3(v2.x or 0, v2.y or 0, v2.z or 0))
end

function Util.PositionCheck(playerPos, locations)
    local nearestDist, nearestPos
    for _, coords in ipairs(locations) do
        local curDist = Util.GetVecDist(playerPos, coords)
        if not nearestDist or curDist < nearestDist then
            nearestDist = curDist
            nearestPos = coords
        end
    end
    return nearestDist or false, nearestPos
end

function Util.GetClosestPlayer()
    local players = Util.GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed, false)

    for i = 1, #players do
        local targetPed = GetPlayerPed(players[i])
        if playerPed ~= targetPed then
            local targetCoords = GetEntityCoords(targetPed, false)
            local distance = #(playerPos - targetCoords)
            if closestDistance == -1 or distance < closestDistance then
                closestPlayer = players[i]
                closestDistance = distance
            end
        end
    end

    return closestPlayer, closestDistance
end

function Util.LoadAnimDict(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(1)
        end
    end
end

function Util.MakeString(length)
    if length < 1 then return nil end
    local str = ""
    for _ = 1, length do
        str = str .. math.random(32, 126)
    end
    return str
end

do
    local gc = {}
    function gc.__gc(p)
        if p.h then p.d(p.h) end
        p.h, p.n, p.d = nil
    end
    local function gen(p, ent)
        ent = ent ~= -1 and ent or nil
        return ent, ent and select(2, p.n(p.h)) or gc.__gc(p)
    end
    local function iterator(init, nxt, drop)
        local handle, ent = init()
        local param = setmetatable({h=handle, n=nxt, d=drop}, gc)
        return gen, param, ent
    end

    function Util.FindObjects()
        return iterator(FindFirstObject, FindNextObject, EndFindObject)
    end

    function Util.FindVehicles()
        return iterator(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
    end

    function Util.FindPickups()
        return iterator(FindFirstPickup, FindNextPickup, EndFindPickup)
    end
end

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

function Util.GetKeyNumber(key)
    return Keys[key]
end

return Util
