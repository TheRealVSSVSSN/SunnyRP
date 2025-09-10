--[[ 
    -- Type: Resource
    -- Name: fsn_entfinder
    -- Use: Caches entity pools and offers helper exports for nearby lookups
    -- Created: 2024-06-27
    -- By: VSSVSSN
--]]

------------------------------------------------------- config
local UPDATE_INTERVAL <const> = 500 -- milliseconds
local NEARBY_RANGE <const> = 50.0

local config = {
    trackObjects = false,
    trackPickups = false
}

local function table_wipe(tbl)
    for k in pairs(tbl) do
        tbl[k] = nil
    end
end

------------------------------------------------------- datastore
local datastore = {
    peds = {},
    objects = config.trackObjects and {} or false,
    vehicles = {},
    pickups = config.trackPickups and {} or false,
    nearby = {
        peds = {},
        objects = {},
        vehicles = {},
        pickups = {}
    }
}

------------------------------------------------------- internals
--- Refresh entity tables using game pools
-- @param pool string: pool name e.g. 'CPed'
-- @param list table: store for all entities
-- @param nearby table: store for nearby entities
-- @param playerCoords vector3: player's coordinates
-- @param filter function? optional post process/filter
local function refreshEntities(pool, list, nearby, playerCoords, filter)
    table_wipe(list)
    table_wipe(nearby)

    for _, entity in ipairs(GetGamePool(pool)) do
        list[#list + 1] = entity

        if #(GetEntityCoords(entity) - playerCoords) <= NEARBY_RANGE then
            nearby[#nearby + 1] = entity
        end

        if filter then filter(entity) end
    end
end

------------------------------------------------------- exports
--- Retrieve tracked vehicles
-- @param nearby boolean: return only nearby vehicles
function getVehicles(nearby)
    return nearby and datastore.nearby.vehicles or datastore.vehicles
end

--- Retrieve tracked peds
-- @param nearby boolean: return only nearby peds
function getPeds(nearby)
    return nearby and datastore.nearby.peds or datastore.peds
end

--- Retrieve tracked pickups
-- @param nearby boolean: return only nearby pickups
function getPickups(nearby)
    return nearby and datastore.nearby.pickups or datastore.pickups
end

--- Retrieve tracked objects
-- @param nearby boolean: return only nearby objects
function getObjects(nearby)
    return nearby and datastore.nearby.objects or datastore.objects
end

--- Return the closest non-player ped to the given coords within Distance
function getPedNearCoords(x, y, z, Distance)
    local coords = vector3(x, y, z)
    local target, nearest = nil, Distance + 0.0

    for _, ped in ipairs(GetGamePool('CPed')) do
        if DoesEntityExist(ped) and not IsPedAPlayer(ped) then
            local dist = #(GetEntityCoords(ped) - coords)
            if dist <= nearest then
                nearest = dist
                target = ped
            end
        end
    end

    return target
end

------------------------------------------------------- main loop
CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        refreshEntities('CPed', datastore.peds, datastore.nearby.peds, playerCoords, function(ped)
            SetPedDropsWeaponsWhenDead(ped, false)
        end)

        refreshEntities('CVehicle', datastore.vehicles, datastore.nearby.vehicles, playerCoords)

        if datastore.objects then
            refreshEntities('CObject', datastore.objects, datastore.nearby.objects, playerCoords)
        end

        if datastore.pickups then
            refreshEntities('CPickup', datastore.pickups, datastore.nearby.pickups, playerCoords)
        end

        Wait(UPDATE_INTERVAL)
    end
end)
