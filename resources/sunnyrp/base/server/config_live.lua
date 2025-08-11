local function fetchAndApply()
  local res = SRP_HTTP.Fetch('GET', '/config/live', nil, { retries = 1 })
  if res.ok and res.data then
    SRP_ConfigBus.apply(res.data)
    SRP_Utils.log('INFO', 'Live config synced')
  else
    SRP_Utils.log('WARN', 'Live config fetch failed: '..tostring(res.error or res.message))
  end
end

CreateThread(function()
  Wait(1500)
  fetchAndApply()
  while true do
    Wait(15000)
    fetchAndApply()
  end
end)

RegisterNetEvent('srp:config:update', function(patch)
  SRP_ConfigBus.apply(patch or {})
end)