SRP = SRP or {}
SRP.Vehicles = SRP.Vehicles or {}
SRP.Vehicles.Config = {
  streamRadius = tonumber(GetConvar('srp_veh_stream_radius', '150.0')) or 150.0,
  despawnRadius = tonumber(GetConvar('srp_veh_despawn_radius', '260.0')) or 260.0,
  syncInterval = tonumber(GetConvar('srp_veh_sync_interval_ms', '30000')) or 30000,
  platePrefix = GetConvar('srp_veh_plate_prefix', 'SRP') or 'SRP',
  impoundYard = GetConvar('srp_veh_impound_yard', 'JUNK01') or 'JUNK01',
  fuelHook = (GetConvar('srp_fuel_hook_enabled', 'false') == 'true'),
}