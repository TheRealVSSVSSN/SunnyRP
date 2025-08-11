SRP = SRP or {}
SRP.Economy = SRP.Economy or {}

SRP.Economy.Config = {
  payPeriod = GetConvar('srp_pay_period', 'weekly'),
  minWage = tonumber(GetConvar('srp_ca_min_wage', '16.50')) or 16.50,
  fastFoodWage = tonumber(GetConvar('srp_ff_min_wage', '20.00')) or 20.00,
  salesBase = tonumber(GetConvar('srp_sales_tax_base', '0.0725')) or 0.0725,
  salesDistrict = tonumber(GetConvar('srp_sales_tax_district', '0.0000')) or 0.0,
  sdi = tonumber(GetConvar('srp_casdi_rate', '0.012')) or 0.012,
  syncMs = tonumber(GetConvar('srp_economy_sync_ms', '45000')) or 45000,

  -- Example job wage map (USD/hr). Override via convars or extend as needed.
  Jobs = {
    unemployed = 0.00,
    sanitation = 18.00,
    police     = 42.00,
    ems        = 40.00,
    taxi       = 18.00,
    fastfood   = tonumber(GetConvar('srp_ff_min_wage', '20.00')) or 20.00,
  },
}