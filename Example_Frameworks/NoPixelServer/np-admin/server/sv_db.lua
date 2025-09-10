NPX.Admin.DB = NPX.Admin.DB or {}

RegisterNetEvent('np-admin:searchRequest')
AddEventHandler('np-admin:searchRequest', function(hexId)
    if not hexId then return end
    local src = source
    local q = [[SELECT hex_id FROM users WHERE hex_id = @id LIMIT 1;]]
    local v = { id = hexId }

    exports.ghmattimysql:execute(q, v, function(result)
        TriggerClientEvent('np-admin:searchResult', src, result and result[1] ~= nil)
    end)
end)

function NPX.Admin.DB.giveCar(ownerHex, cid, model)
    if not ownerHex or not cid or not model then return end
    local q = [[INSERT INTO characters_cars (owner, cid, model, vehicle_state, fuel, engine_damage, body_damage, current_garage, license_plate)
    VALUES(@owner, @cid, @model, @vehicle_state, @fuel, @engine_damage, @body_damage, @current_garage, @license_plate);]]
    local v = {
        owner = ownerHex,
        cid = cid,
        model = model,
        vehicle_state = 'In',
        fuel = 100,
        engine_damage = 1000,
        body_damage = 1000,
        current_garage = 'T',
        license_plate = tostring(math.random(10000, 99999))
    }

    exports.ghmattimysql:execute(q, v)
end

function NPX.Admin.DB.UnbanSteamId(steamid)
    if not steamid then return end
    local q = [[DELETE FROM user_bans WHERE steam_id = @id;]]
    local v = { id = steamid }

    exports.ghmattimysql:execute(q, v)
end

function NPX.Admin.DB.IsPlayerBanned(target, callback)
    local user = exports['np-base']:getModule('Player'):GetUser(target)
    if not user then callback(false, true) return end
    local steamid = user:getVar('hexid')

    local q = [[SELECT 1 FROM user_bans WHERE steam_id = @id LIMIT 1;]]
    local v = { id = steamid }

    exports.ghmattimysql:execute(q, v, function(result)
        callback(result and result[1] ~= nil, false)
    end)
end

