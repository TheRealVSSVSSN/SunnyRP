-- resources/sunnyrp/crime/client/main.lua
-- Placeholder lockpick abstraction; replace with real minigame later.

RegisterNetEvent('srp:crime:lockpick:start', function(data)
  local ms = (data and data.ms) or 4500
  local slug = data and data.slug or 'unknown'
  -- simple pseudo-minigame: progress wait then 70% success
  local success = false
  local endTime = GetGameTimer() + ms
  while GetGameTimer() < endTime do
    Wait(0)
    -- (You can show a scaleform/progress bar here)
  end
  success = (math.random(100) <= 70)
  TriggerServerEvent('srp:crime:lockpick:result', { slug = slug, ok = success })
end)