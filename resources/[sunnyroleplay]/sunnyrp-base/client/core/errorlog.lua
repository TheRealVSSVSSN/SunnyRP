-- Client error bus: send to server -> backend/Discord
local function send(kind, data)
  TriggerServerEvent('srp:error:client', kind, data)
end

-- Example wrappers for risky calls
function SRP_SafeCall(fn, ...)
  local ok, err = xpcall(fn, debug.traceback, ...)
  if not ok then send('lua', { error = tostring(err) }) end
  return ok
end

-- NUI error funnel (window.onerror -> nuiCallback -> server)
RegisterNUICallback('srp:nui:error', function(payload, cb)
  send('nui', payload or {})
  cb({ ok = true })
end)