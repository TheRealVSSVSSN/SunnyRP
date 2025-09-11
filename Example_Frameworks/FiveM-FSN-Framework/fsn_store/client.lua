--[[
    fsn_store - client
    Modernised store interaction and robbery logic
]]

--[[
    -- Type: Function
    -- Name: DrawText3D
    -- Use: Renders 3D text in world space
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
local function DrawText3D(x, y, z, text, color, scale)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(0)
        SetTextProportional(true)
        SetTextColour(color[1], color[2], color[3], color[4] or 255)
        SetTextCentre(true)
        BeginTextCommandDisplayText('STRING')
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayText(_x, _y)
    end
end

local stores = {
    {id = 'liquorace', coords = vector3(1392.3483886719, 3604.0036621094, 34.980926513672), blip = true, busy = false, gunstore = false},
    {id = 'ltdgas', coords = vector3(1698.4125976563, 4924.998046875, 42.063678741455), blip = true, busy = false, gunstore = false},
    {id = 'ltdgas', coords = vector3(-707.94940185547, -914.28442382813, 19.215589523315), blip = true, busy = false, gunstore = false},
    {id = 'ltdgas', coords = vector3(1163.341796875, -323.94161987305, 69.205139160156), blip = true, busy = false, gunstore = false},
    {id = 'ltdgas', coords = vector3(-48.42569732666, -1757.5212402344, 29.420993804932), blip = true, busy = false, gunstore = false},

    {id = 'robsliquor', coords = vector3(-1487.6705322266, -379.61917114258, 40.163394927979), blip = true, busy = false, gunstore = false},
    {id = 'robsliquor', coords = vector3(-2968.5520019531, 390.56546020508, 15.043312072754), blip = true, busy = false, gunstore = false},
    {id = 'robsliquor', coords = vector3(1166.4477539063, 2708.3881835938, 38.157699584961), blip = true, busy = false, gunstore = false},
    {id = 'robsliquor', coords = vector3(1136.1823730469, -981.75445556641, 46.415802001953), blip = true, busy = false, gunstore = false},
    {id = 'robsliquor', coords = vector3(-1223.4569091797, -906.90423583984, 12.3263463974), blip = true, busy = false, gunstore = false},

    {id = 'twentyfourseven', coords = vector3(25.816429138184, -1347.3413085938, 29.497024536133), blip = true, busy = false, gunstore = false},
    {id = 'twentyfourseven', coords = vector3(374.22787475586, 326.03570556641, 103.56636810303), blip = true, busy = false, gunstore = false},
    {id = 'twentyfourseven', coords = vector3(-3242.7116699219, 1001.4896240234, 12.830704689026), blip = true, busy = false, gunstore = false},
    {id = 'twentyfourseven', coords = vector3(1961.62890625, 3741.0764160156, 32.343776702881), blip = true, busy = false, gunstore = false},
    {id = 'twentyfourseven', coords = vector3(1730.2172851563, 6415.9599609375, 35.037227630615), blip = true, busy = false, gunstore = false},
    {id = 'twentyfourseven', coords = vector3(2678.9938964844, 3281.0151367188, 55.241138458252), blip = true, busy = false, gunstore = false},
    {id = 'twentyfourseven', coords = vector3(2557.4074707031, 382.74633789063, 108.62294769287), blip = true, busy = false, gunstore = false},

    {id = 'pillbox', coords = vector3(316.72573852539, -588.17431640625, 43.291801452637), blip = false, busy = false, gunstore = false},

    {id='ply_owner', coords = vector3(20.658050537109, -1106.4268798828, 29.797029495239), blip=true, busy=false, gunstore=true},
    {id='ply_owner', coords = vector3(252.50720214844, -48.169807434082, 69.941047668457), blip=true, busy=false, gunstore=true},
    {id='ply_owner', coords = vector3(-1305.5524902344, -392.48916625977, 36.695766448975), blip=true, busy=false, gunstore=true},
    {id='ply_owner', coords = vector3(-3172.5053710938, 1086.0944824219, 20.83874130249), blip=true, busy=false, gunstore=true},
    {id='ply_owner', coords = vector3(-331.59213256836, 6082.30859375, 31.454767227173), blip=true, busy=false, gunstore=true},
    {id='ply_owner', coords = vector3(1692.4958496094, 3758.3500976563, 34.705307006836), blip=true, busy=false, gunstore=true},
    {id='ply_owner', coords = vector3(2569.7351074219, 294.61560058594, 108.73488616943), blip=true, busy=false, gunstore=true},
    {id='ply_owner', coords = vector3(844.45977783203, -1033.3918457031, 28.194868087769), blip=true, busy=false, gunstore=true},
    {id='ply_owner', coords = vector3(-664.06213378906, -935.31024169922, 21.829229354858), blip=true, busy=false, gunstore=true},
    {id='ply_owner', coords = vector3(812.17529296875, -2157.5158691406, 29.619016647339), blip=true, busy=false, gunstore=true},
    {id='ply_owner', coords = vector3(-1119.0673828125, 2697.0854492188, 18.554151535034), blip=true, busy=false, gunstore=true},
}

local storekeepers = {
    {coords = vec4(-705.81408691406, -914.63317871094, 19.215587615967, 88.849708557129), ped = 0},
    {coords = vec4(-46.755832672119, -1758.6920166016, 29.421007156372, 50.685424804688), ped = 0},
    {coords = vec4(24.2922706604, -1347.4547119141, 29.497022628784, 270.94165039063), ped = 0},
    {coords = vec4(-1222.3319091797, -908.91625976563, 12.326347351074, 26.143705368042), ped = 0},
    {coords = vec4(-1486.1457519531, -377.66079711914, 40.163425445557, 139.18792724609), ped = 0},
    {coords = vec4(372.76062011719, 328.07223510742, 103.56637573242, 249.64683532715), ped = 0},
    {coords = vec4(1164.9409179688, -323.45886230469, 69.205146789551, 97.392929077148), ped = 0},
    {coords = vec4(1133.9039306641, -982.02099609375, 46.415802001953, 271.70544433594), ped = 0},
    {coords = vec4(1959.0269775391, 3741.3435058594, 32.343746185303, 299.91790771484), ped = 0},
    {coords = vec4(1166.1110839844, 2710.9475097656, 38.157703399658, 176.98136901855), ped = 0},
    {coords = vec4(1392.1517333984, 3606.2194824219, 34.980926513672, 201.22804260254), ped = 0},
    {coords = vec4(1697.9591064453, 4922.5615234375, 42.063674926758, 326.3063659668), ped = 0},
    {coords = vec4(316.4407043457, -587.11462402344, 43.291835784912, 184.49844360352), ped = 0},
}

local requireLicense = true
local weaponLicensePrice = 5000
local shopKeeperModel = joaat('mp_m_shopkeep_01')
local robbing = false
local robStart = 0
local lastRob = 0

--[[
    -- Type: Thread
    -- Name: createStoreBlips
    -- Use: Adds blips for store locations
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
CreateThread(function()
    for _, s in ipairs(stores) do
        if s.blip then
            local blip = AddBlipForCoord(s.coords.x, s.coords.y, s.coords.z)
            SetBlipSprite(blip, s.gunstore and 110 or 52)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(s.gunstore and 'Gun Store' or 'Store')
            EndTextCommandSetBlipName(blip)
        end
    end
end)

--[[
    -- Type: Thread
    -- Name: storeInteractionLoop
    -- Use: Handles entering store markers and opening inventory
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
CreateThread(function()
    while true do
        local wait = 1000
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        for _, s in ipairs(stores) do
            local dist = #(pos - s.coords)
            if dist < 10.0 then
                wait = 0
                DrawMarker(25, s.coords.x, s.coords.y, s.coords.z - 0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255,255,255,150, 0,0,2,0,0,0,0)
                if dist < 2.0 then
                    if not s.busy then
                        DrawText3D(s.coords.x, s.coords.y, s.coords.z, '[E] Access Store', {255,255,255,200}, 0.25)
                        if IsControlJustReleased(0, 38) then
                            if not s.gunstore then
                                TriggerServerEvent('fsn_store:request', s.id, false)
                            else
                                if not requireLicense or exports.fsn_licenses:fsn_hasLicense('weapon') then
                                    TriggerServerEvent('fsn_store:request', s.id, true)
                                else
                                    TriggerEvent('fsn_notify:displayNotification', 'This store requires a <b>WEAPON</b> license!', 'centerLeft', 3000, 'error')
                                end
                            end
                        end
                    else
                        DrawText3D(s.coords.x, s.coords.y, s.coords.z, '~r~Store in use\\n Please try again later', {255,255,255,200}, 0.25)
                    end
                end
            end
        end
        Wait(wait)
    end
end)

--[[
    -- Type: Thread
    -- Name: spawnStorekeepers
    -- Use: Spawns shopkeeper peds and keeps them alive
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
CreateThread(function()
    RequestModel(shopKeeperModel)
    while not HasModelLoaded(shopKeeperModel) do Wait(0) end
    for _, data in ipairs(storekeepers) do
        local c = data.coords
        data.ped = CreatePed(4, shopKeeperModel, c.x, c.y, c.z, c.w, false, true)
        SetBlockingOfNonTemporaryEvents(data.ped, true)
    end
    while true do
        Wait(5000)
        for _, data in ipairs(storekeepers) do
            if not DoesEntityExist(data.ped) or IsPedDeadOrDying(data.ped, true) then
                local c = data.coords
                RequestModel(shopKeeperModel)
                while not HasModelLoaded(shopKeeperModel) do Wait(0) end
                data.ped = CreatePed(4, shopKeeperModel, c.x, c.y, c.z, c.w, false, true)
                SetBlockingOfNonTemporaryEvents(data.ped, true)
            end
        end
    end
end)

--[[
    -- Type: Thread
    -- Name: robberyLoop
    -- Use: Handles robbing storekeepers
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        for _, keeper in ipairs(storekeepers) do
            local kcoords = vector3(keeper.coords.x, keeper.coords.y, keeper.coords.z)
            if #(pos - kcoords) < 10.0 and DoesEntityExist(keeper.ped) then
                if IsPlayerFreeAiming(PlayerId()) and IsPlayerFreeAimingAtEntity(PlayerId(), keeper.ped) then
                    if robbing then
                        TaskStandStill(keeper.ped, 3000)
                        TaskCower(keeper.ped, 3000)
                        if not IsEntityPlayingAnim(keeper.ped, 'random@mugging3', 'handsup_standing_base', 3) then
                            RequestAnimDict('random@mugging3')
                            TaskPlayAnim(keeper.ped, 'random@mugging3', 'handsup_standing_base', 4.0, -4.0, -1, 49, 0, false, false, false)
                        end
                        if GetGameTimer() - robStart > 30000 then
                            robbing = false
                            TriggerEvent('fsn_bank:change:walletAdd', math.random(100, 600))
                            TriggerEvent('fsn_inventory:item:add', 'dirty_money', math.random(500, 1000))
                            Wait(4000)
                        end
                    else
                        if GetGameTimer() - lastRob > 1800000 or lastRob == 0 then
                            if math.random(0,100) > 20 then
                                TaskStandStill(keeper.ped, 3000)
                                TaskCower(keeper.ped, 3000)
                                SetPedSweat(keeper.ped, 100.0)
                                robbing = true
                                robStart = GetGameTimer()
                                lastRob = GetGameTimer()
                                TriggerEvent('fsn_notify:displayNotification', 'Robbing...', 'centerLeft', 6000, 'info')
                                exports.fsn_progress:fsn_ProgressBar(58,133,255,'ROBBING',30)
                                if math.random(0,100) > 30 then
                                    local c = GetEntityCoords(ped)
                                    TriggerServerEvent('fsn_police:dispatch', {x=c.x,y=c.y,z=c.z}, 12, '10-31b | ARMED ROBBERY IN PROGRESS')
                                end
                            else
                                TaskCombatPed(keeper.ped, ped, 0, 16)
                                if math.random(0,100) > 30 then
                                    local c = GetEntityCoords(ped)
                                    TriggerServerEvent('fsn_police:dispatch', {x=c.x,y=c.y,z=c.z}, 12, '10-31b | ARMED ROBBERY IN PROGRESS')
                                end
                                robbing = false
                            end
                        else
                            TriggerEvent('fsn_notify:displayNotification', "You can't do that yet!", 'centerLeft', 6000, 'info')
                            local c = GetEntityCoords(ped)
                            TriggerServerEvent('fsn_police:dispatch', {x=c.x,y=c.y,z=c.z}, 12, '10-31b | Attempted armed store robbery')
                            Wait(6000)
                        end
                    end
                else
                    if robbing then
                        exports.fsn_progress:removeBar()
                        TriggerEvent('fsn_notify:displayNotification', 'You failed...', 'centerLeft', 6000, 'error')
                        robbing = false
                        Wait(6000)
                    end
                end
            end
        end
    end
end)

--[[
    -- Type: Thread
    -- Name: weaponLicensePurchase
    -- Use: Allows players to purchase a weapon license
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
local weaponLicLocation = vector3(14.055945396423, -1105.7650146484, 29.797029495239)
CreateThread(function()
    while true do
        local wait = 1000
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local dist = #(pos - weaponLicLocation)
        if dist < 2.0 then
            wait = 0
            DrawText3D(weaponLicLocation.x, weaponLicLocation.y, weaponLicLocation.z, ('Press ~g~[E]~s~ to buy a weapon\'s license for ~g~$%s'):format(weaponLicensePrice), {255,255,255,200}, 0.25)
            if IsControlJustReleased(0, 38) then
                local money = exports.fsn_main:fsn_GetWallet()
                if money >= weaponLicensePrice then
                    if not exports.fsn_licenses:fsn_hasLicense('weapon') then
                        TriggerEvent('fsn_licenses:police:give', 'weapon')
                        exports.mythic_notify:DoCustomHudText('success', 'You bought a weapons license with 0 infractions!', 4000)
                        TriggerEvent('fsn_bank:change:walletMinus', weaponLicensePrice)
                    else
                        exports.mythic_notify:DoCustomHudText('error', 'You already have a weapons license!', 4000)
                    end
                else
                    exports.mythic_notify:DoCustomHudText('error', 'You can not afford this!', 5000)
                end
            end
        end
        Wait(wait)
    end
end)

