-- Placeholder: you can show duty status on the HUD or keybind a duty toggle.
-- Example keybind (F6) to toggle duty:
RegisterCommand('+srpDutyToggle', function()
  SendNUIMessage({ type='jobs:toggle' }) -- if you add an in-game UI panel
  -- or just ask server to toggle:
  ExecuteCommand('duty toggle')
end, false)
RegisterKeyMapping('+srpDutyToggle', 'SRP: Toggle Duty', 'keyboard', 'F6')