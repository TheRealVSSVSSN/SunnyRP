print('^2[SRP]^7 Base server booting...')

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
  deferrals.defer()
  local src = source
  deferrals.update('Checking permissions...')
  -- TODO: replace "player:src" with your real identifier mapping when Identity is wired
  SRP_Utils.try(function()
    SRP_Perms.refreshFor(src, ('player:%d'):format(src))
  end)
  deferrals.update('Welcome to Sunny Roleplay!')
  deferrals.done()
end)

AddEventHandler('playerJoining', function()
  local src = source
  SRP_Utils.try(function()
    SRP_Buckets.AssignLoading(src)
    exports['srp_base']:EmitHud(src, { time = SRP_Config.Time.realistic and 'realistic' or 'scripted' })
    TriggerClientEvent(SRP_CONST.EVENTS.SPAWN_CHOOSE, src)
  end)
end)

AddEventHandler('playerDropped', function()
  local src = source
  SRP_Utils.try(function()
    SRP_Buckets.Free(src)
  end)
end)