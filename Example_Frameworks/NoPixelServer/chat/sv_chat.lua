RegisterNetEvent('chat:init')
RegisterNetEvent('chat:addTemplate')
RegisterNetEvent('chat:addMessage')
RegisterNetEvent('chat:addSuggestion')
RegisterNetEvent('chat:removeSuggestion')
RegisterNetEvent('_chat:messageEntered')
RegisterNetEvent('chat:clear')
RegisterNetEvent('__cfx_internal:commandFallback')
 
AddEventHandler('_chat:messageEntered', function(author, color, message)
    if not message or not author then
        return
    end
 
    TriggerEvent('chatMessage', source, author, message)

    if not WasEventCanceled() then
        TriggerClientEvent('chatMessage', -1, author, color or { 255, 255, 255 }, message)
    end

    print(('%s^7: %s^7'):format(author, message))
end)

AddEventHandler("chatMessage", function(source, args, raw)
    CancelEvent()
end)
 



AddEventHandler('__cfx_internal:commandFallback', function(command)
    local name = GetPlayerName(source)

    TriggerEvent('chatMessage', source, name, '/' .. command)

    if not WasEventCanceled() then
        TriggerClientEvent('chatMessage', -1, name, { 255, 255, 255 }, '/' .. command)
    end

    CancelEvent()
end)

-- command suggestions for clients

--[[
    -- Type: Function
    -- Name: refreshCommands
    -- Use: Sends available command suggestions to the specified player
    -- Created: 2024-06-07
    -- By: VSSVSSN
--]]
local function refreshCommands(player)
    if GetRegisteredCommands then
        local registeredCommands = GetRegisteredCommands()

        local suggestions = {}

        for _, command in ipairs(registeredCommands) do
            if IsPlayerAceAllowed(player, ('command.%s'):format(command.name)) then
                table.insert(suggestions, {
                    name = '/' .. command.name,
                    help = ''
                })
            end
        end

        TriggerClientEvent('chat:addSuggestions', player, suggestions)
    end
end

AddEventHandler('chat:init', function()
    refreshCommands(source)
end)

AddEventHandler('onServerResourceStart', function(resName)
    Wait(500)

    for _, player in ipairs(GetPlayers()) do
        refreshCommands(player)
    end
end)
