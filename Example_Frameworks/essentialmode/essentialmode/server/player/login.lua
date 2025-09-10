--[[
    -- Type: Server
    -- Name: PlayerLogin
    -- Use: Handles player authentication and data persistence
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]

local function LoadUser(identifier, source, isNew)
    local result = MySQL.query.await('SELECT permission_level, money, identifier, `group` FROM users WHERE identifier = ?', {identifier})
    if not result[1] then return end
    local group = groups[result[1].group]
    Users[source] = Player(source, result[1].permission_level, result[1].money, result[1].identifier, group)
    TriggerEvent('es:playerLoaded', source, Users[source])
    if settings.defaultSettings.enableRankDecorators then
        TriggerClientEvent('es:setPlayerDecorator', source, 'rank', Users[source]:getPermissions(), true)
    end
    if isNew then
        TriggerEvent('es:newPlayerLoaded', source, Users[source])
    end
end

--[[
    -- Type: Function
    -- Name: isIdentifierBanned
    -- Use: Checks if identifier currently has an active ban
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
function isIdentifierBanned(id)
    local result = MySQL.query.await('SELECT expires FROM bans WHERE banned = ?', {id})
    for _, v in ipairs(result) do
        if v.expires == -1 or v.expires > os.time() then
            return true
        end
    end
    return false
end

AddEventHandler('es:getPlayers', function(cb)
    cb(Users)
end)

local function hasAccount(identifier)
    local exists = MySQL.scalar.await('SELECT 1 FROM users WHERE identifier = ?', {identifier})
    return exists ~= nil
end

local function registerUser(identifier, source)
    if not hasAccount(identifier) then
        MySQL.insert.await('INSERT INTO users (`identifier`, `permission_level`, `money`, `group`) VALUES (?, 0, ?, "user")', {
            identifier,
            settings.defaultSettings.startingCash
        })
        LoadUser(identifier, source, true)
    else
        LoadUser(identifier, source, false)
    end
end

_G.registerUser = registerUser

RegisterNetEvent('es:setPlayerData')
AddEventHandler('es:setPlayerData', function(user, k, v, cb)
    if Users[user] and Users[user][k] then
        if k ~= 'money' then
            Users[user][k] = v
            MySQL.update.await(('UPDATE users SET `%s` = ? WHERE identifier = ?'):format(k), {v, Users[user].identifier})
            if k == 'group' then
                Users[user].group = groups[v]
            end
        end
        cb('Player data edited.', true)
    else
        cb('Column does not exist!', false)
    end
end)

RegisterNetEvent('es:setPlayerDataId')
AddEventHandler('es:setPlayerDataId', function(user, k, v, cb)
    MySQL.update.await(('UPDATE users SET `%s` = ? WHERE identifier = ?'):format(k), {v, user})
    cb('Player data edited.', true)
end)

RegisterNetEvent('es:getPlayerFromId')
AddEventHandler('es:getPlayerFromId', function(user, cb)
    cb(Users and Users[user])
end)

RegisterNetEvent('es:getPlayerFromIdentifier')
AddEventHandler('es:getPlayerFromIdentifier', function(identifier, cb)
    local result = MySQL.query.await('SELECT permission_level, money, identifier, `group` FROM users WHERE identifier = ?', {identifier})
    cb(result[1])
end)

RegisterNetEvent('es:getAllPlayers')
AddEventHandler('es:getAllPlayers', function(cb)
    local result = MySQL.query.await('SELECT permission_level, money, identifier, `group` FROM users', {})
    cb(result)
end)

--[[
    -- Type: Function
    -- Name: savePlayerMoney
    -- Use: Periodically writes player money to the database
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
local function savePlayerMoney()
    SetTimeout(60000, function()
        for _, v in pairs(Users) do
            MySQL.update('UPDATE users SET money = ? WHERE identifier = ?', {v.money, v.identifier})
        end
        savePlayerMoney()
    end)
end

savePlayerMoney()
