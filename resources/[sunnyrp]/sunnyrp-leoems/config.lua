SRP = SRP or {}
SRP.LeoEms = SRP.LeoEms or {}

SRP.LeoEms.Config = {
  dispatchBlipTimeMs = tonumber(GetConvar('srp_dispatch_blip_time_ms', '120000')) or 120000,
  dispatchRateLimitMs = tonumber(GetConvar('srp_dispatch_rate_limit_ms', '2000')) or 2000,
}