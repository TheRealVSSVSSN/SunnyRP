SRP_State = { players = {}, dirty = {}, lastPush = {} }

local function ensure(pid)
  SRP_State.players[pid] = SRP_State.players[pid] or {
    job = nil, duty = false, cash = 0, bank = 0,
    voiceMode = 'normal', radio = 0,
    vitals = { health = 200, armor = 0, stress = 0, hunger = 50 },
    street = '', time = '', weather = '', isDead = false
  }
  return SRP_State.players[pid]
end

function SRP_State.update(pid, patch)
  local s = ensure(pid)
  for k,v in pairs(patch) do s[k] = v end
  SRP_State.dirty[pid] = true
end

CreateThread(function()
  while true do
    Wait(math.floor(1000 / (SRP_Config.QoL.hudRateHz or 6)))
    for pid,_ in pairs(SRP_State.dirty) do
      local now = GetGameTimer()
      if not SRP_State.lastPush[pid] or (now - SRP_State.lastPush[pid] > 1000 / (SRP_Config.QoL.hudRateHz or 6)) then
        TriggerClientEvent(SRP_CONST.EVENTS.HUD_SET, pid, SRP_State.players[pid] or {})
        SRP_State.lastPush[pid] = now
        SRP_State.dirty[pid] = nil
      end
    end
  end
end)

exports('EmitHud', function(pid, delta) SRP_State.update(pid, delta or {}) end)