-- add text entries for all the help types we have
AddTextEntry('FOUNTAIN_HELP', 'This fountain currently contains $~1~.~n~Press ~INPUT_PICKUP~ to obtain $~1~.~n~Press ~INPUT_DETONATE~ to place $~1~.')
AddTextEntry('FOUNTAIN_HELP_DRAINED', 'This fountain currently contains $~1~.~n~Press ~INPUT_DETONATE~ to place $~1~.')
AddTextEntry('FOUNTAIN_HELP_BROKE', 'This fountain currently contains $~1~.~n~Press ~INPUT_PICKUP~ to obtain $~1~.')
AddTextEntry('FOUNTAIN_HELP_BROKE_N_DRAINED', 'This fountain currently contains $~1~.')
AddTextEntry('FOUNTAIN_HELP_INUSE', 'This fountain currently contains $~1~.~n~You can use it again in ~a~.')

-- upvalue aliases so that we will be fast if far away
local Wait = Wait
local GetEntityCoords = GetEntityCoords
local PlayerPedId = PlayerPedId

-- controls
local INPUT_PICKUP <const> = 38
local INPUT_DETONATE <const> = 47

-- timer, don't tick as frequently if we're far from any money fountain
local relevanceTimer = 500

--[[
    -- Type: Function
    -- Name: handleControls
    -- Use: Sends server events based on player input
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
local function handleControls(id)
    if IsControlJustReleased(0, INPUT_PICKUP) then
        TriggerServerEvent('money_fountain:tryPickup', id)
    elseif IsControlJustReleased(0, INPUT_DETONATE) then
        TriggerServerEvent('money_fountain:tryPlace', id)
    end
end

--[[
    -- Type: Function
    -- Name: showHelp
    -- Use: Displays contextual help for the fountain
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
local function showHelp(data, youCanSpend, fountainCanSpend)
    local helpName

    if youCanSpend and fountainCanSpend then
        helpName = 'FOUNTAIN_HELP'
    elseif youCanSpend and not fountainCanSpend then
        helpName = 'FOUNTAIN_HELP_DRAINED'
    elseif not youCanSpend and fountainCanSpend then
        helpName = 'FOUNTAIN_HELP_BROKE'
    else
        helpName = 'FOUNTAIN_HELP_BROKE_N_DRAINED'
    end

    BeginTextCommandDisplayHelp(helpName)
    AddTextComponentInteger(GlobalState['fountain_' .. data.id])

    if fountainCanSpend then
        AddTextComponentInteger(data.amount)
    end

    if youCanSpend then
        AddTextComponentInteger(data.amount)
    end

    EndTextCommandDisplayHelp(0, false, false, 1000)
end

CreateThread(function()
    while true do
        Wait(relevanceTimer)

        local coords = GetEntityCoords(PlayerPedId())
        local near = false

        for _, data in pairs(moneyFountains) do
            local dist = #(coords - data.coords)

            if dist < 40.0 then
                near = true
                DrawMarker(29, data.coords.x, data.coords.y, data.coords.z, 0, 0, 0, 0.0, 0, 0, 1.0, 1.0, 1.0, 0, 150, 0, 120, false, true, 2, false, nil, nil, false)

                if dist < 1.0 then
                    local player = LocalPlayer
                    local nextUse = player.state['fountain_nextUse']

                    if nextUse and nextUse >= GetNetworkTime() then
                        BeginTextCommandDisplayHelp('FOUNTAIN_HELP_INUSE')
                        AddTextComponentInteger(GlobalState['fountain_' .. data.id])
                        AddTextComponentSubstringTime(math.tointeger(nextUse - GetNetworkTime()), 2 | 4)
                        EndTextCommandDisplayHelp(0, false, false, 1000)
                    else
                        handleControls(data.id)

                        local youCanSpend = (player.state['money_cash'] or 0) >= data.amount
                        local fountainCanSpend = GlobalState['fountain_' .. data.id] >= data.amount

                        showHelp(data, youCanSpend, fountainCanSpend)
                    end
                end
            end
        end

        relevanceTimer = near and 0 or 500
    end
end)

