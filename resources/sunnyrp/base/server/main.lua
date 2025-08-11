print('^2[SRP]^7 Base server booting...')

-- Use deferral orchestrator so we’re ready for registration gating
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
  local src = source
  SRP_Utils.try(function()
    SRP_Deferrals.handle(src, name, setKickReason, deferrals)
  end)
end)

-- After join: buckets + HUD seed + signal character selection (other resource)
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