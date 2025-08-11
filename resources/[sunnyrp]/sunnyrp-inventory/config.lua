SRP = SRP or {}
SRP.Inventory = SRP.Inventory or {}

SRP.Inventory.Config = {
  hotbarSlots = tonumber(GetConvar('srp_inv_hotbar_slots', '5')) or 5,
  dropTTL = tonumber(GetConvar('srp_inv_drop_ttl_seconds', '300')) or 300,
  groundRadius = tonumber(GetConvar('srp_inv_ground_radius', '2.5')) or 2.5,
  weaponFeature = (GetConvar('srp_inv_feature_weapons', 'true') == 'true'),
  defaultMaxStack = tonumber(GetConvar('srp_inv_max_stack', '250')) or 250
}