--[[
    -- Type: Server
    -- Name: np-weapons server
    -- Use: Persists and retrieves weapon ammo values for players
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

local db = exports.ghmattimysql

RegisterNetEvent('np-weapons:getAmmo', function()
    local src = source
    local user = exports['np-base']:getModule('Player'):GetUser(src)
    if not user then return end
    local char = user:getCurrentCharacter()

    db:execute('SELECT type, ammo FROM characters_weapons WHERE id = @id', {
        ['@id'] = char.id
    }, function(result)
        local ammoTable = {}
        for _, row in ipairs(result) do
            ammoTable[row.type] = { ammo = row.ammo, type = row.type }
        end
        TriggerClientEvent('np-items:SetAmmo', src, ammoTable)
    end)
end)

RegisterNetEvent('np-weapons:updateAmmo', function(newAmmo, ammoType)
    local src = source
    local user = exports['np-base']:getModule('Player'):GetUser(src)
    if not user then return end
    local char = user:getCurrentCharacter()

    db:execute('SELECT ammo FROM characters_weapons WHERE type = @type AND id = @identifier', {
        ['@type'] = ammoType,
        ['@identifier'] = char.id
    }, function(result)
        if result[1] then
            db:execute('UPDATE characters_weapons SET ammo = @newammo WHERE type = @type AND id = @identifier', {
                ['@newammo'] = newAmmo,
                ['@type'] = ammoType,
                ['@identifier'] = char.id
            })
        else
            db:execute('INSERT INTO characters_weapons (id, type, ammo) VALUES (@identifier, @type, @ammo)', {
                ['@identifier'] = char.id,
                ['@type'] = ammoType,
                ['@ammo'] = newAmmo
            })
        end
    end)
end)

