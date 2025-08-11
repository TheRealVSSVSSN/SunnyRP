SRP = SRP or {}
SRP.Telemetry = SRP.Telemetry or {}

SRP.Telemetry.Config = {
  sampleMs = tonumber(GetConvar('srp_tel_sample_ms', '750')) or 750,
  tpThreshold = tonumber(GetConvar('srp_tel_tp_threshold_m', '180.0')) or 180.0,
  footMax = tonumber(GetConvar('srp_tel_speed_foot_mps', '12.0')) or 12.0,
  vehMax  = tonumber(GetConvar('srp_tel_speed_vehicle_mps', '120.0')) or 120.0,
  alertRepeatS = tonumber(GetConvar('srp_tel_alert_repeat_s', '30')) or 30,
  postRateMs = tonumber(GetConvar('srp_tel_post_rate_ms', '500')) or 500,
}