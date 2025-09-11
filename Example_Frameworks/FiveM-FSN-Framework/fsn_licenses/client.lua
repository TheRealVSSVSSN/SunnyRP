local licenses = {}
local name = ''
local charid = 0

--[[
    -- Type: Function
    -- Name: saveLicenses
    -- Use: Sends current license table to the server for persistence
    -- Created: 2024-07-13
    -- By: VSSVSSN
--]]
local function saveLicenses()
    TriggerServerEvent('fsn_licenses:save', charid, json.encode(licenses))
end

--[[
    -- Type: Event
    -- Name: fsn_main:character
    -- Use: Initializes license data when a character loads
    -- Created: 2024-07-13
    -- By: VSSVSSN
--]]
AddEventHandler('fsn_main:character', function(char)
    if char.char_licenses ~= '' then
        licenses = json.decode(char.char_licenses)
    else
        licenses = {}
    end

    name = string.format('%s %s', char.char_fname, char.char_lname)
    charid = char.char_id

    if licenses["driver"] then
        TriggerServerEvent('fsn_licenses:check', 'driver', licenses['driver'].infractions, licenses['driver'].date)
    end
end)

--[[
    -- Type: Function
    -- Name: fsn_NearestPlayersC
    -- Use: Returns server IDs for players within a radius
    -- Created: 2024-07-13
    -- By: VSSVSSN
--]]
function fsn_NearestPlayersC(x, y, z, radius)
    local players = {}
    for _, id in ipairs(GetActivePlayers()) do
        local ppos = GetEntityCoords(GetPlayerPed(id))
        if #(ppos - vector3(x, y, z)) < radius then
            table.insert(players, GetPlayerServerId(id))
        end
    end
    return players
end

--[[
    -- Type: Event
    -- Name: fsn_licenses:updateStatus
    -- Use: Updates local license status and informs the player
    -- Created: 2024-07-13
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_licenses:updateStatus')
AddEventHandler('fsn_licenses:updateStatus', function(type, status)
    TriggerEvent('fsn_notify:displayNotification', 'YOUR '..type..' LICENSE HAS BEEN '..status, 'centerLeft', 10000, 'alert')
    if licenses[type] then
        licenses[type].status = status
        saveLicenses()
    end
end)

--[[
    -- Type: Event
    -- Name: fsn_licenses:showid
    -- Use: Displays ID information to nearby players
    -- Created: 2024-07-13
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_licenses:showid')
AddEventHandler('fsn_licenses:showid', function()
    local pos = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('fsn_licenses:chat', name, {
        type = 'id',
        charid = charid,
        job = exports.fsn_jobs:fsn_GetJob()
    }, fsn_NearestPlayersC(pos.x, pos.y, pos.z, 5))
end)

--[[
    -- Type: Event
    -- Name: fsn_licenses:infraction
    -- Use: Adds infraction points to a license
    -- Created: 2024-07-13
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_licenses:infraction')
AddEventHandler('fsn_licenses:infraction', function(type, amt)
    licenses[type].infractions = licenses[type].infractions + amt
    saveLicenses()
    TriggerServerEvent('fsn_licenses:check', type, licenses[type].infractions, licenses[type].date)
end)

--[[
    -- Type: Event
    -- Name: fsn_licenses:setinfractions
    -- Use: Sets infraction points and adjusts status accordingly
    -- Created: 2024-07-13
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_licenses:setinfractions')
AddEventHandler('fsn_licenses:setinfractions', function(type, amt)
    if amt <= 15 then
        licenses[type].status = 'ACTIVE'
    else
        licenses[type].status = 'SUSPENDED'
    end
    licenses[type].infractions = amt
    saveLicenses()
end)

--[[
    -- Type: Event
    -- Name: fsn_licenses:display
    -- Use: Shares license data with nearby players
    -- Created: 2024-07-13
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_licenses:display')
AddEventHandler('fsn_licenses:display', function(requested)
    local pos = GetEntityCoords(PlayerPedId())
    local nearby = fsn_NearestPlayersC(pos.x, pos.y, pos.z, 5)

    if requested == 'all' then
        for _, lic in pairs(licenses) do
            TriggerServerEvent('fsn_licenses:chat', name, lic, nearby)
        end
        return
    end

    local lic = licenses[requested]
    if lic then
        TriggerServerEvent('fsn_licenses:chat', name, lic, nearby)
    else
        TriggerEvent('fsn_notify:displayNotification', 'You do not have a '..requested..' license.', 'centerLeft', 4000, 'error')
    end
end)

--[[
    -- Type: Event
    -- Name: fsn_licenses:police:give
    -- Use: Issues a new license to the player
    -- Created: 2024-07-13
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_licenses:police:give')
AddEventHandler('fsn_licenses:police:give', function(type)
    licenses[type] = {
        date = os.time(),
        type = type,
        infractions = 0,
        status = 'ACTIVE'
    }
    saveLicenses()
end)

--[[
    -- Type: Function
    -- Name: fsn_hasLicense
    -- Use: Exported helper to check license existence
    -- Created: 2024-07-13
    -- By: VSSVSSN
--]]
function fsn_hasLicense(type)
    return licenses[type] ~= nil
end

--[[
    -- Type: Function
    -- Name: fsn_getLicensePoints
    -- Use: Exported helper to return infraction points or 100 if missing
    -- Created: 2024-07-13
    -- By: VSSVSSN
--]]
function fsn_getLicensePoints(type)
    return licenses[type] and licenses[type].infractions or 100
end

--[[
    -- Type: Table
    -- Name: license_stores
    -- Use: Holds configuration for license purchase locations
    -- Created: 2024-07-13
    -- By: VSSVSSN
--]]
local blip = {x = 237.59239196777, y = -406.15228271484, z = 47.924365997314}
local license_stores = {
    {
        loc = {x = 233.22550964355, y = -410.34426879883, z = 48.11198425293},
        store = 'driver',
        cost = 500,
        text = 'Press ~INPUT_PICKUP~ to buy a drivers license (~g~$500~w~)'
    },
    {
        loc = {x = 238.16859436035, y = -412.05615234375, z = 48.11194229126},
        store = 'pilot',
        cost = 75000,
        text = 'Press ~INPUT_PICKUP~ to buy a pilots license (~g~$75,000~w~)'
    }
}

--[[
    -- Type: Function
    -- Name: buyLicense
    -- Use: Handles license purchase logic
    -- Created: 2024-07-13
    -- By: VSSVSSN
--]]
local function buyLicense(index)
    local store = license_stores[index]
    if store.store == 'driver' then
        if tonumber(exports.fsn_main:fsn_GetWallet()) >= store.cost then
            if licenses['driver'] then
                if licenses['driver'].status ~= 'EXPIRED' then
                    TriggerEvent('fsn_notify:displayNotification', 'Your current license cannot be replaced', 'centerLeft', 4000, 'error')
                else
                    TriggerEvent('fsn_bank:change:walletMinus', 250)
                    TriggerEvent('fsn_notify:displayNotification', 'You updated your current license for <span style="color:limegreen">$250', 'centerLeft', 6000, 'success')
                    licenses['driver'].date = os.time()
                    licenses['driver'].infractions = 0
                    licenses['driver'].status = 'ACTIVE'
                    saveLicenses()
                end
            else
                licenses['driver'] = {
                    date = os.time(),
                    type = 'driver',
                    infractions = 0,
                    status = 'ACTIVE'
                }
                TriggerEvent('fsn_bank:change:walletMinus', 500)
                TriggerEvent('fsn_notify:displayNotification', 'You bought a new license for <span style="color:limegreen">$500', 'centerLeft', 6000, 'success')
                saveLicenses()
            end
        else
            TriggerEvent('fsn_notify:displayNotification', 'You do not have enough cash.', 'centerLeft', 4000, 'error')
        end
    elseif store.store == 'pilot' then
        if tonumber(exports.fsn_main:fsn_GetWallet()) >= store.cost then
            -- Pilot license purchase flow can be implemented here
        else
            TriggerEvent('fsn_notify:displayNotification', 'You do not have a enough cash.', 'centerLeft', 4000, 'error')
        end
    end
end

--[[
    -- Type: Thread
    -- Name: License Center Thread
    -- Use: Draws markers and handles interaction for license purchases
    -- Created: 2024-07-13
    -- By: VSSVSSN
--]]
Citizen.CreateThread(function()
    local bleep = AddBlipForCoord(blip.x, blip.y, blip.z)
    SetBlipSprite(bleep, 498)
    SetBlipAsShortRange(bleep, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("License Center")
    EndTextCommandSetBlipName(bleep)

    while true do
        Citizen.Wait(0)
        for k, v in pairs(license_stores) do
            if GetDistanceBetweenCoords(v.loc.x, v.loc.y, v.loc.z, GetEntityCoords(PlayerPedId()), true) < 10 then
                DrawMarker(1, v.loc.x, v.loc.y, v.loc.z - 1, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.4001, 0, 155, 255, 175, 0, 0, 0, 0)
                if GetDistanceBetweenCoords(v.loc.x, v.loc.y, v.loc.z, GetEntityCoords(PlayerPedId()), true) < 1 then
                    SetTextComponentFormat("STRING")
                    AddTextComponentString(v.text)
                    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                    if IsControlJustPressed(0, 38) then
                        buyLicense(k)
                    end
                end
            end
        end
    end
end)

