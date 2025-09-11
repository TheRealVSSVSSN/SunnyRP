--  -------------------
--  BEGIN:       Locals
--  -------------------

local FSN

--  -------------------
--  END:         Locals
--  -------------------

--  -------------------
--  BEGIN:      Threads
--  -------------------

CreateThread(function()
    while not FSN do
        TriggerEvent('fsn:getFsnObject', function(obj)
            FSN = obj
        end)
        Wait(100)
    end
end)

--  -------------------
--  END:        Threads
--  -------------------

--  -------------------
--  BEGIN:    Functions
--  -------------------

local function getSteamIdentifier(src)
    for _, identifier in ipairs(GetPlayerIdentifiers(src)) do
        if identifier:sub(1,5) == 'steam' then
            return identifier
        end
    end
    return nil
end

local function isModerator(src)
    local steamId = getSteamIdentifier(src)
    if not steamId then return false end
    for _, id in ipairs(Config.Moderators) do
        if id == steamId then
            return true
        end
    end
    return false
end

local function isAdmin(src)
    local steamId = getSteamIdentifier(src)
    if not steamId then return false end
    for _, id in ipairs(Config.Admins) do
        if id == steamId then
            return true
        end
    end
    return false
end

local function getModeratorName(src)
    return GetPlayerName(src)
end

local function getAdminName(src)
    return GetPlayerName(src)
end

local function registerModeratorCommands()
    RegisterCommand('sc', function(source, args, raw)
        if source == 0 or not isModerator(source) then return end
        local msg = raw:sub(4)
        for _, ply in ipairs(GetPlayers()) do
            ply = tonumber(ply)
            if isModerator(ply) then
                TriggerClientEvent('chat:addMessage', ply, {
                    template = '<div style="padding:0.5vw; background-color: rgba(44, 95, 148, 0.6); border-radius:3px;"><strong>^8SC [Mod] {0}:^7</strong><br>{1}</div>',
                    args = {getModeratorName(source), msg}
                })
            end
        end
    end)
end

local function registerAdminCommands()
    RegisterCommand('sc', function(source, args, raw)
        if source == 0 or not isAdmin(source) then return end
        local msg = raw:sub(4)
        for _, ply in ipairs(GetPlayers()) do
            ply = tonumber(ply)
            if isAdmin(ply) then
                TriggerClientEvent('chat:addMessage', ply, {
                    template = '<div style="padding:0.5vw; background-color: rgba(44,95,148,0.6); border-radius:3px;"><strong>^8SC [Admin] {0}:^7</strong><br>{1}</div>',
                    args = {getAdminName(source), msg}
                })
            end
        end
    end)

    RegisterCommand('adminmenu', function(source)
        if source == 0 or not isAdmin(source) then return end
        TriggerClientEvent('chat:addMessage', source, {
            template = '<div style="padding:0.5vw; background-color: rgba(44,95,148,0.6); border-radius:3px;"><strong>^8System:^7</strong><br>The admin menu is not yet implemented!</div>',
            args = {}
        })
    end)

    RegisterCommand('amenu', function(source)
        if source == 0 or not isAdmin(source) then return end
        TriggerClientEvent('chat:addMessage', source, {
            template = '<div style="padding:0.5vw; background-color: rgba(44,95,148,0.6); border-radius:3px;"><strong>^8System:^7</strong><br>The admin menu is not yet implemented!</div>',
            args = {}
        })
    end)

    RegisterCommand('freeze', function(source, args)
        if source == 0 or not isAdmin(source) then return end
        local targetId = tonumber(args[1])
        local target = targetId and FSN.GetPlayerFromId(targetId)
        if target then
            TriggerClientEvent('fsn_admin:FreezeMe', target.ply_id, getAdminName(source))
            TriggerClientEvent('chat:addMessage', source, {
                template = '<div style="padding:0.5vw; background-color: rgba(44,95,148,0.6); border-radius:3px;"><strong>^8System:^7</strong><br>You toggled the frozen status of {0}</div>',
                args = {targetId}
            })
        else
            TriggerClientEvent('chat:addMessage', source, {
                template = '<div style="padding:0.5vw; background-color: rgba(44,95,148,0.6); border-radius:3px;"><strong>^8System:^7</strong><br>That target either doesn\'t exist or was entered wrong.</div>',
                args = {}
            })
        end
    end)

    RegisterCommand('announce', function(source, args, raw)
        local msg = raw:sub(9)
        if source == 0 then
            TriggerClientEvent('chat:addMessage', -1, {
                template = '<div style="padding:0.5vw; background-color: rgba(44,95,148,0.6); border-radius:3px;"><strong>^8SERVER ANNOUNCEMENT:^7</strong><br>{0}</div>',
                args = {msg}
            })
            return
        end
        if not isAdmin(source) then return end
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div style="padding:0.5vw; background-color: rgba(44,95,148,0.6); border-radius:3px;"><strong>^8[{0}] Announcement:^7</strong><br>{1}</div>',
            args = {getAdminName(source), msg}
        })
    end)

    RegisterCommand('goto', function(source, args)
        if source == 0 or not isAdmin(source) then return end
        local targetId = tonumber(args[1])
        local target = targetId and FSN.GetPlayerFromId(targetId)
        if target then
            TriggerClientEvent('fsn_admin:requestXYZ', target.ply_id, source)
            TriggerClientEvent('chat:addMessage', source, {
                template = '<div style="padding:0.5vw; background-color: rgba(44,95,148,0.6); border-radius:3px;"><strong>^8System:^7</strong> You teleported to {0}.</div>',
                args = {targetId}
            })
        else
            TriggerClientEvent('chat:addMessage', source, {
                template = '<div style="padding:0.5vw; background-color: rgba(44,95,148,0.6); border-radius:3px;"><strong>^8System:^7</strong><br>That target either doesn\'t exist or was entered wrong.</div>',
                args = {}
            })
        end
    end)

    RegisterCommand('bring', function(source, args)
        if source == 0 or not isAdmin(source) then return end
        local targetId = tonumber(args[1])
        local target = targetId and FSN.GetPlayerFromId(targetId)
        if target then
            TriggerClientEvent('fsn_admin:requestXYZ', source, target.ply_id)
            TriggerClientEvent('chat:addMessage', source, {
                template = '<div style="padding:0.5vw; background-color: rgba(44,95,148,0.6); border-radius:3px;"><strong>^8System:^7</strong> You brought {0} to you.</div>',
                args = {targetId}
            })
        else
            TriggerClientEvent('chat:addMessage', source, {
                template = '<div style="padding:0.5vw; background-color: rgba(44,95,148,0.6); border-radius:3px;"><strong>^8System:^7</strong><br>That target either doesn\'t exist or was entered wrong.</div>',
                args = {}
            })
        end
    end)

    RegisterCommand('kick', function(source, args, raw)
        local targetId = tonumber(args[1])
        local reason = raw:sub(7)
        if source == 0 then
            if targetId and reason and reason ~= '' then
                DropPlayer(targetId, 'You have been kicked by the server for: '..reason)
            end
            return
        end
        if not isAdmin(source) then return end
        local target = targetId and FSN.GetPlayerFromId(targetId)
        if target and reason ~= '' then
            DropPlayer(target.ply_id, 'You have been kicked for: '..reason..' by: '..getAdminName(source))
        else
            TriggerClientEvent('chat:addMessage', source, {
                template = '<div style="padding:0.5vw; background-color: rgba(44,95,148,0.6); border-radius:3px;"><strong>^8System:^7</strong><br>You need to specify a valid target and reason.</div>',
                args = {}
            })
        end
    end)

    RegisterCommand('ban', function(source, args, raw)
        local times = {
            ['1d']=86400,
            ['2d']=172800,
            ['3d']=259200,
            ['4d']=345600,
            ['5d']=432000,
            ['6d']=518400,
            ['1w']=604800,
            ['2w']=1209600,
            ['3w']=1814400,
            ['1m']=2629743,
            ['2m']=5259486,
            ['perm']=999999999
        }

        local targetId = tonumber(args[1])
        local length   = args[2]
        local reason   = raw:sub(5)

        if source ~= 0 and not isAdmin(source) then return end
        if not targetId or not length or not times[length] or reason == '' then return end

        local target = FSN.GetPlayerFromId(targetId)
        if not target then
            if source ~= 0 then
                TriggerClientEvent('chat:addMessage', source, {
                    template = '<div style="padding:0.5vw; background-color: rgba(44,95,148,0.6); border-radius:3px;"><strong>^8System:^7</strong><br>That target either doesn\'t exist or was entered wrong.</div>',
                    args = {}
                })
            end
            return
        end

        local steamId = getSteamIdentifier(target.ply_id)
        if not steamId then return end

        local unbanTime = os.time() + times[length]
        MySQL.Async.execute('UPDATE fsn_users SET banned = @unban, banned_r = @reason WHERE steamid = @steamId', {
            ['@unban'] = unbanTime,
            ['@reason'] = reason,
            ['@steamId'] = steamId
        })

        local banner = source == 0 and 'the server' or getAdminName(source)
        DropPlayer(target.ply_id, 'You have been banned for: '..reason..' by '..banner..'. Time: '..length)
    end)
end

local function registerModeratorSuggestions(source)
    if isModerator(source) then
        TriggerClientEvent('chat:addSuggestion', source, '/sc', 'Talk in staff chat.', {
            { name = 'Message', help = 'Message to send.' }
        })
    end
end

local function registerAdminSuggestions(source)
    if isAdmin(source) then
        TriggerClientEvent('chat:addSuggestion', source, '/sc', 'Talk in staff chat.', {
            { name = 'Message', help = 'Message to send.' }
        })
        TriggerClientEvent('chat:addSuggestion', source, '/adminmenu', 'The admin menu is not yet implemented.', {})
        TriggerClientEvent('chat:addSuggestion', source, '/amenu', 'The admin menu is not yet implemented.', {})
        TriggerClientEvent('chat:addSuggestion', source, '/freeze', 'Freeze the target you specify.', {
            { name = 'ID', help = 'The server ID of the target' }
        })
        TriggerClientEvent('chat:addSuggestion', source, '/goto', 'Teleport to the target you specify.', {
            { name = 'ID', help = 'The server ID of the target' }
        })
        TriggerClientEvent('chat:addSuggestion', source, '/bring', 'Bring the target you specify to your location.', {
            { name = 'ID', help = 'The server ID of the target' }
        })
        TriggerClientEvent('chat:addSuggestion', source, '/kick', 'Kick the specified target from the server.', {
            { name = 'ID', help = 'The server ID of the target' },
            { name = 'reason', help = 'The reason you are kicking the target from the server.' }
        })
        TriggerClientEvent('chat:addSuggestion', source, '/ban', 'Ban the target from the server.', {
            { name = 'ID', help = 'The server ID of the target' },
            { name = 'Length', help = 'Valid lengths: 1d,2d,3d,4d,5d,6d,1w,2w,3w,1m,2m,perm' },
            { name = 'Reason', help = 'The reason for the ban' }
        })
    end
end

--  -------------------
--  END:      Functions
--  -------------------

--  -------------------
--  BEGIN:       Events
--  -------------------

RegisterNetEvent('fsn_admin:sendXYZ')
AddEventHandler('fsn_admin:sendXYZ', function(sendTo, coords)
    TriggerClientEvent('fsn_admin:receiveXYZ', sendTo, coords)
end)

RegisterNetEvent('fsn_admin:enableAdminCommands')
AddEventHandler('fsn_admin:enableAdminCommands', function(source)
    registerAdminSuggestions(source)
end)

RegisterNetEvent('fsn_admin:enableModeratorCommands')
AddEventHandler('fsn_admin:enableModeratorCommands', function(source)
    registerModeratorSuggestions(source)
end)

RegisterNetEvent('fsn:playerReady')
AddEventHandler('fsn:playerReady', function()
    local playerId = source
    Wait(1000)
    if isAdmin(playerId) then
        TriggerEvent('fsn_admin:enableAdminCommands', playerId)
    end
    if isModerator(playerId) then
        TriggerEvent('fsn_admin:enableModeratorCommands', playerId)
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    registerAdminCommands()
    registerModeratorCommands()
end)

--  -------------------
--  END:         Events
--  -------------------
