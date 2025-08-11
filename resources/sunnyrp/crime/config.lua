SRP = SRP or {}
SRP.Crime = SRP.Crime or {}

SRP.Crime.Config = {
  registerCooldownS = tonumber(GetConvar('srp_crime_register_cooldown_s','420')) or 420,
  heatDecayTickS    = tonumber(GetConvar('srp_crime_heat_decay_tick_s','300')) or 300,
  lockpickBaseMs    = tonumber(GetConvar('srp_crime_lockpick_base_ms','4500')) or 4500,

  Registers = {
    -- slug must match heists.seed (backend)
    { slug='247_vanilla_reg1', label='24/7 Strawberry — Register #1', coords = vector3(25.7,-1347.3,29.5) },
  },

  Heat = {
    onAttempt = 3,     -- +3 heat when you try
    onSuccess = 7,     -- +7 extra when you succeed
    onFail    = 2,     -- +2 when you fail
    decay     = 1      -- -1 per decay tick
  }
}