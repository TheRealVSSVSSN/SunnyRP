local currentFires = {}

RegisterNetEvent('thermite:StartClientFires')
AddEventHandler('thermite:StartClientFires', function(x, y, z, arg1, arg2)
    if #(vector3(x, y, z) - GetEntityCoords(PlayerPedId())) < 100.0 then
        local fire = StartScriptFire(x, y, z, arg1, arg2)
        currentFires[#currentFires + 1] = fire
    end
end)

RegisterNetEvent('thermite:StopFiresClient')
AddEventHandler('thermite:StopFiresClient', function()
    for _, fire in ipairs(currentFires) do
        RemoveScriptFire(fire)
    end
    currentFires = {}
end)

local function randomFloat(min, max, precision)
    local range = max - min
    local offset = range * math.random()
    local unrounded = min + offset

    if not precision then
        return unrounded
    end

    local powerOfTen = 10 ^ precision
    return math.floor(unrounded * powerOfTen + 0.5) / powerOfTen
end

local function startFireAtLocation(x, y, z, time)
    local rand = math.random(7, 11)

    for _ = 1, rand do
        local randy = randomFloat(0, 0.4, 5)
        local randx = randomFloat(0, 0.4, 5)

        if math.random(1, 2) == 2 then
            y = y + randy
        else
            y = y - randy
        end

        if math.random(1, 2) == 2 then
            x = x + randx
        else
            x = x - randx
        end

        TriggerServerEvent('thermite:StartFireAtLocation', x, y, z, 24, false)
    end

    Citizen.Wait(time)
    TriggerServerEvent('thermite:StopFires')
end

local currentlyInGame, passed = false, false
local gui = false

local function openGui()
    gui = true
    SetNuiFocus(true, true)
    SendNUIMessage({ openPhone = true })
end

local function play(dropAmount, letter, speed, inter)
    SendNUIMessage({ openSection = 'playgame', amount = dropAmount, letterSet = letter, speed = speed, interval = inter })
end

local function CloseGui()
    currentlyInGame = false
    gui = false
    SetNuiFocus(false, false)
    SendNUIMessage({ openPhone = false })
end

local function startGame(dropAmount, letter, speed, inter)
    openGui()
    play(dropAmount, letter, speed, inter)
    currentlyInGame = true
    while currentlyInGame do
        Citizen.Wait(400)
        if exports['isPed']:isPed('dead') then
            CloseGui()
        end
    end
    return passed
end

-- NUI Callback Methods
RegisterNUICallback('close', function(_, cb)
    CloseGui()
    cb('ok')
end)

RegisterNUICallback('failure', function(_, cb)
    passed = false
    CloseGui()
    cb('ok')
end)

RegisterNUICallback('complete', function(_, cb)
    passed = true
    CloseGui()
    cb('ok')
end)

exports('startFireAtLocation', startFireAtLocation)
exports('startGame', startGame)

