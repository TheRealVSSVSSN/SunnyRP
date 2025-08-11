SRP = SRP or {}
SRP.HUD = SRP.HUD or {}
SRP.HUD.Config = {
  enabled = (GetConvar('srp_hud_enabled', 'true') == 'true'),
  clientFlushMs = tonumber(GetConvar('srp_hud_update_interval_ms', '750')) or 750,
  tickSeconds = tonumber(GetConvar('srp_hud_status_tick_seconds', '60')) or 60,
  accountsRefreshMs = tonumber(GetConvar('srp_hud_accounts_refresh_ms', '10000')) or 10000,

  visible = {
    vitals   = (GetConvar('srp_hud_show_vitals', 'true') == 'true'),
    status   = (GetConvar('srp_hud_show_status', 'true') == 'true'),
    identity = (GetConvar('srp_hud_show_identity', 'true') == 'true'),
    voice    = (GetConvar('srp_hud_show_voice', 'true') == 'true'),
  }
}