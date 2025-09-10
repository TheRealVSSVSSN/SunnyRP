--[[
    Spawn Manager
    Modernized player spawning logic for FiveM.
    Handles spawn points, automatic respawn and model loading.
    Refactored for maintainability and updated natives usage.
--]]

local SpawnManager = {
    points = {},
    autoEnabled = false,
    autoCallback = nil,
    spawnLock = false,
    nextId = 1,
    respawnForced = false,
    diedAt = nil
}

-- Support mapmanager map directives
AddEventHandler('getMapDirectives', function(add)
    add('spawnpoint', function(state, model)
        return function(opts)
            local x = opts.x or opts[1]
            local y = opts.y or opts[2]
            local z = opts.z or opts[3]
            local heading = opts.heading or 0.0

            -- slight offsets to avoid zero vector issues
            x, y, z = x + 0.0001, y + 0.0001, z + 0.0001
            heading = heading + 0.01

            local id = SpawnManager:addSpawnPoint({
                x = x,
                y = y,
                z = z,
                heading = heading,
                model = model
            })

            if not tonumber(model) then
                model = GetHashKey(model)
            end

            state.add('xyz', { x, y, z })
            state.add('model', model)
            state.add('idx', id)
        end
    end, function(state)
        for i, sp in ipairs(SpawnManager.points) do
            if sp.x == state.xyz[1] and sp.y == state.xyz[2] and sp.z == state.xyz[3] and sp.model == state.model then
                table.remove(SpawnManager.points, i)
                return
            end
        end
    end)
end)

-- Validate and register a spawn point
function SpawnManager:addSpawnPoint(spawn)
    assert(tonumber(spawn.x) and tonumber(spawn.y) and tonumber(spawn.z), 'invalid spawn position')
    assert(tonumber(spawn.heading), 'invalid spawn heading')

    local model = tonumber(spawn.model) or GetHashKey(spawn.model)
    assert(IsModelInCdimage(model), 'invalid spawn model')

    spawn.model = model
    spawn.idx = self.nextId
    self.nextId = self.nextId + 1
    table.insert(self.points, spawn)
    return spawn.idx
end

function SpawnManager:removeSpawnPoint(idx)
    for i = 1, #self.points do
        if self.points[i].idx == idx then
            table.remove(self.points, i)
            return
        end
    end
end

function SpawnManager:loadSpawns(jsonString)
    local data = json.decode(jsonString)
    assert(data and data.spawns, "no 'spawns' in JSON data")
    for _, spawn in ipairs(data.spawns) do
        self:addSpawnPoint(spawn)
    end
end

function SpawnManager:setAutoSpawn(enabled)
    self.autoEnabled = enabled
end

function SpawnManager:setAutoSpawnCallback(cb)
    self.autoCallback = cb
    self.autoEnabled = true
end

local function freezePlayer(id, freeze)
    local ped = GetPlayerPed(id)
    SetPlayerControl(id, not freeze, 0)

    if freeze then
        SetEntityVisible(ped, false, false)
        SetEntityCollision(ped, false, false)
        FreezeEntityPosition(ped, true)
        SetPlayerInvincible(id, true)
        if not IsPedFatallyInjured(ped) then
            ClearPedTasksImmediately(ped)
        end
    else
        SetEntityVisible(ped, true, false)
        SetEntityCollision(ped, true, true)
        FreezeEntityPosition(ped, false)
        SetPlayerInvincible(id, false)
    end
end

local function loadScene(x, y, z)
    if not NewLoadSceneStart then return end
    NewLoadSceneStart(x, y, z, 0.0, 0.0, 0.0, 20.0, 0)
    while IsNewLoadSceneActive() do
        NetworkUpdateLoadScene()
        Wait(0)
    end
end

function SpawnManager:spawnPlayer(spawnIdx, cb)
    if self.spawnLock then return end
    self.spawnLock = true

    CreateThread(function()
        if not spawnIdx then
            local count = #SpawnManager.points
            if count == 0 then
                print('[spawnmanager] no spawn points available')
                SpawnManager.spawnLock = false
                return
            end
            spawnIdx = math.random(1, count)
        end

        local spawn = type(spawnIdx) == 'table' and spawnIdx or SpawnManager.points[spawnIdx]
        if not spawn then
            print('[spawnmanager] invalid spawn index')
            SpawnManager.spawnLock = false
            return
        end

        if not spawn.skipFade then
            DoScreenFadeOut(500)
            while not IsScreenFadedOut() do
                Wait(0)
            end
        end

        freezePlayer(PlayerId(), true)

        if spawn.model then
            RequestModel(spawn.model)
            while not HasModelLoaded(spawn.model) do
                RequestModel(spawn.model)
                Wait(0)
            end
            SetPlayerModel(PlayerId(), spawn.model)
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
        ClearPlayerWantedLevel(PlayerId())

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

        freezePlayer(PlayerId(), false)
        TriggerEvent('playerSpawned', spawn)

        if cb then
            cb(spawn)
        end

        SpawnManager.spawnLock = false
    end)
end

function SpawnManager:forceRespawn()
    self.spawnLock = false
    self.respawnForced = true
end

-- Automatic spawning monitor thread
CreateThread(function()
    while true do
        Wait(50)
        local ped = PlayerPedId()
        if ped and ped ~= -1 then
            if SpawnManager.autoEnabled and NetworkIsPlayerActive(PlayerId()) then
                if (SpawnManager.diedAt and GetGameTimer() - SpawnManager.diedAt > 2000) or SpawnManager.respawnForced then
                    if SpawnManager.autoCallback then
                        SpawnManager.autoCallback()
                    else
                        SpawnManager:spawnPlayer()
                    end
                    SpawnManager.respawnForced = false
                end
            end

            if IsEntityDead(ped) then
                SpawnManager.diedAt = SpawnManager.diedAt or GetGameTimer()
            else
                SpawnManager.diedAt = nil
            end
        end
    end
end)

-- Exports
exports('spawnPlayer', function(...) SpawnManager:spawnPlayer(...) end)
exports('addSpawnPoint', function(...) return SpawnManager:addSpawnPoint(...) end)
exports('removeSpawnPoint', function(...) SpawnManager:removeSpawnPoint(...) end)
exports('loadSpawns', function(...) SpawnManager:loadSpawns(...) end)
exports('setAutoSpawn', function(...) SpawnManager:setAutoSpawn(...) end)
exports('setAutoSpawnCallback', function(...) SpawnManager:setAutoSpawnCallback(...) end)
exports('forceRespawn', function(...) SpawnManager:forceRespawn(...) end)

