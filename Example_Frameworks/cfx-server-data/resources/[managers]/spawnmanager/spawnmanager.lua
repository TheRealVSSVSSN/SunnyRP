--[[
    -- Type: Module
    -- Name: SpawnManager
    -- Use: Handles player spawning in a unified manner
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

local SpawnManager = {
    points = {},
    auto = false,
    autoCallback = nil,
    nextId = 1,
    lock = false,
    respawnForced = false,
    deathTime = nil
}

--[[
    -- Type: Event
    -- Name: getMapDirectives
    -- Use: Registers spawnpoints defined in map files
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
AddEventHandler('getMapDirectives', function(add)
    add('spawnpoint', function(state, model)
        return function(opts)
            local ok, err = pcall(function()
                local x = tonumber(opts.x or opts[1])
                local y = tonumber(opts.y or opts[2])
                local z = tonumber(opts.z or opts[3])
                local heading = tonumber(opts.heading) or 0.0

                if x and y and z then
                    SpawnManager.addPoint({
                        x = x + 0.0001,
                        y = y + 0.0001,
                        z = z + 0.0001,
                        heading = heading + 0.01,
                        model = model
                    })

                    if type(model) ~= 'number' then
                        model = joaat(model)
                    end

                    state.add('xyz', { x, y, z })
                    state.add('model', model)
                else
                    error('invalid spawn options')
                end
            end)

            if not ok then
                print('[spawnmanager] '..err)
            end
        end
    end, function(state)
        for i, sp in ipairs(SpawnManager.points) do
            if sp.x == state.xyz[1] and sp.y == state.xyz[2] and sp.z == state.xyz[3] and sp.model == state.model then
                table.remove(SpawnManager.points, i)
                break
            end
        end
    end)
end)

--[[
    -- Type: Function
    -- Name: loadSpawns
    -- Use: Loads spawn points from a JSON string
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function SpawnManager.loadSpawns(spawnString)
    local data = json.decode(spawnString)
    if not data or not data.spawns then
        error("no 'spawns' in JSON data")
    end

    for _, spawn in ipairs(data.spawns) do
        SpawnManager.addPoint(spawn)
    end
end

--[[
    -- Type: Function
    -- Name: addPoint
    -- Use: Validates and registers a spawn point
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function SpawnManager.addPoint(spawn)
    local x, y, z = tonumber(spawn.x), tonumber(spawn.y), tonumber(spawn.z)
    if not (x and y and z) then
        error('invalid spawn position')
    end

    local heading = tonumber(spawn.heading) or 0.0

    local model = spawn.model
    if model then
        if type(model) ~= 'number' then
            model = joaat(model)
        end

        if not IsModelInCdimage(model) then
            error('invalid spawn model')
        end
    end

    spawn.x, spawn.y, spawn.z, spawn.heading = x, y, z, heading
    spawn.model = model
    spawn.idx = SpawnManager.nextId
    SpawnManager.nextId = SpawnManager.nextId + 1

    table.insert(SpawnManager.points, spawn)
    return spawn.idx
end

--[[
    -- Type: Function
    -- Name: removePoint
    -- Use: Removes a spawn point by index
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function SpawnManager.removePoint(idx)
    for i = 1, #SpawnManager.points do
        if SpawnManager.points[i].idx == idx then
            table.remove(SpawnManager.points, i)
            break
        end
    end
end

--[[
    -- Type: Function
    -- Name: setAutoSpawn
    -- Use: Toggles automatic respawn
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function SpawnManager.setAutoSpawn(enabled)
    SpawnManager.auto = enabled and true or false
end

--[[
    -- Type: Function
    -- Name: setAutoSpawnCallback
    -- Use: Sets a custom callback for automatic respawn
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function SpawnManager.setAutoSpawnCallback(cb)
    SpawnManager.autoCallback = cb
    SpawnManager.auto = true
end

--[[
    -- Type: Function
    -- Name: freezePlayer
    -- Use: Freezes or unfreezes the player
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function freezePlayer(id, freeze)
    local ped = GetPlayerPed(id)
    SetPlayerControl(id, not freeze, 0)

    if not freeze then
        if not IsEntityVisible(ped) then
            SetEntityVisible(ped, true)
        end

        if not IsPedInAnyVehicle(ped) then
            SetEntityCollision(ped, true)
        end

        FreezeEntityPosition(ped, false)
        SetPlayerInvincible(id, false)
    else
        if IsEntityVisible(ped) then
            SetEntityVisible(ped, false)
        end

        SetEntityCollision(ped, false)
        FreezeEntityPosition(ped, true)
        SetPlayerInvincible(id, true)

        if not IsPedFatallyInjured(ped) then
            ClearPedTasksImmediately(ped)
        end
    end
end

--[[
    -- Type: Function
    -- Name: loadScene
    -- Use: Preloads map data around coordinates
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function loadScene(x, y, z)
    if not NewLoadSceneStart then
        return
    end

    NewLoadSceneStart(x, y, z, 0.0, 0.0, 0.0, 20.0, 0)

    while IsNewLoadSceneActive() do
        NetworkUpdateLoadScene()
        Wait(0)
    end
end

--[[
    -- Type: Function
    -- Name: spawnPlayer
    -- Use: Spawns the player at a specified or random spawn point
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function SpawnManager.spawnPlayer(spawnIdx, cb)
    if SpawnManager.lock then
        return
    end
    SpawnManager.lock = true

    CreateThread(function()
        if not spawnIdx then
            spawnIdx = GetRandomIntInRange(1, #SpawnManager.points + 1)
        end

        local spawn = type(spawnIdx) == 'table' and spawnIdx or SpawnManager.points[spawnIdx]
        if spawn then
            spawn.x = spawn.x + 0.0
            spawn.y = spawn.y + 0.0
            spawn.z = spawn.z + 0.0
            spawn.heading = spawn.heading + 0.0
        end

        if not spawn then
            print('[spawnmanager] invalid spawn index')
            SpawnManager.lock = false
            return
        end

        if not spawn.skipFade then
            DoScreenFadeOut(500)
            while not IsScreenFadedOut() do
                Wait(0)
            end
        end

        local playerId = PlayerId()
        freezePlayer(playerId, true)

        if spawn.model then
            RequestModel(spawn.model)
            while not HasModelLoaded(spawn.model) do
                RequestModel(spawn.model)
                Wait(0)
            end

            SetPlayerModel(playerId, spawn.model)
            SetModelAsNoLongerNeeded(spawn.model)

            if N_0x283978a15512b2fe then
                N_0x283978a15512b2fe(PlayerPedId(), true)
            end
        end

        RequestCollisionAtCoord(spawn.x, spawn.y, spawn.z)

        local ped = PlayerPedId()
        SetEntityCoordsNoOffset(ped, spawn.x, spawn.y, spawn.z, false, false, false, true)
        NetworkResurrectLocalPlayer(spawn.x, spawn.y, spawn.z, spawn.heading, true, true, false)

        ClearPedTasksImmediately(ped)
        RemoveAllPedWeapons(ped)
        ClearPlayerWantedLevel(playerId)

        local time = GetGameTimer()
        while not HasCollisionLoadedAroundEntity(ped) and (GetGameTimer() - time) < 5000 do
            Wait(0)
        end

        ShutdownLoadingScreen()

        if IsScreenFadedOut() then
            DoScreenFadeIn(500)
            while not IsScreenFadedIn() do
                Wait(0)
            end
        end

        freezePlayer(playerId, false)
        TriggerEvent('playerSpawned', spawn)

        if cb then
            cb(spawn)
        end

        SpawnManager.lock = false
    end)
end

--[[
    -- Type: Thread
    -- Name: AutoRespawnMonitor
    -- Use: Monitors player death and triggers auto respawn
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
CreateThread(function()
    while true do
        Wait(50)

        local ped = PlayerPedId()
        if ped and ped ~= -1 then
            if SpawnManager.auto and NetworkIsPlayerActive(PlayerId()) then
                if (SpawnManager.deathTime and (GetGameTimer() - SpawnManager.deathTime) > 2000) or SpawnManager.respawnForced then
                    if SpawnManager.autoCallback then
                        SpawnManager.autoCallback()
                    else
                        SpawnManager.spawnPlayer()
                    end

                    SpawnManager.respawnForced = false
                end
            end

            if IsEntityDead(ped) then
                if not SpawnManager.deathTime then
                    SpawnManager.deathTime = GetGameTimer()
                end
            else
                SpawnManager.deathTime = nil
            end
        end
    end
end)

--[[
    -- Type: Function
    -- Name: forceRespawn
    -- Use: Forces the player to respawn immediately
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function SpawnManager.forceRespawn()
    SpawnManager.lock = false
    SpawnManager.respawnForced = true
end

-- exported functions
exports('spawnPlayer', function(...) SpawnManager.spawnPlayer(...) end)
exports('addSpawnPoint', function(...) return SpawnManager.addPoint(...) end)
exports('removeSpawnPoint', function(...) SpawnManager.removePoint(...) end)
exports('loadSpawns', function(...) SpawnManager.loadSpawns(...) end)
exports('setAutoSpawn', function(...) SpawnManager.setAutoSpawn(...) end)
exports('setAutoSpawnCallback', function(...) SpawnManager.setAutoSpawnCallback(...) end)
exports('forceRespawn', function(...) SpawnManager.forceRespawn(...) end)

