SRP = SRP or {}
SRP.Voice = SRP.Voice or {}

SRP.Voice.Config = {
  whisper = tonumber(GetConvar('srp_voice_mode_whisper', '3.0')) or 3.0,
  normal  = tonumber(GetConvar('srp_voice_mode_normal',  '10.0')) or 10.0,
  shout   = tonumber(GetConvar('srp_voice_mode_shout',   '25.0')) or 25.0,

  pttKey  = tonumber(GetConvar('srp_voice_radio_ptt_key', '249')) or 249, -- INPUT_PUSH_TO_TALK
  radioDefaultVol = tonumber(GetConvar('srp_voice_radio_default_vol', '60')) or 60,
  phoneDefaultVol = tonumber(GetConvar('srp_voice_phone_default_vol', '70')) or 70,
}