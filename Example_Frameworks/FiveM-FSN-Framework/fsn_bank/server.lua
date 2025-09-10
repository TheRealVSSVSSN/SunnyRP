RegisterNetEvent('fsn_bank:database:update')
AddEventHandler('fsn_bank:database:update', function(charid, wallet, bank)
  if bank ~= false then
    MySQL.Async.execute('UPDATE fsn_characters SET char_bank=@bank WHERE char_id=@char_id', {
      ['@char_id'] = charid,
      ['@bank'] = bank
    })
  end
  if wallet ~= false then
    MySQL.Async.execute('UPDATE fsn_characters SET char_money=@wallet WHERE char_id=@char_id', {
      ['@char_id'] = charid,
      ['@wallet'] = wallet
    })
  end
end)

RegisterNetEvent('fsn_bank:transfer')
AddEventHandler('fsn_bank:transfer', function(receive, amount)
  local src = source
  local amt = tonumber(amount)
  if not amt or amt <= 0 then
    TriggerClientEvent('fsn_notify:displayNotification', src, 'Invalid transfer amount!', 'centerRight', 4000, 'error')
    return
  end
  if not GetPlayerName(receive) then
    TriggerClientEvent('fsn_notify:displayNotification', src, 'We cannot find this account!', 'centerRight', 4000, 'error')
    return
  end
  if exports['fsn_main']:fsn_GetBank(src) < amt then
    TriggerClientEvent('fsn_notify:displayNotification', src, 'There isn\'t enough in the account!', 'centerRight', 4000, 'error')
    return
  end
  TriggerClientEvent('fsn_bank:change:bankAdd', receive, amt)
  TriggerClientEvent('fsn_bank:change:bankMinus', src, amt)
  TriggerEvent('fsn_main:logging:addLog', src, 'money', 'Character('..exports['fsn_main']:fsn_CharID(src)..') transferred $'..amt..' to Character('..exports['fsn_main']:fsn_CharID(receive)..')')
end)
