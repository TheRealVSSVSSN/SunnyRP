local spikeCoords = {}
local spikesBlip
local loadSpikes = true

local function setSpikesOnGround(amount)
    TriggerEvent("animation:PlayAnimation", "layspike")
    Wait(1000)
    local heading = GetEntityHeading(PlayerPedId())

    for i = 1, amount do
        local pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -1.5 + (3.5 * i), 0.15)
        TriggerServerEvent("police:spikesLocation", pos.x, pos.y, pos.z, heading)
    end

    if DoesBlipExist(spikesBlip) then
        RemoveBlip(spikesBlip)
    end

    local pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.5, 0.15)
    spikesBlip = AddBlipForCoord(pos.x, pos.y, pos.z)

    SetBlipSprite(spikesBlip, 238)
    SetBlipScale(spikesBlip, 1.2)
    SetBlipAsShortRange(spikesBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Last Road Spikes")
    EndTextCommandSetBlipName(spikesBlip)
    TriggerEvent("DoLongHudText", "You have placed down a spike strip.", 1)
end

CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped, false)
            local driverPed = GetPedInVehicleSeat(veh, -1)
            if #spikeCoords > 0 and driverPed == ped then
                for i = 1, #spikeCoords do
                    local data = spikeCoords[i]
                    if data and not data.watching then
                        local curDst = #(vector3(data.x, data.y, data.z) - GetEntityCoords(ped))
                        if curDst < 35.0 then
                            data.watching = true
                            TriggerEvent("spikes:watchtarget", i)
                        end
                    end
                end
            else
                Wait(150)
            end
        else
            Wait(1000)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(1000)
        local ped = PlayerPedId()
        for k, v in pairs(spikeCoords) do
            local curDst = #(vector3(v.x, v.y, v.z) - GetEntityCoords(ped))
            if curDst < 85.0 then
                if not v.placed or not DoesEntityExist(v.object) then
                    deRenderSpikes(k)
                    renderSpikes(k)
                elseif v.placed and v.object ~= nil then
                    deRenderSpikes(k)
                end
                Wait(100)
            end
        end
    end
end)

local function renderSpikes(k)
    if not loadSpikes or spikeCoords[k].placed or spikeCoords[k].object then return end
    spikeCoords[k].placed = true
    local model = GetHashKey("P_ld_stinger_s")

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    local obj = CreateObject(model, spikeCoords[k].x, spikeCoords[k].y, spikeCoords[k].z, false, true, false)
    PlaceObjectOnGroundProperly(obj)
    SetEntityHeading(obj, spikeCoords[k].h)
    FreezeEntityPosition(obj, true)
    spikeCoords[k].object = obj
end

local function deRenderSpikes(k)
    local obj = spikeCoords[k].object
    if obj then
        DeleteObject(obj)
        if DoesEntityExist(obj) then
            SetEntityAsNoLongerNeeded(obj)
            DeleteObject(obj)
        end
        spikeCoords[k].placed = false
        spikeCoords[k].object = nil
    end
end

RegisterNetEvent('addSpikes')
AddEventHandler('addSpikes', function(data, id)
    spikeCoords[id] = data
end)

RegisterNetEvent('removeSpikes')
AddEventHandler('removeSpikes', function(id)
    if spikeCoords[id] then
        table.remove(spikeCoords, id)
    end
end)

RegisterNetEvent('c_setSpike')
AddEventHandler('c_setSpike', function()
    local src = GetPlayerServerId(PlayerId())
    for _, v in pairs(spikeCoords) do
        if v.id == src then
            TriggerEvent("DoLongHudText", "You already have spikes down.", 2)
            return
        end
    end
    setSpikesOnGround(3)
end)

RegisterNetEvent('police:spikesup')
AddEventHandler('police:spikesup', function()
    if not loadSpikes then
        TriggerEvent("DoLongHudText", "You are already picking up spikes you little bitch.", 2)
        return
    end
    loadSpikes = false
    TriggerEvent("animation:PlayAnimation", "layspike")
    for i = 1, 4 do
        removeSpikeStanding()
        Wait(1000)
    end
    TriggerEvent("DoLongHudText", "You have picked up a spike strip.", 1)
    Wait(1000)
    loadSpikes = true
end)

local function removeSpikeStanding()
    for k, v in pairs(spikeCoords) do
        local curDst = #(vector3(v.x, v.y, v.z) - GetEntityCoords(PlayerPedId()))
        if curDst < 15.0 then
            if v.object then
                DeleteObject(v.object)
                SetEntityAsNoLongerNeeded(v.object)
            end
            TriggerServerEvent("police:removespikes", k)
            return
        end
    end
end

local function burstVehicleTyres(veh)
    for i = 0, 7 do
        SetVehicleTyreBurst(veh, i, true, 1000.0)
    end
end

RegisterNetEvent('spikes:watchtarget')
AddEventHandler('spikes:watchtarget', function(watchId)
    while true do
        Wait(0)
        local ped = PlayerPedId()
        if not IsPedInAnyVehicle(ped, false) then return end
        local veh = GetVehiclePedIsIn(ped, false)
        if GetPedInVehicleSeat(veh, -1) ~= ped then return end
        local data = spikeCoords[watchId]
        if not data or not data.watching then return end
        if #(vector3(data.x, data.y, data.z) - GetEntityCoords(ped)) > 40.0 then
            data.watching = false
            return
        end

        local d1, d2 = GetModelDimensions(GetEntityModel(veh))
        local checkPoints = {
            GetOffsetFromEntityInWorldCoords(veh, d1.x - 0.25, 0.25, 0.0),
            GetOffsetFromEntityInWorldCoords(veh, d2.x + 0.25, 0.25, 0.0),
            GetOffsetFromEntityInWorldCoords(veh, d1.x - 0.25, -0.85, 0.0),
            GetOffsetFromEntityInWorldCoords(veh, d2.x + 0.25, -0.85, 0.0),
        }
        local spikePos = vector3(data.x, data.y, data.z)
        for _, pos in ipairs(checkPoints) do
            if #(spikePos - pos) < 1.5 then
                burstVehicleTyres(veh)
                data.watching = false
                return
            end
        end
    end
end)
