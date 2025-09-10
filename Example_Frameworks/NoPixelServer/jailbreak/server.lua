--[[
    -- Type: Server Script
    -- Name: jailbreak server
    -- Use: Handles jail timers and jail/unjail commands
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

local mysql = exports.ghmattimysql

RegisterNetEvent("updateJailTime", function(minutes)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    minutes = tonumber(minutes) or 0

    if minutes <= 0 then
        TriggerClientEvent("endJailTime", src)
    else
        mysql:execute("UPDATE `characters` SET `jail_time` = @time WHERE `id` = @cid", {
            ['time'] = minutes,
            ['cid'] = char.id
        })
    end
end)

RegisterNetEvent("updateJailTimeMobster", function(minutes)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    minutes = tonumber(minutes) or 0

    if minutes <= 0 then
        TriggerClientEvent("endJailTime", src)
    else
        mysql:execute("UPDATE `characters` SET `jail_time_mobster` = @time WHERE `id` = @cid", {
            ['time'] = minutes,
            ['cid'] = char.id
        })
    end
end)

CreateThread(function()
    while true do
        Wait(60000)
        mysql:execute("SELECT id, jail_time FROM `characters`", {}, function(result)
            for _, v in ipairs(result) do
                if v.jail_time and v.jail_time >= 1 then
                    mysql:execute("UPDATE `characters` SET `jail_time` = @time WHERE `id` = @cid", {
                        ['time'] = v.jail_time - 1,
                        ['cid'] = v.id
                    })
                end
            end
        end)
    end
end)

RegisterNetEvent("jail:characterFullySpawned", function()
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local character = user:getCurrentCharacter()
    local playerName = character.first_name .. ' ' .. character.last_name
    local date = os.date("%Y-%m-%d")

    mysql:execute("SELECT jail_time FROM `characters` WHERE id = @cid", { ['cid'] = character.id }, function(result)
        TriggerClientEvent("beginJail", src, true, result[1].jail_time, playerName, character.id, date)
    end)
end)

-- Backwards compatibility with legacy misspelled event
RegisterNetEvent("jail:charecterFullySpawend", function()
    TriggerEvent("jail:characterFullySpawned")
end)

RegisterNetEvent("checkJailTime", function()
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()

    mysql:execute("SELECT jail_time FROM `characters` WHERE id = @cid", { ['cid'] = char.id }, function(result)
        local time = tonumber(result[1].jail_time) or 0
        TriggerClientEvent("TimeRemaining", src, time, time <= 0)
    end)
end)

RegisterCommand("unjail", function(source, args)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)

    if (user:getVar("job") == "police" or user:getVar("job") == "doc") and args[1] then
        local targetId = tonumber(args[1])
        local targetUser = exports["np-base"]:getModule("Player"):GetUser(targetId)
        if targetUser then
            local targetChar = targetUser:getCurrentCharacter()
            TriggerClientEvent("endJailTime", targetId)
            mysql:execute("UPDATE `characters` SET `jail_time` = 0 WHERE `id` = @cid", { ['cid'] = targetChar.id })
        else
            TriggerClientEvent("DoLongHudText", src, "There are no player with this ID.", 2)
        end
    end
end)

RegisterCommand("jail", function(source, args)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)

    if user:getVar("job") == "police" or user:getVar("job") == "doc" then
        TriggerClientEvent("police:jailing", src, args)
    end
end)

-- RegisterCommand('mob_jail', function(source, args)
--     TriggerClientEvent('beginJail3', args[1], tonumber(args[2]))
-- end)
