--[[
    -- Type: Variable
    -- Name: droppedItems
    -- Use: Stores dropped items keyed by identifier
    -- Created: 2024-09-17
    -- By: VSSVSSN
--]]
local droppedItems = {}

--[[
    -- Type: Function
    -- Name: pickupAnimation
    -- Use: Plays item pickup animation on the player
    -- Created: 2024-09-17
    -- By: VSSVSSN
--]]
local function pickupAnimation()
    RequestAnimDict('pickup_object')
    while not HasAnimDictLoaded('pickup_object') do
        Wait(5)
    end
    TaskPlayAnim(PlayerPedId(), 'pickup_object', 'pickup_low', 8.0, 1.0, -1, 49, 1.0, false, false, false)
    Wait(1000)
    ClearPedTasks(PlayerPedId())
end

local ALT_KEY, E_KEY = 19, 38

--[[
    -- Type: Thread
    -- Name: dropMonitor
    -- Use: Draws markers and handles item pickup interactions
    -- Created: 2024-09-17
    -- By: VSSVSSN
--]]
CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local pCoords = GetEntityCoords(ped)
        for id, drop in pairs(droppedItems) do
            local dCoords = vector3(drop.loc.x, drop.loc.y, drop.loc.z)
            local distance = #(pCoords - dCoords)
            if distance < 10.0 then
                DrawMarker(25, dCoords.x, dCoords.y, dCoords.z - 0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 150, false, false, 2, false, nil, nil, false)
                if distance < 2.0 then
                    Util.DrawText3D(dCoords.x, dCoords.y, dCoords.z, ('[ALT+E] Pickup~y~\n%s'):format(drop.item.name), {255,255,255,200}, 0.25)
                    if IsControlPressed(0, ALT_KEY) and IsControlJustPressed(0, E_KEY) then
                        if exports['fsn_inventory']:fsn_CanCarry(drop.item.index, drop.item.amt) then
                            TriggerServerEvent('fsn_inventory:drops:collect', id)
                            pickupAnimation()
                        else
                            TriggerEvent('fsn_notify:displayNotification', 'You can not carry this item. (Max Weight Limit: 40)', 'centerLeft', 3000, 'error')
                        end
                    end
                end
            end
        end
    end
end)

--[[
    -- Type: Event
    -- Name: fsn_inventory:drops:send
    -- Use: Receives updated drop data from server
    -- Created: 2024-09-17
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_inventory:drops:send', function(tbl)
    print(('fsn_inventory_dropping: received %s items'):format(#tbl))
    droppedItems = tbl
end)

TriggerServerEvent('fsn_inventory:drops:request')
