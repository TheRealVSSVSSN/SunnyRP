-- Simple task/progress primitive using NUI overlay.
-- Server-auth completion recommended: server calls SRP_Task.Complete(id, ok)

SRP_Task = SRP_Task or {}
local current = nil

-- Start a task
-- opts = { id?, label?, durationMs=5000, canCancel=true }
function SRP_Task.Start(opts)
  if current then return false end
  current = {
    id = opts.id or ('tsk_'..math.random(100000,999999)),
    label = opts.label or 'Working...',
    duration = opts.durationMs or 5000,
    t0 = GetGameTimer(),
    canCancel = (opts.canCancel ~= false)
  }
  SendNUIMessage({ app='srp', action='taskStart', payload=current })
  SetNuiFocus(false, false)
  return current.id
end

function SRP_Task.Cancel()
  if not current or not current.canCancel then return end
  SendNUIMessage({ app='srp', action='taskCancel', payload={ id=current.id } })
  current = nil
end

-- Server will call this on the client that owns the task
RegisterNetEvent('srp:task:complete', function(id, ok)
  if not current or current.id ~= id then return end
  SendNUIMessage({ app='srp', action='taskEnd', payload={ id=id, ok = ok and true or false } })
  current = nil
end)

exports('TaskStart', SRP_Task.Start)
exports('TaskCancel', SRP_Task.Cancel)