--[[
    -- Type: Resource
    -- Name: np-keys
    -- Use: Handles vehicle key ownership, transfer, and access logic on the client
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

--[[
    -- Type: Table
    -- Name: Keys
    -- Use: Stores owned plates and state for searches or hotwires
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local Keys = {
    owned = {},
    searched = {},
    hotwired = {},
    inAction = false,
    engineLockTimer = 0,
    towEnabled = false
}

--[[
    -- Type: Table
    -- Name: Controls
    -- Use: Holds key bindings for search and hotwire actions
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local Controls = {
    vehicleSearch = {47, "G"},
    vehicleHotwire = {74, "H"}
}

--[[
    -- Type: Function
    -- Name: addKey
    -- Use: Adds a vehicle plate to the player's owned keys
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function addKey(plate)
    if plate and plate ~= "" then
        Keys.owned[plate] = true
    end
end

--[[
    -- Type: Function
    -- Name: removeKey
    -- Use: Removes a vehicle plate from the player's owned keys
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function removeKey(plate)
    Keys.owned[plate] = nil
end

--[[
    -- Type: Function
    -- Name: hasKey
    -- Use: Checks if the player owns a key for the provided plate
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function hasKey(plate)
    return Keys.owned[plate] == true
end
exports('hasKey', hasKey)

--[[
    -- Type: Function
    -- Name: resetState
    -- Use: Clears all stored key and interaction data
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function resetState()
    Keys.owned = {}
    Keys.searched = {}
    Keys.hotwired = {}
    Keys.inAction = false
    Keys.engineLockTimer = 0
end

--[[
    -- Type: Function
    -- Name: getVehicleInDirection
    -- Use: Casts a ray to find the first vehicle in the player's direction
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function getVehicleInDirection(coordFrom, coordTo)
    local offset = 0
    local rayHandle
    local vehicle
    for i = 0, 100 do
        rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0)
        local _, _, _, _, veh = GetRaycastResult(rayHandle)
        vehicle = veh
        if vehicle ~= 0 then break end
        offset = offset - 1
    end
    if vehicle ~= 0 then
        local distance = #(coordFrom - GetEntityCoords(vehicle))
        if distance < 5.0 then return vehicle end
    end
    return nil
end

--[[
    -- Type: Function
    -- Name: drawText3D
    -- Use: Renders 3D text at a world coordinate
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function drawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 370
        DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
    end
end

--[[
    -- Type: Function
    -- Name: giveKeyToClosest
    -- Use: Gives keys of the current vehicle to the closest player
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function giveKeyToClosest()
    local ped = PlayerPedId()
    local coordA = GetEntityCoords(ped)
    local coordB = GetOffsetFromEntityInWorldCoords(ped, 0.0, 5.0, 0.0)
    local veh = getVehicleInDirection(coordA, coordB)
    if not veh or veh == 0 then
        TriggerEvent("DoLongHudText", "Vehicle not found!", 2)
        return
    end
    local plate = GetVehicleNumberPlateText(veh)
    if not hasKey(plate) then
        TriggerEvent("DoLongHudText", "No keys for target vehicle!", 2)
        return
    end
    local closestPlayer, distance = GetClosestPlayer()
    if distance ~= -1 and distance < 5.0 then
        TriggerServerEvent('keys:send', GetPlayerServerId(closestPlayer), plate)
        TriggerEvent("DoLongHudText", "You just gave keys to your vehicle!", 1)
    else
        TriggerEvent("DoLongHudText", "No player near you!", 2)
    end
end

--[[
    -- Type: Function
    -- Name: giveKeysToPassengers
    -- Use: Gives keys of the current vehicle to all passengers
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function giveKeysToPassengers()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh == 0 then
        TriggerEvent("DoLongHudText", "You are not in a vehicle!", 2)
        return
    end
    local plate = GetVehicleNumberPlateText(veh)
    if not hasKey(plate) then
        TriggerEvent("DoLongHudText", "No keys for target vehicle!", 2)
        return
    end
    for seat = -1, GetVehicleMaxNumberOfPassengers(veh) - 1 do
        local passenger = GetPedInVehicleSeat(veh, seat)
        if passenger ~= ped and passenger ~= 0 then
            for _, player in pairs(GetActivePlayers()) do
                if GetPlayerPed(player) == passenger then
                    TriggerServerEvent('keys:send', GetPlayerServerId(player), plate)
                end
            end
        end
    end
    TriggerEvent("DoLongHudText", "You just gave keys to your vehicle!", 1)
end

--[[
    -- Type: Function
    -- Name: searchVehicle
    -- Use: Attempts to find keys inside the current vehicle
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function searchVehicle()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsUsing(ped)
    if Keys.searched[veh] then return end
    Keys.searched[veh] = true
    Keys.inAction = true
    TriggerEvent("keys:shutoffengine")
    local finished = exports["np-taskbar"]:taskBar(5000, "Searching")
    if finished == 100 then
        if math.random(100) > 50 then
            local plate = GetVehicleNumberPlateText(veh)
            addKey(plate)
            TriggerEvent("DoLongHudText", "You found the keys.", 1)
        else
            TriggerEvent("DoLongHudText", "Nothing was found.", 2)
        end
    end
    Keys.inAction = false
end

--[[
    -- Type: Function
    -- Name: hotwireVehicle
    -- Use: Attempts to start the vehicle without keys
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function hotwireVehicle()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsUsing(ped)
    if Keys.hotwired[veh] then
        TriggerEvent("DoLongHudText", "You cannot work out this hotwire.", 2)
        return
    end
    Keys.hotwired[veh] = true
    Keys.inAction = true
    TriggerEvent("keys:shutoffengine")
    local carTimer = math.random(45000, 120000)
    local finished = exports["np-taskbar"]:taskBar(carTimer, "Attempting Hotwire")
    if finished == 100 and math.random(100) > 60 then
        SetVehicleEngineOn(veh, true, false, true)
        SetVehicleUndriveable(veh, false)
        addKey(GetVehicleNumberPlateText(veh))
        TriggerEvent("DoLongHudText", "You successfully hotwired the vehicle.", 1)
    else
        TriggerEvent("DoLongHudText", "You cannot work out this hotwire.", 2)
    end
    Keys.inAction = false
end

--[[
    -- Type: Function
    -- Name: engineControlLoop
    -- Use: Manages engine state based on key ownership
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function engineControlLoop()
    while true do
        Citizen.Wait(500)
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsUsing(ped)
            local plate = GetVehicleNumberPlateText(veh)
            if GetPedInVehicleSeat(veh, -1) == ped then
                if not hasKey(plate) then
                    SetVehicleEngineOn(veh, false, true, true)
                elseif Keys.engineLockTimer <= 0 then
                    SetVehicleEngineOn(veh, true, true, true)
                    SetVehicleUndriveable(veh, false)
                end
            end
            if Keys.engineLockTimer > 0 then
                Keys.engineLockTimer = Keys.engineLockTimer - 500
                SetVehicleEngineOn(veh, false, true, true)
            end
        end
    end
end
Citizen.CreateThread(engineControlLoop)

--[[
    -- Type: Event
    -- Name: garages:giveLoginKeys
    -- Use: Loads all keys owned by the player on login
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('garages:giveLoginKeys')
AddEventHandler('garages:giveLoginKeys', function(keys)
    for _, plate in ipairs(keys) do
        addKey(plate)
    end
end)

--[[
    -- Type: Event
    -- Name: keys:addNew
    -- Use: Adds a key for the provided vehicle
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('keys:addNew')
AddEventHandler('keys:addNew', function(veh, plate)
    plate = plate or (DoesEntityExist(veh) and GetVehicleNumberPlateText(veh))
    if plate then addKey(plate) end
    if veh and veh ~= 0 then
        SetVehRadioStation(veh, "OFF")
        SetVehicleDoorsLocked(veh, 1)
    end
end)

--[[
    -- Type: Event
    -- Name: keys:loadKey
    -- Use: Adds a key if not already owned
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('keys:loadKey')
AddEventHandler('keys:loadKey', function(plate)
    addKey(plate)
end)

--[[
    -- Type: Event
    -- Name: keys:remove
    -- Use: Removes a key for the provided plate
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('keys:remove')
AddEventHandler('keys:remove', function(plate)
    removeKey(plate)
end)

--[[
    -- Type: Event
    -- Name: keys:reset
    -- Use: Resets key and interaction state
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('keys:reset')
AddEventHandler('keys:reset', function()
    resetState()
end)

--[[
    -- Type: Event
    -- Name: keys:give
    -- Use: Gives keys of the closest vehicle to the nearest player
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('keys:give')
AddEventHandler('keys:give', giveKeyToClosest)

--[[
    -- Type: Event
    -- Name: keys:gives
    -- Use: Gives keys of the current vehicle to all passengers
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('keys:gives')
AddEventHandler('keys:gives', giveKeysToPassengers)

--[[
    -- Type: Event
    -- Name: keys:received
    -- Use: Adds a key when received from another player
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('keys:received')
AddEventHandler('keys:received', function(plate)
    if not hasKey(plate) then
        addKey(plate)
        TriggerEvent("DoLongHudText", "You just received keys to a vehicle!", 1)
    else
        TriggerEvent("DoLongHudText", "You already have keys to that vehicle!", 2)
    end
end)

--[[
    -- Type: Event
    -- Name: keys:checkandgive
    -- Use: Copies key ownership from one plate to another
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('keys:checkandgive')
AddEventHandler('keys:checkandgive', function(newplate, oldplate)
    if hasKey(oldplate) then addKey(newplate) end
end)

--[[
    -- Type: Event
    -- Name: np-jobmanager:playerBecameJob
    -- Use: Enables key features for specific jobs
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('np-jobmanager:playerBecameJob')
AddEventHandler('np-jobmanager:playerBecameJob', function(job)
    if job == "towtruck" or job == "police" or job == "ems" then
        Keys.towEnabled = true
    else
        Keys.towEnabled = false
    end
end)

--[[
    -- Type: Event
    -- Name: keys:hasKeys
    -- Use: Returns whether the player has keys for a vehicle
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('keys:hasKeys')
AddEventHandler('keys:hasKeys', function(from, veh)
    if not veh or veh == 0 then
        if from == 'engine' then
            TriggerEvent("car:engineHasKeys", veh, false)
        elseif from == 'doors' then
            TriggerEvent("keys:unlockDoor", veh, false)
        end
        return
    end
    local plate = GetVehicleNumberPlateText(veh)
    local allow = hasKey(plate)
    if from == 'engine' then
        TriggerEvent("car:engineHasKeys", veh, allow)
    elseif from == 'doors' then
        TriggerEvent("keys:unlockDoor", veh, allow)
    end
end)

--[[
    -- Type: Event
    -- Name: unseatPlayerCiv
    -- Use: Removes the closest player from the nearby vehicle if the caller has keys
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('unseatPlayerCiv')
AddEventHandler('unseatPlayerCiv', function()
    local ped = PlayerPedId()
    local coordA = GetEntityCoords(ped)
    local coordB = GetOffsetFromEntityInWorldCoords(ped, 0.0, 5.0, 0.0)
    local veh = getVehicleInDirection(coordA, coordB)
    if veh and veh ~= 0 then
        local plate = GetVehicleNumberPlateText(veh)
        if hasKey(plate) then
            local target, distance = GetClosestPlayer()
            if distance ~= -1 and distance < 10.0 then
                TriggerServerEvent('unseatAccepted', GetPlayerServerId(target))
            else
                TriggerEvent("DoLongHudText", 'No Player Found', 2)
            end
        else
            TriggerEvent("DoLongHudText", 'No Keys', 2)
        end
    else
        TriggerEvent("DoLongHudText", 'Car does not exist', 2)
    end
end)

--[[
    -- Type: Event
    -- Name: vehsearch:disable
    -- Use: Marks a vehicle as already searched
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('vehsearch:disable')
AddEventHandler('vehsearch:disable', function(veh)
    Keys.searched[veh] = true
end)

--[[
    -- Type: Event
    -- Name: event:control:npkeys
    -- Use: Handles search and hotwire control actions
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('event:control:npkeys')
AddEventHandler('event:control:npkeys', function(useID)
    if Keys.inAction then return end
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local veh = GetVehiclePedIsUsing(ped)
        local plate = GetVehicleNumberPlateText(veh)
        if GetPedInVehicleSeat(veh, -1) == ped and not hasKey(plate) and not Keys.searched[veh] then
            if useID == 1 then
                searchVehicle()
            elseif useID == 2 then
                hotwireVehicle()
            end
        end
    end
end)

--[[
    -- Type: Event
    -- Name: event:control:update
    -- Use: Updates control bindings
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('event:control:update')
AddEventHandler('event:control:update', function(tbl)
    Controls.vehicleSearch = tbl["vehicleSearch"] or Controls.vehicleSearch
    Controls.vehicleHotwire = tbl["vehicleHotwire"] or Controls.vehicleHotwire
end)

--[[
    -- Type: Event
    -- Name: keys:startvehicle
    -- Use: Starts the engine if the vehicle is in good condition
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('keys:startvehicle')
AddEventHandler('keys:startvehicle', function()
    local veh = GetVehiclePedIsUsing(PlayerPedId())
    if veh ~= 0 and GetVehicleEngineHealth(veh) > 199.0 then
        Keys.engineLockTimer = 0
        SetVehicleEngineOn(veh, true, false, true)
        SetVehicleUndriveable(veh, false)
    else
        SetVehicleEngineOn(veh, false, true, true)
        SetVehicleUndriveable(veh, true)
    end
end)

--[[
    -- Type: Event
    -- Name: keys:shutoffengine
    -- Use: Temporarily disables the engine while performing actions
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local runningShutdown = false
RegisterNetEvent('keys:shutoffengine')
AddEventHandler('keys:shutoffengine', function()
    Keys.engineLockTimer = 1000
    if runningShutdown then return end
    runningShutdown = true
    while Keys.engineLockTimer > 0 do
        Citizen.Wait(1)
        local veh = GetVehiclePedIsUsing(PlayerPedId())
        SetVehicleEngineOn(veh, false, true, true)
        Keys.engineLockTimer = Keys.engineLockTimer - 1
    end
    runningShutdown = false
end)

--[[
    -- Type: Function
    -- Name: GetPlayers
    -- Use: Returns a list of active players
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function GetPlayers()
    local players = {}
    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1] = i
        end
    end
    return players
end

--[[
    -- Type: Function
    -- Name: GetClosestPlayer
    -- Use: Finds the closest player to the caller
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply)
    for _, value in ipairs(players) do
        local target = GetPlayerPed(value)
        if target ~= ply then
            local targetCoords = GetEntityCoords(target)
            local distance = #(targetCoords - plyCoords)
            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
    return closestPlayer, closestDistance
end
