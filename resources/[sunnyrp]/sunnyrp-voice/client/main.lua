-- Client: SRP.Voice facade. Native Mumble by default; pma-voice if available.
SRP = SRP or {}
SRP.Voice = SRP.Voice or {}
local CFG = SRP.Voice.Config

local usingPma = (GetResourceState('pma-voice') == 'started')
local mode = 'normal'
local radio = { freq = 0, volume = CFG.radioDefaultVol, talking = false, members = {} }
local phone = { callId = 0, peer = 0, volume = CFG.phoneDefaultVol, speaker = false }
local pttKey = CFG.pttKey

-- ===== HUD Bridge (Phase F)
local function hudUpdate()
  TriggerEvent('srp:hud:voice:update', {
    mode = mode,
    radio = (radio.freq ~= 0),
    radioTalking = radio.talking,
    call = (phone.callId ~= 0),
    speaker = phone.speaker
  })
end

-- ===== Proximity modes
local function applyProximity()
  if mode == 'whisper' then
    NetworkSetTalkerProximity(CFG.whisper)
  elseif mode == 'shout' then
    NetworkSetTalkerProximity(CFG.shout)
  else
    NetworkSetTalkerProximity(CFG.normal)
  end
end

SRP.Voice.SetMode = function(m)
  if m ~= 'whisper' and m ~= 'normal' and m ~= 'shout' then return end
  mode = m
  applyProximity()
  hudUpdate()
end

-- Quick demo binds (cycle voice range)
RegisterCommand('srp_voice_range', function(_, args)
  local m = tostring(args[1] or ''); if m == '' then return end
  SRP.Voice.SetMode(m)
end)

-- ===== Radio
local function pma_setRadioChannel(ch) exports['pma-voice']:setRadioChannel(ch) end
local function pma_setRadioVolume(p) exports['pma-voice']:setRadioVolume(math.max(0, math.min(100, p))) end

local function native_radioListen(ch, listen)
  if listen then
    if not MumbleDoesChannelExist(ch) then MumbleCreateChannel(ch) end
    MumbleAddVoiceChannelListen(ch)
  else
    MumbleRemoveVoiceChannelListen(ch)
  end
end

-- When PTT held: send to radio channel (and keep proximity for locals by using targets to both)
local RADIO_TARGET = 1
local function native_beginRadioTalk()
  -- Build voice target containing: radio channel + (optionally) nearby players so locals still hear you
  MumbleSetVoiceTarget(RADIO_TARGET)
  MumbleClearVoiceTargetChannels(RADIO_TARGET)
  MumbleClearVoiceTargetPlayers(RADIO_TARGET)
  -- route to channel
  if radio.freq > 0 then
    MumbleAddVoiceTargetChannel(RADIO_TARGET, radio.freq)
  end
  -- also add near players so proximity still hears you
  local ply = PlayerId()
  for _, id in ipairs(GetActivePlayers()) do
    if id ~= ply then
      local pid = GetPlayerPed(id)
      local dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(pid))
      if dist <= (CFG.normal * 1.2) then
        MumbleAddVoiceTargetPlayer(RADIO_TARGET, id)
      end
    end
  end
end

local function native_endRadioTalk()
  MumbleSetVoiceTarget(0) -- back to proximity-only
end

SRP.Voice.Radio = {
  Join = function(freq)
    freq = tonumber(freq) or 0
    if freq == radio.freq then return end
    if usingPma then
      pma_setRadioChannel(freq)
    else
      if radio.freq > 0 then native_radioListen(radio.freq, false) end
      if freq > 0 then native_radioListen(freq, true) end
    end
    radio.freq = freq
    TriggerServerEvent('srp:voice:radio:join', freq)
    hudUpdate()
  end,
  Leave = function()
    if usingPma then
      pma_setRadioChannel(0)
    else
      if radio.freq > 0 then native_radioListen(radio.freq, false) end
    end
    TriggerServerEvent('srp:voice:radio:leave')
    radio.freq = 0
    hudUpdate()
  end,
  SetVolume = function(percent)
    radio.volume = math.max(0, math.min(100, tonumber(percent) or 0))
    if usingPma then
      pma_setRadioVolume(radio.volume)
    end
    -- native fallback volumes handled in a small loop below (per-talker override)
    hudUpdate()
  end
}

RegisterCommand('radiovol', function(_, args)
  SRP.Voice.Radio.SetVolume(tonumber(args[1] or radio.volume))
end)

-- Server tells us who’s in our radio freq (for native fallback)
RegisterNetEvent('srp:voice:radio:members', function(freq, members)
  if freq ~= radio.freq then return end
  radio.members = members or {}
end)

-- ===== Phone
local function pma_setCallChannel(id) exports['pma-voice']:setCallChannel(id) end
-- (pma-voice handles call volume via its own convars; we keep a local state for future)

SRP.Voice.Phone = {
  Start = function(targetServerId)
    TriggerServerEvent('srp:voice:phone:call:start', tonumber(targetServerId))
  end,
  End = function()
    TriggerServerEvent('srp:voice:phone:call:end')
  end,
  Speaker = function(enabled)
    phone.speaker = not not enabled
    TriggerServerEvent('srp:voice:phone:speaker', phone.speaker)
    hudUpdate()
  end,
}

-- Connected to a call
RegisterNetEvent('srp:voice:phone:connect', function(callId, peerServerId)
  phone.callId, phone.peer = callId, tonumber(peerServerId)
  if usingPma then
    pma_setCallChannel(callId)
  else
    if not MumbleDoesChannelExist(callId) then MumbleCreateChannel(callId) end
    MumbleAddVoiceChannelListen(callId)
  end
  hudUpdate()
end)

-- Disconnected
RegisterNetEvent('srp:voice:phone:disconnect', function()
  if usingPma then
    pma_setCallChannel(0)
  else
    if phone.callId > 0 then MumbleRemoveVoiceChannelListen(phone.callId) end
  end
  phone.callId, phone.peer, phone.speaker = 0, 0, false
  hudUpdate()
end)

-- Speaker status updates (server echoes to both ends)
RegisterNetEvent('srp:voice:phone:speaker:update', function(enabled)
  phone.speaker = not not enabled
  hudUpdate()
end)

-- ===== PTT handling (radio)
CreateThread(function()
  while true do
    Wait(0)
    local pressed = IsControlPressed(0, pttKey)
    if pressed and not radio.talking and radio.freq > 0 then
      radio.talking = true
      if usingPma then
        -- pma-voice handles capture routing automatically, we just update HUD
      else
        native_beginRadioTalk()
      end
      hudUpdate()
    elseif (not pressed) and radio.talking then
      radio.talking = false
      if not usingPma then
        native_endRadioTalk()
      end
      hudUpdate()
    end
  end
end)

-- ===== Native fallback: per-talker radio volume (when they talk), and call routing
CreateThread(function()
  if usingPma then return end
  while true do
    Wait(120) -- light polling
    -- Radio: if someone in same freq is talking, apply volume override; reset otherwise
    if radio.freq > 0 then
      for sid, _ in pairs(radio.members or {}) do
        local pid = GetPlayerFromServerId(tonumber(sid))
        if pid ~= -1 then
          if NetworkIsPlayerTalking(pid) then
            MumbleSetVolumeOverride(GetPlayerFromServerId(sid), (radio.volume / 100.0))
          else
            MumbleSetVolumeOverride(GetPlayerFromServerId(sid), -1.0)
          end
        end
      end
    end
    -- Phone (send to peer using voice targets while preserving proximity)
    if phone.callId > 0 and phone.peer > 0 then
      local tgt = 2
      MumbleSetVoiceTarget(tgt)
      MumbleClearVoiceTargetPlayers(tgt)
      MumbleAddVoiceTargetPlayerByServerId(tgt, phone.peer)
      -- If speakerphone, also make locals hear the remote louder by overriding remote volume
      if phone.speaker then
        local pid = GetPlayerFromServerId(phone.peer)
        if pid ~= -1 then
          -- small boost; we avoid >1.0 to prevent clipping
          MumbleSetVolumeOverrideByServerId(phone.peer, 0.85)
        end
      else
        MumbleSetVolumeOverrideByServerId(phone.peer, -1.0)
      end
      -- restore default target so proximity works when not talking
      MumbleSetVoiceTarget(0)
    end
  end
end)

-- ===== Init
CreateThread(function()
  applyProximity()
  hudUpdate()
end)