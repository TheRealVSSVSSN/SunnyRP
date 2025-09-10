NPX = NPX or {}
NPX.Admin = NPX.Admin or {}
NPX._Admin = NPX._Admin or {}
NPX._Admin.Players = {}
NPX._Admin.DiscPlayers = {}

local function extractIdentifiers(src)
    local identifiers = GetPlayerIdentifiers(src)
    local steam, license
    for _, v in ipairs(identifiers) do
        if v:sub(1,6) == 'steam:' then
            steam = v
        elseif v:sub(1,8) == 'license:' then
            license = v
        end
    end
    return steam, license
end

RegisterNetEvent('np-admin:Disconnect')
AddEventHandler('np-admin:Disconnect', function(reason)
    DropPlayer(source, reason)
end)

RegisterNetEvent('admin:noclipFromClient')
AddEventHandler('admin:noclipFromClient', function(enabled)
    local src = source
    exports['np-log']:AddLog('Admin', GetPlayerName(src), 'Noclip', {state = enabled and 'enabled' or 'disabled'})
end)

RegisterNetEvent('admin:isFlying')
AddEventHandler('admin:isFlying', function(data)
    TriggerEvent('np-admin:NoclipState', data)
end)

RegisterNetEvent('np-admin:bringPlayerServer')
AddEventHandler('np-admin:bringPlayerServer', function(data, playerID)
    TriggerClientEvent('np-admin:bringPlayer', playerID, data)
end)

RegisterNetEvent('np-admin:setcloak')
AddEventHandler('np-admin:setcloak', function(args)
    TriggerClientEvent('cloak', source, args)
end)

RegisterNetEvent('np-admin:kick')
AddEventHandler('np-admin:kick', function(kickid, reason)
    DropPlayer(kickid, reason)
end)

RegisterNetEvent('np-admin:AddPlayer')
AddEventHandler('np-admin:AddPlayer', function()
    local src = source
    local user = exports['np-base']:getModule('Player'):GetUser(src)
    local steamIdentifier, license = extractIdentifiers(src)
    if not user or not steamIdentifier or not license then return end

    local data = {
        source = src,
        steamid = HexIdToSteamId(steamIdentifier),
        comid = steamIdentifier:gsub('steam:', ''),
        name = GetPlayerName(src),
        hexid = user:getVar('hexid'),
        ip = GetPlayerEndpoint(src),
        rank = NPX.Admin:GetPlayerRank(user),
        license = license:gsub('license:', ''),
        ping = GetPlayerPing(src)
    }

    NPX._Admin.Players[src] = data
    TriggerClientEvent('np-admin:AddPlayer', -1, data)
    NPX.Admin.AddAllPlayers(src)
end)

function NPX.Admin.AddAllPlayers(src)
    for _, playerId in ipairs(GetPlayers()) do
        local steamIdentifier, license = extractIdentifiers(playerId)
        if steamIdentifier and license then
            local info = {
                src = tonumber(playerId),
                steamid = HexIdToSteamId(steamIdentifier),
                comid = steamIdentifier:gsub('steam:', ''),
                name = GetPlayerName(playerId),
                ip = GetPlayerEndpoint(playerId),
                license = license:gsub('license:', ''),
                ping = GetPlayerPing(playerId)
            }
            TriggerClientEvent('np-admin:AddAllPlayers', src, info)
        end
    end
end

function NPX.Admin.AddPlayerS(self, data)
    NPX._Admin.Players[data.src] = data
end

AddEventHandler('playerDropped', function()
    local src = source
    local steamIdentifier, license = extractIdentifiers(src)
    if not steamIdentifier or not license then return end
    local data = {
        src = src,
        steamid = HexIdToSteamId(steamIdentifier),
        comid = steamIdentifier:gsub('steam:', ''),
        name = GetPlayerName(src),
        ip = GetPlayerEndpoint(src),
        license = license:gsub('license:', ''),
        ping = GetPlayerPing(src)
    }

    TriggerClientEvent('np-admin:RemovePlayer', -1, data)
    Citizen.CreateThread(function()
        Wait(600000)
        TriggerClientEvent('np-admin:RemoveRecent', -1, data)
    end)
end)

function HexIdToSteamId(hexId)
    local cid = math.floor(tonumber(string.sub( hexId, 7), 16))
	local steam64 = math.floor(tonumber(string.sub( cid, 2)))
	local a = steam64 % 2 == 0 and 0 or 1
	local b = math.floor(math.abs(6561197960265728 - steam64 - a) / 2)
	local sid = "STEAM_0:"..a..":"..(a == 1 and b -1 or b)
    return sid
end

-- local sex {
--     ["name"] = "text",
    
-- }

RegisterNetEvent('server:enablehuddebug')
AddEventHandler('server:enablehuddebug', function(enable)
        debug = not debug
        local src = source
        if debug then
            exports["np-log"]:AddLog("Admin", GetPlayerName(src), "Dev Debug", {item = tostring("Enabled")}) 
            TriggerClientEvent('hud:enabledebug', src)
        else
            exports["np-log"]:AddLog("Admin", GetPlayerName(src), "Dev Debug", {item = tostring("Disabled")}) 
            TriggerClientEvent('hud:enabledebug', src)
        end
end)


RegisterNetEvent('np-admin:runCommand')
AddEventHandler('np-admin:runCommand', function(data)
    --print("triggered me dudeed - server")
    local src = source

    TriggerClientEvent('np-admin:RunClCommand', src, data.command, data)

    local cmd = NPX._Admin.Commands[data.command]
    if cmd and cmd.runcommand then
        local caller = {
            source = src,
            name = GetPlayerName(src),
            steamid = GetPlayerIdentifiers(src)[1],
            getVar = function(self, key) return self[key] end,
        }
        cmd.runcommand(caller, data)
    end
end)

RegisterNetEvent('admin:dumpCurrentPlayers')
AddEventHandler('admin:dumpCurrentPlayers', function()

end)

function NPX.Admin.reBuildAdmin(self, user,src)
    if not user then return end
    if not self:IsValidUser(user) then return end
    if self:IsAdmin(user) then
        local commands = exports["np-base"]:getModule("Commands")
        commands:removeCommand("/menu", src)
        commands:removeCommand("/heatmap", src)
        commands:removeCommand("/polystart", src)
        commands:removeCommand("/polyadd", src)
        commands:removeCommand("/polyremove", src)
        commands:removeCommand("/polyend", src)

        commands:AddCommand("/heatmap", "Toggel Display Heatmap", src, function(src, args)
            TriggerEvent("heatmap:display", src)
        end)

        commands:AddCommand("/menu", "Opens the admin menu", src, function(src, args)
            TriggerClientEvent("np-admin:openMenu", src)
        end)

        commands:AddCommand("/polystart", "Start building shape", src, function(src, args)
            local name = ""
            for i = 2, #args do
                name = name .. " " .. args[i]
            end
            TriggerClientEvent("pz_startshape", src, name)
        end)

        commands:AddCommand("/polyadd", "Add a point to the shape", src, function(src, args)
            TriggerClientEvent("pz_addpoint", src)
        end)

        commands:AddCommand("/polyremove", "Remove last point of the shape", src, function(src, args)
            TriggerClientEvent("pz_removepoint", src)
        end)

        commands:AddCommand("/polyend", "Stop building shape", src, function(src, args)
            TriggerClientEvent("pz_endshape", src)
        end)
    else
        commands:removeCommand("/menu", src)
        commands:removeCommand("/heatmap", src)
        commands:removeCommand("/polystart", src)
        commands:removeCommand("/polyadd", src)
        commands:removeCommand("/polyremove", src)
        commands:removeCommand("/polyend", src)
        TriggerClientEvent("np-admin:noLongerAdmin", src)
    end
end