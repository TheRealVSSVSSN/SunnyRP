SRP = SRP or {}
SRP.Chat = SRP.Chat or {}
SRP.Chat.Config = {
  rangeLocal = tonumber(GetConvar('srp_chat_range_local', '15.0')) or 15.0,
  rangeMeDo  = tonumber(GetConvar('srp_chat_range_me_do', '15.0')) or 15.0,
  staffScope = GetConvar('srp_chat_staff_scope', 'staff.chat'),
  profanity  = (GetConvar('srp_chat_profanity_filter', 'true') == 'true'),
  oocEnabled = (GetConvar('srp_chat_ooc_enabled', 'true') == 'true'),

  rate = {
    general = tonumber(GetConvar('srp_chat_rate_ms_general', '1500')) or 1500,
    me_do   = tonumber(GetConvar('srp_chat_rate_ms_me_do', '1000')) or 1000,
    ooc     = tonumber(GetConvar('srp_chat_rate_ms_ooc', '3000')) or 3000,
    staff   = tonumber(GetConvar('srp_chat_rate_ms_staff', '1000')) or 1000,
  }
}