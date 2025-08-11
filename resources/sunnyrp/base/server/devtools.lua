-- Simple debug switch
RegisterCommand('srpdebug', function(src, args)
  local onoff = (args[1] == 'on')
  SRP_Config.Dev.debug = onoff
  TriggerClientEvent('chat:addMessage', src, { args={'SRP', 'Debug '..(onoff and 'ON' or 'OFF')} })
end, false)