--[[
    -- Type: Client Script
    -- Name: client.lua
    -- Use: Controls metro and country train routes for players
    -- Created: 2024-06-04
    -- By: VSSVSSN
--]]

local showStations = false

local metro = {train=nil, speed=0.0, maxSpeed=0.0, nextStop=1, running=false, host=false}
local country = {train=nil, speed=0.0, maxSpeed=0.0, nextStop=1, running=false, host=false}

--[[
    -- Type: Data
    -- Name: station arrays
    -- Use: Coordinates for train stations
    -- Created: 2024-06-04
    -- By: VSSVSSN
--]]
local metroStations = {
    {-547.34,-1286.17,25.30},
    {-892.66,-2322.51,-13.24},
    {-1100.22,-2724.03,-8.30},
    {-1071.49,-2713.18,-8.92},
    {-875.61,-2319.86,-13.24},
    {-536.62,-1285.00,25.30},
    {270.09,-1209.91,37.46},
    {-287.13,-327.40,8.54},
    {-821.34,-132.45,18.43},
    {-1359.97,-465.32,13.53},
    {-498.96,-680.65,10.29},
    {-217.97,-1032.16,28.72},
    {113.90,-1729.99,28.45},
    {117.33,-1721.93,28.52},
    {-209.84,-1037.24,28.72},
    {-499.39,-665.58,10.29},
    {-1344.52,-462.10,13.53},
    {-806.85,-141.39,18.43},
    {-302.21,-327.28,8.54},
    {262.01,-1198.61,37.44}
}

local countryStations = {
    {664.93,-997.59,22.26},
    {190.62,-1956.81,19.52},
    {2615.39,2934.86,39.31},
    {2885.53,4862.01,62.55},
    {47.06,6280.89,31.58},
    {2002.36,3619.80,38.56},
    {2609.70,2937.11,39.41}
}

--[[
    -- Type: Function
    -- Name: drawTxt
    -- Use: Draws 2D text on screen
    -- Created: 2024-06-04
    -- By: VSSVSSN
--]]
local function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

--[[
    -- Type: Function
    -- Name: loadModels
    -- Use: Requests all train related models
    -- Created: 2024-06-04
    -- By: VSSVSSN
--]]
local function loadModels()
    local models = {
        "freight", "freightcar", "freightgrain", "freightcont1", "freightcont2",
        "freighttrailer", "tankercar", "metrotrain", "s_m_m_lsmetro_01"
    }
    for _,model in ipairs(models) do
        local hash = GetHashKey(model)
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Citizen.Wait(0)
        end
    end
end

--[[
    -- Type: Function
    -- Name: deleteTrain
    -- Use: Safely removes a train entity
    -- Created: 2024-06-04
    -- By: VSSVSSN
--]]
local function deleteTrain(train)
    if train and DoesEntityExist(train) then
        local trailer = GetTrainCarriage(train, 1)
        if trailer and DoesEntityExist(trailer) then
            DeleteEntity(trailer)
        end
        DeleteEntity(train)
    end
end

--[[
    -- Type: Function
    -- Name: spawnTrain
    -- Use: Creates a mission train at given coords
    -- Created: 2024-06-04
    -- By: VSSVSSN
--]]
local function spawnTrain(route, coords, isMetro)
    loadModels()
    deleteTrain(route.train)
    route.train = CreateMissionTrain(24, coords[1], coords[2], coords[3], isMetro)
    SetTrainSpeed(route.train, 0.0)
    SetTrainCruiseSpeed(route.train, 0.0)
    SetVehicleHasBeenOwnedByPlayer(route.train, true)
    local id = NetworkGetNetworkIdFromEntity(route.train)
    SetNetworkIdCanMigrate(id, false)
    route.speed = 0.0
    route.maxSpeed = 0.0
    route.running = true
end

--[[
    -- Type: Function
    -- Name: updateRoute
    -- Use: Handles automatic train movement between stations
    -- Created: 2024-06-04
    -- By: VSSVSSN
--]]
local function updateRoute(route, stations)
    local train = route.train
    local nextStation = vector3(stations[route.nextStop][1], stations[route.nextStop][2], stations[route.nextStop][3])
    local distance = #(nextStation - GetEntityCoords(train))
    if distance < 5.0 then
        SetTrainSpeed(train, 0.0)
        SetTrainCruiseSpeed(train, 0.0)
        Citizen.Wait(5000)
        route.nextStop = route.nextStop + 1
        if route.nextStop > #stations then route.nextStop = 1 end
    else
        route.maxSpeed = distance < 250.0 and distance * 0.7 or 45.0
        if route.speed < route.maxSpeed then route.speed = route.speed + 1.0 end
        if route.speed > route.maxSpeed then route.speed = route.speed - 1.0 end
        SetTrainSpeed(train, route.speed)
        SetTrainCruiseSpeed(train, route.speed)
    end
end

--[[
    -- Type: Function
    -- Name: toggleBlips
    -- Use: Shows or hides station blips
    -- Created: 2024-06-04
    -- By: VSSVSSN
--]]
local function toggleBlips()
    showStations = not showStations
    local function handle(list, sprite, colour, text)
        for _, item in pairs(list) do
            if item.blip then
                RemoveBlip(item.blip)
                item.blip = nil
            end
            if showStations then
                item.blip = AddBlipForCoord(item[1], item[2], item[3])
                SetBlipSprite(item.blip, sprite)
                SetBlipColour(item.blip, colour)
                SetBlipScale(item.blip, 0.75)
                SetBlipAsShortRange(item.blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(text)
                EndTextCommandSetBlipName(item.blip)
            end
        end
    end
    handle(metroStations, 36, 2, "Metro Train Station")
    handle(countryStations, 36, 12, "Country Train Station")
end
RegisterNetEvent('trains:toggleBlips')
AddEventHandler('trains:toggleBlips', toggleBlips)

--[[
    -- Type: Function
    -- Name: getVehicleInDirection
    -- Use: Returns first vehicle in player's view
    -- Created: 2024-06-04
    -- By: VSSVSSN
--]]
local function getVehicleInDirection()
    local playerped = PlayerPedId()
    local coordFrom = GetEntityCoords(playerped)
    local coordTo = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
    local offset = 0
    local vehicle
    for i = 0, 100 do
        local ray = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, playerped, 0)
        _, _, _, _, vehicle = GetRaycastResult(ray)
        offset = offset - 1
        if vehicle ~= 0 then break end
    end
    local distance = vehicle ~= 0 and #(coordFrom - GetEntityCoords(vehicle)) or 999.0
    if distance > 25.0 then vehicle = nil end
    return vehicle or 0
end

--[[
    -- Type: Thread
    -- Name: host loop
    -- Use: Updates trains for current host
    -- Created: 2024-06-04
    -- By: VSSVSSN
--]]
Citizen.CreateThread(function()
    while true do
        if metro.host and metro.running and metro.train then
            updateRoute(metro, metroStations)
        end
        if country.host and country.running and country.train then
            updateRoute(country, countryStations)
        end
        Citizen.Wait(1000)
    end
end)

--[[
    -- Type: Event
    -- Name: trains:hostAssigned
    -- Use: Sets host flag and spawns train
    -- Created: 2024-06-04
    -- By: VSSVSSN
--]]
RegisterNetEvent('trains:hostAssigned')
AddEventHandler('trains:hostAssigned', function(isHost)
    if isHost then
        metro.host = true
        country.host = true
    end
end)

--[[
    -- Type: Thread
    -- Name: player interaction
    -- Use: Handles entering and starting trains
    -- Created: 2024-06-04
    -- By: VSSVSSN
--]]
Citizen.CreateThread(function()
    toggleBlips()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(1, 38) then
            local playerPed = PlayerPedId()
            local veh = getVehicleInDirection()
            if IsThisModelATrain(GetEntityModel(veh)) and not IsPedInAnyTrain(playerPed) then
                for seat = 0, 2 do
                    if IsVehicleSeatFree(veh, seat) then
                        SetPedIntoVehicle(playerPed, veh, seat)
                        break
                    end
                end
            else
                local pos = GetEntityCoords(playerPed)
                local metroDist = #(vector3(metroStations[metro.nextStop][1], metroStations[metro.nextStop][2], metroStations[metro.nextStop][3]) - pos)
                local countryDist = #(vector3(countryStations[country.nextStop][1], countryStations[country.nextStop][2], countryStations[country.nextStop][3]) - pos)
                if metroDist < 25.0 then
                    TriggerServerEvent('trains:requestHost')
                    spawnTrain(metro, metroStations[metro.nextStop], true)
                    TriggerEvent('chatMessage', 'THOMAS', {0,0,0}, ' Metro train departing shortly.')
                elseif countryDist < 25.0 then
                    TriggerServerEvent('trains:requestHost')
                    spawnTrain(country, countryStations[country.nextStop], false)
                    TriggerEvent('chatMessage', 'THOMAS', {0,0,0}, ' Country train departing shortly.')
                else
                    TriggerEvent('chatMessage', 'THOMAS', {0,0,0}, ' You are not near a train station.')
                end
            end
        end
    end
end)
