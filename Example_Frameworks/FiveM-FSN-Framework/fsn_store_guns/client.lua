local stores = {
    {id = 'gunstore_1', coords = vec3(20.65805, -1106.42688, 29.79703)},
    {id = 'gunstore_2', coords = vec3(252.5072, -48.16981, 69.94105)},
    {id = 'gunstore_3', coords = vec3(-1305.55249, -392.48917, 36.69577)},
    {id = 'gunstore_4', coords = vec3(-3172.50537, 1086.09448, 20.83874)},
    {id = 'gunstore_5', coords = vec3(-331.59213, 6082.30859, 31.45477)},
    {id = 'gunstore_6', coords = vec3(1692.49585, 3758.3501, 34.70531)},
    {id = 'gunstore_7', coords = vec3(2569.73511, 294.6156, 108.73489)},
    {id = 'gunstore_8', coords = vec3(844.45978, -1033.39185, 28.19487)},
    {id = 'gunstore_9', coords = vec3(-664.06213, -935.31024, 21.82923)},
    {id = 'gunstore_10', coords = vec3(812.17529, -2157.51587, 29.61902)},
    {id = 'gunstore_11', coords = vec3(-1119.06738, 2697.08545, 18.55415)}
}

local requireLicense = false

--[[
    -- Type: Function
    -- Name: handleStoreInteraction
    -- Use: Manages player interaction for a single gun store
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
local function handleStoreInteraction(store, playerCoords)
    local distance = #(playerCoords - store.coords)
    if distance < 10.0 then
        DrawMarker(25, store.coords.x, store.coords.y, store.coords.z - 0.95, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 150, false, true, 2, false, false, false, false)
        if distance < 1.0 then
            Util.DrawText3D(store.coords.x, store.coords.y, store.coords.z, '[E] Access Store', {255,255,255,200}, 0.25)
            if IsControlJustReleased(0, Util.GetKeyNumber('E')) then
                if requireLicense and not exports['fsn_licenses']:fsn_hasLicense('weapon') then
                    TriggerEvent('fsn_notify:displayNotification', 'This store requires a <b>WEAPON</b> license!', 'centerLeft', 3000, 'error')
                else
                    TriggerServerEvent('fsn_store_guns:request', store.id)
                end
            end
        end
    end
end

--[[
    -- Type: Thread
    -- Name: StoreLoop
    -- Use: Monitors player proximity to gun stores and handles access
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
CreateThread(function()
    while true do
        Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        for _, store in ipairs(stores) do
            handleStoreInteraction(store, playerCoords)
        end
    end
end)

--[[
    -- Type: Thread
    -- Name: BlipCreator
    -- Use: Generates map blips for each gun store location
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
CreateThread(function()
    for _, store in ipairs(stores) do
        local blip = AddBlipForCoord(store.coords.x, store.coords.y, store.coords.z)
        SetBlipSprite(blip, 110)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Gun Store")
        EndTextCommandSetBlipName(blip)
    end
end)

--[[
    -- Type: Thread
    -- Name: LicensePurchase
    -- Use: Allows the player to purchase a weapon license
    -- Created: 2025-09-11
    -- By: VSSVSSN
--]]
local weaponLicLocation = vec3(14.05595, -1105.76501, 29.79703)
local weaponLicensePrice = 5000

CreateThread(function()
    while true do
        Wait(0)
        local playerPos = GetEntityCoords(PlayerPedId())
        local dist = #(playerPos - weaponLicLocation)
        if dist < 2.0 then
            Util.DrawText3D(weaponLicLocation.x, weaponLicLocation.y, weaponLicLocation.z, 'Press ~g~[ E ] ~s~ to buy a weapon\'s license for ~g~$~w~'..weaponLicensePrice, {255,255,255,200}, 0.25)
            local money = exports.fsn_main:fsn_GetWallet()
            if IsControlJustPressed(0, Util.GetKeyNumber('E')) then
                if money >= weaponLicensePrice then
                    if not exports['fsn_licenses']:fsn_hasLicense('weapon') then
                        TriggerEvent('fsn_licenses:police:give', 'weapon')
                        exports['mythic_notify']:DoCustomHudText('success', 'You bought a weapons license with 0 infractions!', 4000)
                        TriggerEvent('fsn_bank:change:walletMinus', weaponLicensePrice)
                    else
                        exports['mythic_notify']:DoCustomHudText('error', 'You already have a weapons license!', 4000)
                    end
                else
                    exports['mythic_notify']:DoCustomHudText('error', 'You can not afford this!', 5000)
                end
            end
        end
    end
end)

