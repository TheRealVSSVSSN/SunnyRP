--[[
    -- Type: Client
    -- Name: BoatShopClient
    -- Use: Handles showroom rendering and player interactions
    -- Created: 2024-05-07
    -- By: VSSVSSN
--]]

local boatSpots = {}
local rentals = {}
local showroomCenter = vector3(-734.4421, -1312.2079, 5.0003)

--[[
    -- Type: Function
    -- Name: spawnDisplayBoat
    -- Use: Spawns or refreshes a showroom boat at a given slot
    -- Created: 2024-05-07
    -- By: VSSVSSN
--]]
local function spawnDisplayBoat(idx)
    local spot = boatSpots[idx]
    if not spot or not spot.boat.model then return end
    if DoesEntityExist(spot.boat.entity) then
        DeleteVehicle(spot.boat.entity)
    end
    local m = GetHashKey(spot.boat.model)
    RequestModel(m)
    while not HasModelLoaded(m) do Wait(0) end
    local pos = spot.coords
    spot.boat.entity = CreateVehicle(m, pos.x, pos.y, pos.z - 1.0, pos.w, false, false)
    SetVehicleOnGroundProperly(spot.boat.entity)
    FreezeEntityPosition(spot.boat.entity, true)
    SetEntityInvincible(spot.boat.entity, true)
    SetVehicleColours(spot.boat.entity, spot.boat.color[1], spot.boat.color[2])
    SetVehicleNumberPlateText(spot.boat.entity, 'PDMFLOOR')
end

--[[
    -- Type: Function
    -- Name: buyBoat
    -- Use: Transfers ownership of a showroom boat to the player
    -- Created: 2024-05-07
    -- By: VSSVSSN
--]]
local function buyBoat(idx)
    local ped = PlayerPedId()
    local spot = boatSpots[idx]
    local boat = spot.boat
    local price = boat.buyprice + math.floor(boat.buyprice * (boat.commission / 100))
    TriggerEvent('fsn_bank:change:walletMinus', price)
    local model = GetHashKey(boat.model)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end
    local spawn = vector4(-714.4751,-1354.5272,-0.4748,134.6729)
    local veh = CreateVehicle(model, spawn.x, spawn.y, spawn.z, spawn.w, true, false)
    SetVehicleColours(veh, boat.color[1], boat.color[2])
    SetVehicleHasBeenOwnedByPlayer(veh, true)
    TaskWarpPedIntoVehicle(ped, veh, -1)
    local finance = {
        outright = true,
        buyprice = price,
        base = boat.buyprice,
        commission = boat.commission
    }
    local details = { plate = GetVehicleNumberPlateText(veh) }
    TriggerServerEvent('fsn_cargarage:buyVehicle', exports['fsn_main']:fsn_CharID(), boat.name, boat.model, details.plate, details, finance, 'b', 0)
    TriggerEvent('fsn_cargarage:makeMine', veh, boat.model, details.plate)
    exports['mythic_notify']:DoCustomHudText('success', 'Purchased '..boat.name..' for $'..price, 3000)
end

--[[
    -- Type: Function
    -- Name: rentBoat
    -- Use: Spawns a temporary rental boat for the player
    -- Created: 2024-05-07
    -- By: VSSVSSN
--]]
local function rentBoat(idx)
    local ped = PlayerPedId()
    local boat = boatSpots[idx].boat
    TriggerEvent('fsn_bank:change:walletMinus', boat.rentalprice)
    local model = GetHashKey(boat.model)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end
    local spawn = vector4(-714.4751,-1354.5272,-0.4748,134.6729)
    local veh = CreateVehicle(model, spawn.x, spawn.y, spawn.z, spawn.w, true, false)
    SetVehicleColours(veh, boat.color[1], boat.color[2])
    SetVehicleHasBeenOwnedByPlayer(veh, true)
    TaskWarpPedIntoVehicle(ped, veh, -1)
    local plate = GetVehicleNumberPlateText(veh)
    rentals[#rentals+1] = {plate = plate, price = boat.rentalprice, entity = veh}
    TriggerEvent('fsn_cargarage:makeMine', veh, boat.model, plate)
    exports['mythic_notify']:DoCustomHudText('success', 'Boat rented', 3000)
end

--[[
    -- Type: Function
    -- Name: handleReturn
    -- Use: Processes returning rental boats and refunds half price
    -- Created: 2024-05-07
    -- By: VSSVSSN
--]]
local function handleReturn()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local returnPos = vector3(-714.4751,-1354.5272,-0.4748)
    if #(pos - returnPos) < 10.0 and IsPedInAnyVehicle(ped, false) then
        local veh = GetVehiclePedIsIn(ped, false)
        for i, b in ipairs(rentals) do
            if GetVehicleNumberPlateText(veh) == b.plate then
                Util.DrawText3D(returnPos.x, returnPos.y, returnPos.z+0.5, 'Press ~g~[E]~w~ to return rental', {255,255,255,200}, 0.2)
                if IsControlJustPressed(0, Util.GetKeyNumber('E')) then
                    TaskLeaveVehicle(ped, veh, 16)
                    Wait(1000)
                    DeleteVehicle(veh)
                    TriggerEvent('fsn_bank:change:walletAdd', b.price*0.5)
                    exports['mythic_notify']:DoCustomHudText('success', 'Rental returned', 3000)
                    table.remove(rentals, i)
                end
                break
            end
        end
    end
end

--[[
    -- Type: Thread
    -- Name: DisplayThread
    -- Use: Maintains showroom boats and interaction prompts
    -- Created: 2024-05-07
    -- By: VSSVSSN
--]]
CreateThread(function()
    local blip = AddBlipForCoord(showroomCenter)
    SetBlipSprite(blip, 455)
    SetBlipColour(blip, 3)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, 0.9)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Los Santos Marina')
    EndTextCommandSetBlipName(blip)

    while true do
        Wait(0)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        if #(pos - showroomCenter) < 100.0 then
            for idx, spot in pairs(boatSpots) do
                if not DoesEntityExist(spot.boat.entity) then
                    spawnDisplayBoat(idx)
                end
                if #(pos - vector3(spot.coords.x, spot.coords.y, spot.coords.z)) < 5.0 then
                    local b = spot.boat
                    local comm = math.floor(b.buyprice * (b.commission/100))
                    Util.DrawText3D(spot.coords.x, spot.coords.y, spot.coords.z+2.4, 'Boat: ~b~'..b.name, {255,255,255,255}, 0.3)
                    Util.DrawText3D(spot.coords.x, spot.coords.y, spot.coords.z+2.2, 'Price: ~g~$'..(b.buyprice+comm), {255,255,255,200}, 0.2)
                    Util.DrawText3D(spot.coords.x, spot.coords.y, spot.coords.z+2.0, 'Rental: ~g~$'..b.rentalprice, {255,255,255,200}, 0.2)
                    if IsControlJustPressed(0, 38) then -- E
                        if exports['fsn_main']:fsn_CanAfford(b.buyprice+comm) then
                            buyBoat(idx)
                        else
                            exports['mythic_notify']:DoCustomHudText('error', 'Not enough money', 3000)
                        end
                    elseif IsControlJustPressed(0, 47) then -- G
                        if exports['fsn_main']:fsn_CanAfford(b.rentalprice) then
                            rentBoat(idx)
                        else
                            exports['mythic_notify']:DoCustomHudText('error', 'Not enough money', 3000)
                        end
                    end
                end
            end
            handleReturn()
        else
            for _, spot in pairs(boatSpots) do
                if spot.boat.entity and DoesEntityExist(spot.boat.entity) then
                    DeleteVehicle(spot.boat.entity)
                    spot.boat.entity = nil
                end
            end
            Wait(500)
        end
    end
end)

--[[
    -- Type: Event
    -- Name: fsn_boatshop:floor:Update
    -- Use: Receives full showroom state from server
    -- Created: 2024-05-07
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_boatshop:floor:Update', function(data)
    boatSpots = data
    for idx in pairs(boatSpots) do
        spawnDisplayBoat(idx)
    end
end)

--[[
    -- Type: Event
    -- Name: fsn_boatshop:floor:Updateboat
    -- Use: Updates a single showroom slot
    -- Created: 2024-05-07
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_boatshop:floor:Updateboat', function(idx, data)
    boatSpots[idx] = data
    spawnDisplayBoat(idx)
end)

TriggerServerEvent('fsn_boatshop:floor:Request')
