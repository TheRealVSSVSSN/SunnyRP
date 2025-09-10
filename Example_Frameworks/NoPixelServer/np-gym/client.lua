--[[
    -- Type: Resource
    -- Name: np-gym client
    -- Use: Handles gym workout interactions for players
    -- Created: 2024-06-09
    -- By: VSSVSSN
--]]
-- luacheck: globals vector3 World3dToScreen2d SetTextScale SetTextFont SetTextProportional SetTextColour
-- luacheck: globals SetTextEntry SetTextCentre AddTextComponentString DrawText DrawRect
-- luacheck: globals PlayerPedId SetEntityCoords SetEntityHeading FreezeEntityPosition TriggerEvent Wait
-- luacheck: globals CreateThread GetEntityCoords IsControlJustReleased


local workoutAreas = {
    { coords = vector3(-1196.979, -1572.897, 4.613), heading = 211.115, workType = 'Weights',  emote = 'weights'  },
    { coords = vector3(-1199.060, -1574.493, 4.610), heading = 213.649, workType = 'Weights',  emote = 'weights'  },
    { coords = vector3(-1200.587, -1577.505, 4.608), heading = 312.377, workType = 'Pushups',  emote = 'pushUps'  },
    { coords = vector3(-1196.013, -1567.369, 4.617), heading = 308.908, workType = 'Situps',   emote = 'situps'   },
    { coords = vector3(-1215.022, -1541.686, 4.728), heading = 119.798, workType = 'Yoga',     emote = 'yoga'    },
    { coords = vector3(-1217.592, -1543.162, 4.721), heading = 119.818, workType = 'Yoga',     emote = 'yoga'    },
    { coords = vector3(-1220.845, -1545.028, 4.692), heading = 119.826, workType = 'Yoga',     emote = 'yoga'    },
    { coords = vector3(-1224.699, -1547.247, 4.625), heading = 119.868, workType = 'Yoga',     emote = 'yoga'    },
    { coords = vector3(-1228.495, -1549.429, 4.556), heading = 119.877, workType = 'Yoga',     emote = 'yoga'    },
    { coords = vector3(-1253.410, -1601.650, 3.150), heading = 213.340, workType = 'Chinups',  emote = 'chinups' },
    { coords = vector3(-1252.430, -1603.140, 3.130), heading = 213.780, workType = 'Chinups',  emote = 'chinups' },
    { coords = vector3(-1251.260, -1604.810, 3.140), heading = 217.940, workType = 'Chinups',  emote = 'chinups' }
}

local inProcess = false

--[[
    -- Type: Function
    -- Name: drawText3D
    -- Use: Renders text in 3D space
    -- Created: 2024-06-09
    -- By: VSSVSSN
--]]
local function drawText3D(coords, text)
    local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
    if not onScreen then return end
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(true)
    AddTextComponentString(text)
    DrawText(x, y)
    local factor = string.len(text) / 370
    DrawRect(x, y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end

--[[
    -- Type: Function
    -- Name: startWorkout
    -- Use: Teleports player to workout spot, plays animation and applies effects
    -- Created: 2024-06-09
    -- By: VSSVSSN
--]]
local function startWorkout(index)
    local area = workoutAreas[index]
    if not area then return end
    inProcess = true
    local ped = PlayerPedId()
    SetEntityCoords(ped, area.coords.x, area.coords.y, area.coords.z, false, false, false, true)
    SetEntityHeading(ped, area.heading)
    FreezeEntityPosition(ped, true)
    TriggerEvent('animation:PlayAnimation', area.emote)
    Wait(30000)
    TriggerEvent('client:newStress', false, 450)
    TriggerEvent('animation:PlayAnimation', 'cancel')
    FreezeEntityPosition(ped, false)
    inProcess = false
end

--[[
    -- Type: Thread
    -- Name: workoutMonitor
    -- Use: Monitors player proximity and handles workout initiation
    -- Created: 2024-06-09
    -- By: VSSVSSN
--]]
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local waitTime = 1000

        if not inProcess then
            for i, area in ipairs(workoutAreas) do
                local distance = #(coords - area.coords)
                if distance < 3.0 then
                    waitTime = 0
                    drawText3D(area.coords, ('[E] to do %s'):format(area.workType))
                    if distance < 1.5 and IsControlJustReleased(0, 38) then
                        startWorkout(i)
                    end
                end
            end
        end

        Wait(waitTime)
    end
end)

