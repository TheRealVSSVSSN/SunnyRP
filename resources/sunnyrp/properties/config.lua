SRP = SRP or {}
SRP.Properties = SRP.Properties or {}

SRP.Properties.Config = {
  interactDist = tonumber(GetConvar('srp_prop_interaction_dist','2.2')) or 2.2,
  bucketBase = tonumber(GetConvar('srp_prop_bucket_base','60000')) or 60000,
  debugBlips = GetConvar('srp_prop_debug_blips','false') == 'true',
}