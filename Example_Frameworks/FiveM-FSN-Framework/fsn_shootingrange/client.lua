--[[ 
    -- Type: Utility
    -- Name: drawTxt
    -- Use: Renders 2D text on screen
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
local function drawTxt(x, y, width, height, scale, text, r, g, b, a, outline)
    SetTextFont(0)
    SetTextProportional(false)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    if outline then SetTextOutline() end
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x - width / 2, y - height / 2 + 0.005)
end

local RANGE_ENTRY = vector3(12.377730369568, -1099.5345458984, 29.797027587891)
local RANGE_COST = 500

local RANGE_SLOTS = {
    [1] = {inUse = false, coords = vector4(8.4415864944458, -1095.2994384766, 29.834543228149, 336.54846191406)},
    [2] = {inUse = false, coords = vector4(9.3716773986816, -1095.6260986328, 29.834558486938, 345.27816772461)},
    [3] = {inUse = false, coords = vector4(10.339754104614, -1095.9066162109, 29.834619522095, 338.00933837891)},
    [4] = {inUse = false, coords = vector4(11.1967420578, -1096.2221679688, 29.834644317627, 329.2360534668)},
    [5] = {inUse = false, coords = vector4(15.823736190796, -1097.9860839844, 29.834819793701, 331.80352783203)},
    [6] = {inUse = false, coords = vector4(16.812646865845, -1098.3410644531, 29.834842681885, 331.81686401367)},
    [7] = {inUse = false, coords = vector4(17.761032104492, -1098.6226806641, 29.834899902344, 333.25262451172)},
    [8] = {inUse = false, coords = vector4(18.791498184204, -1099.0651855469, 29.834928512573, 333.07080078125)}
}

local TARGETS = {
    [1] = {hash = -58618026,  coords = vector4(21.266675949097, -1091.4289550781, 29.796955108643, 153.48428344727)},
    [2] = {hash = -58618026,  coords = vector4(19.882585525513, -1090.9522705078, 29.797023773193, 153.84771728516)},
    [3] = {hash = 104571594,  coords = vector4(22.355573654175, -1082.1015625, 29.797029495239, 159.56182861328)},
    [4] = {hash = 1741284929, coords = vector4(20.907932281494, -1081.6898193359, 29.797029495239, 165.92581176758)},
    [5] = {hash = -58618026,  coords = vector4(15.272421836853, -1079.6857910156, 29.843517303467, 151.82936096191)},
    [6] = {hash = 104571594,  coords = vector4(16.726470947266, -1080.1750488281, 29.797027587891, 166.9317779541)},
    [7] = {hash = 1741284929, coords = vector4(18.902379989624, -1068.4865722656, 29.797027587891, 159.13600158691)},
    [8] = {hash = -58618026,  coords = vector4(28.2692527771,   -1072.0395507813, 29.797023773193, 154.90347290039)},
    [9] = {hash = 104571594,  coords = vector4(22.517183303833, -1069.9752197266, 29.797023773193, 161.59638977051)},
    [10]= {hash = 1741284929, coords = vector4(16.31834602356,  -1089.5882568359, 29.797029495239, 157.49235534668)},
    [11]= {hash = -58618026,  coords = vector4(24.26784324646,  -1082.4281005859, 29.797029495239, 162.89242553711)},
    [12]= {hash = 104571594,  coords = vector4(15.326369285583, -1079.6533203125, 29.797029495239, 152.5389251709)}
}

local inRange = false
local currentRange = nil
local currentTarget = nil
local lastTarget = 0
local shotHandled = false

local createTarget

--[[ 
    -- Type: Function
    -- Name: startRange
    -- Use: Requests a shooting range slot from the server
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
local function startRange()
    TriggerServerEvent('fsn_shootingrange:requestJoin')
end

--[[ 
    -- Type: Function
    -- Name: joinRange
    -- Use: Places the player into the provided range slot
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
local function joinRange(rangeId)
    local slot = RANGE_SLOTS[rangeId]
    if not slot then return end
    local ped = PlayerPedId()
    SetEntityCoords(ped, slot.coords.x, slot.coords.y, slot.coords.z - 1.0, false, false, false, true)
    SetEntityHeading(ped, slot.coords.w)
    FreezeEntityPosition(ped, true)
    inRange = true
    currentRange = rangeId
    createTarget(0)
end

--[[ 
    -- Type: Function
    -- Name: leaveRange
    -- Use: Removes the player from the current range slot
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
local function leaveRange()
    if currentTarget then
        DeleteObject(currentTarget)
        currentTarget = nil
    end
    if currentRange then
        TriggerServerEvent('fsn_shootingrange:leave', currentRange)
    end
    SetEntityCoords(PlayerPedId(), RANGE_ENTRY)
    FreezeEntityPosition(PlayerPedId(), false)
    inRange = false
    lastTarget = 0
    currentRange = nil
end

--[[ 
    -- Type: Function
    -- Name: createTarget
    -- Use: Spawns a new target model in the range
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
createTarget = function(lastId)
    if currentTarget then
        DeleteObject(currentTarget)
        currentTarget = nil
    end

    local newId = math.random(1, #TARGETS)
    if newId == lastId then
        return createTarget(lastId)
    end

    lastTarget = newId
    local data = TARGETS[newId]
    RequestModel(data.hash)
    while not HasModelLoaded(data.hash) do
        drawTxt(1.24, 1.44, 1.0, 1.0, 0.4, "~r~Loading your next target...", 255, 255, 255, 255)
        Wait(0)
    end
    local obj = CreateObject(data.hash, data.coords.x, data.coords.y, data.coords.z, true, true, true)
    SetEntityHeading(obj, data.coords.w)
    SetEntityAsMissionEntity(obj, true, true)
    currentTarget = obj
    TriggerEvent('fsn_notify:displayNotification', 'Target created...', 'centerRight', 3000, 'info')
end

RegisterNetEvent('fsn_shootingrange:join', joinRange)
RegisterNetEvent('fsn_shootingrange:noRange', function()
    TriggerEvent('fsn_notify:displayNotification', 'There are no ranges available, try again later.', 'centerLeft', 4000, 'error')
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() and inRange then
        leaveRange()
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        if inRange then
            if IsPedShooting(ped) then
                if not shotHandled then
                    shotHandled = true
                    createTarget(lastTarget)
                end
            else
                shotHandled = false
            end

            BeginTextCommandDisplayHelp("STRING")
            AddTextComponentSubstringPlayerName("Press ~INPUT_PICKUP~ to ~r~leave~w~ the range")
            EndTextCommandDisplayHelp(0, false, false, -1)
            if IsControlJustPressed(0, 51) then
                leaveRange()
            end
        else
            local dist = #(RANGE_ENTRY - GetEntityCoords(ped))
            if dist < 10.0 then
                DrawMarker(1, RANGE_ENTRY - vector3(0, 0, 1), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.001, 1.0001, 0.4001, 0, 155, 255, 175, false, true, 2, false, nil, nil, false)
                if dist < 1.0 then
                    BeginTextCommandDisplayHelp("STRING")
                    AddTextComponentSubstringPlayerName("Press ~INPUT_PICKUP~ to access the range (~g~$" .. RANGE_COST .. "~w~)")
                    EndTextCommandDisplayHelp(0, false, false, -1)
                    if IsControlJustPressed(0, 51) then
                        startRange()
                    end
                end
            end
        end
    end
end)

