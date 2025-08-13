-- sunnyrp-base/shared/state.lua
-- Canonical state bag keys & lightweight helpers (shared)

SRP_State = SRP_State or {}

-- Registry of keys we standardize across the server (read-only convention)
SRP_State.Keys = {
  -- Set during deferrals / character select
  playerId   = 'srp:playerId',     -- number
  verified   = 'srp:verified',     -- boolean
  charId     = 'srp:charId',       -- number | nil (until selected)

  -- Job & duty (set on character select / job changes)
  job        = 'srp:job',          -- string
  duty       = 'srp:duty',         -- boolean

  -- Voice & radio (voice adapter will manage)
  voiceMode  = 'srp:voiceMode',    -- 'whisper' | 'normal' | 'shout'
  radio      = 'srp:radio',        -- number | nil  (channel)
  talking    = 'srp:talking',      -- boolean       (NetworkIsPlayerTalking echo)

  -- Presence (updated by presence manager)
  bucket     = 'srp:bucket',       -- number
  zone       = 'srp:zone',         -- string (SHORT name like "DAVIS"/"PBOX")
  street     = 'srp:street',       -- string (resolved display name)
}

-- client/server convenience (server performs authoritative sets; client should NOT set)
function SRP_State.key(name)
  return SRP_State.Keys[name]
end