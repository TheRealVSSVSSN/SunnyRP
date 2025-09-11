local cur_channel = 0
RegisterServerEvent('fsn_voicecontrol:call:ring')
--[[
    -- Type: Event Handler
    -- Name: fsn_voicecontrol:call:ring
    -- Use: Attempts to start a call between two numbers
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
AddEventHandler('fsn_voicecontrol:call:ring', function(ringNum, ringingNum)
  local target = exports.fsn_main:fsn_GetPlayerFromPhoneNumber(ringNum)
  if target ~= 0 then
    TriggerClientEvent('fsn_voicecontrol:call:ring', target, ringingNum)
    TriggerClientEvent('fsn_notify:displayNotification', source, 'Ringing #'..ringNum..'...', 'centerRight', 8000, 'info')
  else
    TriggerClientEvent('fsn_voicecontrol:call:end', source)
    TriggerClientEvent('fsn_notify:displayNotification', source, 'No player found with this phone number!', 'centerRight', 5000, 'error')
  end
end)

RegisterServerEvent('fsn_voicecontrol:call:answer')
--[[
    -- Type: Event Handler
    -- Name: fsn_voicecontrol:call:answer
    -- Use: Connects two players in a voice channel when a call is accepted
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
AddEventHandler('fsn_voicecontrol:call:answer', function(ringnum)
  local ringing = exports.fsn_main:fsn_GetPlayerFromPhoneNumber(ringnum)
  cur_channel = cur_channel+1
  TriggerClientEvent('fsn_voicecontrol:call:start', source, cur_channel)
  TriggerClientEvent('fsn_voicecontrol:call:start', ringing, cur_channel)
  TriggerClientEvent('fsn_notify:displayNotification', source, 'Call connected (C:'..cur_channel..')', 'centerRight', 5000, 'success' )
  TriggerClientEvent('fsn_notify:displayNotification', ringing, 'Call connected (C:'..cur_channel..')', 'centerRight', 5000, 'success' )
end)

RegisterServerEvent('fsn_voicecontrol:call:decline')
--[[
    -- Type: Event Handler
    -- Name: fsn_voicecontrol:call:decline
    -- Use: Notifies both parties that the call was declined
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
AddEventHandler('fsn_voicecontrol:call:decline', function(ringnum)
  local ringing = exports.fsn_main:fsn_GetPlayerFromPhoneNumber(ringnum)
  TriggerClientEvent('fsn_voicecontrol:call:end', source)
  TriggerClientEvent('fsn_voicecontrol:call:end', ringing)
  TriggerClientEvent('fsn_notify:displayNotification', ringing, 'Call was declined', 'centerRight', 5000, 'error' )
  TriggerClientEvent('fsn_notify:displayNotification', source, 'Call declined', 'centerRight', 5000, 'info' )
end)

RegisterServerEvent('fsn_voicecontrol:call:hold')
--[[
    -- Type: Event Handler
    -- Name: fsn_voicecontrol:call:hold
    -- Use: Places an active call on hold
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
AddEventHandler('fsn_voicecontrol:call:hold', function(ringnum)
  local ringing = exports.fsn_main:fsn_GetPlayerFromPhoneNumber(ringnum)
  TriggerClientEvent('fsn_voicecontrol:call:hold', source, true)
  TriggerClientEvent('fsn_voicecontrol:call:hold', ringing, false)
  TriggerClientEvent('fsn_notify:displayNotification', source, 'Call placed on hold', 'centerRight', 5000, 'info' )
  TriggerClientEvent('fsn_notify:displayNotification', ringing, 'Call is now on hold', 'centerRight', 5000, 'info' )
end)

RegisterServerEvent('fsn_voicecontrol:call:unhold')
--[[
    -- Type: Event Handler
    -- Name: fsn_voicecontrol:call:unhold
    -- Use: Resumes a previously held call
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
AddEventHandler('fsn_voicecontrol:call:unhold', function(ringnum)
  local ringing = exports.fsn_main:fsn_GetPlayerFromPhoneNumber(ringnum)
  TriggerClientEvent('fsn_voicecontrol:call:unhold', source)
  TriggerClientEvent('fsn_voicecontrol:call:unhold', ringing)
  TriggerClientEvent('fsn_notify:displayNotification', source, 'Call now active', 'centerRight', 5000, 'info' )
  TriggerClientEvent('fsn_notify:displayNotification', ringing, 'Call is now active', 'centerRight', 5000, 'info' )
end)


RegisterServerEvent('fsn_voicecontrol:call:end')
--[[
    -- Type: Event Handler
    -- Name: fsn_voicecontrol:call:end
    -- Use: Terminates the voice call for both players
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
AddEventHandler('fsn_voicecontrol:call:end', function(ringnum)
  local ringing = exports.fsn_main:fsn_GetPlayerFromPhoneNumber(ringnum)
  TriggerClientEvent('fsn_voicecontrol:call:end', source)
  TriggerClientEvent('fsn_voicecontrol:call:end', ringing)
  TriggerClientEvent('fsn_notify:displayNotification', ringing, 'Call was ended', 'centerRight', 5000, 'error' )
  TriggerClientEvent('fsn_notify:displayNotification', source, 'Call ended', 'centerRight', 5000, 'error' )
end)
