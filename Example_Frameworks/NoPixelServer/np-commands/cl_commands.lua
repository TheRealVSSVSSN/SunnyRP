--[[
    -- Type: Client Script
    -- Name: cl_commands
    -- Use: Registers client-side chat commands for various utility actions
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end
    TriggerServerEvent('np-commands:buildCommands')
end)

local commands = {
    { 'cpr', function() TriggerEvent('pixerium:check', 3, 'trycpr', false) end },
    { 'door1', function() TriggerEvent('car:doors', 'open', 0) end },
    { 'door2', function() TriggerEvent('car:doors', 'open', 1) end },
    { 'door3', function() TriggerEvent('car:doors', 'open', 2) end },
    { 'door4', function() TriggerEvent('car:doors', 'open', 3) end },
    { 'hood', function() TriggerEvent('car:doors', 'open', 4) end },
    { 'as', function() TriggerEvent('idk also') end },
    { 'selfie', function() TriggerEvent('selfiePhone') end },
    { 'showid', function() TriggerEvent('showID') end },
    { 'givekey', function() TriggerEvent('keys:give') end },
    { 'window', function(args) TriggerEvent('car:windows', args[1], args[2]) end },
    { 'rollup', function() TriggerEvent('car:windowsup') end },
    { 'phone', function() TriggerEvent('phoneGui2') end },
    { 'finance', function() TriggerEvent('finance1') end },
    { 'inv', function() TriggerEvent('OpenInv') end },
    { 'vm', function() TriggerEvent('shop:useVM') end },
    { 'news', function() TriggerEvent('NewsStandCheck') end },
    { 'confirm', function() TriggerEvent('housing:confirmed') end },
    { 'notes', function() TriggerEvent('Notepad:open') end },
    { 'trunkkidnap', function() TriggerEvent('ped:forceTrunk') end },
    { 'trunkeject', function() TriggerEvent('ped:releaseTrunkCheck') end },
    { 'trunkgetin', function() TriggerEvent('ped:forceTrunkSelf') end },
    { 'trunkejectself', function() TriggerEvent('ped:releaseTrunkCheckSelf') end },
    { 'anchor', function() TriggerEvent('client:anchor') end },
    { 'debug', function() TriggerEvent('server:enablehuddebug') end },
    { 'carry', function() TriggerEvent('police:carryAI') end },
    { 'atm', function() TriggerEvent('bank:checkATM') end },
    { 'getpos', function()
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local heading = GetEntityHeading(ped)
        Citizen.Trace(string.format('X: %s Y: %s Z: %s HEADING: %s', coords.x, coords.y, coords.z, heading))
    end }
}

for _, cmd in ipairs(commands) do
    RegisterCommand(cmd[1], function(_, args)
        cmd[2](args)
    end, false)
end

