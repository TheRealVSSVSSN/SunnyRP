--[[
    -- Type: Module
    -- Name: Golf Client
    -- Use: Handles client-side logic for the golf mini game
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]

local courseStart = vec3(-1332.78, 128.18, 56.03)
local startRadius = 1.5
local exitRadius = 500.0
local control = { use = 38 } -- E key

local state = {
    playing = false,
    hole = 0,
    stroke = 0,
    total = 0,
    ball = nil,
    club = 2,
    caddy = nil,
    blipBall = nil,
    blipStart = nil,
    blipEnd = nil
}

--[[
    -- Type: Table
    -- Name: clubs
    -- Use: Defines club names and power multipliers
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]
local clubs = {
    [1] = { name = 'Putter', power = 5.0 },
    [2] = { name = 'Iron',  power = 20.0 },
    [3] = { name = 'Wedge', power = 12.0 },
    [4] = { name = 'Driver', power = 35.0 }
}

--[[
    -- Type: Table
    -- Name: holes
    -- Use: Coordinates for each hole's start and end positions
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]
local holes = {
    [1] = { par = 5, start = vec3(-1371.337, 173.095, 57.013), finish = vec3(-1114.227, 220.842, 63.895) },
    [2] = { par = 4, start = vec3(-1107.189, 156.581, 62.040), finish = vec3(-1322.094, 158.878, 56.800) },
    [3] = { par = 3, start = vec3(-1312.102, 125.833, 56.434), finish = vec3(-1237.347, 112.984, 56.201) },
    [4] = { par = 4, start = vec3(-1216.913, 106.987, 57.039), finish = vec3(-1096.628,   7.780, 49.736) },
    [5] = { par = 4, start = vec3(-1097.860,  66.415, 52.925), finish = vec3(-957.498, -90.376, 39.275) },
    [6] = { par = 3, start = vec3(-987.742, -105.076, 39.586), finish = vec3(-1103.507, -115.236, 40.559) },
    [7] = { par = 4, start = vec3(-1117.019, -103.859, 40.841), finish = vec3(-1290.536,   2.795, 49.341) },
    [8] = { par = 5, start = vec3(-1272.252,  38.043, 48.725), finish = vec3(-1034.802, -83.167, 43.035) },
    [9] = { par = 4, start = vec3(-1138.320,  -0.134, 47.982), finish = vec3(-1294.686,  83.576, 53.928) }
}

--[[
    -- Type: Function
    -- Name: displayHelp
    -- Use: Renders instructional text on screen
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]
local function displayHelp(msg)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

--[[
    -- Type: Function
    -- Name: spawnCaddy
    -- Use: Spawns a golf cart and seats the player
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]
local function spawnCaddy()
    local model = GetHashKey('caddy')
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    local veh = CreateVehicle(model, courseStart.x, courseStart.y, courseStart.z, 180.0, true, false)
    SetVehicleOnGroundProperly(veh)
    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
    SetModelAsNoLongerNeeded(model)
    state.caddy = veh
end

--[[
    -- Type: Function
    -- Name: createBall
    -- Use: Creates the golf ball object at provided coordinates
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]
local function createBall(coords)
    if state.ball then
        DeleteEntity(state.ball)
    end
    local ball = CreateObject(GetHashKey('prop_golf_ball'), coords.x, coords.y, coords.z, true, true, false)
    SetEntityRecordsCollisions(ball, true)
    SetEntityCollision(ball, true, true)
    FreezeEntityPosition(ball, true)
    state.ball = ball
    if state.blipBall then
        RemoveBlip(state.blipBall)
    end
    state.blipBall = AddBlipForEntity(ball)
    SetBlipSprite(state.blipBall, 161)
    SetBlipScale(state.blipBall, 0.8)
end

--[[
    -- Type: Function
    -- Name: cleanup
    -- Use: Removes entities and blips at game end
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]
local function cleanup()
    if state.ball then
        DeleteEntity(state.ball)
        state.ball = nil
    end
    if state.caddy then
        DeleteEntity(state.caddy)
        state.caddy = nil
    end
    if state.blipBall then RemoveBlip(state.blipBall) end
    if state.blipStart then RemoveBlip(state.blipStart) end
    if state.blipEnd   then RemoveBlip(state.blipEnd)   end
end

--[[
    -- Type: Function
    -- Name: startHole
    -- Use: Initializes new hole and places ball
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]
local function startHole()
    state.stroke = 0
    local data = holes[state.hole]
    createBall(data.start)
    if state.blipStart then RemoveBlip(state.blipStart) end
    if state.blipEnd   then RemoveBlip(state.blipEnd)   end
    state.blipStart = AddBlipForCoord(data.start.x, data.start.y, data.start.z)
    state.blipEnd   = AddBlipForCoord(data.finish.x, data.finish.y, data.finish.z)
    SetBlipColour(state.blipStart, 2)
    SetBlipColour(state.blipEnd, 1)
end

--[[
    -- Type: Function
    -- Name: startGolf
    -- Use: Begins the golf session
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]
local function startGolf()
    state.playing = true
    state.hole = 1
    state.total = 0
    spawnCaddy()
    startHole()
end

--[[
    -- Type: Function
    -- Name: endGolf
    -- Use: Ends the golf session and cleans up
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]
local function endGolf()
    cleanup()
    state.playing = false
    state.hole = 0
end

--[[
    -- Type: Function
    -- Name: swing
    -- Use: Applies velocity to ball based on club and camera direction
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]
local function swing()
    if not state.ball then return end
    local dir = GetGameplayCamRot(2)
    local forward = vec3(-math.sin(dir.z * math.pi/180.0), math.cos(dir.z * math.pi/180.0), 0.0)
    local power = clubs[state.club].power
    FreezeEntityPosition(state.ball, false)
    ApplyForceToEntity(state.ball, 1, forward.x*power, forward.y*power, 1.0, 0.0,0.0,0.0, 0, false, true, true, false, true)
    state.stroke = state.stroke + 1
    state.total  = state.total + 1
end

--[[
    -- Type: Function
    -- Name: updateHud
    -- Use: Draws basic HUD with current game information
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]
local function updateHud()
    local data = holes[state.hole]
    local distance = 0
    if state.ball then
        distance = #(GetEntityCoords(state.ball) - data.finish)
    end
    DrawRect(0.5,0.93,0.2,0.04,0,0,0,150)
    SetTextFont(0)
    SetTextScale(0.35,0.35)
    SetTextColour(255,255,255,255)
    SetTextCentre(true)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(('Hole %d | Stroke %d | Total %d | %s | %dm'):format(state.hole, state.stroke, state.total, clubs[state.club].name, distance))
    EndTextCommandDisplayText(0.5,0.92)
end

--[[
    -- Type: Function
    -- Name: checkProgress
    -- Use: Determines if ball reached the current hole
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]
local function checkProgress()
    if not state.ball then return end
    local data = holes[state.hole]
    local distance = #(GetEntityCoords(state.ball) - data.finish)
    if distance <= 1.0 then
        state.hole = state.hole + 1
        if state.hole > #holes then
            endGolf()
        else
            startHole()
        end
    end
end

--[[
    -- Type: Thread
    -- Name: interactionThread
    -- Use: Handles player start and end commands
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]
CreateThread(function()
    while true do
        local wait = 500
        local player = PlayerPedId()
        local dist = #(GetEntityCoords(player) - courseStart)
        if dist < 30.0 then
            wait = 0
            DrawMarker(27, courseStart.x, courseStart.y, courseStart.z - 1.0, 0.0,0.0,0.0, 0.0,0.0,0.0, 1.5,1.5,1.0, 0,255,0,150, false,false,2,false,nil,nil,false)
        end
        if dist < startRadius then
            wait = 0
            if state.playing then
                displayHelp(('Press ~INPUT_CONTEXT~ to end golf'))
                if IsControlJustReleased(0, control.use) then
                    endGolf()
                end
            else
                displayHelp(('Press ~INPUT_CONTEXT~ to start golf'))
                if IsControlJustReleased(0, control.use) then
                    startGolf()
                end
            end
        elseif dist > exitRadius and state.playing then
            endGolf()
        end
        Wait(wait)
    end
end)

--[[
    -- Type: Thread
    -- Name: gameThread
    -- Use: Runs core game loop while playing
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]
CreateThread(function()
    while true do
        if state.playing then
            updateHud()
            checkProgress()
            if IsControlJustReleased(0, 24) then
                swing()
            end
            if IsControlJustReleased(0, 157) then state.club = 1 end
            if IsControlJustReleased(0, 158) then state.club = 2 end
            if IsControlJustReleased(0, 160) then state.club = 3 end
            if IsControlJustReleased(0, 164) then state.club = 4 end
        end
        Wait(0)
    end
end)

--[[
    -- Type: Event
    -- Name: onResourceStop
    -- Use: Cleans up when resource stops
    -- Created: 2024-04-27
    -- By: VSSVSSN
--]]
AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then
        cleanup()
    end
end)

