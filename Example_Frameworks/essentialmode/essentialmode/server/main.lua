--[[
    -- Type: Server
    -- Name: Main
    -- Use: Core runtime for EssentialMode
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]

local Users = {}
local commands = {}
local settings = {
    defaultSettings = {
        banReason = 'You are currently banned. Please go to: insertsite.com/bans',
        pvpEnabled = false,
        permissionDenied = false,
        debugInformation = false,
        startingCash = 0,
        enableRankDecorators = false
    },
    sessionSettings = {}
}

--[[
    -- Type: Event
    -- Name: playerConnecting
    -- Use: Checks ban list before allowing connection
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local src = source
    deferrals.defer()
    Wait(0)
    local identifiers = GetPlayerIdentifiers(src)
    for _, identifier in ipairs(identifiers) do
        debugMsg(('Checking user ban: %s (%s)'):format(identifier, name))
        if isIdentifierBanned(identifier) then
            local reason = settings.defaultSettings.banReason
            if type(reason) == 'function' then
                reason = reason(identifier, name)
            end
            deferrals.done(reason or 'You are banned from this server')
            CancelEvent()
            return
        end
    end
    deferrals.done()
end)

--[[
    -- Type: Event
    -- Name: playerDropped
    -- Use: Persists player money on disconnect
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
AddEventHandler('playerDropped', function()
    local src = source
    local user = Users[src]
    if user then
        MySQL.update('UPDATE users SET money = ? WHERE identifier = ?', {
            user.money,
            user.identifier
        })
        Users[src] = nil
    end
end)

local justJoined = {}

RegisterNetEvent('es:firstJoinProper')
AddEventHandler('es:firstJoinProper', function()
    local src = source
    for _, identifier in ipairs(GetPlayerIdentifiers(src)) do
        if not Users[src] then
            debugMsg('Essential | Loading user: ' .. GetPlayerName(src))
            registerUser(identifier, src)
            TriggerEvent('es:initialized', src)
            justJoined[src] = true
            if settings.defaultSettings.pvpEnabled then
                TriggerClientEvent('es:enablePvp', src)
            end
        end
    end
end)

AddEventHandler('es:setSessionSetting', function(k, v)
    settings.sessionSettings[k] = v
end)

AddEventHandler('es:getSessionSetting', function(k, cb)
    cb(settings.sessionSettings[k])
end)

AddEventHandler('playerSpawn', function()
    local src = source
    if justJoined[src] then
        TriggerEvent('es:firstSpawn', src)
        justJoined[src] = nil
    end
end)

AddEventHandler('es:setDefaultSettings', function(tbl)
    for k, v in pairs(tbl) do
        if settings.defaultSettings[k] ~= nil then
            settings.defaultSettings[k] = v
        end
    end
    debugMsg('Default settings edited.')
end)

AddEventHandler('chatMessage', function(src, n, message)
    if startswith(message, '/') then
        local command_args = stringsplit(message, ' ')
        command_args[1] = command_args[1]:gsub('/', '')
        local command = commands[command_args[1]]
        if command then
            CancelEvent()
            if command.perm > 0 then
                local user = Users[src]
                if user and (user.permission_level >= command.perm or user.group:canTarget(command.group)) then
                    command.cmd(src, command_args, user)
                    TriggerEvent('es:adminCommandRan', src, command_args, user)
                else
                    command.callbackfailed(src, command_args, user)
                    TriggerEvent('es:adminCommandFailed', src, command_args, user)
                    if type(settings.defaultSettings.permissionDenied) == 'string' and not WasEventCanceled() then
                        TriggerClientEvent('chatMessage', src, '', {0, 0, 0}, settings.defaultSettings.permissionDenied)
                    end
                    debugMsg(('Non admin (%s) attempted to run admin command: %s'):format(GetPlayerName(src), command_args[1]))
                end
            else
                command.cmd(src, command_args, Users[src])
                TriggerEvent('es:userCommandRan', src, command_args, Users[src])
            end
            TriggerEvent('es:commandRan', src, command_args, Users[src])
        else
            TriggerEvent('es:invalidCommandHandler', src, command_args, Users[src])
            if WasEventCanceled() then
                CancelEvent()
            end
        end
    else
        TriggerEvent('es:chatMessage', src, message, Users[src])
    end
end)

AddEventHandler('es:addCommand', function(command, callback)
    commands[command] = {perm = 0, group = 'user', cmd = callback}
    debugMsg('Command added: ' .. command)
end)

AddEventHandler('es:addAdminCommand', function(command, perm, callback, callbackfailed)
    commands[command] = {perm = perm, group = 'superadmin', cmd = callback, callbackfailed = callbackfailed}
    debugMsg(('Admin command added: %s, requires permission level: %s'):format(command, perm))
end)

AddEventHandler('es:addGroupCommand', function(command, group, callback, callbackfailed)
    commands[command] = {perm = math.maxinteger, group = group, cmd = callback, callbackfailed = callbackfailed}
    debugMsg(('Group command added: %s, requires group: %s'):format(command, group))
end)

RegisterNetEvent('es:updatePositions')
AddEventHandler('es:updatePositions', function(x, y, z)
    local src = source
    if Users[src] then
        Users[src]:setCoords(x, y, z)
    end
end)

commands['info'] = {perm = 0}
commands['info'].cmd = function(src, args, user)
    TriggerClientEvent('chatMessage', src, 'SYSTEM', {255, 0, 0}, '^2[^3EssentialMode^2]^0 Version: ^22.0.0')
    TriggerClientEvent('chatMessage', src, 'SYSTEM', {255, 0, 0}, '^2[^3EssentialMode^2]^0 Commands loaded: ^2' .. (returnIndexesInTable(commands) - 1))
end
