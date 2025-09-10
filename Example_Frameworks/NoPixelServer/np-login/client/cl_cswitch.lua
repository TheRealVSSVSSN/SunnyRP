CreateThread(function()
    if NetworkIsSessionStarted() then
        TriggerEvent('LoadingScreen:close')
    end
end)

local waiting = false

local locations = {
    vec3(295.75341796875, -1351.5417480469, 24.537811279297),
    vec3(-1501.84, 857.4, 180.8),
    vec3(1768.31, 2515.12, 45.83), -- jail infirm
    vec3(343.68, -597.65, 43.29) -- pillbox bathroom
}

RegisterNetEvent('event:control:login')
AddEventHandler('event:control:login', function(useID)
    if not waiting then
        waiting = true

        local firstPress = GetGameTimer()

        CreateThread(function()
            local v = locations[useID]
            while true do
                Wait(0)

                local pedCoords = GetEntityCoords(PlayerPedId())

                if #(pedCoords - v) > 20.0 then waiting = false return end

                local curTime = GetGameTimer() * 0.001
                local timeRemaining = 30 - math.floor(curTime - (firstPress * 0.001))

                exports["np-base"]:getModule("Util"):DrawText("Switching character in ~b~" .. timeRemaining .. "~s~ seconds, press ~b~E~s~ to cancel.", 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)

                if IsControlJustPressed(0, 38) then
                    Wait(500)
                    waiting = false
                    return
                end
                if timeRemaining <= 0 then
                    TransitionToBlurred(500)
                    DoScreenFadeOut(500)
                    Wait(1000)
                    TriggerEvent("np-base:clearStates")
                    exports["np-base"]:getModule("SpawnManager"):Initialize()

                    waiting = false
                    return
                end
            end
        end)
    end
end)

-- #MarkedForMarker
CreateThread(function()
    while true do
        Wait(0)

        local pedCoords = GetEntityCoords(PlayerPedId())
        for _, v in ipairs(locations) do
            if #(pedCoords - v) < 200.0 then
                DrawMarker(27, v.x, v.y, v.z - 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0, 0, 155, 255, 10, false, false, 0, false, 0, 0, false)

                if #(pedCoords - v) < 1.0 and not waiting then
                    exports["np-base"]:getModule("Util"):DrawText("Press ~b~E~s~ to switch your ~b~ character", 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)
                end
            end
        end
    end
end)