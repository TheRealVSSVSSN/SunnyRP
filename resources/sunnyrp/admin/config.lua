SRP = SRP or {}
SRP.Admin = SRP.Admin or {}

SRP.Admin.Config = {
  cooldownMs = tonumber(GetConvar('srp_admin_cooldown_ms', '1500')) or 1500,
  presenceHeartbeatMs = tonumber(GetConvar('srp_admin_presence_heartbeat_ms', '20000')) or 20000,
  -- action -> required scope (mirrors backend)
  ScopeMap = {
    spectate = 'admin.spectate',
    noclip   = 'admin.noclip',
    bring    = 'admin.teleport',
    goto     = 'admin.teleport',
    cleanup  = 'admin.cleanup',
    kick     = 'admin.kick',
    ban      = 'admin.ban',
    unban    = 'admin.ban',
  }
}