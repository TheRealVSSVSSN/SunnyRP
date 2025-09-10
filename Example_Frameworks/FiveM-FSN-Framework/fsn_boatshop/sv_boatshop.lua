--[[
    -- Type: Server
    -- Name: BoatShopServer
    -- Use: Handles showroom state and employee commands
    -- Created: 2024-05-07
    -- By: VSSVSSN
--]]

local boatSpots = {}
for i, spot in ipairs(Config.Spots) do
    boatSpots[i] = { coords = spot.coords, boat = {} }
end

local function worksAtStore(src)
    return exports["fsn_jobs"]:isPlayerClockedInWhitelist(src, 4)
end

local function getBoatByModel(model)
    for _, boat in ipairs(Config.Boats) do
        if boat.model == model then
            return boat
        end
    end
end

local function refreshSpot(idx)
    local info = Config.Boats[math.random(#Config.Boats)]
    boatSpots[idx].boat = {
        model = info.model,
        name = info.name,
        buyprice = info.price,
        rentalprice = info.rental,
        commission = 15,
        color = { math.random(1,159), math.random(1,159) },
        updated = false
    }
end

--[[
    -- Type: Event
    -- Name: fsn_boatshop:floor:Request
    -- Use: Sends current showroom state to requesting client
    -- Created: 2024-05-07
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_boatshop:floor:Request', function()
    local src = source
    for i = 1, #boatSpots do
        if not boatSpots[i].boat.model then
            refreshSpot(i)
        end
    end
    TriggerClientEvent('fsn_boatshop:floor:Update', src, boatSpots)
end)

local function updateColor(idx, col, primary, src)
    if not worksAtStore(src) then return end
    local spot = boatSpots[idx]
    if not spot then return end
    spot.boat.color[primary and 1 or 2] = col
    spot.boat.updated = false
    TriggerClientEvent('fsn_boatshop:floor:Updateboat', -1, idx, spot)
end

RegisterNetEvent('fsn_boatshop:floor:color:One', function(idx, col)
    updateColor(idx, col, true, source)
end)

RegisterNetEvent('fsn_boatshop:floor:color:Two', function(idx, col)
    updateColor(idx, col, false, source)
end)

local function updateCommission(idx, amt, src)
    if not worksAtStore(src) then return end
    local spot = boatSpots[idx]
    if not spot then return end
    spot.boat.commission = amt
    spot.boat.updated = false
    TriggerClientEvent('fsn_boatshop:floor:Updateboat', -1, idx, spot)
end

RegisterNetEvent('fsn_boatshop:floor:commission', function(idx, amt)
    updateCommission(idx, amt, source)
end)

local function changeBoat(idx, model, src)
    if not worksAtStore(src) then return end
    local spot = boatSpots[idx]
    local info = getBoatByModel(model)
    if not spot or not info then return end
    spot.boat.model = info.model
    spot.boat.name = info.name
    spot.boat.buyprice = info.price
    spot.boat.rentalprice = info.rental
    spot.boat.updated = false
    TriggerClientEvent('fsn_boatshop:floor:Updateboat', -1, idx, spot)
end

RegisterNetEvent('fsn_boatshop:floor:ChangeBoat', function(idx, model)
    changeBoat(idx, model, source)
end)

AddEventHandler('chatMessage', function(src, name, msg)
    if not worksAtStore(src) then return end
    local args = {}
    for word in msg:gmatch('%S+') do args[#args+1] = word end
    local cmd = args[1]

    if cmd == '/comm' and args[2] then
        local amt = tonumber(args[2])
        if amt and amt >= 0 and amt <= 30 then
            updateCommission(closestSpot(src), amt, src)
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', src, {type='error', text='Usage: /comm 0-30'})
        end
        CancelEvent()
    elseif cmd == '/color1' and args[2] then
        local col = tonumber(args[2])
        if col and col >= 0 and col <= 159 then
            updateColor(closestSpot(src), col, true, src)
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', src, {type='error', text='Usage: /color1 0-159'})
        end
        CancelEvent()
    elseif cmd == '/color2' and args[2] then
        local col = tonumber(args[2])
        if col and col >= 0 and col <= 159 then
            updateColor(closestSpot(src), col, false, src)
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', src, {type='error', text='Usage: /color2 0-159'})
        end
        CancelEvent()
    elseif cmd == '/setboat' and args[2] and args[3] then
        local idx = tonumber(args[2])
        if not idx then
            TriggerClientEvent('mythic_notify:client:SendAlert', src, {type='error', text='Usage: /setboat <slot> <model>'})
        else
            changeBoat(idx, args[3], src)
        end
        CancelEvent()
    end
end)

--[[
    -- Type: Function
    -- Name: closestSpot
    -- Use: Returns the nearest showroom index to a player
    -- Created: 2024-05-07
    -- By: VSSVSSN
--]]
function closestSpot(src)
    local ped = GetPlayerPed(src)
    local p = GetEntityCoords(ped)
    local idx, dist = nil, 9999.0
    for i, spot in ipairs(boatSpots) do
        local s = spot.coords
        local d = #(p - vector3(s.x, s.y, s.z))
        if d < dist then
            dist = d
            idx = i
        end
    end
    return idx
end
