--[[
    -- Type: Server Script
    -- Name: sweed
    -- Use: Manages weed plant lifecycle and persistence
    -- Created: 2024-08-18
    -- By: VSSVSSN
--]]

RegisterNetEvent("weed:createplant")
AddEventHandler("weed:createplant", function(x, y, z, seed)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    if not user then return end
    local character = user:getCurrentCharacter()
    local coords = { x = x, y = y, z = z }

    exports.ghmattimysql:execute(
        "INSERT INTO weed_plants (coords, seed, owner) VALUES (@coord, @seed, @owner)",
        {
            ['@coord'] = json.encode(coords),
            ['@seed'] = seed,
            ['@owner'] = character.id
        }
    )
end)

RegisterNetEvent("weed:killplant")
AddEventHandler("weed:killplant", function(dbId)
    exports.ghmattimysql:execute("DELETE FROM weed_plants WHERE id = @id", { ['@id'] = dbId })
end)

RegisterNetEvent("weed:UpdateWeedGrowth")
AddEventHandler("weed:UpdateWeedGrowth", function(dbId, growth)
    exports.ghmattimysql:execute(
        "UPDATE weed_plants SET growth = @growth WHERE id = @id",
        { ['@growth'] = growth, ['@id'] = dbId }
    )
end)

RegisterNetEvent("weed:requestTable")
AddEventHandler("weed:requestTable", function()
    local src = source
    exports.ghmattimysql:execute("SELECT * FROM weed_plants", {}, function(result)
        TriggerClientEvent("weed:currentcrops", src, result or {})
    end)
end)