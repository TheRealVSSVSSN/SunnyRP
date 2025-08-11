-- Server: tracks radio membership and phone calls so the client fallback can apply overrides.
SRP = SRP or {}
SRP.Voice = SRP.Voice or {}
local VOICE = SRP.Voice

local radios = {}          -- [freq] = { [src]=true, ... }
local radioOf = {}         -- [src] = freq or nil

local calls = {}           -- [callId] = {a=src1, b=src2, speakerA=false, speakerB=false}
local callOf = {}          -- [src] = callId or nil
local nextCallId = 10001

local function joinRadio(src, freq)
  freq = tonumber(freq)
  radios[freq] = radios[freq] or {}
  radios[freq][src] = true
  radioOf[src] = freq
  -- notify everyone about membership change (for native fallback volume overrides)
  TriggerClientEvent('srp:voice:radio:members', -1, freq, radios[freq])
end

local function leaveRadio(src)
  local freq = radioOf[src]
  if not freq then return end
  if radios[freq] then radios[freq][src] = nil end
  radioOf[src] = nil
  TriggerClientEvent('srp:voice:radio:members', -1, freq, radios[freq] or {})
end

AddEventHandler('playerDropped', function()
  local src = source
  leaveRadio(src)
  local cid = callOf[src]
  if cid and calls[cid] then
    local other = (calls[cid].a == src) and calls[cid].b or calls[cid].a
    calls[cid] = nil
    callOf[src], callOf[other] = nil, nil
    TriggerClientEvent('srp:voice:phone:disconnect', other)
  end
end)

RegisterNetEvent('srp:voice:radio:join', function(freq)
  joinRadio(source, freq)
end)

RegisterNetEvent('srp:voice:radio:leave', function()
  leaveRadio(source)
end)

RegisterNetEvent('srp:voice:phone:call:start', function(targetSrc)
  local src = source
  targetSrc = tonumber(targetSrc)
  if not targetSrc or src == targetSrc then return end
  if callOf[src] or callOf[targetSrc] then return end
  local id = nextCallId; nextCallId = nextCallId + 1
  calls[id] = { a = src, b = targetSrc, speakerA = false, speakerB = false }
  callOf[src], callOf[targetSrc] = id, id
  TriggerClientEvent('srp:voice:phone:connect', src, id, targetSrc)
  TriggerClientEvent('srp:voice:phone:connect', targetSrc, id, src)
end)

RegisterNetEvent('srp:voice:phone:call:end', function()
  local src = source
  local cid = callOf[src]; if not cid then return end
  local c = calls[cid]; if not c then return end
  local other = (c.a == src) and c.b or c.a
  calls[cid], callOf[src], callOf[other] = nil, nil, nil
  TriggerClientEvent('srp:voice:phone:disconnect', other)
  TriggerClientEvent('srp:voice:phone:disconnect', src)
end)

RegisterNetEvent('srp:voice:phone:speaker', function(enabled)
  local src = source
  local cid = callOf[src]; if not cid then return end
  local c = calls[cid]; if not c then return end
  if c.a == src then c.speakerA = enabled else c.speakerB = enabled end
  TriggerClientEvent('srp:voice:phone:speaker:update', c.a, c.speakerA)
  TriggerClientEvent('srp:voice:phone:speaker:update', c.b, c.speakerB)
end)