print('^2[SRP]^7 Base server booting...')

-- Player lifecycle: basic ACL + buckets (loading -> choose -> main later)
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
  deferrals.defer()
  local src = source
  deferrals.update('Checking permissions...')
  -- TODO: replace "player:src" with your real identifier mapping when Identity resource is wired
  SRP_Perms.refreshFor(src, ('player:%d'):format(src))
  deferrals.update('Welcome to Sunny Roleplay!')
  deferrals.done()
end)

AddEventHandler('playerJoining', function(oldId)
  local src = source
  SRP_Buckets.AssignLoading(src)
  -- Minimal HUD seed
  exports['srp_base']:EmitHud(src, { time = SRP_Config.Time.realistic and 'realistic' or 'scripted' })
  -- Client will open selection/hud when ready (characters resource)
  TriggerClientEvent(SRP_CONST.EVENTS.SPAWN_CHOOSE, src)
end)

AddEventHandler('playerDropped', function()
  local src = source
  SRP_Buckets.Free(src)
end)