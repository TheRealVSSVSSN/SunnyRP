SRP = SRP or {}
SRP.Phone = SRP.Phone or {}

SRP.Phone.Config = {
  smsRateMs = tonumber(GetConvar('srp_phone_sms_rate_ms','1200')) or 1200,
  pollMs    = tonumber(GetConvar('srp_phone_push_poll_ms','15000')) or 15000,
  areaDefault = GetConvar('srp_phone_area_default','415'),
  adsEnabled  = GetConvar('srp_phone_ads_enabled','true') == 'true',
}