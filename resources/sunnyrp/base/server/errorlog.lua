-- Server error sink: accepts client error events and forwards to backend + Discord (notify)
RegisterNetEvent('srp:error:client', function(kind, data)
  local src = source
  local payload = {
    source = src,
    kind = kind or 'lua',
    data = data or {},
    ts = os.time()
  }

  -- Try telemetry endpoint (if present)
  SRP_HTTP.Fetch('POST', '/telemetry/errors', payload, { retries = 1, timeout = 5000 })

  -- Also emit to Discord (optional)
  SRP_HTTP.Fetch('POST', '/notify/emit', {
    channel = 'ops',
    content = ('Client error from %s [%s]: %s'):format(GetPlayerName(src) or ('src:'..src), kind or 'lua', json.encode(data or {}))
  }, { retries = 0, timeout = 4000 })
end)