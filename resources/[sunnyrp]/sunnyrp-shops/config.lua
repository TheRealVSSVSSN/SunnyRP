SRP = SRP or {}
SRP.Shops = SRP.Shops or {}

SRP.Shops.Config = {
  taxDefault = tonumber(GetConvar('srp_shop_tax_rate','8.5')) or 8.5,
  rateLimitMs = tonumber(GetConvar('srp_shop_rate_limit_ms','1200')) or 1200,
}