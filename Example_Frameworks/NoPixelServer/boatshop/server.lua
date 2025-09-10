RegisterServerEvent('ply_docks:CheckForSpawnBoat')
RegisterServerEvent('ply_docks:CheckForBoat')
RegisterServerEvent('ply_docks:SetBoatOut')
RegisterServerEvent('ply_docks:GetBoats')
RegisterServerEvent('ply_docks:CheckForSelBoat')
RegisterServerEvent('ply_docks:Lang')



--[[Function]]--

-- Removed legacy helpers in favor of inline database lookups.



--[[Local/Global]]--

local state_in, state_out = "In", "Out"
local boats = {}



--[[Events]]--


--Langage
AddEventHandler('ply_docks:Lang', function(lang)
    local lang = lang
    if lang == "FR" then
        state_in = "Rentré"
        state_out = "Sortit"
    elseif lang == "EN" then
        state_in = "In"
        state_out = "Out"
    end
end)


--Dock

AddEventHandler('ply_docks:CheckForSpawnBoat', function(boat_id)
    local boat_id = boat_id
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    exports.ghmattimysql:execute("SELECT * FROM user_boat WHERE identifier = @identifier AND id = @id", { ['@identifier'] = char.id, ['@id'] = boat_id }, function(data)
        TriggerClientEvent('ply_docks:SpawnBoat', source, data[1].boat_model, data[1].boat_plate, data[1].boat_state, data[1].boat_colorprimary, data[1].boat_colorsecondary, data[1].boat_pearlescentcolor, data[1].boat_wheelcolor)
    end)
end)

AddEventHandler('ply_docks:CheckForBoat', function(plate)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    exports.ghmattimysql:scalar(
        "SELECT boat_plate FROM user_boat WHERE identifier=@identifier AND boat_plate=@plate",
        { ['@identifier'] = char.id, ['@plate'] = plate },
        function(result)
            if result then
                exports.ghmattimysql:execute(
                    "UPDATE user_boat SET boat_state=@state WHERE identifier=@identifier AND boat_plate=@plate",
                    { ['@identifier'] = char.id, ['@state'] = state_in, ['@plate'] = plate }
                )
                TriggerClientEvent('ply_docks:StoreBoatTrue', src)
            else
                TriggerClientEvent('ply_docks:StoreBoatFalse', src)
            end
        end
    )
end)


AddEventHandler('ply_docks:SetBoatOut', function(boat, plate)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    local boat = boat
    local state = state_out
    local plate = plate
    exports.ghmattimysql:execute("UPDATE user_boat SET boat_state=@state WHERE identifier=@identifier AND boat_plate=@plate AND boat_model=@boat", { ['@identifier'] = char.id, ['@boat'] = boat, ['@state'] = state, ['@plate'] = plate })
end)

AddEventHandler('ply_docks:CheckForSelBoat', function(plate)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    exports.ghmattimysql:execute(
        "SELECT boat_price FROM user_boat WHERE identifier=@identifier AND boat_plate=@plate",
        { ['@identifier'] = char.id, ['@plate'] = plate },
        function(result)
            local row = result[1]
            if row then
                local salePrice = row.boat_price / 2
                user:addMoney(salePrice)
                exports.ghmattimysql:execute(
                    "DELETE from user_boat WHERE identifier=@identifier AND boat_plate=@plate",
                    { ['@identifier'] = char.id, ['@plate'] = plate }
                )
                TriggerClientEvent('ply_docks:SelBoatTrue', src)
            else
                TriggerClientEvent('ply_docks:SelBoatFalse', src)
            end
        end
    )
end)


-- Base

AddEventHandler('ply_docks:GetBoats', function()
    boats = {}
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    exports.ghmattimysql:execute(
        "SELECT * FROM user_boat WHERE identifier=@identifier",
        { ['@identifier'] = char.id },
        function(data)
            for _, v in ipairs(data) do
                local t = { id = v.id, boat_model = v.boat_model, boat_name = v.boat_name, boat_state = v.boat_state }
                table.insert(boats, tonumber(v.id), t)
            end
            TriggerClientEvent('ply_docks:getBoat', src, boats)
        end
    )
end)

--
AddEventHandler('playerConnecting', function()
    exports.ghmattimysql:execute(
        "UPDATE user_boat SET boat_state=@state WHERE boat_state=@old_state",
        { ['@old_state'] = state_out, ['@state'] = state_in }
    )
end)
