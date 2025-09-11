--[[
    -- Type: Client Script
    -- Name: Ragdoll Respawn
    -- Use: Handles death detection, respawn timer and revival
    -- Created: 2024-02-23
    -- By: VSSVSSN
--]]

local isDead = false
local respawnTimer = 0
local respawnDelay = 300 -- seconds
local holdCounter = 0
local spawnLocation = vector3(357.43, -593.36, 28.79)

--[[
    -- Type: Function
    -- Name: drawTxt
    -- Use: Renders 2D text on screen
--]]
local function drawTxt(x, y, width, height, scale, text, r, g, b, a)
    SetTextFont(4)
    SetTextProportional(false)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextOutline()
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x - width / 2, y - height / 2)
end

--[[
    -- Type: Function
    -- Name: handleRespawnLoop
    -- Use: Displays timer and handles manual respawn
--]]
local function handleRespawnLoop()
    CreateThread(function()
        while isDead do
            Wait(0)
            if respawnTimer > 0 then
                drawTxt(0.9, 1.4, 1.0, 1.0, 0.6, ('Respawn in ~r~%s~w~s'):format(math.ceil(respawnTimer)), 255, 255, 255, 255)
                respawnTimer = respawnTimer - 0.1
            else
                drawTxt(0.9, 1.4, 1.0, 1.0, 0.6, ('Hold ~r~E~w~ to respawn (%s)'):format(math.floor(holdCounter / 100)), 255, 255, 255, 255)
                if IsControlPressed(0, 38) then -- INPUT_CONTEXT
                    holdCounter = holdCounter + 1
                    if holdCounter >= 300 then -- 3 seconds
                        respawnPlayer()
                    end
                else
                    holdCounter = 0
                end
            end
        end
    end)
end

--[[
    -- Type: Function
    -- Name: setPlayerDead
    -- Use: Marks player as dead and starts timer
--]]
function setPlayerDead()
    local ped = PlayerPedId()
    SetEntityInvincible(ped, true)
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    isDead = true
    respawnTimer = respawnDelay
    TriggerServerEvent('ragdoll:playerDied', GetPedCauseOfDeath(ped))
    handleRespawnLoop()
end

--[[
    -- Type: Function
    -- Name: respawnPlayer
    -- Use: Revives player at the configured location
--]]
function respawnPlayer()
    local ped = PlayerPedId()
    NetworkResurrectLocalPlayer(spawnLocation.x, spawnLocation.y, spawnLocation.z, 0.0, true, false)
    ClearPedBloodDamage(ped)
    SetEntityInvincible(ped, false)
    isDead = false
    holdCounter = 0
    TriggerServerEvent('ragdoll:playerRevived')
end

--[[
    -- Type: Thread
    -- Name: deathWatcher
    -- Use: Watches for death state
--]]
CreateThread(function()
    while true do
        Wait(250)
        if IsEntityDead(PlayerPedId()) and not isDead then
            setPlayerDead()
        end
    end
end)

--[[ Event Bindings ]]--
RegisterNetEvent('ragdoll:revive', respawnPlayer)
RegisterNetEvent('ragdoll:doCPR', respawnPlayer)
RegisterNetEvent('ragdoll:setDead', setPlayerDead)
